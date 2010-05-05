From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] RDMA/nes: add support of iWARP multicast
 acceleration over IB_QPT_RAW_ETY QP type
Date: Wed, 5 May 2010 14:42:15 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801D00D549@irsmsx503.ger.corp.intel.com>
References: <20100430165249.1386.73960.stgit@gkslx010.igk.intel.com>
 <20100430165434.1386.80375.stgit@gkslx010.igk.intel.com>
 <4BE05713.6030101@opengridcomputing.com>
 <BE2BFE91933D1B4089447C64486040801B6784ED@irsmsx503.ger.corp.intel.com>
 <4BE06425.6000104@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE06425.6000104-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve, 

> ud_post_send and friends implements the transmit path for IMA. Our RAW ETH QP needs access to physical addresses from user space. Due to security reasons we should make a virtual-to-physical address translation in kernel. 
>
>   
Steve Wise wrote:
But why couldn't you just use the normal memory registration paths?  IE 
the user mode app does ibv_reg_mr() and then uses lkey/addr/len in SGEs 
in the ibv_post_send() which could do kernel bypass.

I see here some misunderstanding. Let me explain better how our tramsmit path works. 

In our implementation we use normal memory registration path using ibv_reg_mr and we use ibv_post_send() with lkey/vaddr/len.

The implementation of ibv_post_send (nes_post_send in libnes) for RAW QP passes lkey/virtual_addr/len information to kernel using shared page to our device driver (ud_post_send). There is no data copy here and the driver is used only for fast synchronization.

Because our RAW ETH QP must use physical addresses only,  ud_post_send() in kernel makes a virtual to physical memory translation and accesses the QP HW for packet transmission. Previously a packet buffer memory was registered and pinned by ibv_reg_mr to provide necessary information for making such translation.

Steve Wise wrote:
Seems like maybe you could fix the non-bypass post_send/recv paths 
instead of implementing an entirely new user<->kernel interface...

The non-bypass post_send/recv channel (using /dev/infiniband/rdma_cm) is shared with all other user-kernel  communication and it is quite complex. It is a perfect path for QP/CQ/PD/mem management but for me it is too complex for traffic acceleration. 

The user<->kernel  path  through additional driver, shared page for lkey/vaddr/len passing and SW memory translation in kernel is much more effective. 

Maybe it is a good idea to make that API more official after some kind of standarization. Our tests proved that it works. We achieved twice better performance and latency. That way could open the way for adding some non-RDMA devices to devices supported OFED API. 

Regards,

Mirek


-----Original Message-----
From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org] 
Sent: Tuesday, May 04, 2010 8:15 PM
To: Walukiewicz, Miroslaw
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 2/2] RDMA/nes: add support of iWARP multicast acceleration over IB_QPT_RAW_ETY QP type

Walukiewicz, Miroslaw wrote:
> Hello Steve,
>
> Our Hw QP is not a UD type QP but L2 raw QP. In verbs API there is assumtion that user provides a data payload only for TX and similarly receives a payload only. The protocol headers (in case of UD - MAC/IP/UDP) are attached by HW. 
>
> Our QP implementation in HW  does not provide such possibity of attaching headers by HW for UD traffic so for multicast acceleration we choose L2 raw path. It provides some overhead for user application but it is still zero copy apprach.
>
> I thought about using a simulation of UD path using L2 raw QP to get the same result like for true UD QP (user handles a payload only). Such approach costs additional copy of payload in SW due to putting headers first and next payload to single tx buffer. Similar situation is for rx. It is a need for copy payload to posted buffers or provide data with some offset. 
>
> ud_post_send and friends implements the transmit path for IMA. Our RAW ETH QP needs access to physical addresses from user space. Due to security reasons we should make a virtual-to-physical address translation in kernel. 
>
>   

But why couldn't you just use the normal memory registration paths?  IE 
the user mode app does ibv_reg_mr() and then uses lkey/addr/len in SGEs 
in the ibv_post_send() which could do kernel bypass.

> Unfortunately an OFED path for ibv_post_send diving to kernel is quite slow due to some number of dynamic memory allocations in the path. We choose to create own private post_send channel to increase tx bandwidth using ud_post_send and friends.

Seems like maybe you could fix the non-bypass post_send/recv paths 
instead of implementing an entirely new user<->kernel interface...

Steve.


>  
>
> Regards,
>
> Mirek
>
> -----Original Message-----
> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org] 
> Sent: Tuesday, May 04, 2010 7:19 PM
> To: Walukiewicz, Miroslaw
> Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 2/2] RDMA/nes: add support of iWARP multicast acceleration over IB_QPT_RAW_ETY QP type
>
> Hey Mirek,
>
> It looks like this patch adds a new file interface for a UD service.  
> Why didn't you extend the existing UD interface as needed? 
>
> What IO is supported with these changes?  IMA via the raw QP, but what 
> ud_post_send() and friends used for?
>
>
> Steve.
>
>
>
> miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>   
>> This patch implements iWarp multicast acceleration (IMA)
>> over IB_QPT_RAW_ETY QP type in nes driver.
>>
>> Application creates a raw eth QP (IBV_QPT_RAW_ETH in user-space) and
>> manages the multicast via ibv_attach_mcast and ibv_detach_mcast calls.
>>
>> Calling ibv_attach_mcast/ibv_datach_mcast has an effect of
>> enabling/disabling L2 MAC address filters in HW.
>>
>> Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>>
>>
>>     

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
