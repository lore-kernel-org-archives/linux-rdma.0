From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/8] opensm/complib: define "if" statements with branch
 prediction hints
Date: Tue, 14 Aug 2012 21:39:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A892A4@ORSMSX101.amr.corp.intel.com>
References: <502AC3DC.9090102@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502AC3DC.9090102-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +#define if_PF(cond)		if(CL_PREDICT_FALSE(cond))
> +#define if_PT(cond)		if(CL_PREDICT_TRUE(cond))

If CL_PREDICT_TRUE/FALSE are too long, why not just shorten those, rather than abstract if statements behind a macro?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
