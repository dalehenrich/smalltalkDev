"Pharo1.3 installation"
| gitPath pharoGitPath installerPath |
gitPath := '/opt/git'.
pharoGitPath := '/opt/git/pharo'.
installerPath := gitPath, '/smalltalkEnv/pharo1.3/metacello-base/source'.

"Create new image"
SmalltalkImage current saveAs: 'metacello-base'.

"patch RB formatter ... custom indent and force Symbol formatting to alway use quated form"
#('RBLiteralToken-storeOn.st' 'RBConfigurableFormatter class-initialize.st') do: [:filename |
        FileStream oldFileNamed: installerPath, '/', filename do: [:fileStream | fileStream fileIn ]].

"My settings"
SystemBrowser default: OBSystemBrowserAdaptor.
CodeHolder showAnnotationPane: true.
ORMethodDefinition
        autoFormatOnDisplay: false;
        autoFormatOnAccept: true.
ECPreferences
        enabled: false;
        useECompletionInsteadOfOCompletion: nil;
        smartCharacters: false.
OBCodeBrowser mercuryPanelEnabled: false.

"Proxy nonsense"
HTTPSocket useProxyServerNamed: 'proxy.eng.vmware.com' port: 3128.
NetworkSystemSettings useHTTPProxy: true.

"Bootstrap latest Metacello and FileTree from mcz"
Gofer new
        gemsource: 'metacello';
        package: 'ConfigurationOfMetacello';
        load.
((Smalltalk at: #ConfigurationOfMetacello) project version: '1.0-beta.32') load: 'batch'.

((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.  

"Install latest Metacello and FileTree from git"
Gofer new
        repository: ((Smalltalk at: #MCFileTreeRepository) new directory: 
                    (FileDirectory on: pharoGitPath, '/filetree/repository/'));
        package: 'MonticelloFileTree-Core';
        load.

(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'filetree://', gitPath, '/metacello-work/repository';
  load: 'ALL'.

"save image"
WorldState addDeferredUIMessage: [
        SmalltalkImage current snapshot: false andQuit: false ].

