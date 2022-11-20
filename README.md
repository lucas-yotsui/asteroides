# Asteroides 
## Projeto de Lucas Yukio Yotsui de Carvalho  

Projeto de jogo inspirado no clássico de fliperama "_Asteroides_" implemntado em C++17, utilizando da biblioteca SFML para recursos de interface gráfica.  

![Print do menu][print]
![Print do jogo][print2]
____

## Regras do Jogo:  
O funcionamento do jogo é simples: o jogador deve sobreviver aos asteroides voando ao seu redor, estando munido de uma arma em sua nave para destruí-los.  

O jogador pode mover sua nave pelo mapa utilizando as teclas W, A, S e D e pode atirar mirando com o mouse e disparando com o botão esquerdo. Ele possui um máximo de 200 pontos de vida, dos quais são removidos 50 toda vez que ele colide com um asteroide e adicionados 25 caso ele destrua um asteroide.   

Quando o jogador dispara ininterruptamente por 10 segundos sua arma superaquece e fica impossibilitada de disparar pelos próximos 15 segundos que ela leva para resfriar.

![Outro print do jogo][print3]

Cada asteroide possui 100 pontos de vida e, portanto, precisa ser atingido por dois disparos para ser destruído. Quando todos os asteroides na tela são destruídos, foi concluída a fase atual e inicia-se a próxima, populando a tela de asteroides mais uma vez. A qauntidade de asteroides em cada fase depende da dificuldade escolhida: para o nível fácil inicia-se o jogo com 15 asteroides e a cada fase avançada adiciona-se um asteroide a essa quantidade inicial; para o níveis médio e difícil a progressão dentre as fases é similar, adicionando um asteroide para cada fase avançada, porém nestes o jogo é iniciado com 30 e 45 asteroides respectivamente.  

____

## Detalhes da Implementação

### Classes, Atributos e Métodos  
O jogo em sua implmentação inteiramente orientada a objetos, fazendo com que possua em sua construção diversas classes com diferentes atributos e métodos. A exemplo disso, o próprio jogo é tratado como um objeto da classe ***Jogo***  
```cpp
class Jogo	{
	private:
		sf::RenderWindow	janela;
		Jogador	jogador;
		sf::Clock tempoDesdeUltimoTiro;
		std::vector<Asteroide*>	asteroides;
		unsigned int qtdInicialAsteroides, qtdAtualAsteroides;
		std::vector<Tiro*>	tiros;
		unsigned int qtdAtualTiros;
		sf::Mouse mouse;
		sf::Font fonte;
		sf::Text fase, pontuacao, recorde;
		unsigned int level, score, highScore;

		void processaEventos();
		bool atualizaJogo();
		void renderiza();
		void criaAsteroides(unsigned int qtd);
		void colisaoEntreAsteroides();
		void tiroNoAsteroide();
		void colisaoJogador();
		void trocaFase();
		void fimDeJogo();

	public:
		Jogo(int dificuldade);
		void rodaJogo();
		~Jogo();
};
```
_trecho do arquivo **frontend.h**_  

### Encapsulamento Respeitado por Todas as Classes  
Todas as classes tem seus atributos privados ou protegidos, de forma que um usuário que instancie um objeto de qualquer uma delas não terá acesso a esses atributos diretamente, podendo modificá-los somente através dos métodos disponíveis para tal. No trecho de código a seguir é possível ver a classe **Jogador** com o campo privado ***atirando*** que armazena o estado do jogador quanto a estar atirando ou não.  
```cpp
class Jogador:public Entidade	{
	private:
		bool	atirando;
		sf::Vector2f	direcao;
		sf::Clock	tempoDesdeUltimoHit;

	public:
		Jogador();
		void processaInputsDoUsuario(sf::Keyboard::Key tecla, bool pressionada);
		void processaInputsDoUsuario(sf::Mouse::Button botao, bool pressionada);
		void atualiza(float deltaTempo);
		void setDirecao(const sf::Vector2f& d);
		float falaTempo();
		void zeraTimer();
		bool estaAtirando();
		float getAngulo();
};
```
_trecho do arquivo **jogador.h**_

A seguir, é possível ver que a função ***estaAtirando()*** informa ao usuário qual o estado da variável ***atirando*** ao usuário sem permitir que ele a altere:  
```cpp
bool trabalho::Jogador::estaAtirando()	{
	return atirando;
}
```
_trecho do arquivo **jogador.cpp**_  
### Uso de Associação
As associações entre classes forma muito utilizadas no projeto, pois para representar um objeto na interface gráfica é preciso que ele tenha vários atributos desenháveis oriundos da biblioteca de SFML. Dessa forma, a maioria das classes criadas possuem dentro de si ao menos um objeto de uma das classes da biblioteca SFML, como a classe **Tiro** definida no seguinte trecho de código:  
```cpp
class Tiro	{
	private:
		sf::CircleShape	corpo;
		sf::FloatRect	hitbox;
		sf::Vector2f	direcao;
		float velocidade;

	public:
		Tiro(const sf::Vector2f& origem, const sf::Vector2f& alvo);
		void atualiza(float deltaTempo);
		sf::CircleShape getCorpo();
		sf::FloatRect	getHitbox();
		void 	setHitbox(const sf::FloatRect& h);
};
```
_trecho do arquivo **tiro.h**_  
### Uso de Alocação Dinâmica via Uso de Ponteiros Inteligentes  
Durante a implemtnação foi utilizada alocação dinâmica para os objetos do tipo Asteroide e Tiro, uma vez que esses objetos um tamanho de 384 e 728 Bytes respectivamente e, caso inicializados normalmente, causariam um estouro da pilha. Para essa alocação foram utilizados ponteiros inteligentes do tipo ***shared_ptr***, como pode ser visto no seguinte trecho:   
```cpp
void trabalho::Jogo::criaAsteroides(unsigned int qtd)	{
	for(unsigned int i = 0; i < qtd; i++)	{
		asteroides.push_back(std::shared_ptr<Asteroide>(new Asteroide{1870, 960}));

		for(unsigned int j = 0; j < i; j++)	{
			if(asteroides.back()->getHitbox().intersects(asteroides[j]->getHitbox()) || asteroides.back()->getHitbox().intersects(jogador.getHitbox()))	{
				asteroides.erase(asteroides.end() - 1);
				i--;
				qtdAtualAsteroides--;

				break;
			}
		}

		qtdAtualAsteroides++;
	}
}
```  
_trecho do arquivo **frontend.cpp**_    
### Sobrecarga de Operador  
Ao longo do projeto, foi realizada a sobrecarga de dois operaedores para a classe Entidade, sendo um o operdaor == que foi definido para testar se os hitboxes de duas entidades diferentes se interceptam e o outro o operador -- que foi utilizado para aplicar dano às entidades. Essa sobrecarga pode ser vista no seguinte trecho:  
```cpp
bool trabalho::Entidade::operator== (Entidade& e)	{
	return getHitbox().intersects(e.getHitbox());
}

void trabalho::Entidade::operator-- (int)	{
	vida -= 50;
} 
```
_trecho do arquivo **entidade.cpp**_
### Polimorfismo
Para a representação de dois dos três principais componentes do jogo, o jogador e os asteroides, foi utilizada uma classe base chamada _Entidade_, que é herdada por duas classes derivadas dela que são especializadas em cada um desses dois tipos de elemento. Essa classe base possui uma função puramente virtual chamada _atualiza_, que a torna abstrata e impede que um objeto dela seja instanciado. Essa função é definida para cada uma das classes derivadas, com comportmentos distintos e específicos. Seguem os trechos em que cada uma dessas classes é definida:
```cpp
class Entidade: public sf::Sprite	{
	protected:
		//Caracteristicas Fisicas da Entidade
		sf::Texture 		textura;
		sf::FloatRect		hitbox;
		sf::RectangleShape	barraDeVida;
		int 				vida;

		//Caracteristicas do Movimento da entidade
		sf::Vector2f		velocidadeAtual;
		float				maxVelocidade;
		float 				aceleracao;
		float				atrito;

		bool				cima;
		bool				baixo;
		bool				direita;
		bool				esquerda;

		float				limJanelaX;
		float				limJanelaY;

	public:
		Entidade(float maxVel, float acel, int life, float limX, float limY);
		void 				setHitbox(const sf::FloatRect& h);
		sf::FloatRect 		getHitbox();
		sf::RectangleShape	getBarraDeVida ();
		int 				getVida();
		void 				ganhaVida();
		virtual	void		atualiza(float deltaTempo) = 0;

		bool	operator== (Entidade& e);
		void	operator-- (int);
};
```  
_Trecho do arquivo **entidade.h**_  
```cpp
class Asteroide:public Entidade	{
	private:
		
	public:
		Asteroide(float limX, float limY);
		void	trocaDirecao(Asteroide& a2);
		void	trocaDirecao(Jogador& j);
		void	atualiza(float deltaTempo);
};
```  
_Trecho do arquivo **asteroide.h**_  
```cpp
class Jogador:public Entidade	{
	private:
		bool				atirando;
		bool				overheat;
		float				tempoAtirando;
		float				tempoCooldown;
		sf::Vector2f		direcao;
		sf::Clock			tempoDesdeUltimoHit;
		sf::RectangleShape	barraCooldown;
		sf::RectangleShape	barraOverheat;

	public:
		Jogador(float limX, float limY);
		void 				processaInputsDoUsuario(sf::Keyboard::Key tecla, bool pressionada);
		void 				processaInputsDoUsuario(sf::Mouse::Button botao, bool pressionada);
		void 				atualiza(float deltaTempo);
		void 				setDirecao(const sf::Vector2f& d);
		float 				falaTempo();
		void				zeraTimer();
		bool				getAtirando();
		bool 				getOverheated();
		sf::RectangleShape	getBarraCooldown();
		sf::RectangleShape	getBarraOverheat();
};
```
_Trecho do arquivo **jogador.h**_  
### Herança
O conceito de herança foi utilizado em diferentes ocasiões ao longo do projeto do jogo, como na classe **Entidade** que herda a classe **sf::Sprite** ou na classe **Jogador** que herda a classe **Entidade**, conforme pode ser visto em sua declaração:  
```cpp
class Jogador:public Entidade	{
	private:
		bool	atirando;
		sf::Vector2f	direcao;
		sf::Clock	tempoDesdeUltimoHit;

	public:
		Jogador();
		void processaInputsDoUsuario(sf::Keyboard::Key tecla, bool pressionada);
		void processaInputsDoUsuario(sf::Mouse::Button botao, bool pressionada);
		void atualiza(float deltaTempo);
		void setDirecao(const sf::Vector2f& d);
		float falaTempo();
		void zeraTimer();
		bool estaAtirando();
		float getAngulo();
};
```
_trecho do arquivo **jogador.h**_  

[print]:	imagensREADME/print.png
[print2]:	imagensREADME/print2.png
[print3]:	imagensREADME/print3.png