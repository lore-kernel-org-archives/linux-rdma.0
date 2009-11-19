From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/9] rdma/cm: fix loopback address support
Date: Thu, 19 Nov 2009 13:24:53 -0800
Message-ID: <adavdh66wd6.fsf@roland-alpha.cisco.com>
References: <8C1E83708E03464FA1613B7E6E9BCBCC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8C1E83708E03464FA1613B7E6E9BCBCC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Mon, 16 Nov 2009 16:06:42 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I added in the following diff as part of applying this to get RDS to
build.  It looks like this is all that's needed to fix the build?

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 536ebe5..3b89923 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -182,8 +182,8 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
 		ic = conn->c_transport_data;
 		dev_addr = &ic->i_cm_id->route.addr.dev_addr;
 
-		ib_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
-		ib_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);
+		rdma_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
+		rdma_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);
 
 		rds_ibdev = ib_get_client_data(ic->i_cm_id->device, &rds_ib_client);
 		iinfo->max_send_wr = ic->i_send_ring.w_nr;
diff --git a/net/rds/iw.c b/net/rds/iw.c
index db224f7..b28fa85 100644
--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -184,8 +184,8 @@ static int rds_iw_conn_info_visitor(struct rds_connection *conn,
 		ic = conn->c_transport_data;
 		dev_addr = &ic->i_cm_id->route.addr.dev_addr;
 
-		ib_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
-		ib_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);
+		rdma_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
+		rdma_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);
 
 		rds_iwdev = ib_get_client_data(ic->i_cm_id->device, &rds_iw_client);
 		iinfo->max_send_wr = ic->i_send_ring.w_nr;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
