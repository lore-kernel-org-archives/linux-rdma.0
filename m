From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Thu, 11 Aug 2011 10:12:09 -0400
Message-ID: <497B04D4-A101-45BA-AFF3-5F661A070CBC@ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201108021344.25284.jackm@dev.mellanox.co.il>
 <32D25205-3E9C-4757-B0AB-7117BDF3F2F7@ornl.gov>
 <201108031337.24527.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237316E3E55C@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1828884A29C6694DAF28B7E6B8A8237316E3E55C-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think it's good idea to support both usage models.

Regards,

Pasha.


>> Things only get complicated when the domain-allocator process allocates a
>> single domain and simply
>> uses that single domain for all jobs (i.e., the domain is never de-allocated
>> for the lifetime of the
>> allocating process, and the allocating process is the server for all jobs).
> 
> To help with OFED feature level compatibility, I'm in the process of adding a new call to ibverbs:
> 
> struct ib_qp_open_attr {
> 	void (*event_handler)(struct ib_event *, void *);
> 	void  *qp_context;
> 	u32    qp_num;
> };
> 
> struct ib_qp *ib_open_qp(*xrcd, *qp_open_attr);
> 
> This provides functionality similar to ib_reg_xrc_recv_qp().  It allows any process within the xrcd to modify the tgt qp and receive events.  Its use is not required, so we can support both usage models.
> 
> I believe we can define this generic enough that it could eventually be used to share other QP types among multiple processes, though more infrastructure would be needed.
> 
> - Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
