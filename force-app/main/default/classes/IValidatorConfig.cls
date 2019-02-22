/*************************************************************************
Name : IValidatorConfig 
Author : Sandeep Kumar
Date : February 22th,2019
Usage : Interface for define Validate Configuration.
*************************************************************************/
public interface IValidatorConfig {
	/**
	 * read all available validation configuration
	 * @return Returns Configuration object which contains all available validation.
	 */
	Configuration readConfiguration();
}