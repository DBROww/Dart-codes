import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MercadoApp());
}

// ============================================================================
// CORES
// ============================================================================

const Color azul = Color(0xFF1565C0);
const Color azulEscuro = Color(0xFF0D47A1);
const Color azulClaro = Color(0xFFE3F2FD);
const Color fundo = Color(0xFFF5F5F5);

// ============================================================================
// MODELO
// ============================================================================

class Produto {
  String nome;
  double preco;
  int quantidade;
  bool comprado;

  Produto({
    required this.nome,
    required this.preco,
    this.quantidade = 1,
    this.comprado = false,
  });

  double get total => preco * quantidade;
}

// ============================================================================
// LISTA DINÂMICA
// ============================================================================

final List<Produto> produtos = [
  Produto(nome: 'Arroz 5kg', preco: 24.90),
  Produto(nome: 'Feijão 1kg', preco: 8.50, quantidade: 2),
  Produto(nome: 'Leite 1L', preco: 4.80),
  Produto(nome: 'Pão de forma', preco: 9.90),
];

// ============================================================================
// GO ROUTER
// ============================================================================

final GoRouter router = GoRouter(
  initialLocation: '/',

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(child: child);
      },

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const InicioScreen();
          },
        ),

        GoRoute(
          path: '/categorias',
          builder: (context, state) {
            return const CategoriasScreen();
          },
        ),

        GoRoute(
          path: '/carrinho',
          builder: (context, state) {
            return const CarrinhoScreen();
          },
        ),
      ],
    ),
  ],
);

// ============================================================================
// APP
// ============================================================================

class MercadoApp extends StatelessWidget {
  const MercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: azul),
        scaffoldBackgroundColor: fundo,
        fontFamily: 'Roboto',
      ),

      routerConfig: router,
    );
  }
}

// ============================================================================
// LAYOUT PRINCIPAL
// ============================================================================

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path == '/categorias') return 1;
    if (path == '/carrinho') return 2;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index(context),

        indicatorColor: azulClaro,

        onDestinationSelected: (index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/categorias');
          } else {
            context.go('/carrinho');
          }
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categorias',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DRAWER
// ============================================================================

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  void _feedback(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: azul));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // CABEÇALHO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 55, 24, 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [azulEscuro, azul]),
            ),

            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.shopping_cart, color: Colors.white, size: 48),

                SizedBox(height: 12),

                Text(
                  'Lista de Compras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Supermercado',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // MENU
          DrawerItem(
            icon: Icons.home_outlined,
            titulo: 'Início',

            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),

          DrawerItem(
            icon: Icons.category_outlined,
            titulo: 'Categorias',

            onTap: () {
              Navigator.pop(context);
              context.go('/categorias');
            },
          ),

          DrawerItem(
            icon: Icons.shopping_cart_outlined,
            titulo: 'Carrinho',

            onTap: () {
              Navigator.pop(context);
              context.go('/carrinho');
            },
          ),

          const Divider(indent: 20, endIndent: 20),

          DrawerItem(
            icon: Icons.delete_outline,
            titulo: 'Limpar lista',

            iconColor: Colors.red,
            textColor: Colors.red,

            onTap: () {
              Navigator.pop(context);

              if (produtos.isEmpty) {
                _feedback(context, 'A lista já está vazia.');
                return;
              }

              produtos.clear();

              _feedback(context, 'Lista de compras limpa!');
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ITEM DO DRAWER
// ============================================================================

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.titulo,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade700),

      title: Text(
        titulo,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),

      onTap: onTap,
    );
  }
}

// ============================================================================
// TELA INICIAL
// ============================================================================

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final nomeController = TextEditingController();
  final precoController = TextEditingController();

  String _dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // --------------------------------------------------------------------------
  // ADICIONAR
  // --------------------------------------------------------------------------

  void _adicionarProduto() {
    final nome = nomeController.text.trim();

    final preco = double.tryParse(precoController.text.replaceAll(',', '.'));

    if (nome.isEmpty || preco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o nome e o preço do produto.'),
          backgroundColor: Colors.orange,
        ),
      );

      return;
    }

    setState(() {
      produtos.add(Produto(nome: nome, preco: preco));
    });

    nomeController.clear();
    precoController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nome foi adicionado à lista.'),
        backgroundColor: azul,
      ),
    );
  }

  // --------------------------------------------------------------------------
  // QUANTIDADE
  // --------------------------------------------------------------------------

  void _alterarQuantidade(Produto produto, int valor) {
    setState(() {
      produto.quantidade += valor;

      if (produto.quantidade < 1) {
        produto.quantidade = 1;
      }
    });
  }

  // --------------------------------------------------------------------------
  // COMPRADO
  // --------------------------------------------------------------------------

  void _alterarCompra(Produto produto, bool valor) {
    setState(() {
      produto.comprado = valor;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          valor
              ? '${produto.nome} comprado!'
              : '${produto.nome} voltou para a lista.',
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // REMOVER
  // --------------------------------------------------------------------------

  void _removerProduto(Produto produto) {
    setState(() {
      produtos.remove(produto);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} removido.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TOTAL
  // --------------------------------------------------------------------------

  double get _total {
    double valor = 0;

    for (final produto in produtos) {
      valor += produto.total;
    }

    return valor;
  }

  // --------------------------------------------------------------------------
  // BUILD
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),

              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text(
          'Lista de Compras',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        centerTitle: true,
      ),

      drawer: const MenuDrawer(),

      body: Column(
        children: [
          // ------------------------------------------------------------------
          // RESUMO
          // ------------------------------------------------------------------
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,

                  decoration: BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.shopping_basket_outlined,
                    color: azul,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Total da lista',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        _dinheiro(_total),

                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: azul,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      '${produtos.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      'itens',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ------------------------------------------------------------------
          // CAMPOS
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                Expanded(
                  flex: 2,

                  child: TextField(
                    controller: nomeController,

                    decoration: InputDecoration(
                      hintText: 'Produto',

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: precoController,

                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    decoration: InputDecoration(
                      hintText: 'Preço',

                      prefixText: 'R\$ ',

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  decoration: BoxDecoration(
                    color: azul,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: IconButton(
                    onPressed: _adicionarProduto,

                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ------------------------------------------------------------------
          // TÍTULO
          // ------------------------------------------------------------------
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),

            child: Row(
              children: [
                Text(
                  'Produtos',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------------------
          // LISTA
          // ------------------------------------------------------------------
          Expanded(
            child: produtos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.remove_shopping_cart_outlined,

                          size: 60,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'Sua lista está vazia.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    itemCount: produtos.length,

                    itemBuilder: (context, index) {
                      final produto = produtos[index];

                      return _ProdutoTile(
                        produto: produto,

                        dinheiro: _dinheiro,

                        onMais: () {
                          _alterarQuantidade(produto, 1);
                        },

                        onMenos: () {
                          _alterarQuantidade(produto, -1);
                        },

                        onCheck: (valor) {
                          _alterarCompra(produto, valor ?? false);
                        },

                        onDelete: () {
                          _removerProduto(produto);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();

    super.dispose();
  }
}

// ============================================================================
// ITEM DO PRODUTO
// ============================================================================

class _ProdutoTile extends StatelessWidget {
  final Produto produto;
  final String Function(double) dinheiro;

  final VoidCallback onMais;
  final VoidCallback onMenos;
  final VoidCallback onDelete;

  final ValueChanged<bool?> onCheck;

  const _ProdutoTile({
    required this.produto,
    required this.dinheiro,
    required this.onMais,
    required this.onMenos,
    required this.onDelete,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,

      margin: const EdgeInsets.only(bottom: 7),

      child: Padding(
        padding: const EdgeInsets.all(8),

        child: Row(
          children: [
            // ÍCONE
            Container(
              width: 45,
              height: 45,

              decoration: BoxDecoration(
                color: azulClaro,

                borderRadius: BorderRadius.circular(10),
              ),

              child: const Icon(Icons.shopping_basket_outlined, color: azul),
            ),

            const SizedBox(width: 10),

            // NOME E PREÇO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    produto.nome,

                    style: TextStyle(
                      fontWeight: FontWeight.w600,

                      decoration: produto.comprado
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    dinheiro(produto.preco),

                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            // QUANTIDADE
            Row(
              children: [
                IconButton(
                  onPressed: onMenos,
                  icon: const Icon(Icons.remove, size: 18),
                ),

                Text(
                  '${produto.quantidade}',

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                IconButton(
                  onPressed: onMais,
                  icon: const Icon(Icons.add, size: 18),
                ),
              ],
            ),

            // CHECKBOX
            Checkbox(
              value: produto.comprado,
              activeColor: azul,
              onChanged: onCheck,
            ),

            // REMOVER
            IconButton(
              onPressed: onDelete,

              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TELA DE CATEGORIAS
// ============================================================================

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  final List<Map<String, dynamic>> categorias = const [
    {'nome': 'Alimentos', 'icone': Icons.restaurant},
    {'nome': 'Bebidas', 'icone': Icons.local_drink},
    {'nome': 'Higiene', 'icone': Icons.clean_hands},
    {'nome': 'Limpeza', 'icone': Icons.cleaning_services},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),

              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text('Categorias'),

        centerTitle: true,
      ),

      drawer: const MenuDrawer(),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          crossAxisSpacing: 12,
          mainAxisSpacing: 12,

          childAspectRatio: 1.2,
        ),

        itemCount: categorias.length,

        itemBuilder: (context, index) {
          final categoria = categorias[index];

          return Card(
            color: Colors.white,
            elevation: 0,

            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Categoria: ${categoria['nome']}')),
                );
              },

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    width: 55,
                    height: 55,

                    decoration: const BoxDecoration(
                      color: azulClaro,
                      shape: BoxShape.circle,
                    ),

                    child: Icon(categoria['icone'], color: azul, size: 28),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    categoria['nome'],

                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// TELA DO CARRINHO
// ============================================================================

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  double get total {
    double valor = 0;

    for (final produto in produtos) {
      if (produto.comprado) {
        valor += produto.total;
      }
    }

    return valor;
  }

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final comprados = produtos.where((p) => p.comprado).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),

              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text('Carrinho'),

        centerTitle: true,
      ),

      drawer: const MenuDrawer(),

      body: Column(
        children: [
          Expanded(
            child: comprados.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'Nenhum produto comprado.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(14),

                    itemCount: comprados.length,

                    itemBuilder: (context, index) {
                      final produto = comprados[index];

                      return Card(
                        color: Colors.white,
                        elevation: 0,

                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: azul),

                          title: Text(produto.nome),

                          subtitle: Text('${produto.quantidade} unidade(s)'),

                          trailing: Text(
                            dinheiro(produto.total),

                            style: const TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // TOTAL
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(20),

            color: azulClaro,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Total da compra',

                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                Text(
                  dinheiro(total),

                  style: const TextStyle(
                    color: azul,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
