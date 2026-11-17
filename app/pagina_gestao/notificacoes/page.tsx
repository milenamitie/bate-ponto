"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import GestaoNav from "@/app/components/GestaoNav";

type Solicitacao = {
  id: number;
  nome_completo: string;
  matricula: string;
  tipo: string;
  data: string;
  motivo: string;
  status: "Pendente" | "Aprovado" | "Reprovado";
  criada_em: string;
};

type Notificacao = {
  id: string;
  solicitacaoId: number;
  titulo: string;
  mensagem: string;
  horario: string;
  lida: boolean;
};

function formatarData(valor?: string | null) {
  if (!valor) return "data não informada";
  const [ano, mes, dia] = valor.slice(0, 10).split("-");
  return ano && mes && dia ? `${dia}/${mes}/${ano}` : valor;
}

function formatarDataHora(valor?: string | null) {
  if (!valor) return "Data de envio não informada";
  const [data, horario] = valor.split(" ");
  return `${formatarData(data)}${horario ? ` às ${horario.slice(0, 5)}` : ""}`;
}

export default function NotificacoesGestor() {
  const router = useRouter();
  const [notificacoes, setNotificacoes] = useState<Notificacao[]>([]);
  const [aba, setAba] = useState<"todas" | "naoLidas">("todas");
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState("");
  const [dadosLocaisCarregados, setDadosLocaisCarregados] = useState(false);

  const carregarNotificacoes = useCallback(async () => {
    setErro("");

    const resposta = await fetch("/api/gestao/solicitacoes", {
      cache: "no-store",
    });

    if (resposta.status === 401 || resposta.status === 403) {
      router.replace("/");
      return;
    }

    const dados = await resposta.json();

    if (!resposta.ok || !Array.isArray(dados)) {
      throw new Error(dados.mensagem || "Não foi possível carregar as notificações.");
    }

    const lidasSalvas = localStorage.getItem("bp_gestao_notificacoes_lidas");
    const idsLidas: string[] = lidasSalvas ? JSON.parse(lidasSalvas) : [];

    const pendentes: Notificacao[] = dados
      .filter((item: Solicitacao) => item.status === "Pendente")
      .map((item: Solicitacao) => ({
        id: `solicitacao-${item.id}`,
        solicitacaoId: item.id,
        titulo: "Solicitação aguardando aprovação",
        mensagem: `${item.nome_completo} enviou uma solicitação de ${String(item.tipo).toLowerCase()} referente ao dia ${formatarData(item.data)}. Motivo: ${item.motivo || "Não informado"}.`,
        horario: formatarDataHora(item.criada_em),
        lida: idsLidas.includes(`solicitacao-${item.id}`),
      }))
      .sort((a: Notificacao, b: Notificacao) => b.solicitacaoId - a.solicitacaoId);

    setNotificacoes(pendentes);
    setDadosLocaisCarregados(true);
  }, [router]);

  useEffect(() => {
    carregarNotificacoes()
      .catch((e) => setErro(e instanceof Error ? e.message : "Erro ao carregar notificações."))
      .finally(() => setCarregando(false));
  }, [carregarNotificacoes]);

  useEffect(() => {
    if (!dadosLocaisCarregados) return;

    localStorage.setItem(
      "bp_gestao_notificacoes_lidas",
      JSON.stringify(notificacoes.filter((item) => item.lida).map((item) => item.id))
    );
  }, [notificacoes, dadosLocaisCarregados]);

  const naoLidas = useMemo(
    () => notificacoes.filter((item) => !item.lida).length,
    [notificacoes]
  );

  const exibidas = useMemo(
    () => aba === "naoLidas" ? notificacoes.filter((item) => !item.lida) : notificacoes,
    [notificacoes, aba]
  );

  function marcarComoLida(id: string) {
    setNotificacoes((lista) =>
      lista.map((item) => item.id === id ? { ...item, lida: true } : item)
    );
  }

  function marcarTodasComoLidas() {
    setNotificacoes((lista) => lista.map((item) => ({ ...item, lida: true })));
  }

  if (carregando) {
    return <div className="folhaCarregando">Carregando notificações...</div>;
  }

  return (
    <main className="gestaoPagina notificacoesPagina">
      <GestaoNav />

      <div className="gestaoBreadcrumb">
        Gestão <span>/</span> Diretoria Acadêmica <span>/</span> <b>Notificações</b>
      </div>

      <section className="notificacoesConteudo">
        <div className="notificacoesCabecalho">
          <div>
            <h1>Notificações</h1>
            <p>
              <strong>{naoLidas} não lidas</strong>
              <span> · solicitações aguardando sua aprovação</span>
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

        {erro && <div className="notificacoesErro" role="alert">{erro}</div>}

        <div className="notificacoesAbas" role="tablist" aria-label="Filtrar notificações">
          <button
            type="button"
            role="tab"
            aria-selected={aba === "todas"}
            className={aba === "todas" ? "ativa" : ""}
            onClick={() => setAba("todas")}
          >
            Todas ({notificacoes.length})
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
                  : "Não há solicitações aguardando aprovação no momento."}
              </p>
            </div>
          ) : (
            exibidas.map((item) => (
              <article
                key={item.id}
                className={`notificacaoCard notificacao-aprovacao ${item.lida ? "notificacaoLida" : "notificacaoNaoLida"}`}
              >
                <div className="notificacaoIcone" aria-hidden="true">✓</div>
                <div className="notificacaoCorpo">
                  <div className="notificacaoLinhaTitulo">
                    <h2>{item.titulo}</h2>
                    <time>{item.horario}</time>
                  </div>
                  <p>{item.mensagem}</p>
                  <div className="notificacaoAcoes">
                    <span className="notificacaoEtiqueta">APROVAÇÃO</span>
                    <div>
                      {!item.lida && (
                        <button type="button" onClick={() => marcarComoLida(item.id)}>
                          MARCAR COMO LIDA
                        </button>
                      )}
                      <button type="button" onClick={() => router.push("/pagina_gestao/aprovacoes")}>VER SOLICITAÇÃO</button>
                    </div>
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
