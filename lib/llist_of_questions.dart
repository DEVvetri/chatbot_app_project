
List<Map<String, dynamic>> testModules = [
  {
    'domain': 'software development',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is the purpose of a variable in programming?',
        'options': [
          'To store data temporarily',
          'To execute a program',
          'To design the UI',
          'To connect to a database'
        ],
        'answer': 'A'
      },
      {
        'question': 'What does SDLC stand for?',
        'options': [
          'Software Design and Learning Cycle',
          'Software Development Life Cycle',
          'System Development and Logic Control',
          'Simple Data Lifecycle'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which of these is a programming language?',
        'options': ['HTML', 'Python', 'CSS', 'XML'],
        'answer': 'B'
      },
      {
        'question': 'What is a bug in software development?',
        'options': [
          'A feature of the software',
          'An error in the code',
          'A type of hardware',
          'A security protocol'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of testing in software development?',
        'options': [
          'To write more code',
          'To find and fix errors',
          'To design the interface',
          'To deploy the software'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'software development',
    'level': 'High',
    'questions': [
      {
        'question':
            'Which design pattern is best for managing object creation?',
        'options': ['Singleton', 'Factory', 'Observer', 'Decorator'],
        'answer': 'B'
      },
      {
        'question':
            'How does a race condition occur in multi-threaded programming?',
        'options': [
          'When threads share memory unsafely',
          'When a single thread runs too fast',
          'When the CPU overheats',
          'When memory allocation fails'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is the time complexity of a binary search algorithm?',
        'options': ['O(n)', 'O(log n)', 'O(n^2)', 'O(1)'],
        'answer': 'B'
      },
      {
        'question': 'Which technique prevents SQL injection in software?',
        'options': [
          'Input validation',
          'Parameterized queries',
          'Hashing passwords',
          'Using cookies'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of a microservices architecture?',
        'options': [
          'To centralize all functionality',
          'To break an application into smaller, independent services',
          'To increase hardware usage',
          'To simplify database design'
        ],
        'answer': 'B'
      }
    ]
  },
  // App Development
  {
    'domain': 'app development',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is the difference between native and hybrid apps?',
        'options': [
          'Native uses web tech, hybrid uses platform-specific code',
          'Native is platform-specific, hybrid uses web tech',
          'Both are the same',
          'Native is slower than hybrid'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which company develops the Android OS?',
        'options': ['Apple', 'Google', 'Microsoft', 'Samsung'],
        'answer': 'B'
      },
      {
        'question': 'What is an APK file?',
        'options': [
          'A graphics file',
          'An Android application package',
          'A database file',
          'A configuration file'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the primary language for iOS app development?',
        'options': ['Java', 'Swift', 'Python', 'C++'],
        'answer': 'B'
      },
      {
        'question': 'What does UI stand for in app development?',
        'options': [
          'User Interface',
          'Unique Identifier',
          'Utility Integration',
          'User Input'
        ],
        'answer': 'A'
      }
    ]
  },
  {
    'domain': 'app development',
    'level': 'High',
    'questions': [
      {
        'question': 'How do you handle app crashes in production?',
        'options': [
          'Ignore them',
          'Use crash reporting tools like Crashlytics',
          'Restart the app manually',
          'Delete the app'
        ],
        'answer': 'B'
      },
      {
        'question':
            'What is the purpose of dependency injection in app development?',
        'options': [
          'To tightly couple components',
          'To improve testability and modularity',
          'To increase app size',
          'To reduce memory usage'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which technique optimizes app startup time?',
        'options': [
          'Lazy loading',
          'Preloading all assets',
          'Increasing thread count',
          'Using more libraries'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is AOT compilation in app development?',
        'options': [
          'Ahead-of-Time compilation for faster runtime',
          'Automatic Object Tracking',
          'A type of debugging',
          'A security feature'
        ],
        'answer': 'A'
      },
      {
        'question': 'How do you secure sensitive data in a mobile app?',
        'options': [
          'Store it in plain text',
          'Use encryption and secure storage',
          'Send it to a server',
          'Hide it in the UI'
        ],
        'answer': 'B'
      }
    ]
  },
  // Web Development
  {
    'domain': 'web development',
    'level': 'Low',
    'questions': [
      {
        'question': 'What does HTML stand for?',
        'options': [
          'HyperText Markup Language',
          'High-Level Text Language',
          'Hyper Transfer Markup Logic',
          'Home Tool Markup Language'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is the purpose of CSS?',
        'options': [
          'To add interactivity',
          'To style web pages',
          'To store data',
          'To manage servers'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does JavaScript do on a webpage?',
        'options': [
          'Adds styling',
          'Structures content',
          'Adds interactivity',
          'Manages databases'
        ],
        'answer': 'C'
      },
      {
        'question': 'What is a web browser?',
        'options': [
          'A programming language',
          'Software to access the internet',
          'A type of server',
          'A security protocol'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of a URL?',
        'options': [
          'To locate a resource on the web',
          'To style a webpage',
          'To encrypt data',
          'To run a script'
        ],
        'answer': 'A'
      }
    ]
  },
  {
    'domain': 'web development',
    'level': 'High',
    'questions': [
      {
        'question': 'What is the purpose of a CDN in web development?',
        'options': [
          'To store user data',
          'To deliver content faster globally',
          'To secure the server',
          'To write backend code'
        ],
        'answer': 'B'
      },
      {
        'question': 'How does CORS affect web security?',
        'options': [
          'It allows unrestricted resource sharing',
          'It restricts cross-origin requests',
          'It encrypts all data',
          'It speeds up requests'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is SSR in web development?',
        'options': [
          'Server-Side Rendering',
          'Simple Style Rendering',
          'Secure Socket Request',
          'Single Script Runtime'
        ],
        'answer': 'A'
      },
      {
        'question': 'How do you prevent XSS attacks?',
        'options': [
          'By sanitizing user input',
          'By increasing server load',
          'By disabling JavaScript',
          'By using more cookies'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is the benefit of using WebSockets?',
        'options': [
          'One-way communication',
          'Real-time bidirectional communication',
          'Reduced security',
          'Faster page loads'
        ],
        'answer': 'B'
      }
    ]
  },
  // Data Science
  {
    'domain': 'data science',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is data science?',
        'options': [
          'A field that analyzes and interprets data',
          'A type of hardware',
          'A programming language',
          'A web development tool'
        ],
        'answer': 'A'
      },
      {
        'question': 'Which language is commonly used in data science?',
        'options': ['HTML', 'Python', 'CSS', 'JavaScript'],
        'answer': 'B'
      },
      {
        'question': 'What is a dataset?',
        'options': [
          'A collection of data',
          'A type of software',
          'A programming function',
          'A security protocol'
        ],
        'answer': 'A'
      },
      {
        'question': 'What does CSV stand for?',
        'options': [
          'Comma-Separated Values',
          'Computer System Variables',
          'Common Science Values',
          'Compiled Source Values'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is the purpose of data visualization?',
        'options': [
          'To write code',
          'To represent data graphically',
          'To store data',
          'To encrypt data'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'data science',
    'level': 'High',
    'questions': [
      {
        'question':
            'What is the purpose of regularization in machine learning?',
        'options': [
          'To increase model complexity',
          'To prevent overfitting',
          'To reduce training time',
          'To encrypt data'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which algorithm is best for unsupervised clustering?',
        'options': ['Linear Regression', 'K-Means', 'Decision Tree', 'SVM'],
        'answer': 'B'
      },
      {
        'question': 'What does PCA stand for in data science?',
        'options': [
          'Principal Component Analysis',
          'Primary Calculation Algorithm',
          'Predictive Control Analysis',
          'Partial Component Adjustment'
        ],
        'answer': 'A'
      },
      {
        'question': 'How do you handle imbalanced datasets?',
        'options': [
          'Ignore the imbalance',
          'Use oversampling or undersampling',
          'Increase model size',
          'Remove all data'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the bias-variance tradeoff?',
        'options': [
          'Balancing model complexity and error',
          'A type of data encryption',
          'A hardware optimization',
          'A visualization technique'
        ],
        'answer': 'A'
      }
    ]
  },
  // Cyber Security
  {
    'domain': 'cyber security',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is a firewall?',
        'options': [
          'A network security device',
          'A type of malware',
          'A programming language',
          'A data storage system'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is phishing?',
        'options': [
          'A type of physical attack',
          'A social engineering attack via email',
          'A hardware failure',
          'A coding error'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does VPN stand for?',
        'options': [
          'Virtual Private Network',
          'Very Public Network',
          'Virtual Programming Node',
          'Verified Protection Network'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is malware?',
        'options': [
          'A type of hardware',
          'Malicious software',
          'A security protocol',
          'A web development tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of a password?',
        'options': [
          'To style a webpage',
          'To secure access to a system',
          'To store data',
          'To run a program'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'cyber security',
    'level': 'High',
    'questions': [
      {
        'question': 'What is a zero-day exploit?',
        'options': [
          'A hardware failure',
          'An attack on unknown vulnerabilities',
          'A type of encryption',
          'A secure protocol'
        ],
        'answer': 'B'
      },
      {
        'question': 'How does a man-in-the-middle attack work?',
        'options': [
          'By physically stealing data',
          'By intercepting communication between two parties',
          'By overloading a server',
          'By deleting files'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of penetration testing?',
        'options': [
          'To design software',
          'To identify security weaknesses',
          'To increase server load',
          'To write code'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which encryption uses public and private keys?',
        'options': [
          'Symmetric encryption',
          'Asymmetric encryption',
          'Hashing',
          'Tokenization'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the role of a honeypot in cybersecurity?',
        'options': [
          'To store sensitive data',
          'To attract and detect attackers',
          'To encrypt communication',
          'To optimize performance'
        ],
        'answer': 'B'
      }
    ]
  },
  // Artificial Intelligence
  {
    'domain': 'artificial intelligence',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is the primary goal of artificial intelligence?',
        'options': [
          'To design websites',
          'To mimic human intelligence',
          'To store data',
          'To secure networks'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which of these is an AI application?',
        'options': [
          'Text editing',
          'Voice assistants',
          'Hardware repair',
          'Web hosting'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does AI stand for?',
        'options': [
          'Automated Integration',
          'Artificial Intelligence',
          'Advanced Internet',
          'Application Interface'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a common AI programming language?',
        'options': ['HTML', 'Python', 'CSS', 'SQL'],
        'answer': 'B'
      },
      {
        'question': 'What is machine learning a part of?',
        'options': [
          'Web development',
          'Artificial Intelligence',
          'Cybersecurity',
          'App design'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'artificial intelligence',
    'level': 'High',
    'questions': [
      {
        'question': 'What is the purpose of a loss function in AI?',
        'options': [
          'To measure model accuracy',
          'To encrypt data',
          'To increase speed',
          'To design UI'
        ],
        'answer': 'A'
      },
      {
        'question': 'Which algorithm is used for reinforcement learning?',
        'options': ['K-Means', 'Q-Learning', 'Linear Regression', 'SVM'],
        'answer': 'B'
      },
      {
        'question': 'What is backpropagation in neural networks?',
        'options': [
          'A hardware process',
          'Adjusting weights based on error',
          'A type of encryption',
          'A data storage method'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you reduce overfitting in an AI model?',
        'options': [
          'Increase model size',
          'Use regularization',
          'Remove all data',
          'Decrease training time'
        ],
        'answer': 'B'
      },
      {
        'question':
            'What is the role of activation functions in neural networks?',
        'options': [
          'To introduce non-linearity',
          'To store data',
          'To secure the model',
          'To speed up training'
        ],
        'answer': 'A'
      }
    ]
  },
  // DevOps
  {
    'domain': 'DevOps',
    'level': 'Low',
    'questions': [
      {
        'question': 'What does CI/CD stand for?',
        'options': [
          'Continuous Integration/Continuous Deployment',
          'Centralized Infrastructure/Code Design',
          'Code Integration/Code Deployment',
          'Continuous Internet/Code Delivery'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is a common DevOps tool?',
        'options': ['Photoshop', 'Jenkins', 'Notepad', 'Excel'],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of automation in DevOps?',
        'options': [
          'To increase manual work',
          'To reduce errors and save time',
          'To design UI',
          'To store data'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does Docker do in DevOps?',
        'options': [
          'Creates databases',
          'Manages containers',
          'Designs websites',
          'Encrypts data'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a pipeline in DevOps?',
        'options': [
          'A hardware component',
          'A series of automated steps',
          'A type of malware',
          'A design pattern'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'DevOps',
    'level': 'High',
    'questions': [
      {
        'question': 'What is Infrastructure as Code (IaC)?',
        'options': [
          'Manual server setup',
          'Managing infrastructure through code',
          'A type of encryption',
          'A hardware tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'Which tool is used for orchestration in DevOps?',
        'options': ['Git', 'Kubernetes', 'Jenkins', 'Ansible'],
        'answer': 'B'
      },
      {
        'question': 'How do you ensure zero downtime in deployments?',
        'options': [
          'Restart the server',
          'Use blue-green deployment',
          'Increase server size',
          'Delete old code'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of monitoring in DevOps?',
        'options': [
          'To write code',
          'To track system performance',
          'To design UI',
          'To store data'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a key benefit of containerization?',
        'options': [
          'Increased hardware usage',
          'Consistency across environments',
          'Slower deployments',
          'More manual work'
        ],
        'answer': 'B'
      }
    ]
  },
  // Flutter
  {
    'domain': 'Flutter',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is Flutter used for?',
        'options': [
          'Web development',
          'Cross-platform app development',
          'Cybersecurity',
          'Data science'
        ],
        'answer': 'B'
      },
      {
        'question': 'What language does Flutter use?',
        'options': ['Java', 'Dart', 'Python', 'C++'],
        'answer': 'B'
      },
      {
        'question': 'What is a widget in Flutter?',
        'options': [
          'A hardware component',
          'A UI building block',
          'A type of malware',
          'A database'
        ],
        'answer': 'B'
      },
      {
        'question': 'Who developed Flutter?',
        'options': ['Microsoft', 'Google', 'Apple', 'Facebook'],
        'answer': 'B'
      },
      {
        'question': 'What is the Flutter SDK?',
        'options': [
          'A hardware kit',
          'A software development kit',
          'A security protocol',
          'A design tool'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'Flutter',
    'level': 'High',
    'questions': [
      {
        'question':
            'What is the difference between Stateless and Stateful widgets?',
        'options': [
          'Stateless can change, Stateful cannot',
          'Stateless cannot change, Stateful can',
          'Both are the same',
          'Stateless is faster'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you manage state in Flutter?',
        'options': [
          'Use HTML',
          'Use Provider or Riverpod',
          'Use CSS',
          'Use a database'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of the BuildContext in Flutter?',
        'options': [
          'To store data',
          'To provide widget tree information',
          'To encrypt data',
          'To design UI'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you implement custom animations in Flutter?',
        'options': [
          'Use AnimationController',
          'Use CSS',
          'Use a database',
          'Use hardware'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is the role of the pubspec.yaml file?',
        'options': [
          'To style the app',
          'To manage dependencies',
          'To secure the app',
          'To store data'
        ],
        'answer': 'B'
      }
    ]
  },
  // React
  {
    'domain': 'React',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is React?',
        'options': [
          'A database',
          'A JavaScript library for UI',
          'A programming language',
          'A security tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'Who developed React?',
        'options': ['Google', 'Facebook', 'Microsoft', 'Apple'],
        'answer': 'B'
      },
      {
        'question': 'What is JSX?',
        'options': [
          'A styling language',
          'A syntax extension for JavaScript',
          'A database query',
          'A security protocol'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does React use to build UI?',
        'options': ['Components', 'Hardware', 'Malware', 'CSS only'],
        'answer': 'A'
      },
      {
        'question': 'What is the purpose of props in React?',
        'options': [
          'To store data',
          'To pass data to components',
          'To encrypt data',
          'To design layouts'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'React',
    'level': 'High',
    'questions': [
      {
        'question': 'What is the purpose of useEffect hook?',
        'options': [
          'To style components',
          'To handle side effects',
          'To store data',
          'To secure the app'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you optimize React performance?',
        'options': [
          'Use more components',
          'Use React.memo and useCallback',
          'Increase server size',
          'Remove all hooks'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is Redux used for in React?',
        'options': [
          'Styling',
          'State management',
          'Database queries',
          'Hardware control'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a higher-order component (HOC)?',
        'options': [
          'A component that wraps another component',
          'A hardware device',
          'A type of malware',
          'A styling tool'
        ],
        'answer': 'A'
      },
      {
        'question': 'How do you handle routing in React?',
        'options': [
          'Use CSS',
          'Use React Router',
          'Use a database',
          'Use hardware'
        ],
        'answer': 'B'
      }
    ]
  },
  // Angular
  {
    'domain': 'Angular',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is Angular used for?',
        'options': [
          'Data science',
          'Web application development',
          'Cybersecurity',
          'Hardware design'
        ],
        'answer': 'B'
      },
      {
        'question': 'What language does Angular use?',
        'options': ['Python', 'TypeScript', 'Java', 'C++'],
        'answer': 'B'
      },
      {
        'question': 'What is a component in Angular?',
        'options': [
          'A hardware part',
          'A reusable UI block',
          'A type of malware',
          'A database'
        ],
        'answer': 'B'
      },
      {
        'question': 'Who developed Angular?',
        'options': ['Microsoft', 'Google', 'Facebook', 'Apple'],
        'answer': 'B'
      },
      {
        'question': 'What is the Angular CLI?',
        'options': [
          'A hardware tool',
          'A command-line interface for Angular',
          'A security protocol',
          'A design tool'
        ],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'Angular',
    'level': 'High',
    'questions': [
      {
        'question': 'What is dependency injection in Angular?',
        'options': [
          'A styling method',
          'A way to provide dependencies to classes',
          'A type of encryption',
          'A hardware tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of RxJS in Angular?',
        'options': [
          'To style components',
          'To handle asynchronous operations',
          'To store data',
          'To secure the app'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you implement lazy loading in Angular?',
        'options': [
          'Use CSS',
          'Use loadChildren in routes',
          'Use a database',
          'Use hardware'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a directive in Angular?',
        'options': [
          'A hardware component',
          'A way to extend HTML behavior',
          'A type of malware',
          'A styling tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the role of NgModule?',
        'options': [
          'To style the app',
          'To organize Angular apps',
          'To encrypt data',
          'To store data'
        ],
        'answer': 'B'
      }
    ]
  },
  // Vue
  {
    'domain': 'Vue',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is Vue.js?',
        'options': [
          'A database',
          'A JavaScript framework for UI',
          'A programming language',
          'A security tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of v-bind in Vue?',
        'options': [
          'To store data',
          'To bind data to HTML attributes',
          'To encrypt data',
          'To design layouts'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does Vue use to build UI?',
        'options': ['Components', 'Hardware', 'Malware', 'CSS only'],
        'answer': 'A'
      },
      {
        'question': 'What is a common Vue directive?',
        'options': ['v-if', 'CSS', 'HTML', 'SQL'],
        'answer': 'A'
      },
      {
        'question': 'Who created Vue.js?',
        'options': ['Evan You', 'Google', 'Microsoft', 'Facebook'],
        'answer': 'A'
      }
    ]
  },
  {
    'domain': 'Vue',
    'level': 'High',
    'questions': [
      {
        'question': 'What are computed properties in Vue?',
        'options': [
          'Static values',
          'Cached dynamic values based on dependencies',
          'Hardware components',
          'Encryption methods'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you manage state in Vue?',
        'options': ['Use CSS', 'Use Vuex', 'Use a database', 'Use hardware'],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of Vue Router?',
        'options': [
          'To style components',
          'To handle navigation',
          'To store data',
          'To secure the app'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a mixin in Vue?',
        'options': [
          'A hardware tool',
          'A way to share reusable code',
          'A type of malware',
          'A styling method'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you optimize Vue performance?',
        'options': [
          'Increase component size',
          'Use v-once and lazy loading',
          'Remove all directives',
          'Add more CSS'
        ],
        'answer': 'B'
      }
    ]
  },
  // Blockchain
  {
    'domain': 'Blockchain',
    'level': 'Low',
    'questions': [
      {
        'question': 'What is a blockchain?',
        'options': [
          'A type of hardware',
          'A decentralized digital ledger',
          'A programming language',
          'A security tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of cryptocurrency?',
        'options': [
          'To design websites',
          'To serve as digital money',
          'To store data',
          'To secure networks'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is Bitcoin?',
        'options': [
          'A hardware device',
          'A type of cryptocurrency',
          'A programming language',
          'A web framework'
        ],
        'answer': 'B'
      },
      {
        'question': 'What does a block in blockchain contain?',
        'options': [
          'CSS code',
          'Transaction data',
          'Hardware specs',
          'UI designs'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a common blockchain platform?',
        'options': ['HTML', 'Ethereum', 'CSS', 'JavaScript'],
        'answer': 'B'
      }
    ]
  },
  {
    'domain': 'Blockchain',
    'level': 'High',
    'questions': [
      {
        'question': 'What is a smart contract?',
        'options': [
          'A hardware component',
          'Self-executing code on blockchain',
          'A type of malware',
          'A styling tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the purpose of a hash function in blockchain?',
        'options': [
          'To style data',
          'To ensure data integrity',
          'To store data',
          'To design UI'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a consensus mechanism?',
        'options': [
          'A hardware tool',
          'A method to agree on blockchain state',
          'A type of encryption',
          'A design pattern'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is proof of work?',
        'options': [
          'A styling method',
          'A consensus algorithm requiring computation',
          'A type of malware',
          'A hardware tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you secure a blockchain network?',
        'options': [
          'Use CSS',
          'Use cryptographic techniques',
          'Use a database',
          'Use hardware'
        ],
        'answer': 'B'
      }
    ]
  },
  // IoT
  {
    'domain': 'IoT',
    'level': 'Low',
    'questions': [
      {
        'question': 'What does IoT stand for?',
        'options': [
          'Internet of Tools',
          'Internet of Things',
          'Input Output Technology',
          'Integrated Operations Tech'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a common IoT device?',
        'options': [
          'Smart thermostat',
          'CSS file',
          'HTML page',
          'SQL database'
        ],
        'answer': 'A'
      },
      {
        'question': 'What is the purpose of sensors in IoT?',
        'options': [
          'To style data',
          'To collect data from the environment',
          'To store data',
          'To design UI'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a protocol used in IoT?',
        'options': ['HTML', 'MQTT', 'CSS', 'JavaScript'],
        'answer': 'B'
      },
      {
        'question': 'What connects IoT devices?',
        'options': [
          'The internet',
          'A single computer',
          'A hardware cable',
          'A styling tool'
        ],
        'answer': 'A'
      }
    ]
  },
  {
    'domain': 'IoT',
    'level': 'High',
    'questions': [
      {
        'question': 'What is edge computing in IoT?',
        'options': [
          'Styling data',
          'Processing data near the source',
          'Storing data in the cloud',
          'Designing UI'
        ],
        'answer': 'B'
      },
      {
        'question': 'How do you secure IoT devices?',
        'options': [
          'Use CSS',
          'Use encryption and authentication',
          'Use a database',
          'Use hardware'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the role of MQTT in IoT?',
        'options': [
          'A hardware component',
          'A lightweight messaging protocol',
          'A type of malware',
          'A styling tool'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is a challenge in IoT scalability?',
        'options': [
          'Too few devices',
          'Managing large numbers of devices',
          'Lack of styling',
          'No internet'
        ],
        'answer': 'B'
      },
      {
        'question': 'What is the benefit of IoT in smart cities?',
        'options': [
          'Increased manual work',
          'Improved resource management',
          'Slower communication',
          'More hardware'
        ],
        'answer': 'B'
      }
    ]
  }
];
