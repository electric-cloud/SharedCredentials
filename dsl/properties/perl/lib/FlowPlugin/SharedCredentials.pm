package FlowPlugin::SharedCredentials;
use strict;
use warnings;
use base qw/FlowPDF/;

use FlowPDF::Log;
# Feel free to use new libraries here, e.g. use File::Temp;
use Data::Dumper;

# Service function that is being used to set some metadata for a plugin.
sub pluginInfo {
    return {
        pluginName          => '@PLUGIN_KEY@',
        pluginVersion       => '@PLUGIN_VERSION@',
        configFields        => ['config'],
        configLocations     => ['ec_plugin_cfgs'],
        defaultConfigValues => {}
    };
}

# Auto-generated method for the procedure Sample Procedure/Sample Procedure
# Add your code into this method and it will be called when step runs
sub sampleProcedure {
    my ($pluginObject, $runtimeParameters, $stepResult) = @_;

    require ElectricCommander;
    my $ec = ElectricCommander->new;

    # my $configName = $ec->getProperty('config');


    my $context = $pluginObject->getContext();
    logInfo("Current context is: ", $context->getRunContext());
    my $params = $context->getStepParameters();
    logInfo("Step parameters are: ", $params);

    my $configName = $params->getParameter('config');
    # Additional property in the config that points to the shared credential
    my $sharedCredName = 'credential__shared';
    my $credPath = $ec->getPropertyValue('/plugins/@PLUGIN_KEY@/project/properties/ec_plugin_cfgs/' . $configName . '/' . $sharedCredName);
    logInfo "Cred Path", $credPath;

    print '$[/myProject/name]';
    print "\n\n";

    eval {
        print "getting by cred name: +$credPath+\n";
        my $xpath = $ec->getFullCredential($credPath);
        print Dumper $xpath->findvalue('//userName');
        print Dumper __LINE__;
        1;
    } or do {

        print $@;
    };

    eval {
        my $xpath = $ec->getFullCredential('/myProject/credentials/TestCred');
        print Dumper $xpath->findvalue('//userName');
        print Dumper __LINE__;
    };

    eval {
        # If the procedure lives in the same project with the credential
        # This one works
        my $xpath = $ec->getFullCredential('TestCred');
        print Dumper $xpath->findvalue('//userName');
        print Dumper __LINE__;
    };

    eval {
        # Even if the user does not have access to the credential, the procedure and project do
        my $xpath = $ec->getFullCredential('/projects/Shared Credentials/credentials/TestCred');
        print Dumper $xpath->findvalue('//userName');
        print Dumper __LINE__;
        1;
    } or do {
        print $@. "\n";
    };

    # my $configValues = $context->getConfigValues();
    # logInfo("Config values are: ", $configValues);

    # $stepResult->setJobStepOutcome('warning');
    # $stepResult->setJobSummary("This is a job summary.");
}


## === step ends ===
# Please do not remove the marker above, it is used to place new procedures into this file.


## === feature step ends ===


1;
