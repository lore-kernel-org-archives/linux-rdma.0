From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] libibverbs: Add support for XRC QPs
Date: Thu, 16 Jun 2011 15:02:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730217B5@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302124E@ORSMSX101.amr.corp.intel.com>
 <201106161304.19939.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106161304.19939.dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Should the following struct be used instead of the suggested struct above?
> 
> 	struct {
> 		struct ibv_xrcd *xrcd;
> 		struct ibv_cq   *cq;
> 		uint32_t	 srq_num;
> 	} xrc;
> 
> (attributes were rearranged according to their size).

I can swap things around.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
