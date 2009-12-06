From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3 v2] opensm SA DB dump/restore: added option to load
 SA DB once
Date: Sun, 06 Dec 2009 12:32:29 +0200
Message-ID: <4B1B883D.3080508@dev.mellanox.co.il>
References: <4AF15EBD.6010307@dev.mellanox.co.il> <20091126133037.GA28564@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091126133037.GA28564@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Sasha Khapyorsky wrote:
> Hi Yevgeny,
> 
> On 13:00 Wed 04 Nov     , Yevgeny Kliteynik wrote:
>> Added option to load SA DB once: 'sa_db_load_once'.
>> This will cause OSM to load SA DB once during first master
>> heavy sweep, and then OSM will move to the usual SA mode.
> 
> It is probably should be done by default, without any options. I don't
> think that loading SA DB on an every sweep is anyhow in use today.

OK, didn't want to change current behavior in case anyone uses
it, but no problem changing it to default behavior. No need
for a separate option.

>> The option is not exposed through OSM command line,
>> but only through options file.
>>
>> [v2 - no changes, just rebased and resolved conflicts]
> 
> Please next time place commit message unrelated lines under '---' and
> before diffstat output, in this way git am skips this during applying.

OK

>> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>  opensm/include/opensm/osm_subnet.h |    5 +++++
>>  opensm/opensm/osm_sa.c             |   20 +++++++++++++++++++-
>>  opensm/opensm/osm_subnet.c         |    7 +++++++
>>  3 files changed, 31 insertions(+), 1 deletions(-)
>>
>> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
>> index 0302f91..871a833 100644
>> --- a/opensm/include/opensm/osm_subnet.h
>> +++ b/opensm/include/opensm/osm_subnet.h
>> @@ -200,6 +200,7 @@ typedef struct osm_subn_opt {
>>  	char *ids_guid_file;
>>  	char *guid_routing_order_file;
>>  	char *sa_db_file;
>> +	boolean_t sa_db_load_once;
>>  	boolean_t do_mesh_analysis;
>>  	boolean_t exit_on_fatal;
>>  	boolean_t honor_guid2lid_file;
>> @@ -411,6 +412,10 @@ typedef struct osm_subn_opt {
>>  *	sa_db_file
>>  *		Name of the SA database file.
>>  *
>> +*	sa_db_load_once
>> +*		When TRUE causes sa_db_file to be loaded only at the
>> +*		first master sweep.
>> +*
>>  *	exit_on_fatal
>>  *		If TRUE (default) - SM will exit on fatal subnet initialization
>>  *		issues.
>> diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
>> index 2db8ba2..e44eab4 100644
>> --- a/opensm/opensm/osm_sa.c
>> +++ b/opensm/opensm/osm_sa.c
>> @@ -912,6 +912,12 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
>>  		return 0;
>>  	}
>>
>> +	if (p_osm->subn.opt.sa_db_load_once && !p_osm->subn.first_time_master_sweep) {
>> +		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
>> +			"Not first sweep - skip SA DB restore\n");
>> +		return 0;
>> +	}
>> +
>>  	file = fopen(file_name, "r");
>>  	if (!file) {
>>  		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 4C02: "
>> @@ -920,6 +926,10 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
>>  		return -1;
>>  	}
>>
>> +	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
>> +		"Restoring SA DB from file \'%s\'\n",
>> +		file_name);
>> +
>>  	lineno = 0;
>>
>>  	while (fgets(line, sizeof(line) - 1, file) != NULL) {
>> @@ -1096,7 +1106,15 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
>>  		}
>>  	}
>>
>> -	if (!rereg_clients)
>> +	/*
>> +	 * If restoring SA DB is required only once, SM should go
>> +	 * into the usual mode right after that, which means that
>> +	 * client re-registration should be required even after
>> +	 * the restore - there is a chance that OSM died right after
>> +	 * some MCMember joined MCast group, and his membership
>> +	 * didn't make it into the SA DB file.
>> +	 */
>> +	if (!p_osm->subn.opt.sa_db_load_once && !rereg_clients)
>>  		p_osm->subn.opt.no_clients_rereg = TRUE;
> 
> Hmm, if you are going to request clients reregistration unconditionally
> then what is the reason to restore SA DB?
> 
> Maybe you wanted to switch this flag off *after* first sweep, but I'm
> not sure following your comment.

We have a dump file with mcast members, and OSM is loading
this file. Suppose OSM has successfully loaded the whole file.
But this does not mean that there's no need to request client
re-registration on all the hosts. Consider the following case:
 - Heavy sweep - SM dumps current SA DB to a file
 - Client asks to join some mcast group
 - SM gets the request and processes it
 - The request is OK - SM sets the 'dirty' flag and
   responds to client
 - Client gets the response
 - SM dies
 - SM is restarted - it loads the existing SA DB, which
   does not includes the latest client's membership
 - Loading of the whole SA DB is OK - no client re-register
   request is issued
 - Client remains disconnected from the mcast group

I want to be able to tell SM to request client re-register
after loading the SA DB even if all was OK.

So there are 3 options to do it:

1. Completely rely on 'no_clients_rereg' option only.
   Do not alter this option, doesn't matter if the SA DB
   reloading succeeded or not.

2. Combine 'no_clients_rereg' option with loading SA DB
   result: if loading succeeded, do whatever 'no_clients_rereg'
   option says. If loading failed at some point, turn off
   the 'no_clients_rereg' option (turn on re-registartion
   requests, don't you just love the double-negative logic?)

3. Add new option for this particular case.

I'm all for option 2, and this is what I'm implementing
in V3 series patches.

Thoughts?

-- Yevgeny
 
> Sasha
> 
> 
>>  _error:
>> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
>> index cac5e94..b0ffddd 100644
>> --- a/opensm/opensm/osm_subnet.c
>> +++ b/opensm/opensm/osm_subnet.c
>> @@ -348,6 +348,7 @@ static const opt_rec_t opt_tbl[] = {
>>  	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
>>  	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
>>  	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_parse_charp, NULL, 0 },
>> +	{ "sa_db_load_once", OPT_OFFSET(sa_db_load_once), opts_parse_boolean, NULL, 1 },
>>  	{ "do_mesh_analysis", OPT_OFFSET(do_mesh_analysis), opts_parse_boolean, NULL, 1 },
>>  	{ "exit_on_fatal", OPT_OFFSET(exit_on_fatal), opts_parse_boolean, NULL, 1 },
>>  	{ "honor_guid2lid_file", OPT_OFFSET(honor_guid2lid_file), opts_parse_boolean, NULL, 1 },
>> @@ -746,6 +747,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>>  	p_opt->ids_guid_file = NULL;
>>  	p_opt->guid_routing_order_file = NULL;
>>  	p_opt->sa_db_file = NULL;
>> +	p_opt->sa_db_load_once = FALSE;
>>  	p_opt->do_mesh_analysis = FALSE;
>>  	p_opt->exit_on_fatal = TRUE;
>>  	p_opt->enable_quirks = FALSE;
>> @@ -1446,6 +1448,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>>  		p_opts->sa_db_file ? p_opts->sa_db_file : null_str);
>>
>>  	fprintf(out,
>> +		"# If TRUE causes SA database to be loaded only at\n"
>> +		"# the first master sweep\nsa_db_load_once %s\n\n",
>> +		p_opts->sa_db_load_once ? "TRUE" : "FALSE");
>> +
>> +	fprintf(out,
>>  		"#\n# HANDOVER - MULTIPLE SMs OPTIONS\n#\n"
>>  		"# SM priority used for deciding who is the master\n"
>>  		"# Range goes from 0 (lowest priority) to 15 (highest).\n"
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
