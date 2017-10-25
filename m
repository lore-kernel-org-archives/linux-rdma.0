From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Endianess in cxgb4
Date: Wed, 25 Oct 2017 10:46:44 -0500
Message-ID: <028401d34da8$75589360$6009ba20$@opengridcomputing.com>
References: <20171024183759.GK16127@mtr-leonro.local> <069401d34cf8$5171f6e0$f455e4a0$@opengridcomputing.com> <20171024190142.GM16127@mtr-leonro.local> <021401d34da0$45afeda0$d10fc8e0$@opengridcomputing.com> <20171025153856.GT16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025153856.GT16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I'm not communicating effectively.  Sorry.
> >
> > This is a bug in t4fw_ri_api.h.  You need create a patch to change
> > fw_ri_fr_nsmr_tpte_wr to make the stag and r2 fields to be __be32.
> 
> Thanks, I'll send a fix.
> 

Thanks for doing this work! 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
