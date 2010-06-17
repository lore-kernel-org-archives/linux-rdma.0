From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] opensm/osmeventplugin: added new events to monitor
 SM
Date: Thu, 17 Jun 2010 17:51:03 +0300
Message-ID: <4C1A3657.5080106@dev.mellanox.co.il>
References: <4C10CF60.8060904@dev.mellanox.co.il> <20100617141802.GH20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617141802.GH20172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On 17-Jun-10 5:18 PM, Sasha Khapyorsky wrote:
> On 14:41 Thu 10 Jun     , Yevgeny Kliteynik wrote:
>> Hi Sasha,
>>
>> Adding new events that allow event plug-in to see
>> when SM finishes heavy sweep and routing configuration,
>> when it updates dump files, when it is no longer master,
>> and when SM port is down:
>>
>>    OSM_EVENT_ID_HEAVY_SWEEP_DONE
>>    OSM_EVENT_ID_UCAST_ROUTING_DONE
>
> What is wrong with using Subnet Up event for those purposes?

There is a big difference between SWEEP_DONE  and SUBNET_UP
events. The former happens before all the managers (drop
manager, QoS, unicast and multicast routing, etc), so there
is a long period between two events.
Moreover, after SWEEP_DONE there is a lot of information
that is later cleared.

As for ROUTING_DONE, if OSM is doing re-route only, then
routing might change, and we don't get SUBNET_UP event.
Furthermore, when torus2QoS routing will be included in
the SM, the re-route will also cause QoS configuration
to change.
  
>>    OSM_EVENT_ID_ENTERING_STANDBY
>>    OSM_EVENT_ID_SM_PORT_DOWN
>
> Instead I would suggest to make "state change" event.

OK
  
>>    OSM_EVENT_ID_SA_DB_DUMPED
>
> Again, "Subnet Up" indicates that all sweep stuff is done (including
> dump files).

This is true. In fact, the way I posed it, there is no
point adding this event. However, this event should also
be sent when SA DB is dumped at the end of light sweep,
and then SUBNET_UP cannot replace it.

>>
>> The last event is reported when SA DB is actually dumped.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>
>> Changes from V2:
>>    - reduced number of events that are reported
>>    - rebased to latest master
>>
>> ---
>>   opensm/include/opensm/osm_event_plugin.h   |    7 ++++++-
>>   opensm/opensm/osm_state_mgr.c              |   16 +++++++++++++++-
>>   opensm/osmeventplugin/src/osmeventplugin.c |   15 +++++++++++++++
>>   3 files changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
>> index 33d1920..a565123 100644
>> --- a/opensm/include/opensm/osm_event_plugin.h
>> +++ b/opensm/include/opensm/osm_event_plugin.h
>> @@ -72,7 +72,12 @@ typedef enum {
>>   	OSM_EVENT_ID_PORT_SELECT,
>>   	OSM_EVENT_ID_TRAP,
>>   	OSM_EVENT_ID_SUBNET_UP,
>> -	OSM_EVENT_ID_MAX
>> +	OSM_EVENT_ID_MAX,
>
> Likely you wanted to move OSM_EVENT_ID_MAX to be last in the list.

Oops...

-- Yevgeny

> Sasha
>
>> +	OSM_EVENT_ID_HEAVY_SWEEP_DONE,
>> +	OSM_EVENT_ID_UCAST_ROUTING_DONE,
>> +	OSM_EVENT_ID_ENTERING_STANDBY,
>> +	OSM_EVENT_ID_SM_PORT_DOWN,
>> +	OSM_EVENT_ID_SA_DB_DUMPED
>>   } osm_epi_event_id_t;
>>
>>   typedef struct osm_epi_port_id {
>> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
>> index 81c8f54..3231ae9 100644
>> --- a/opensm/opensm/osm_state_mgr.c
>> +++ b/opensm/opensm/osm_state_mgr.c
>> @@ -1151,6 +1151,8 @@ static void do_sweep(osm_sm_t * sm)
>>   		if (!sm->p_subn->subnet_initialization_error) {
>>   			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>>   					"REROUTE COMPLETE");
>> +			osm_opensm_report_event(sm->p_subn->p_osm,
>> +				OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
>>   			return;
>>   		}
>>   	}
>> @@ -1185,6 +1187,8 @@ repeat_discovery:
>>
>>   		/* Move to DISCOVERING state */
>>   		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
>> +		osm_opensm_report_event(sm->p_subn->p_osm,
>> +				OSM_EVENT_ID_SM_PORT_DOWN, NULL);
>>   		return;
>>   	}
>>
>> @@ -1205,6 +1209,8 @@ repeat_discovery:
>>   				"ENTERING STANDBY STATE");
>>   		/* notify master SM about us */
>>   		osm_send_trap144(sm, 0);
>> +		osm_opensm_report_event(sm->p_subn->p_osm,
>> +				OSM_EVENT_ID_ENTERING_STANDBY, NULL);
>>   		return;
>>   	}
>>
>> @@ -1212,6 +1218,9 @@ repeat_discovery:
>>   	if (sm->p_subn->force_heavy_sweep)
>>   		goto repeat_discovery;
>>
>> +	osm_opensm_report_event(sm->p_subn->p_osm,
>> +				OSM_EVENT_ID_HEAVY_SWEEP_DONE, NULL);
>> +
>>   	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "HEAVY SWEEP COMPLETE");
>>
>>   	/* If we are MASTER - get the highest remote_sm, and
>> @@ -1314,6 +1323,8 @@ repeat_discovery:
>>
>>   	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>>   			"SWITCHES CONFIGURED FOR UNICAST");
>> +	osm_opensm_report_event(sm->p_subn->p_osm,
>> +			OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
>>
>>   	if (!sm->p_subn->opt.disable_multicast) {
>>   		osm_mcast_mgr_process(sm);
>> @@ -1375,7 +1386,10 @@ repeat_discovery:
>>
>>   		if (osm_log_is_active(sm->p_log, OSM_LOG_VERBOSE) ||
>>   		    sm->p_subn->opt.sa_db_dump)
>> -			osm_sa_db_file_dump(sm->p_subn->p_osm);
>> +			if (!osm_sa_db_file_dump(sm->p_subn->p_osm))
>> +				osm_opensm_report_event(sm->p_subn->p_osm,
>> +					OSM_EVENT_ID_SA_DB_DUMPED, NULL);
>> +
>>   	}
>>
>>   	/*
>> diff --git a/opensm/osmeventplugin/src/osmeventplugin.c b/opensm/osmeventplugin/src/osmeventplugin.c
>> index b4d9ce9..af68a5c 100644
>> --- a/opensm/osmeventplugin/src/osmeventplugin.c
>> +++ b/opensm/osmeventplugin/src/osmeventplugin.c
>> @@ -176,6 +176,21 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
>>   	case OSM_EVENT_ID_SUBNET_UP:
>>   		fprintf(log->log_file, "Subnet up reported\n");
>>   		break;
>> +	case OSM_EVENT_ID_HEAVY_SWEEP_DONE:
>> +		fprintf(log->log_file, "Heavy sweep completed\n");
>> +		break;
>> +	case OSM_EVENT_ID_UCAST_ROUTING_DONE:
>> +		fprintf(log->log_file, "Unicast routing completed\n");
>> +		break;
>> +	case OSM_EVENT_ID_ENTERING_STANDBY:
>> +		fprintf(log->log_file, "Entering stand-by state\n");
>> +		break;
>> +	case OSM_EVENT_ID_SM_PORT_DOWN:
>> +		fprintf(log->log_file, "SM port is down\n");
>> +		break;
>> +	case OSM_EVENT_ID_SA_DB_DUMPED:
>> +		fprintf(log->log_file, "SA DB dump file updated\n");
>> +		break;
>>   	case OSM_EVENT_ID_MAX:
>>   	default:
>>   		osm_log(log->osmlog, OSM_LOG_ERROR,
>> --
>> 1.5.1.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
