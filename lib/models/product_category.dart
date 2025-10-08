class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String apiEndpoint;
  final String icon;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.apiEndpoint,
    required this.icon,
  });

  static List<ProductCategory> getCategories() {
    return [
      ProductCategory(
        id: 'articles_printed',
        name: 'Artículos Impresos',
        description: 'Artículos publicados en revistas impresas con información detallada de publicación',
        apiEndpoint: 'ART_I',
        icon: '📰',
      ),
      ProductCategory(
        id: 'articles_electronic',
        name: 'Artículos Electrónicos',
        description: 'Artículos publicados en revistas electrónicas con enlaces web y DOI',
        apiEndpoint: 'ART_E',
        icon: '💻',
      ),
      ProductCategory(
        id: 'books',
        name: 'Libros de Investigación',
        description: 'Libros resultado de investigación con ISBN y editorial',
        apiEndpoint: 'LIB',
        icon: '📚',
      ),
      ProductCategory(
        id: 'book_chapters',
        name: 'Capítulos de Libro',
        description: 'Capítulos en libros resultado de investigación con referencia al libro',
        apiEndpoint: 'CAP_LIB',
        icon: '📖',
      ),
    ];
  }
}