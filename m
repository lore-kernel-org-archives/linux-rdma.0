From: Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: opensm/osm_opensm.c: no report when SM is exiting
Date: Thu, 19 Aug 2010 10:09:55 +0300
Message-ID: <4C6CD8C3.70505@dev.mellanox.co.il>
References: <4C6BE246.4080102@dev.mellanox.co.il>	<20100818090618.c9c5bd9b.weiny2@llnl.gov>	<4C6C5794.9090701@dev.mellanox.co.il> <20100818175923.47fa3da8.weiny2@llnl.gov>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100818175923.47fa3da8.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19-Aug-10 3:59 AM, Ira Weiny wrote:
> On Wed, 18 Aug 2010 14:58:44 -0700
> Yevgeny Kliteynik<kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
> 
>> On 18-Aug-10 7:06 PM, Ira Weiny wrote:
>>> On Wed, 18 Aug 2010 06:38:14 -0700
>>> Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>   wrote:
>>>
>>>> Don't bother reporting events to plug-ins while SM is exiting.
>>>
>>> Does this fix a bug?
>>
>> Don't think so (at least not that I'm aware of it).
>> For me, the issue here is optimization.
> 
> Does this delay exit?  Is that the optimization.

Yes.
When SM catches SIGTERM, it marks osm_exit_flag.
However, it doesn't mean that SM will stop doing
whatever it's doing and start exiting - if SM is
in the middle of calling plug-ins, it will
continue calling them.

 
> I wonder if plugins would want to know the SM is shutting down.  But there is
> a "delete" function... ?

The "delete" function allows plug-ins to know when
SM is exiting (if they want to know it).

-- Yevgeny 
 
> Ira
> 
>>
>> -- Yevgeny
>>
>>> Ira
>>>
>>>>
>>>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>> ---
>>>>    opensm/opensm/osm_opensm.c |    2 +-
>>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
>>>> index d3dc02e..50e8763 100644
>>>> --- a/opensm/opensm/osm_opensm.c
>>>> +++ b/opensm/opensm/osm_opensm.c
>>>> @@ -475,7 +475,7 @@ void osm_opensm_report_event(osm_opensm_t *osm, osm_epi_event_id_t event_id,
>>>>    	cl_list_item_t *item;
>>>>
>>>>    	for (item = cl_qlist_head(&osm->plugin_list);
>>>> -	     item != cl_qlist_end(&osm->plugin_list);
>>>> +	     (!osm_exit_flag)&&   (item != cl_qlist_end(&osm->plugin_list));
>>>>    	     item = cl_qlist_next(item)) {
>>>>    		osm_epi_plugin_t *p = (osm_epi_plugin_t *)item;
>>>>    		if (p->impl->report)
>>>> -- 
>>>> 1.6.2.4
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://**vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
