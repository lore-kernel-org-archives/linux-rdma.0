From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 7/9] rdma/cm: fix loopback address support
Date: Thu, 19 Nov 2009 13:34:56 -0800
Message-ID: <42A55A1000E043B88D6860FA4DF45698@amr.corp.intel.com>
References: <8C1E83708E03464FA1613B7E6E9BCBCC@amr.corp.intel.com> <adavdh66wd6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdh66wd6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I added in the following diff as part of applying this to get RDS to
>build.  It looks like this is all that's needed to fix the build?

Apparently I don't build RDS.  Yes, this looks right to me.  I'm assuming that
these calls are made only for established connections, where dev_addr is set
correctly.

>diff --git a/net/rds/iw.c b/net/rds/iw.c
>index db224f7..b28fa85 100644
>--- a/net/rds/iw.c
>+++ b/net/rds/iw.c
>@@ -184,8 +184,8 @@ static int rds_iw_conn_info_visitor(struct rds_connection
>*conn,
> 		ic = conn->c_transport_data;
> 		dev_addr = &ic->i_cm_id->route.addr.dev_addr;
>
>-		ib_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
>-		ib_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);
>+		rdma_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
>+		rdma_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);

This patch has the side effect of actually returning the correct 'GID' for an
iWarp device.  ib_addr_get_sgid should have been iw_addr_get_sgid here.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
