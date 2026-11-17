
"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import ProfessorNav from "@/app/components/ProfessorNav";

type Servidor = {
  id: number;
  nome_completo: string;
  email_institucional: string;
};

type Solicitacao = {
  id: number;
  tipo: "Justificativa" | "Compensação";
  data: string;
  motivo: string;
  status: "Pendente" | "Aprovado" | "Reprovado";
  criada_em: string;
  decidida_em: string | null;
  decisao_observacao: string | null;
};

type Registro = {
  id: number;
  data: string;
  entrada: string | null;
  saida: string | null;
  atraso_minutos: number;
  status: string;
};

type Grade = {
  id: number;
  servidor_id: number;
  disciplina: string;
  turma: string;
  sala: string;
  dia_semana: string;
  hora_inicio: string;
  hora_fim: string;
  status: string;
};

type TipoNotificacao = "alerta" | "lembrete" | "aprovacao";

type Notificacao = {
  id: string;
  tipo: TipoNotificacao;
  titulo: string;
  mensagem: string;
  horario: string;
  etiqueta: string;
  lida: boolean;
};

type Preferencias = {
  alertas: boolean;
  aprovacoes: boolean;
  lembretes: boolean;
};

const preferenciasPadrao: Preferencias = {
  alertas: true,
  aprovacoes: true,
  lembretes: true,
};

function obterDataHoje() {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "America/Sao_Paulo",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date());
}

function obterHorarioAtual() {
  const partes = new Intl.DateTimeFormat("pt-BR", {
    timeZone: "America/Sao_Paulo",
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  }).formatToParts(new Date());

  const hora = partes.find((parte) => parte.type === "hour")?.value || "00";
  const minuto = partes.find((parte) => parte.type === "minute")?.value || "00";

  return Number(hora) * 60 + Number(minuto);
}

function obterDiaHoje() {
  const dia = new Intl.DateTimeFormat("pt-BR", {
    timeZone: "America/Sao_Paulo",
    weekday: "long",
  }).format(new Date());

  const dias: Record<string, string> = {
    "segunda-feira": "Segunda",
    "terça-feira": "Terça",
    "quarta-feira": "Quarta",
    "quinta-feira": "Quinta",
    "sexta-feira": "Sexta",
    "sábado": "Sábado",
    "domingo": "Domingo",
  };

  return dias[dia] || "";
}

function formatarData(data: string) {
  if (!data) return "";

  const dataLimpa = data.slice(0, 10);
  const [ano, mes, dia] = dataLimpa.split("-");

  if (!ano || !mes || !dia) return data;

  return `${dia}/${mes}/${ano}`;
}

function formatarHorario(dataHora: string | null) {
  if (!dataHora) return "Horário não informado";

  const partes = dataHora.split(" ");
  const data = partes[0];
  const horario = partes[1];

  if (!data) return dataHora;

  const hoje = obterDataHoje();

  if (data === hoje) {
    return `Hoje, ${horario?.slice(0, 5) || ""}`;
  }

  return `${formatarData(data)}${horario ? `, ${horario.slice(0, 5)}` : ""}`;
}

function converterMinutos(horario: string) {
  const [hora, minuto] = horario.slice(0, 5).split(":").map(Number);

  return hora * 60 + minuto;
}

export default function NotificacoesProfessor() {
  const router = useRouter();

  const [servidor, setServidor] = useState<Servidor | null>(null);
  const [notificacoes, setNotificacoes] = useState<Notificacao[]>([]);
  const [aba, setAba] = useState<"todas" | "naoLidas">("todas");
  const [preferencias, setPreferencias] = useState(preferenciasPadrao);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState("");
  const [dadosLocaisCarregados, setDadosLocaisCarregados] = useState(false);

  useEffect(() => {
    const idSalvo = localStorage.getItem("servidorId");

    if (!idSalvo || !Number(idSalvo)) {
      router.replace("/");
      return;
    }

    const id = Number(idSalvo);

    async function carregarDados() {
      try {
        const preferenciasSalvas = localStorage.getItem(
          `bp_preferencias_notificacoes_${id}`
        );

        if (preferenciasSalvas) {
          setPreferencias({
            ...preferenciasPadrao,
            ...JSON.parse(preferenciasSalvas),
          });
        }

        const lidasSalvas = localStorage.getItem(
          `bp_notificacoes_lidas_${id}`
        );

        const idsLidas: string[] = lidasSalvas
          ? JSON.parse(lidasSalvas)
          : [];

        const respostaServidor = await fetch("/api/servidores");
        const dadosServidores = await respostaServidor.json();

        if (!respostaServidor.ok) {
          throw new Error("Não foi possível carregar seus dados.");
        }

        const servidorAtual = dadosServidores.find(
          (item: Servidor) => item.id === id
        );

        if (!servidorAtual) {
          localStorage.removeItem("servidorId");
          router.replace("/");
          return;
        }

        setServidor(servidorAtual);

        const [resSolicitacoes, resRegistros, resGrades] =
          await Promise.all([
            fetch("/api/solicitacoes"),
            fetch(`/api/registros_ponto?servidor_id=${id}`),
            fetch("/api/grades"),
          ]);

        const resultados = await Promise.all([
          resSolicitacoes.json(),
          resRegistros.json(),
          resGrades.json(),
        ]);

        const [solicitacoes, registros, grades] = resultados;

        const notificacoesGeradas: Notificacao[] = [];

        if (resSolicitacoes.ok && Array.isArray(solicitacoes)) {
          solicitacoes.forEach((solicitacao: Solicitacao) => {
            const dataSolicitacao = formatarData(solicitacao.data);

            let titulo = "Solicitação enviada";
            let mensagem = `Sua solicitação de ${solicitacao.tipo.toLowerCase()} para ${dataSolicitacao} está aguardando análise.`;
            let horario = formatarHorario(solicitacao.criada_em);

            if (solicitacao.status === "Aprovado") {
              titulo = `${solicitacao.tipo} aprovada`;
              mensagem = `Sua solicitação referente a ${dataSolicitacao} foi aprovada.`;

              if (solicitacao.decisao_observacao) {
                mensagem += ` Observação: ${solicitacao.decisao_observacao}`;
              }

              horario = formatarHorario(
                solicitacao.decidida_em || solicitacao.criada_em
              );
            }

            if (solicitacao.status === "Reprovado") {
              titulo = `${solicitacao.tipo} reprovada`;
              mensagem = `Sua solicitação referente a ${dataSolicitacao} foi reprovada.`;

              if (solicitacao.decisao_observacao) {
                mensagem += ` Motivo: ${solicitacao.decisao_observacao}`;
              }

              horario = formatarHorario(
                solicitacao.decidida_em || solicitacao.criada_em
              );
            }

            notificacoesGeradas.push({
              id: `solicitacao-${solicitacao.id}`,
              tipo: "aprovacao",
              titulo,
              mensagem,
              horario,
              etiqueta: "SOLICITAÇÃO",
              lida: idsLidas.includes(`solicitacao-${solicitacao.id}`),
            });
          });
        }

        if (resRegistros.ok && Array.isArray(registros)) {
          const hoje = obterDataHoje();

          registros.forEach((registro: Registro) => {
            if (
              Number(registro.atraso_minutos) > 0 ||
              registro.status === "Atrasado"
            ) {
              notificacoesGeradas.push({
                id: `atraso-${registro.id}`,
                tipo: "alerta",
                titulo: "Registro de entrada atrasado",
                mensagem: `No dia ${formatarData(registro.data)}, seu registro de entrada foi realizado com ${registro.atraso_minutos} minutos de atraso.`,
                horario: formatarData(registro.data),
                etiqueta: "ATRASO",
                lida: idsLidas.includes(`atraso-${registro.id}`),
              });
            }

            if (
              registro.entrada &&
              !registro.saida &&
              registro.data < hoje
            ) {
              notificacoesGeradas.push({
                id: `saida-pendente-${registro.id}`,
                tipo: "alerta",
                titulo: "Registro de saída pendente",
                mensagem: `Não encontramos um horário de saída registrado no seu ponto do dia ${formatarData(registro.data)}.`,
                horario: formatarData(registro.data),
                etiqueta: "PONTO",
                lida: idsLidas.includes(`saida-pendente-${registro.id}`),
              });
            }
          });
        }

        if (resGrades.ok && Array.isArray(grades)) {
          const minhasGrades = grades.filter(
            (grade: Grade) =>
              grade.servidor_id === id && grade.status === "Ativo"
          );

          const diaHoje = obterDiaHoje();
          const horarioAtual = obterHorarioAtual();

          minhasGrades.forEach((grade: Grade) => {
            if (grade.dia_semana !== diaHoje) return;

            const inicio = converterMinutos(grade.hora_inicio);
            const diferenca = inicio - horarioAtual;

            if (diferenca > 0 && diferenca <= 30) {
              const horario = grade.hora_inicio.slice(0, 5);

              notificacoesGeradas.push({
                id: `aula-${obterDataHoje()}-${grade.id}`,
                tipo: "lembrete",
                titulo: "Aula se aproximando",
                mensagem: `Sua aula de ${grade.disciplina}, turma ${grade.turma}, começa às ${horario}. Sala: ${grade.sala || "Não informada"}.`,
                horario: `Hoje, ${horario}`,
                etiqueta: "LEMBRETE",
                lida: idsLidas.includes(
                  `aula-${obterDataHoje()}-${grade.id}`
                ),
              });
            }
          });
        }

        notificacoesGeradas.sort((a, b) => {
          const ordem = (horario: string) => {
            if (horario.startsWith("Hoje")) return 0;
            return 1;
          };

          return ordem(a.horario) - ordem(b.horario);
        });

        setNotificacoes(notificacoesGeradas);
      } catch (e) {
        setErro(
          e instanceof Error
            ? e.message
            : "Não foi possível carregar as notificações."
        );
      } finally {
        setCarregando(false);
        setDadosLocaisCarregados(true);
      }
    }

    carregarDados();
  }, [router]);

  const notificacoesFiltradas = useMemo(() => {
    return notificacoes.filter((item) => {
      if (item.tipo === "alerta" && !preferencias.alertas) return false;
      if (item.tipo === "aprovacao" && !preferencias.aprovacoes) return false;
      if (item.tipo === "lembrete" && !preferencias.lembretes) return false;

      return true;
    });
  }, [notificacoes, preferencias]);

  useEffect(() => {
    if (!dadosLocaisCarregados || !servidor) return;

    localStorage.setItem(
      `bp_notificacoes_lidas_${servidor.id}`,
      JSON.stringify(
        notificacoes.filter((item) => item.lida).map((item) => item.id)
      )
    );

    localStorage.setItem(
      `bp_preferencias_notificacoes_${servidor.id}`,
      JSON.stringify(preferencias)
    );
  }, [notificacoes, preferencias, servidor, dadosLocaisCarregados]);

  const naoLidas = useMemo(
    () => notificacoesFiltradas.filter((item) => !item.lida).length,
    [notificacoesFiltradas]
  );

  const exibidas = useMemo(
    () =>
      aba === "naoLidas"
        ? notificacoesFiltradas.filter((item) => !item.lida)
        : notificacoesFiltradas,
    [notificacoesFiltradas, aba]
  );

  function marcarComoLida(id: string) {
    setNotificacoes((lista) =>
      lista.map((item) =>
        item.id === id ? { ...item, lida: true } : item
      )
    );
  }

  function marcarTodasComoLidas() {
    setNotificacoes((lista) =>
      lista.map((item) => ({ ...item, lida: true }))
    );
  }

  function alternarPreferencia(campo: keyof Preferencias) {
    setPreferencias((atual) => ({
      ...atual,
      [campo]: !atual[campo],
    }));
  }

  if (carregando) {
    return <div className="folhaCarregando">Carregando notificações...</div>;
  }

  return (
    <main className="folhaPagina notificacoesPagina">
      <ProfessorNav
        paginaAtiva="notificacoes"
        nomeProfessor={servidor?.nome_completo || "Professor"}
        notificacoesNaoLidas={naoLidas}
      />

      <div className="folhaBreadcrumb">
        <span>Sistema</span>
        <span>/</span>
        <span>Dep. Ciências Exatas</span>
        <span>/</span>
        <strong>Notificações</strong>
      </div>

      <section className="notificacoesConteudo">
        <div className="notificacoesCabecalho">
          <div>
            <h1>Notificações</h1>
            <p>
              <strong>{naoLidas} não lidas</strong>
              <span> · alertas e lembretes do sistema</span>
            </p>
          </div>

          <button
            className="notificacoesMarcarTodas"
            type="button"
            onClick={marcarTodasComoLidas}
            disabled={naoLidas === 0}
          >
            MARCAR TODAS LIDAS
          </button>
        </div>

        {erro && <div className="notificacoesErro">{erro}</div>}

        <section className="notificacoesPreferencias">
          <div className="notificacoesEmail">
            <span>E-MAIL DE NOTIFICAÇÕES</span>
            <strong>
              {servidor?.email_institucional || "E-mail não cadastrado"}
            </strong>
          </div>

          <label>
            <input
              type="checkbox"
              checked={preferencias.alertas}
              onChange={() => alternarPreferencia("alertas")}
            />
            <span>Alertas de ponto</span>
          </label>

          <label>
            <input
              type="checkbox"
              checked={preferencias.aprovacoes}
              onChange={() => alternarPreferencia("aprovacoes")}
            />
            <span>Aprovações</span>
          </label>

          <label>
            <input
              type="checkbox"
              checked={preferencias.lembretes}
              onChange={() => alternarPreferencia("lembretes")}
            />
            <span>Lembretes diários</span>
          </label>
        </section>

        <div
          className="notificacoesAbas"
          role="tablist"
          aria-label="Filtrar notificações"
        >
          <button
            type="button"
            role="tab"
            aria-selected={aba === "todas"}
            className={aba === "todas" ? "ativa" : ""}
            onClick={() => setAba("todas")}
          >
            Todas ({notificacoesFiltradas.length})
          </button>

          <button
            type="button"
            role="tab"
            aria-selected={aba === "naoLidas"}
            className={aba === "naoLidas" ? "ativa" : ""}
            onClick={() => setAba("naoLidas")}
          >
            Não lidas ({naoLidas})
          </button>
        </div>

        <div className="notificacoesLista">
          {exibidas.length === 0 ? (
            <div className="notificacoesVazio">
              <strong>✓</strong>
              <p>
                {aba === "naoLidas"
                  ? "Você não tem notificações não lidas."
                  : "Você ainda não tem notificações."}
              </p>
            </div>
          ) : (
            exibidas.map((item) => (
              <article
                key={item.id}
                className={`notificacaoCard notificacao-${item.tipo} ${
                  item.lida ? "notificacaoLida" : "notificacaoNaoLida"
                }`}
              >
                <div className="notificacaoIcone" aria-hidden="true">
                  {item.tipo === "alerta" && "⚠"}
                  {item.tipo === "lembrete" && "♟"}
                  {item.tipo === "aprovacao" && "✓"}
                </div>

                <div className="notificacaoCorpo">
                  <div className="notificacaoLinhaTitulo">
                    <h2>{item.titulo}</h2>
                    <time>{item.horario}</time>
                  </div>

                  <p>{item.mensagem}</p>

                  <div className="notificacaoAcoes">
                    <span className="notificacaoEtiqueta">
                      {item.etiqueta}
                    </span>

                    {!item.lida && (
                      <button
                        type="button"
                        onClick={() => marcarComoLida(item.id)}
                      >
                        MARCAR COMO LIDA
                      </button>
                    )}
                  </div>
                </div>
              </article>
            ))
          )}
        </div>
      </section>
    </main>
  );
}
