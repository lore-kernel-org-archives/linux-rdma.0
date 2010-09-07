From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libvendor/osm_vendor_ibumad_sa.c: remove useless "if"
 statement
Date: Tue, 07 Sep 2010 21:20:00 +0300
Message-ID: <4C868250.6090501@dev.mellanox.co.il>
References: <4C8656B0.5050104@mellanox.co.il> <AANLkTingExvAshGM6uOQhy3TNFwH7dSrF6fWXYzGxke4@mail.gmail.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTingExvAshGM6uOQhy3TNFwH7dSrF6fWXYzGxke4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07-Sep-10 8:47 PM, Hal Rosenstock wrote:
> On Tue, Sep 7, 2010 at 11:13 AM, Yevgeny Kliteynik
> <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  wrote:
>> Content of p_query_req_copy is used in the function,
>> so no point checking if it's NULL before the free().
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>   opensm/libvendor/osm_vendor_ibumad_sa.c |    3 +--
> 
> Same change could be done for osm_vendor_mlx_sa.c too.

Sure, thanks.

-- Yevgeny
 
> -- Hal
> 
>>   1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libvendor/osm_vendor_ibumad_sa.c
>> index 75bc303..1fdcc47 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad_sa.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
>> @@ -199,8 +199,7 @@ static void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
>>         if ((p_query_req_copy->flags&  OSM_SA_FLAGS_SYNC) == OSM_SA_FLAGS_SYNC)
>>                 cl_event_signal(&p_bind->sync_event);
>>
>> -       if (p_query_req_copy)
>> -               free(p_query_req_copy);
>> +       free(p_query_req_copy);
>>         OSM_LOG_EXIT(p_bind->p_log);
>>   }
>>
>> --
>> 1.6.2.4
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
