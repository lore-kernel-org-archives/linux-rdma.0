From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFI] ucmatose: No effect to set service type for QoS
Date: Thu, 11 Aug 2016 17:15:43 -0400
Message-ID: <dbf070a3-e6c0-74b6-9127-7f77e0594b2f@dev.mellanox.co.il>
References: <CAMGffEn=dQsBzV9SPsVTJdsppJ65n_FFiRRASyrjwnmMNmCuDQ@mail.gmail.com>
 <170f9d79-2351-d95f-9ed1-eddedc467d68@dev.mellanox.co.il>
 <CAMGffEmP_ouVu5v1cGGENqD9dssgtAqTg39-xa6--NaUkf1aVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEmP_ouVu5v1cGGENqD9dssgtAqTg39-xa6--NaUkf1aVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/11/2016 8:29 AM, Jinpu Wang wrote:
> On Wed, Aug 10, 2016 at 8:52 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 8/9/2016 12:26 PM, Jinpu Wang wrote:
>>> Hi Sean,
>>>
>>> I'm testing QoS support for IB. I notice ucmatose has equally
>>> performance when set different service type, but set SL in ib_send_bw
>>> works well (different SL show different performance base on opensm
>>> settings)
>>>
>>> I capature packats using ibdump, it shows in in LRH the service level
>>> fields are all 0 when running traffic with ucmatose.
>>>
>>> When running ib_send_bw, it carries the right service level I set.
>>>
>>> Seems in rdma_set_service_type, it sets to tos to id_priv->tos, and
>>> lter set to path_rec->qos_class or traffic_class but not to sl
>>> directly, what's the consideration here?
>>> code snip:
>>>         switch (cma_family(id_priv)) {
>>>         case AF_INET:
>>>                 path_rec->qos_class = cpu_to_be16((u16) id_priv->tos);
>>>                 comp_mask |= IB_SA_PATH_REC_QOS_CLASS;
>>>                 break;
>>>         case AF_INET6:
>>>                 sin6 = (struct sockaddr_in6 *) cma_src_addr(id_priv);
>>>                 path_rec->traffic_class = (u8)
>>> (be32_to_cpu(sin6->sin6_flowinfo) >> 20);
>>>                 comp_mask |= IB_SA_PATH_REC_TRAFFIC_CLASS;
>>>                 break;
>>>         case AF_IB:
>>>                 sib = (struct sockaddr_ib *) cma_src_addr(id_priv);
>>>                 path_rec->traffic_class = (u8)
>>> (be32_to_cpu(sib->sib_flowinfo) >> 20);
>>>
>>>
>>> Does it make sense we also set sl here, or service type for ucmatose
>>> is totally different with SL for ib_send_bw?
>>
>> I think this is an OpenSM configuration issue. QoS policy needs to be
>> setup to return the proper SL to use for QoS class or TClass in the
>> PathRecord response.
>>
>> -- Hal
>>
> Thanks Hal,
> 
> Configure extra QoS policy seems quite complex.

Configuration complexity varies depending on the requirements of the QoS
needs.

Which type of RDMA CM connections are being used (IPv4, IPv6, or native
IB) ?

> Do you think patch attached make sense?

Attached patch doesn't appear to relate to upstream.

It also looks incomplete to me. What invokes rdma_set_service_level ? Is
it some option in ucma.c:ucma_set_option ?

Current patch doesn't appear to me to be backward compatible. If
rdma_set_service_level is not called in flow, then SL should not be set
in SA PR query which is what happens today.

Also, if SL is set in query, you probably don't need some of the other
fields that are being set.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
