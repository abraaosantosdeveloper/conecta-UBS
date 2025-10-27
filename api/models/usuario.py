class Usuario:
    def __init__(self, nome_completo, cpf, email, senha_hash, data_nascimento, tipo_perfil, 
                 telefone=None, id_usuario=None, ativo=True, data_cadastro=None, data_atualizacao=None):
        self.nome_completo = nome_completo
        self.cpf = cpf
        self.email = email
        self.senha_hash = senha_hash
        self.data_nascimento = data_nascimento
        self.tipo_perfil = tipo_perfil
        self.telefone = telefone
        self.id_usuario = id_usuario
        self.ativo = ativo
        self.data_cadastro = data_cadastro
        self.data_atualizacao = data_atualizacao
    
    def to_dict(self):
        return {
            'id_usuario': self.id_usuario,
            'nome_completo': self.nome_completo,
            'cpf': self.cpf,
            'email': self.email,
            'telefone': self.telefone,
            'data_nascimento': self.data_nascimento,
            'tipo_perfil': self.tipo_perfil,
            'ativo': self.ativo
        }