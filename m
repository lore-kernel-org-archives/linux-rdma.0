From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] replace (long*)(long) casting with transportable data
 type (uintptr_t)
Date: Tue, 30 Nov 2010 10:52:31 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1925B9B71490@orsmsx501.amr.corp.intel.com>
References: <7C00F472050C412BABCB4F2A59CFBD63@amr.corp.intel.com>
 <20101130175555.GX11898@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130175555.GX11898@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 14:12 Thu 09 Sep     , Stan C. Smith wrote:
>>
>> Hello,
>>   In osm_vendor_ibumad_sa.c the casting of a pointer to a long
>> causes data truncation problems in 64-bit Windows where sizeof(long)
>> != sizeof(void*). 'uintptr_t' is correct in both operating
>> environments.
>
> Wouldn't it be better to remove those additional castings at all?
> Like below?

Hello,
  I assume the original casts were there for a reason hence the cumbersome double cast?
Mellanox had reported a truncation problem which was fixed with the (uintptr_t) replacement of (long*)(long).
It certainly make more sense to use the single cast if it works; no truncation.
I'll check with those who discovered the truncation and see if they tried the obvious single cast approach.

stan.

>
>>
>> thank you,
>>
>> stan.
>>
>> signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c
>> b/opensm/libvendor/osm_vendor_ibumad_sa.c
>> index 1fdcc47..9180972 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad_sa.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
>> @@ -85,7 +85,7 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
>>
>>      /* obtain the sent context since we store it during send in the
>> ni_ctx */    p_query_req_copy = -        (osmv_query_req_t *) (long
>> *)(long)(p_req_madw->context.ni_context. +       (osmv_query_req_t *)
>>                                              (uintptr_t)(p_req_madw->context.ni_context. node_guid);
>
>       p_query_req_copy = (osmv_query_req_t *)
> p_req_madw->context.ni_context.node_guid;
>
>>
>>      /* provide the context of the original request in the result */
>> @@ -181,7 +181,7 @@ static void __osmv_sa_mad_err_cb(IN void
>> *bind_context, IN osm_madw_t * p_madw)
>>
>>      /* Obtain the sent context etc */
>>      p_query_req_copy =
>> -        (osmv_query_req_t *) (long *)(long)(p_madw->context.ni_context.
>> +        (osmv_query_req_t *) (uintptr_t)(p_madw->context.ni_context.
>>                                              node_guid);
>
>       p_query_req_copy = (osmv_query_req_t *)
> p_madw->context.ni_context.node_guid;
>
>>
>>      /* provide the context of the original request in the result */
>> @@ -433,7 +433,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t *
>>      p_bind,         } *p_query_req_copy = *p_query_req;
>>      p_madw->context.ni_context.node_guid =
>> -        (ib_net64_t) (long)p_query_req_copy;
>> +        (ib_net64_t) (uintptr_t)p_query_req_copy;
>
>       p_madw->context.ni_context.node_guid = (ib_net64_t) p_query_req_copy;
>
> ?
>
> Sasha
>
>>
>>      /* we can support async as well as sync calls */
>>      sync = ((p_query_req->flags & OSM_SA_FLAGS_SYNC) ==
>> OSM_SA_FLAGS_SYNC);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
