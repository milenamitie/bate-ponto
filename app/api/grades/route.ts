import { NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/db";
import { RowDataPacket } from "mysql2";

interface ServidorMateria extends RowDataPacket {
  cargo: string;
  materia: string | null;
}

async function validarMateriaDoProfessor(
  servidorId: number,
  disciplina: string
): Promise<string | null> {
  const [rows] = await db.execute<ServidorMateria[]>(
    `SELECT cargo, materia FROM servidores WHERE id = ? LIMIT 1`,
    [servidorId]
  );
  const servidor = rows[0];

  if (!servidor || servidor.cargo !== "Professor") {
    return "A grade deve estar vinculada a um professor.";
  }

  if (!servidor.materia?.trim()) {
    return "Cadastre a matéria do professor antes de criar a grade.";
  }

  if (disciplina.trim() !== servidor.materia.trim()) {
    return "A disciplina da grade deve ser a mesma matéria do professor.";
  }

  return null;
}

export async function GET() {
  try {
    const [rows] = await db.query(`
      SELECT
        g.id,
        g.servidor_id,
        s.nome_completo,
        g.disciplina,
        g.turma,
        g.sala,
        g.dia_semana,
        TIME_FORMAT(g.hora_inicio, '%H:%i') AS hora_inicio,
        TIME_FORMAT(g.hora_fim, '%H:%i') AS hora_fim,
        g.status
      FROM grades_aulas g
      INNER JOIN servidores s ON s.id = g.servidor_id
      WHERE BINARY TRIM(g.disciplina) = BINARY TRIM(s.materia)
      ORDER BY
        FIELD(
          g.dia_semana,
          'Segunda',
          'Terça',
          'Quarta',
          'Quinta',
          'Sexta',
          'Sábado',
          'Domingo'
        ),
        g.hora_inicio
    `);

    return NextResponse.json(rows);
  } catch (error) {
    console.error("Erro ao buscar grades:", error);

    return NextResponse.json(
      { erro: "Erro ao buscar grades." },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const {
      servidor_id,
      disciplina,
      turma,
      sala,
      dia_semana,
      hora_inicio,
      hora_fim,
      status,
    } = body;

    if (
      !servidor_id ||
      !Number.isInteger(Number(servidor_id)) ||
      !disciplina ||
      !turma ||
      !sala ||
      !dia_semana ||
      !hora_inicio ||
      !hora_fim
    ) {
      return NextResponse.json(
        { erro: "Preencha todos os campos obrigatórios." },
        { status: 400 }
      );
    }

    if (hora_inicio >= hora_fim) {
      return NextResponse.json(
        { erro: "O horário de início deve ser anterior ao horário de término." },
        { status: 400 }
      );
    }

    const erroMateria = await validarMateriaDoProfessor(
      Number(servidor_id),
      disciplina
    );

    if (erroMateria) {
      return NextResponse.json({ erro: erroMateria }, { status: 400 });
    }

    const [resultado] = await db.query(
      `
      INSERT INTO grades_aulas
      (
        servidor_id,
        disciplina,
        turma,
        sala,
        dia_semana,
        hora_inicio,
        hora_fim,
        status
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        Number(servidor_id),
        disciplina,
        turma,
        sala,
        dia_semana,
        hora_inicio,
        hora_fim,
        status || "Ativo",
      ]
    );

    return NextResponse.json({
      mensagem: "Grade cadastrada com sucesso.",
      id: (resultado as any).insertId,
    });
  } catch (error) {
    console.error("Erro ao cadastrar grade:", error);

    return NextResponse.json(
      { erro: "Erro ao cadastrar grade." },
      { status: 500 }
    );
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json();

    const {
      id,
      servidor_id,
      disciplina,
      turma,
      sala,
      dia_semana,
      hora_inicio,
      hora_fim,
      status,
    } = body;

    if (
      !id ||
      !servidor_id ||
      !Number.isInteger(Number(servidor_id)) ||
      !disciplina ||
      !turma ||
      !sala ||
      !dia_semana ||
      !hora_inicio ||
      !hora_fim
    ) {
      return NextResponse.json(
        { erro: "Preencha todos os campos obrigatórios." },
        { status: 400 }
      );
    }

    if (hora_inicio >= hora_fim) {
      return NextResponse.json(
        { erro: "O horário de início deve ser anterior ao horário de término." },
        { status: 400 }
      );
    }

    const erroMateria = await validarMateriaDoProfessor(
      Number(servidor_id),
      disciplina
    );

    if (erroMateria) {
      return NextResponse.json({ erro: erroMateria }, { status: 400 });
    }

    await db.query(
      `
      UPDATE grades_aulas
      SET
        servidor_id = ?,
        disciplina = ?,
        turma = ?,
        sala = ?,
        dia_semana = ?,
        hora_inicio = ?,
        hora_fim = ?,
        status = ?
      WHERE id = ?
      `,
      [
        Number(servidor_id),
        disciplina,
        turma,
        sala,
        dia_semana,
        hora_inicio,
        hora_fim,
        status || "Ativo",
        id,
      ]
    );

    return NextResponse.json({
      mensagem: "Grade atualizada com sucesso.",
    });
  } catch (error) {
    console.error("Erro ao atualizar grade:", error);

    return NextResponse.json(
      { erro: "Erro ao atualizar grade." },
      { status: 500 }
    );
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get("id");

    if (!id) {
      return NextResponse.json(
        { erro: "ID da grade é obrigatório." },
        { status: 400 }
      );
    }

    await db.query(
      `
      DELETE FROM grades_aulas
      WHERE id = ?
      `,
      [id]
    );

    return NextResponse.json({
      mensagem: "Grade excluída com sucesso.",
    });
  } catch (error) {
    console.error("Erro ao excluir grade:", error);

    return NextResponse.json(
      { erro: "Erro ao excluir grade." },
      { status: 500 }
    );
  }
}