/// Abstract class for Overall Equipment Effectiveness related
/// properties; will be added as superclass if so configured.
Class opc.ua.data.OEE [ Abstract ]
{

Property OEEActualOutput As %Integer [ InitialExpression = 0 ];

Property OEEActualProductionTime As %Integer [ InitialExpression = 0 ];

Property OEEAvailability As %Double [ InitialExpression = 0 ];

Property OEEAvailabilityHistory As %Double [ InitialExpression = 0 ];

Property OEEAvailabilityOCAP As %String;

Property OEEAvailabilityTarget As %Double [ InitialExpression = 0 ];

Property OEEFailureTime As %Integer [ InitialExpression = 0 ];

Property OEENotScheduledOperatingTime As %Integer [ InitialExpression = 0 ];

Property OEEOverall As %Double [ InitialExpression = 0 ];

Property OEEOverallHistory As %Double [ InitialExpression = 0 ];

Property OEEOverallOCAP As %String;

Property OEEOverallTarget As %Double [ InitialExpression = 0 ];

Property OEEPerformance As %Double [ InitialExpression = 0 ];

Property OEEPerformanceHistory As %Double [ InitialExpression = 0 ];

Property OEEPerformanceOCAP As %String;

Property OEEPerformanceTarget As %Double [ InitialExpression = 0 ];

Property OEEPotentialProductionTime As %Integer [ InitialExpression = 0 ];

Property OEEProductivity As %Double [ InitialExpression = 0 ];

Property OEEProductivityHistory As %Double [ InitialExpression = 0 ];

Property OEEProductivityOCAP As %String;

Property OEEProductivityTarget As %Double [ InitialExpression = 0 ];

Property OEEQuality As %Double [ InitialExpression = 0 ];

Property OEEQualityHistory As %Double [ InitialExpression = 0 ];

Property OEEQualityOCAP As %String;

Property OEEQualityTarget As %Double [ InitialExpression = 0 ];

Property OEERejectedOutput As %Integer [ InitialExpression = 0 ];

Property OEERework As %Integer [ InitialExpression = 0 ];

Property OEEScrap As %Integer [ InitialExpression = 0 ];

Property OEEStandardCycleTime As %Double [ InitialExpression = 0 ];

Property OEEUnscheduledDownTime As %Integer [ InitialExpression = 0 ];

Property OEEUnscheduledIdleTime As %Integer [ InitialExpression = 0 ];

Property OEEWaitingTime As %Integer [ InitialExpression = 0 ];

}
