From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 0/4] add RAW Packet QP type
Date: Tue, 17 Jan 2012 10:21:28 -0600
Message-ID: <4F15A008.9010303@opengridcomputing.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com> <4F158ED7.3080405@opengridcomputing.com> <4F159AEB.1060603@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F159AEB.1060603-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Felix Marti <felix-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/17/2012 09:59 AM, Or Gerlitz wrote:
> On 1/17/2012 5:08 PM, Steve Wise wrote:
>> I think this series should add some new send flags for HW that does checksum offload [...] also, on ingress, most 
>> hardware can do INET checksum validation, and a way to indicate the results to the application is needed.  Perhaps 
>> flags in the CQE? [...] another form of HW assist is with VLAN insertion/extraction.  The API should provide a way to 
>> specify if a VLAN ID should be inserted by HW and removed from a packet on ingress (and passed to the app via the 
>> CQE).  In fact, we probably want a way to associate a VLAN with a RAW QP, maybe as a QP attribute?
>
> Hi Steve,
>
> Nice to see how a discussion is quickly revived when the subject is close to people's needs... anyway, yep, sure, this 
> submission allows for basic functionality, as I mentioned and there's more to add here, but this could (should...) be 
> done gradually,  i.e in steps that adds on the basic patch. Now to the points you've raised:
>
> Sure, we want to be able to do checksum offload on TX and on RX as well. Adding checksum offload support will be done 
> with a patch to libibverbs which is similar in spirit to commit e0605d "IB/core: Add IP checksum offload support" 
> subject to reporting the RX checksum okay through new IB_WC_IP_CSUM_OK bit in ibv_wc->wc_flags along the lines of the 
> patch I sent last week to the kernel. So we will have a new device capability and two new bit flags IB_SEND_IP_CSUM 
> and IB_WC_IP_CSUM_OK, no ABI breaking... happy.

Sounds good, with the caveat that we need more bits to specify L4 CSUM generation as well as L3 (and L2 CRC).

>
>
> Less simple will be to add support in libibverbs and the low level driver libraries, for Large-Send-Offload, e.g in 
> the spirit of commits b846f25aa "IB/core: Add creation flags to struct ib_qp_init_attr" and c93570f2 "IB/core: Add 
> IPoIB UD LSO support", since we probably need to be able to specify something in the qp creation (Sean's verbs 
> extension proposal!) and add fields to struct ibv_send_wr.wr.ud, in the WR case, we need more 16 (= 8 + 4 + 4) bytes, 
> where it seems before the patch we have 12 bytes extra from wr.atomic, I need to check the compiler packing here...
>
>> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
>> index 6acfc81..81bc55f 100644
>> --- a/include/infiniband/verbs.h
>> +++ b/include/infiniband/verbs.h
>> @@ -534,6 +534,9 @@ struct ibv_send_wr {
>>                         struct ibv_ah  *ah;
>>                         uint32_t        remote_qpn;
>>                         uint32_t        remote_qkey;
>> +                       void            *header;
>> +                       uint32_t        hlen;
>> +                       uint32_t        mss;
>>                 } ud;
>>         } wr;
>>  };
>
>
> As for vlan stripping/insertion, I'm not having definitive opinion yet - if we don't expect the system (library, 
> firmware, hardware) to insert/strip the L2 MAC header, I', not sure what does it buy us to have the vlan tag 
> inserted/stripped?

Actually, I'm not sure.  But cxgb4 allows for it. :)  Maybe someone from Chelsio could explain the utility?

>
> As for your comment on vlan association with raw qp, do you actually refer to the steering work the HCA/NIC should do 
> w.r.t that qp? e.g you'd like to have L2 elements in the tuple/rule which is used to steer packets to that QP?
>

It definitely needs to be part of the steering filter/flow.  If we define a new API for adding the filter/flow, then I 
think that is one place where the VLAN ID would be provided by the app.  Also as part of a SEND WR, as Miroslaw points 
out.  My original thought was that you associate it with the RAW QP and then it is used by the provider as needed, but 
maybe that is too restrictive.


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
