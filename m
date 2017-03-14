From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/7] Fix missing swaps when computing path bits
Date: Tue, 14 Mar 2017 10:21:09 -0600
Message-ID: <1489508474-16664-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sparse says the slid is BE in this context.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c | 4 ++--
 librdmacm/rsocket.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index d7c797fccd7728..da4e69cd171f5b 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -656,7 +656,7 @@ acmp_record_mc_av(struct acmp_port *port, struct ib_mc_member_rec *mc_rec,
 	dest->path.dgid = mc_rec->mgid;
 	dest->path.sgid = mc_rec->port_gid;
 	dest->path.dlid = mc_rec->mlid;
-	dest->path.slid = htobe16(port->lid) | port->sa_dest.av.src_path_bits;
+	dest->path.slid = htobe16(port->lid | port->sa_dest.av.src_path_bits);
 	dest->path.flowlabel_hoplimit = htobe32(sl_flow_hop & 0xFFFFFFF);
 	dest->path.tclass = mc_rec->tclass;
 	dest->path.reversible_numpath = IBV_PATH_RECORD_REVERSIBLE | 1;
@@ -675,7 +675,7 @@ acmp_init_path_av(struct acmp_port *port, struct acmp_dest *dest)
 
 	dest->av.dlid = be16toh(dest->path.dlid);
 	dest->av.sl = be16toh(dest->path.qosclass_sl) & 0xF;
-	dest->av.src_path_bits = dest->path.slid & 0x7F;
+	dest->av.src_path_bits = be16toh(dest->path.slid) & 0x7F;
 	dest->av.static_rate = dest->path.rate & 0x3F;
 	dest->av.port_num = port->port_num;
 
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 2742b7bd982d7b..db06a9c3b1c5ee 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -4103,7 +4103,7 @@ static void udp_svc_create_ah(struct rsocket *rs, struct ds_dest *dest, uint32_t
 	}
 	attr.dlid = be16toh(id->route.path_rec->dlid);
 	attr.sl = id->route.path_rec->sl;
-	attr.src_path_bits = id->route.path_rec->slid & udp_svc_path_bits(dest);
+	attr.src_path_bits = be16toh(id->route.path_rec->slid) & udp_svc_path_bits(dest);
 	attr.static_rate = id->route.path_rec->rate;
 	attr.port_num  = id->port_num;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
