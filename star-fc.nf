#!/usr/bin/env nextflow

/* enable DSL2*/
nextflow.enable.dsl=2


/*================================================================
The EPIGEN LAB presents...

  The nf-STAR+fc pipeline

- A pipeline in development (add more description)

==================================================================
Version: 0.1
Project repository: 
==================================================================
Authors:

- Bioinformatics Design
 Josue Guzman-Linares (josue.guzl98@gmail.com)
 Ivonne Ramirez-Diaz (mail)

- Nextflow Port
 Josue Guzman-Linares (josue.guzl98@gmail.com)
 Ivonne Ramirez-Diaz (mail)

================================================================*/



/*
  Define pipeline version
  If you bump the number, remember to bump it in the header description at the begining of this script too
*/
version = "0.1"



/*
  Define pipeline Name
  This will be used as a name to include in the results and intermediates directory names
*/
pipeline_name = "nf-STAR+fc"



/*
Define the help message as a function to call when needed
*/

def helpMessage() { 

	log.info"""
  ==========================================
  ${pipeline_name}
 
  v${version}
  ==========================================

	Usage:

	nextflow run ${pipeline_name}.nf 
    
    --fastq_dir <path to fastq files> 
    --star_index <path to star index files>
    --gtf <path to human reference gtf>
    --output_dir <directory where results, intermediate and log files will be stored>
    -resume	   <- Use cached results if the executed project has been run before;
	      default: not activated
	      This native NF option checks if anything has changed from a previous pipeline execution.
	      Then, it resumes the run from the last successful stage.
	      i.e. If for some reason your previous run got interrupted,
	      running the -resume option will take it from the last successful pipeline stage
	      instead of starting over
	      Read more here: https://www.nextflow.io/docs/latest/getstarted.html#getstart-resume
    --help           <- Shows Pipeline Information
    --version        <- Show version
	""".stripIndent()
} 



/*
  Initiate default values for parameters
  to avoid "WARN: Access to undefined parameter" messages
*/

params.fastq_dir = false  //if no inputh path is provided, value is false to provoke the error during the parameter validation block
params.host = false  //if no inputh path is provided, value is false to provoke the error during the parameter validation block
params.help = false //default is false to not trigger help message automatically at every run
params.version = false //default is false to not trigger version message automatically at every run



/*
  If the user inputs the --help flag
  print the help message and exit pipeline
*/

if (params.help){
	helpMessage()
	exit 0
}



/*
  If the user inputs the --version flag
  print the pipeline version
*/
if (params.version){
	println "${pipeline_name} v${version}"
	exit 0
}



/*
  Define the Nextflow version under which this pipeline was developed or successfuly tested
*/
nextflow_required_version = '22.10.7.5853'



/*
  Try Catch to verify compatible Nextflow version
  If user Nextflow version is lower than the required version pipeline will continue
  but a message is printed to tell the user maybe it's a good idea to update her/his Nextflow
*/
try {
	if( ! nextflow.version.matches(">= $nextflow_required_version") ){
		throw GroovyException('Your Nextflow version is older than Pipeline required version')
	}
} catch (all) {
	log.error "-----\n" +
			"  This pipeline requires Nextflow version: $nextflow_required_version \n" +
      "  But you are running version: $workflow.nextflow.version \n" +
			"  The pipeline will continue but some things may not work as intended\n" +
			"  You may want to run `nextflow self-update` to update Nextflow\n" +
			"============================================================"
}



/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/



/* Check if the input directory is provided
    if it was not provided, it keeps the 'false' value assigned in the parameter initiation block above
    and this test fails
*/
if ( !params.fastq_dir) {
  log.error " Please provide the --fastq_dir \n\n" +
  " For more information, execute: nextflow run ${pipeline_name}.nf --help"
  exit 1
}



/*
Output directory definition
Default value to create directory is the parent dir of --input_dir
*/
params.output_dir = file(params.fastq_dir).getParent() //!! maybe creates bug, should check



