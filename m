From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_mcmember_record.c: optimization in zero
 mgid comparison
Date: Sun, 01 Nov 2009 22:26:19 +0200
Message-ID: <4AEDEEEB.8010401@dev.mellanox.co.il>
References: <4AED56C0.4080006@dev.mellanox.co.il> <20091101160216.GF29434@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091101160216.GF29434@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 11:37 Sun 01 Nov     , Yevgeny Kliteynik wrote:
>> Hi Sasha,
>>
>> Small optimization in comparison to zero mgid in new
>> mcast group creation.
>>
>> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> 
> Applied. Thanks.
> 
> Also see below.
> 
>> ---
>>  opensm/opensm/osm_sa_mcmember_record.c |   11 ++++-------
>>  1 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
>> index dd01eed..18dc22c 100644
>> --- a/opensm/opensm/osm_sa_mcmember_record.c
>> +++ b/opensm/opensm/osm_sa_mcmember_record.c
>> @@ -731,7 +731,7 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
>>  						OUT osm_mgrp_t ** pp_mgrp)
>>  {
>>  	ib_net16_t mlid;
>> -	unsigned zero_mgid, i;
>> +	unsigned zero_mgid = 1;
>>  	uint8_t scope;
>>  	ib_gid_t *p_mgid;
>>  	ib_api_status_t status = IB_SUCCESS;
>> @@ -740,12 +740,9 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
>>  	OSM_LOG_ENTER(sa->p_log);
>>
>>  	/* but what if the given MGID was not 0 ? */
>> -	zero_mgid = 1;
>> -	for (i = 0; i < sizeof(p_recvd_mcmember_rec->mgid); i++)
>> -		if (p_recvd_mcmember_rec->mgid.raw[i] != 0) {
>> -			zero_mgid = 0;
>> -			break;
>> -		}
>> +	if (p_recvd_mcmember_rec->mgid.unicast.prefix != 0 ||
>> +	    p_recvd_mcmember_rec->mgid.unicast.interface_id != 0)
>> +		zero_mgid = 0;
> 
> Actually you can use 'ib_zero_gid' here, something like:
> 
> 	zero_mgid = !memcmp(&p_recvd_mcmember_rec->mgid, &ib_zero_gid,
> 			    sizeof(ib_git_t));

Oh, I didn't know that it existed :)
BTW, it appears that we already have such function:

	static inline boolean_t
	ib_gid_is_notzero(IN const ib_gid_t * p_gid)

So it might as well just be something like that:

 opensm/opensm/osm_sa_mcmember_record.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 45e743f..617f352 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -731,22 +731,14 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 						OUT osm_mgrp_t ** pp_mgrp)
 {
 	ib_net16_t mlid;
-	unsigned zero_mgid, i;
 	uint8_t scope;
 	ib_gid_t *p_mgid;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_member_rec_t mcm_rec = *p_recvd_mcmember_rec;	/* copy for modifications */
+	boolean_t zero_mgid = !ib_gid_is_notzero(&p_recvd_mcmember_rec->mgid);
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	/* but what if the given MGID was not 0 ? */
-	zero_mgid = 1;
-	for (i = 0; i < sizeof(p_recvd_mcmember_rec->mgid); i++)
-		if (p_recvd_mcmember_rec->mgid.raw[i] != 0) {
-			zero_mgid = 0;
-			break;
-		}
-
 	/*
 	   we allocate a new mlid number before we might use it
 	   for MGID ...

Want me to send a patch against the new master?

-- Yevgeny
 
> Sasha
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
