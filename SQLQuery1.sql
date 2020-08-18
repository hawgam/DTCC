/* Criando Banco de Dados
create database Hawgamauditech
go
*/

use Hawgamauditech
go

/* Criação das tabelas */

/* Tabela 01 -  CLINICA VIRTUAL */
create table CLINICAVIRTUAL	(	idClinicaVirtual					INT				NOT NULL,
								nomeClinica							VARCHAR(100)	NOT NULL,
								enderecoClinica						VARCHAR(50)		NOT NULL,
								complementoEnder					VARCHAR(50)				,
								cepClinica							VARCHAR(9)		NOT NULL,
								cidadeClinica						VARCHAR(30)		NOT NULL,
								ufClinica							VARCHAR(2)		NOT NULL,
								cnpjClinica							VARCHAR(30)				,
								emailClinica						VARCHAR(100)	NOT NULL,
								dataAbertura						DATETIME		NOT NULL,
								dataEncerramento					DATETIME				,
								statusClinica						BIT						,
								/* Adição PF e FK */
								constraint IDCLINICAVIRTUAL_pk		PRIMARY KEY (idClinicaVirtual),
							);
go
/* Tabela 02 -  MIDIA */
create table MIDIA			(	idMidia 							INT				NOT NULL,
								descicaoMIDIA						VARCHAR(255)			,
								midiaPath							VARCHAR(255)	NOT NULL,
								midiaFile							VARBINARY(max)			,
								/* Adição PF e FK */
								constraint IDMIDIA_pk				PRIMARY KEY (idMidia),
							);
go
/* Tabela 03 -  EXERCICIO */
create table EXERCICIO		(	idExercicio							INT				NOT NULL,
								nomeExercicio						VARCHAR(100)	NOT NULL,
								descricaoExercicio					VARCHAR(255)			,
								padraoResposta						VARCHAR(255)	NOT NULL,	/* Neste caso tem que ser avaliado o tido das respostas */
								midiaIDmidia						INT				NOT NULL,
								profissionalIDprofissional			INT				NOT NULL,	/* Neste caso tem que ser avaliado se este dado sera herdado como fk */
								/* Adição PF e FK */
								constraint IDEXERCICIO_pk			PRIMARY KEY (idExercicio),
								constraint MIDIA_EXERCICIO_fk		FOREIGN KEY (midiaIDmidia)						references	MIDIA			(idMidia),
							);
go
/* Tabela 04 -  PARAMETRO */
create table PARAMETRO		(	idParametro							INT				NOT NULL,
								nomeParametro						VARCHAR(100)	NOT NULL,
								descricaoParametro					VARCHAR(255)	NOT NULL,
								valMinParametro						FLOAT					,
								valMaxParametro						FLOAT					,
								valDefaultParametro					FLOAT					,
								/* Adição PF e FK */
								constraint IDPARAMETRO_pk			PRIMARY KEY	(idParametro),
							);
go
/* Tabela 05 -  PACIENTE */
create table PACIENTE		(	idPaciente							INT				NOT NULL,
								nomePaciente						VARCHAR(100)	NOT NULL,
								cpfPaciente							VARCHAR(20)				,
								statusPaciente						BIT				NOT NULL,
								dataNascimento						DATE			NOT NULL,
								nomePai								VARCHAR(100)			,
								cpfPai								VARCHAR(20)				,
								nomeMae								VARCHAR(100)	NOT NULL,
								cpfMae								VARCHAR(20)		NOT NULL,
								enderecoPaciente					VARCHAR(50)		NOT NULL,
								complementoEnder					VARCHAR(50)				,
								cepPaciente							VARCHAR(9)		NOT NULL,
								cidadePaciente						VARCHAR(30)		NOT NULL,
								ufPaciente							VARCHAR(2)		NOT NULL,
								clinicaIDclinica					INT				NOT NULL,
								/* Adição PF e FK */
								constraint IDPACIENTE_pk			PRIMARY KEY	(idPaciente),
								constraint CLINICA_PACIENTE_fk		FOREIGN KEY	(clinicaIDclinica)					references	CLINICAVIRTUAL	(idClinicaVirtual),
							);
go
/* Tabela 06 -  TRATAMENTO */
create table TRATAMENTO		(	idTratamento						INT				NOT NULL,
								dataInicio							DATETIME		NOT NULL,
								dataTermino							DATETIME				,
								observacaoTratamento				NVARCHAR(max)			,
								statusTratamento					BIT				NOT NULL,
								profissionalIDprofissional			INT				NOT NULL, /* Neste caso tem que ser avaliado se este dado sera herdado como fk */
								pacienteIDpaciente					INT				NOT NULL,
								clinicaIDclinica					INT				NOT NULL,
								/* Adição PF e FK */
								constraint IDTRATAMENTO_pk			PRIMARY KEY	(idTratamento),
								constraint PACIENTE_TRATAMENTO_fk	FOREIGN KEY	(pacienteIDpaciente)				references	PACIENTE		(idPaciente),
								constraint CLINICA_TRATAMENTO_fk	FOREIGN KEY	(clinicaIDclinica)					references	CLINICAVIRTUAL	(idClinicaVirtual),
							);
go
/* Tabela 07 -  FASE */
create table FASE			(	idFase								INT				NOT NULL,
								dataInicio							DATETIME		NOT NULL,
								dataFinal							DATETIME				,
								numDias								FLOAT			NOT NULL,
								qtdeTreinoDia						FLOAT			NOT NULL,
								intervaloTreinoHora					FLOAT			NOT NULL,
								pesoTreino							FLOAT			NOT NULL,
								pesoDesafio							FLOAT			NOT NULL,
								parametroIDparametro				INT				NOT NULL,
								exercicioIDexercicio				INT				NOT NULL,
								tratamentoIDtratamento				INT				NOT NULL,
								/* Adição PF e FK */
								constraint IDFASE_pk				PRIMARY KEY	(idFase),
								constraint PARAMETRO_FASE_fk		FOREIGN KEY (parametroIDparametro)				references PARAMETRO		(idParametro),
								constraint EXERCICO_FASE_fk			FOREIGN KEY (exercicioIDexercicio)				references EXERCICIO		(idExercicio),
								constraint TRATAMENTO_FASE_fk		FOREIGN KEY (tratamentoIDtratamento)			references TRATAMENTO		(idTratamento),
							);
go
/* Tabela 08 -  TREINAMENTO FASE */
create table TREINAMENTOFASE(	idTreinamentoFase					INT				NOT NULL,
								respostaTreino						VARCHAR(255)			, /* Neste caso tem que ser avaliado o tido das respostas */
								dataExecucao						DATETIME		NOT NULL,
								faseIDfase							INT				NOT NULL, 
								/* Adição PF e FK */
								constraint IDTREINAMENTOFASE_pk		PRIMARY KEY (idTreinamentoFase),
								constraint FASE_TREINAMENTOFASE_fk	FOREIGN KEY (faseIDfase)						references FASE				(idFase),
							);
go
/* Tabela 09 -  RESULTADO FASE */
create table RESULTADOFASE	(	idResultadoFase						INT				NOT NULL,
								resultadoFase						FLOAT			NOT NULL, /* Neste caso tem que ser avaliado o tido das respostas */
								dataTermino							DATETIME		NOT NULL,
								faseIDfase							INT				NOT NULL, /* Neste caso tem que ser avaliado se este dado sera herdado como fk */
								treinamentofaseIDtreinamentofase 	INT				NOT NULL,
								pacienteIDpaciente					INT				NOT NULL,
								/* Adição PF e FK */
								constraint IDRESULTADOFASE_pk		PRIMARY KEY (idResultadoFase),
								constraint TREINAMENTO_RESULTADO_fk	FOREIGN KEY (treinamentofaseIDtreinamentofase)	references TREINAMENTOFASE	(idTreinamentoFase),
								constraint PACIENTE_RESULTADO_fk	FOREIGN KEY (pacienteIDpaciente)				references PACIENTE			(idPaciente),
							);
go
/* Tabela 10 -  PROFISSIONAL */
create table PROFISSIONAL	(	idProfissional						INT				NOT NULL,
								nomeProfissional					VARCHAR(100)	NOT NULL,
								cpfProfissional						VARCHAR(20)		NOT NULL,
								numOrdemProfissional				VARCHAR(30)				,
								clinicaIDclinica					INT				NOT NULL,
								/* Adição PF e FK */
								constraint IDPROFISSIONAL_pk		PRIMARY KEY (idProfissional),
								constraint CLINICA_PROFISSIONAL_fk	FOREIGN KEY (clinicaIDclinica)					references CLINICAVIRTUAL	(idClinicaVirtual),
							);
 go
/* Tabela 11 -  TELEFONE */
create table TELEFONE		(	idTelefone							INT				NOT NULL,
								tipoTelefone						INT				NOT NULL,
								numTelefone							VARCHAR(20)		NOT NULL,
								tipoOwner							INT				NOT NULL,
								idOwner								INT						,
								clinicaIDclinica					INT				NOT NULL,
								profissionalIDprofissional			INT				NOT NULL, 
								/* Adição PF e FK */
								constraint IDTELEFONE_pk			PRIMARY KEY (idTelefone),
								constraint CLINICA_TELEFONE_fk		FOREIGN KEY (clinicaIDclinica)					references CLINICAVIRTUAL	(idClinicaVirtual),
								constraint PROFISSIONAL_TELEFONE_fk	FOREIGN KEY (profissionalIDprofissional)		references PROFISSIONAL		(idProfissional),
							);
go
/* Tabela 12 -  FATURAMENTO */
create table FATURAMENTO	(	idFaturamento						INT				NOT NULL,
								numNF								VARCHAR(20)		NOT NULL,
								dataFaturamento						DATE			NOT NULL,
								qtdePaciente						INT				NOT NULL,
								qtdeTratamento						INT				NOT NULL,
								qtdeTreinamento						INT				NOT NULL,
								valorPaciente						NUMERIC(7,2)	NOT NULL,
								valorTratamento						NUMERIC(7,2)	NOT NULL,
								valorTreinamento					NUMERIC(7,2)	NOT NULL,
								valorClinica						NUMERIC(7,2)	NOT NULL,
								valorTotal							NUMERIC(7,2)	NOT NULL,
								aliqImposto							FLOAT			NOT NULL,
								clinicaIDclinica					INT				NOT NULL,
								/* Adição PF e FK */
								constraint IDFATURAMENTO_pk			PRIMARY KEY (idFaturamento),
								constraint CLINICA_FATURAMENTO_fk	FOREIGN KEY (clinicaIDclinica)					references CLINICAVIRTUAL	(idClinicaVirtual),
							);
go

/* DROP DAS TABELAS - ANTES DE INSERIR DADOS */

drop table FATURAMENTO
go
drop table TELEFONE
go
drop table PROFISSIONAL
go
drop table RESULTADOFASE
go
drop table TREINAMENTOFASE
go
drop table FASE
go
drop table TRATAMENTO
go
drop table PACIENTE
go
drop table PARAMETRO
go
drop table EXERCICIO
go
drop table MIDIA
go
drop table CLINICAVIRTUAL
go

/* FINAL DO DROP DAS TABELAS */

sp_help clinicavirtual
