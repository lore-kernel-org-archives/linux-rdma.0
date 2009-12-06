From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3 v2] opensm SA DB dump/restore: dump SA DB only if
 modified
Date: Sun, 06 Dec 2009 14:28:58 +0200
Message-ID: <4B1BA38A.5080103@dev.mellanox.co.il>
References: <4AF15EF0.6050903@dev.mellanox.co.il> <20091126141519.GB28564@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091126141519.GB28564@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Sasha Khapyorsky wrote:
> On 13:01 Wed 04 Nov     , Yevgeny Kliteynik wrote:
>> Optimizing SA DB dump - added "dirty" flag to denote
>> that the SA DB was modified, so that the DB will be
>> dumped only when the flag is on.
>>
>> [v2 - no changes, just rebased and resolved conflicts]
>>
>> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>  opensm/include/opensm/osm_sa.h         |    5 +++++
>>  opensm/opensm/osm_inform.c             |    2 ++
>>  opensm/opensm/osm_multicast.c          |    3 +++
>>  opensm/opensm/osm_sa.c                 |    7 ++++++-
>>  opensm/opensm/osm_sa_mcmember_record.c |    4 ++++
>>  opensm/opensm/osm_service.c            |    3 +++
>>  6 files changed, 23 insertions(+), 1 deletions(-)
>>
>> diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
>> index dad3142..35684cc 100644
>> --- a/opensm/include/opensm/osm_sa.h
>> +++ b/opensm/include/opensm/osm_sa.h
>> @@ -125,6 +125,7 @@ typedef struct osm_sa {
>>  	atomic32_t sa_trans_id;
>>  	osm_sa_mad_ctrl_t mad_ctrl;
>>  	cl_timer_t sr_timer;
>> +	boolean_t dirty;
>>  	cl_disp_reg_handle_t cpi_disp_h;
>>  	cl_disp_reg_handle_t nr_disp_h;
>>  	cl_disp_reg_handle_t pir_disp_h;
>> @@ -178,6 +179,10 @@ typedef struct osm_sa {
>>  *	mad_ctrl
>>  *		Mad Controller
>>  *
>> +*	dirty
>> +*		A flag that denotes that SA DB is dirty and needs
>> +*		to be written to the dump file (if dumping is enabled)
>> +*
>>  * SEE ALSO
>>  *	SM object
>>  *********/
>> diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
>> index 84310a5..d2dd8e7 100644
>> --- a/opensm/opensm/osm_inform.c
>> +++ b/opensm/opensm/osm_inform.c
>> @@ -248,6 +248,7 @@ void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>>  #endif
>>
>>  	cl_qlist_insert_head(&p_subn->sa_infr_list, &p_infr->list_item);
>> +	p_subn->p_osm->sa.dirty = TRUE;
>>
>>  	OSM_LOG(p_log, OSM_LOG_DEBUG, "Dump after insertion (size %d)\n",
>>  		cl_qlist_count(&p_subn->sa_infr_list));
>> @@ -271,6 +272,7 @@ void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>>  			     OSM_LOG_DEBUG);
>>
>>  	cl_qlist_remove_item(&p_subn->sa_infr_list, &p_infr->list_item);
>> +	p_subn->p_osm->sa.dirty = TRUE;
>>
>>  	osm_infr_delete(p_infr);
>>
>> diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
>> index 8ccab8e..c501986 100644
>> --- a/opensm/opensm/osm_multicast.c
>> +++ b/opensm/opensm/osm_multicast.c
>> @@ -197,6 +197,7 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
>>  	    ++mgrp->full_members == 1)
>>  		mgrp_send_notice(subn, log, mgrp, 66);
>>
>> +	subn->p_osm->sa.dirty = TRUE;
>>  	return mcm_port;
>>  }
>>
>> @@ -251,6 +252,8 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
>>  		mgrp_send_notice(subn, log, mgrp, 67);
>>  		osm_mgrp_cleanup(subn, mgrp);
>>  	}
>> +
>> +	subn->p_osm->sa.dirty = TRUE;
>>  }
> 
> In general I don't like an idea of spreading this global "dirty" flag
> over various OpenSM areas (it makes the code dirty). But even if it is
> needed couldn't we minimize number of such occurrences?
> 
> For example those specific ones in osm_multicast.c are duplicated in
> osm_sa_mcmember_record.c (and also will cause 'dirty' flag setup on the
> SA DB from file loading). Could we consolidate all multicast related
> cases with re-routing requesting for example?

I'll try to make it less "dirty".

Here's what I'll do: I'll sent a V3 of these patch series,
this time it will be only two patches: loading SA DB only
at first master heavy sweep, and new option to dump SA DB
at every sweep.

I will rework this "dirty" thing and send it in a separate
patch in the future.

-- Yevgeny
 
> Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
