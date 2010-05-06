From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] RDMA/nes: add support of iWARP multicast
 acceleration over IB_QPT_RAW_ETY QP type
Date: Thu, 6 May 2010 17:27:25 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801D282D4B@irsmsx503.ger.corp.intel.com>
References: <20100430165249.1386.73960.stgit@gkslx010.igk.intel.com>
 <20100430165434.1386.80375.stgit@gkslx010.igk.intel.com>
 <4BE05713.6030101@opengridcomputing.com>
 <BE2BFE91933D1B4089447C64486040801B6784ED@irsmsx503.ger.corp.intel.com>
 <4BE06425.6000104@opengridcomputing.com>
 <BE2BFE91933D1B4089447C64486040801D00D549@irsmsx503.ger.corp.intel.com>
 <4BE18710.9090304@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE18710.9090304-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Steve Wise wrote:
Is this all just optimizing mcast packets?

The RAW ETH QP API could be used to accelerate sending and receiving any L2 packets. It depends on application and HW setup. We use it for accelerating a multicast traffic.

Steve Wise wrote:
Does this raw qp service share the mac address with the ports being used 
by the host stack?  Or does each raw qp get its own mac address?

We use a MAC address of the port as a source MAC. The destination MAC is derived from multicast group. In theory,  it is possible using other MAC for unicast traffic acceleration, but it is much more complex due to making correct ARP responses and HW possibility to push unicast packets to correct QPs. 

Steve Wise wrote:
Do you all have a user mode UDP/IP running on this raw qp? 

Yes, we use modified mckey for most tests. 

Steve Wise wrote:
If so, does it use its own IP address separate from the host stack or does it share the host's IP address.

Our test application shares an IP address of host interface as a source IP address. 

Regards,

Mirek
 

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
Sent: Wednesday, May 05, 2010 4:56 PM
To: Walukiewicz, Miroslaw
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 2/2] RDMA/nes: add support of iWARP multicast acceleration over IB_QPT_RAW_ETY QP type


> I see here some misunderstanding. Let me explain better how our tramsmit path works. 
>
> In our implementation we use normal memory registration path using ibv_reg_mr and we use ibv_post_send() with lkey/vaddr/len.
>
> The implementation of ibv_post_send (nes_post_send in libnes) for RAW QP passes lkey/virtual_addr/len information to kernel using shared page to our device driver (ud_post_send). There is no data copy here and the driver is used only for fast synchronization.
>
> Because our RAW ETH QP must use physical addresses only,  ud_post_send() in kernel makes a virtual to physical memory translation and accesses the QP HW for packet transmission. Previously a packet buffer memory was registered and pinned by ibv_reg_mr to provide necessary information for making such translation.
>
>   

I see.  Thanks!


> The non-bypass post_send/recv channel (using /dev/infiniband/rdma_cm) is shared with all other user-kernel  communication and it is quite complex. It is a perfect path for QP/CQ/PD/mem management but for me it is too complex for traffic acceleration. 
>
> The user<->kernel  path  through additional driver, shared page for lkey/vaddr/len passing and SW memory translation in kernel is much more effective. 
>
> Maybe it is a good idea to make that API more official after some kind of standarization. Our tests proved that it works. We achieved twice better performance and latency. That way could open the way for adding some non-RDMA devices to devices supported OFED API. 
>
>   

Sounds good.

Do you have specific perf numbers to share?  Is this all just optimizing 
mcast packets? 

Also:

Does this raw qp service share the mac address with the ports being used 
by the host stack?  Or does each raw qp get its own mac address?

Do you all have a user mode UDP/IP running on this raw qp?  If so, does 
it use its own IP address separate from the host stack or does it share 
the host's IP address.


Thanks,

Steve.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
