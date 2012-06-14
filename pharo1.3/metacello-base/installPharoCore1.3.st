"PharoCore1.3 installation"
| gitPath pharoGitPath installerPath |
gitPath := '/opt/git'.
pharoGitPath := '/opt/git/pharo'.
installerPath := gitPath, '/smalltalkEnv/pharo1.3/metacello-base/source'.

"patch RB formatter ... custom indent and force Symbol formatting to alway use quated form"
#('RBLiteralToken-storeOn.st' 'RBConfigurableFormatter class-initialize.st') do: [:filename |
        FileStream oldFileNamed: installerPath, '/', filename do: [:fileStream | fileStream fileIn ]].

"My settings"
MCCodeTool showAnnotationPane: true.
SystemBrowser default: OBSystemBrowserAdaptor.
ORMethodDefinition
        autoFormatOnDisplay: false;
        autoFormatOnAccept: true.
ECPreferences
        enabled: false;
        useECompletionInsteadOfOCompletion: nil;
        smartCharacters: false.
OBCodeBrowser mercuryPanelEnabled: false.

"Install Metacello-Base"
Gofer new
  gemsource: 'metacello';
  package: 'Metacello-Base';
  load.

