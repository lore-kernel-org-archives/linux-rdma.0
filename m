From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Endianess in cxgb4
Date: Tue, 24 Oct 2017 13:45:52 -0500
Message-ID: <069401d34cf8$5171f6e0$f455e4a0$@opengridcomputing.com>
References: <20171024183759.GK16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024183759.GK16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Steve,
> 
> I reviewed my reports from various static checkers and saw strange code
> in build_tpte_memreg() function that in drivers/infiniband/hw/cxgb4/qp.c.
> 
> That function has following code:
>  614         fr->r2 = cpu_to_be32(0);
>  615         fr->stag = cpu_to_be32(mhp->ibmr.rkey);
> 
> The r2, stag and rkey are u32, why do you need cpu_to_be32() conversion?
> 

Hey Leon,

The r2 and stag fields in struct fw_ri_fr_nsmr_tpte_wr should be __be32.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
