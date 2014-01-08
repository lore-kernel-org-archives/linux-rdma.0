From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH opensm] Parse the the partition config in dry-run mode
 first
Date: Wed, 08 Jan 2014 11:34:15 -0500
Message-ID: <52CD7E07.1080506@dev.mellanox.co.il>
References: <52C846F7.6080806@dev.mellanox.co.il> <52C889F7.5050508@fastmail.fm> <52CADB6C.3000604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52CADB6C.3000604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/6/2014 11:35 AM, Hal Rosenstock wrote:
> Hi Bernd,
> 
> On 1/4/2014 5:23 PM, Bernd Schubert wrote:
>> Hello Hal,
>>
>> thanks for updating the patch! I had it on my todo list during my vacation 
>> (still one week left) and didn't have the time to care about it before.
>>
>> What do you think about the patch below on top of your updated patch?
>> (So far I only tested if it compiles at all.)
>>
>>
>> From: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
>>
>> When the partition config file is parsed, partitions are created
>> for each line. If one of the config lines has an error a default
>> partition is created already by a previous commit, but partitions
>> from previous lines are not cleaned up. 
> 
> Would a better policy for this be to honor all good partition config
> lines and ignore/warn about the bad ones rather than revert to default ?
> 
> So as long as there was at least one good line in partition config it
> would use that; otherwise the default partition config.
> 
> Does that make sense ?

Current policy is to take the part of the configuration that is correct
and ignore the errors (logging the line numbers on which they occur).
This seems to be slightly better than defaulting back to the default
partition config (just default partition with IPoIB) as it is likely to
be closer to what the admin wants as a policy so I'd prefer to leave it
this way unless there's some stronger motivation to change this.

-- Hal

> 
> -- Hal
> 
>> Avoid this by doing a dry-run parse first and only if this succeeds 
>> actually create new partitions. 
>> This still ignores errors from osm_prtn_make_new(), but these
>> errors are rather unlikely (i.e. malloc fails) and not really
>> related to the config file.
>>
>> Signed-off-by: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
>> ---
>>  opensm/osm_prtn_config.c |   47 ++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 41 insertions(+), 6 deletions(-)
>>
>> diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
>> index 9bad7a7..4a2eaab 100644
>> --- a/opensm/osm_prtn_config.c
>> +++ b/opensm/osm_prtn_config.c
>> @@ -212,7 +212,8 @@ static void __create_mgrp(struct part_conf *conf, struct precreate_mgroup *group
>>  }
>>  
>>  static int partition_create(unsigned lineno, struct part_conf *conf,
>> -			    char *name, char *id, char *flag, char *flag_val)
>> +			    char *name, char *id, char *flag, char *flag_val,
>> +			    boolean_t is_dry_run)
>>  {
>>  	ib_net16_t pkey;
>>  
>> @@ -230,6 +231,9 @@ static int partition_create(unsigned lineno, struct part_conf *conf,
>>  	} else
>>  		pkey = 0;
>>  
>> +	if (is_dry_run)
>> +		return 0;
>> +
>>  	conf->p_prtn = osm_prtn_make_new(conf->p_log, conf->p_subn,
>>  					 name, pkey);
>>  	if (!conf->p_prtn)
>> @@ -601,7 +605,11 @@ static int flush_part_conf(struct part_conf *conf)
>>  	return 0;
>>  }
>>  
>> -static int parse_part_conf(struct part_conf *conf, char *str, int lineno)
>> +/**
>> + *@is_dry_run only test if this line is valid
>> + */
>> +static int parse_part_conf(struct part_conf *conf, char *str, int lineno,
>> +			   boolean_t is_dry_run)
>>  {
>>  	int ret, len = 0;
>>  	char *name, *id, *flag, *flval;
>> @@ -659,7 +667,8 @@ static int parse_part_conf(struct part_conf *conf, char *str, int lineno)
>>  	}
>>  
>>  	if (p != str || (partition_create(lineno, conf,
>> -					  name, id, flag, flval) < 0)) {
>> +					  name, id, flag, flval,
>> +					  is_dry_run) < 0)) {
>>  		OSM_LOG(conf->p_log, OSM_LOG_ERROR, "PARSE ERROR: line %d: "
>>  			"bad partition definition\n", lineno);
>>  		fprintf(stderr, "\nPARSE ERROR: line %d: "
>> @@ -697,10 +706,12 @@ done:
>>  }
>>  
>>  /**
>> + * @is_dry_run test if the config is valid only
>>   * @return -1 on error, 0 on success
>>   */
>> -int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>> -			       const char *file_name)
>> +static int _osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>> +				       const char *file_name,
>> +				       boolean_t is_dry_run)
>>  {
>>  	char line[4096];
>>  	struct part_conf *conf = NULL;
>> @@ -757,7 +768,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>>  			if (q)
>>  				*q = '\0';
>>  
>> -			len = parse_part_conf(conf, p, lineno);
>> +			len = parse_part_conf(conf, p, lineno, is_dry_run);
>>  			if (len < 0) {
>>  				is_parse_success = FALSE;
>>  				break;
>> @@ -779,3 +790,27 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>>  	else
>>  		return -1;
>>  }
>> +
>> +
>> +/**
>> + * @return -1 on error, 0 on success
>> + */
>> +int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>> +			       const char *file_name)
>> +{
>> +	boolean_t is_dry_run = TRUE; // dry-run first
>> +	int parse_res;
>> +
>> +	while (1) {
>> +		parse_res =_osm_prtn_config_parse_file(p_log, p_subn, file_name,
>> +						       is_dry_run);
>> +		if (parse_res != 0);
>> +			return -1;
>> +
>> +		if (!is_dry_run)
>> +			return 0; // parse / partition create success
>> +
>> +		is_dry_run = FALSE;
>> +	}
>> +
>> +}
>>
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
