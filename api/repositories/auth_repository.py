from database import connector

class UsuarioRepository:
    def criar(self, usuario):
        query = """INSERT INTO usuarios (nome_completo, cpf, email, senha_hash, telefone, data_nascimento, tipo_perfil)
        VALUES(%s,%s,%s,%s,%s,%s,%s)
        """
        params = (
            usuario.nome_completo,
            usuario.cpf,
            usuario.email,
            usuario.senha_hash,
            usuario.telefone,
            usuario.data_nascimento,
            usuario.tipo_perfil
        )
        
        return connector.execute_query(query, params)

    def buscar_por_email(self, email):
        query = """SELECT id_usuario, nome_completo, cpf, email"""