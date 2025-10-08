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
      // Generación de Nuevo Conocimiento
      ProductCategory(
        id: 'articles_printed',
        name: 'Artículos Impresos',
        description: 'Artículos publicados en revistas impresas',
        apiEndpoint: 'ART_I',
        icon: '📰',
      ),
      ProductCategory(
        id: 'articles_electronic',
        name: 'Artículos Electrónicos',
        description: 'Artículos publicados en revistas electrónicas',
        apiEndpoint: 'ART_E',
        icon: '💻',
      ),
      ProductCategory(
        id: 'books',
        name: 'Libros de Investigación',
        description: 'Libros resultado de investigación',
        apiEndpoint: 'LIB',
        icon: '📚',
      ),
      ProductCategory(
        id: 'book_chapters',
        name: 'Capítulos de Libro',
        description: 'Capítulos en libros resultado de investigación',
        apiEndpoint: 'CAP_LIB',
        icon: '📖',
      ),
      ProductCategory(
        id: 'patents',
        name: 'Patentes',
        description: 'Patentes registradas',
        apiEndpoint: 'PAT',
        icon: '🔬',
      ),
      ProductCategory(
        id: 'scientific_notes_printed',
        name: 'Notas Científicas Impresas',
        description: 'Notas científicas en formato impreso',
        apiEndpoint: 'N_I',
        icon: '📝',
      ),
      ProductCategory(
        id: 'scientific_notes_electronic',
        name: 'Notas Científicas Electrónicas',
        description: 'Notas científicas en formato electrónico',
        apiEndpoint: 'N_E',
        icon: '📝',
      ),
      
      // Desarrollo Tecnológico e Innovación
      ProductCategory(
        id: 'software',
        name: 'Software',
        description: 'Desarrollos de software',
        apiEndpoint: 'SF',
        icon: '⚙️',
      ),
      ProductCategory(
        id: 'industrial_prototype',
        name: 'Prototipo Industrial',
        description: 'Prototipos industriales desarrollados',
        apiEndpoint: 'PI',
        icon: '🔧',
      ),
      ProductCategory(
        id: 'tech_companies',
        name: 'Empresas Base Tecnológica',
        description: 'Empresas de base tecnológica',
        apiEndpoint: 'EBT',
        icon: '🏢',
      ),
      ProductCategory(
        id: 'industrial_design',
        name: 'Diseño Industrial',
        description: 'Diseños industriales registrados',
        apiEndpoint: 'DI',
        icon: '🎨',
      ),
      ProductCategory(
        id: 'pilot_plant',
        name: 'Planta Piloto',
        description: 'Plantas piloto desarrolladas',
        apiEndpoint: 'PP',
        icon: '🏭',
      ),
      ProductCategory(
        id: 'utility_model',
        name: 'Modelo de Utilidad',
        description: 'Modelos de utilidad registrados',
        apiEndpoint: 'MU',
        icon: '🔩',
      ),
      ProductCategory(
        id: 'circuit_layout',
        name: 'Esquema de Circuito Integrado',
        description: 'Esquemas de circuitos integrados',
        apiEndpoint: 'ECI',
        icon: '🔌',
      ),
      ProductCategory(
        id: 'regulations',
        name: 'Regulaciones, Normas o Legislaciones',
        description: 'Regulaciones y normas desarrolladas',
        apiEndpoint: 'REG',
        icon: '📋',
      ),
      ProductCategory(
        id: 'tech_consulting',
        name: 'Consultoría en S&T',
        description: 'Consultoría en ciencia y tecnología',
        apiEndpoint: 'CON_S_T',
        icon: '💼',
      ),
      ProductCategory(
        id: 'innovation',
        name: 'Innovación en Gestión Empresarial',
        description: 'Innovaciones en procesos empresariales',
        apiEndpoint: 'INO_EMP',
        icon: '📈',
      ),
      ProductCategory(
        id: 'tech_services',
        name: 'Servicios Técnicos',
        description: 'Servicios técnicos especializados',
        apiEndpoint: 'ST',
        icon: '🔧',
      ),
      ProductCategory(
        id: 'tech_processes',
        name: 'Procesos y Procedimientos',
        description: 'Procesos y procedimientos técnicos',
        apiEndpoint: 'PRO_PROC',
        icon: '⚙️',
      ),
      ProductCategory(
        id: 'other_articles',
        name: 'Otro Artículo Divulgativo',
        description: 'Otros artículos de divulgación',
        apiEndpoint: 'GC_ART',
        icon: '📰',
      ),
      
      // Formación de Recursos Humanos
      ProductCategory(
        id: 'thesis_doctorate',
        name: 'Tesis de Doctorado',
        description: 'Dirección de tesis doctorales',
        apiEndpoint: 'TD',
        icon: '🎓',
      ),
      ProductCategory(
        id: 'thesis_master',
        name: 'Tesis de Maestría',
        description: 'Dirección de tesis de maestría',
        apiEndpoint: 'TM',
        icon: '🎓',
      ),
      ProductCategory(
        id: 'undergraduate_project',
        name: 'Trabajo de Pregrado',
        description: 'Dirección de trabajos de pregrado',
        apiEndpoint: 'TP',
        icon: '🎓',
      ),
      ProductCategory(
        id: 'student_support',
        name: 'Apoyo a Estudiantes',
        description: 'Apoyo y acompañamiento a estudiantes',
        apiEndpoint: 'AE',
        icon: '🤝',
      ),
      ProductCategory(
        id: 'postdoc',
        name: 'Estancia de Investigación Postdoctoral',
        description: 'Supervisión de estancias postdoctorales',
        apiEndpoint: 'EIP',
        icon: '🔬',
      ),
      ProductCategory(
        id: 'researcher_training',
        name: 'Cursos de Formación',
        description: 'Cursos de formación de investigadores',
        apiEndpoint: 'CFR',
        icon: '📚',
      ),
      
      // Apropiación Social del Conocimiento
      ProductCategory(
        id: 'social_participation',
        name: 'Participación en Espacios',
        description: 'Participación ciudadana en C&T',
        apiEndpoint: 'ASC1',
        icon: '👥',
      ),
      ProductCategory(
        id: 'circulation_knowledge',
        name: 'Circulación de Conocimiento',
        description: 'Circulación del conocimiento especializado',
        apiEndpoint: 'ASC2',
        icon: '🔄',
      ),
      ProductCategory(
        id: 'communication_knowledge',
        name: 'Comunicación del Conocimiento',
        description: 'Comunicación pública del conocimiento',
        apiEndpoint: 'ASC3',
        icon: '📢',
      ),
      ProductCategory(
        id: 'knowledge_transfer',
        name: 'Transferencia de Conocimiento',
        description: 'Gestión y transferencia de conocimiento',
        apiEndpoint: 'ASC4',
        icon: '🔄',
      ),
      ProductCategory(
        id: 'tech_appropriation',
        name: 'Apropiación Tecnológica',
        description: 'Uso y apropiación de tecnologías',
        apiEndpoint: 'ASC5',
        icon: '📲',
      ),
      ProductCategory(
        id: 'social_innovation',
        name: 'Innovación Social',
        description: 'Innovaciones de tipo social',
        apiEndpoint: 'ASC6',
        icon: '🌟',
      ),
      ProductCategory(
        id: 'entrepreneurship',
        name: 'Emprendimientos',
        description: 'Emprendimientos de base tecnológica',
        apiEndpoint: 'ASC7',
        icon: '🚀',
      ),
      ProductCategory(
        id: 'science_networks',
        name: 'Redes de Conocimiento',
        description: 'Redes de conocimiento científico',
        apiEndpoint: 'ASC8',
        icon: '🌐',
      ),
      
      // Otros Productos Académicos
      ProductCategory(
        id: 'editorial_books',
        name: 'Libros de Texto',
        description: 'Libros de texto y editoriales',
        apiEndpoint: 'LIB_EDIT',
        icon: '📖',
      ),
      ProductCategory(
        id: 'tech_manuals',
        name: 'Manuales Técnicos',
        description: 'Manuales y documentos técnicos',
        apiEndpoint: 'MAN_TEC',
        icon: '📋',
      ),
      ProductCategory(
        id: 'translations',
        name: 'Traducciones',
        description: 'Traducciones de obras especializadas',
        apiEndpoint: 'LIB1',
        icon: '🌍',
      ),
      ProductCategory(
        id: 'other_publications',
        name: 'Otras Publicaciones',
        description: 'Otras publicaciones divulgativas',
        apiEndpoint: 'OT_PROD',
        icon: '📄',
      ),
      ProductCategory(
        id: 'documentary',
        name: 'Documentales',
        description: 'Documentales científicos',
        apiEndpoint: 'DOC',
        icon: '🎬',
      ),
      ProductCategory(
        id: 'artistic_expressions',
        name: 'Expresiones Artísticas',
        description: 'Obras y expresiones artísticas',
        apiEndpoint: 'EXP_ART',
        icon: '🎨',
      ),
      ProductCategory(
        id: 'literary_works',
        name: 'Obras Literarias',
        description: 'Creaciones literarias',
        apiEndpoint: 'OBR_LIT',
        icon: '✍️',
      ),
      ProductCategory(
        id: 'musical_works',
        name: 'Obras Musicales',
        description: 'Composiciones musicales',
        apiEndpoint: 'OBR_MUS',
        icon: '🎵',
      ),
      ProductCategory(
        id: 'architectural_works',
        name: 'Obras Arquitectónicas',
        description: 'Diseños arquitectónicos',
        apiEndpoint: 'OBR_ARQ',
        icon: '🏗️',
      ),
      
      // Actividades de Investigación
      ProductCategory(
        id: 'research_projects',
        name: 'Proyectos de Investigación',
        description: 'Proyectos de investigación ejecutados',
        apiEndpoint: 'PROY_INV',
        icon: '🔬',
      ),
      ProductCategory(
        id: 'extension_projects',
        name: 'Proyectos de Extensión',
        description: 'Proyectos de extensión y vinculación',
        apiEndpoint: 'PROY_EXT',
        icon: '🤝',
      ),
      ProductCategory(
        id: 'awards',
        name: 'Premios y Distinciones',
        description: 'Reconocimientos y premios obtenidos',
        apiEndpoint: 'PREM',
        icon: '🏆',
      ),
      ProductCategory(
        id: 'editorial_activities',
        name: 'Actividades Editoriales',
        description: 'Participación en actividades editoriales',
        apiEndpoint: 'ACT_EDIT',
        icon: '✏️',
      ),
      ProductCategory(
        id: 'academic_events',
        name: 'Eventos Académicos',
        description: 'Organización de eventos académicos',
        apiEndpoint: 'EVENT_ACAD',
        icon: '🎪',
      ),
      ProductCategory(
        id: 'networks',
        name: 'Redes de Investigación',
        description: 'Participación en redes de investigación',
        apiEndpoint: 'REDES',
        icon: '🌐',
      ),
      ProductCategory(
        id: 'peer_evaluation',
        name: 'Evaluación Académica',
        description: 'Actividades de evaluación por pares',
        apiEndpoint: 'EVAL_ACAD',
        icon: '📝',
      ),
      ProductCategory(
        id: 'academic_networks',
        name: 'Membresías Académicas',
        description: 'Membresías en organizaciones académicas',
        apiEndpoint: 'MEMB_ACAD',
        icon: '🎓',
      ),
    ];
  }
}