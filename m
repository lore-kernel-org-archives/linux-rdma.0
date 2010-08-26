From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Thu, 26 Aug 2010 13:11:56 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
References: <20100826141723.GC8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141723.GC8795@mtldesk30>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -330,15 +348,29 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
>  	union ib_gid gid;
>  	int ret = -ENODEV;
> 
> -	rdma_addr_get_sgid(dev_addr, &gid);
> +	if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
> +		iboe_addr_get_sgid(dev_addr, &gid);

How does this work with iwarp?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
