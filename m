From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/6] rsocket: Fix byte swapping when constructing path records
Date: Wed, 15 Mar 2017 16:12:06 -0600
Message-ID: <1489615927-12117-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These swaps were missed or in the wrong place

Found by sparse.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/rsocket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index a0bc604845c118..4fbe7aaa938610 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -3551,11 +3551,11 @@ static void rs_convert_sa_path(struct ibv_sa_path_rec *sa_path,
 	path_data->path.dlid = sa_path->dlid;
 	path_data->path.slid = sa_path->slid;
 	fl_hop = be32toh(sa_path->flow_label) << 8;
-	path_data->path.flowlabel_hoplimit = htobe32(fl_hop) | sa_path->hop_limit;
+	path_data->path.flowlabel_hoplimit = htobe32(fl_hop | sa_path->hop_limit);
 	path_data->path.tclass = sa_path->traffic_class;
 	path_data->path.reversible_numpath = sa_path->reversible << 7 | 1;
 	path_data->path.pkey = sa_path->pkey;
-	path_data->path.qosclass_sl = sa_path->sl;
+	path_data->path.qosclass_sl = htobe16(sa_path->sl);
 	path_data->path.mtu = sa_path->mtu | 2 << 6;	/* exactly */
 	path_data->path.rate = sa_path->rate | 2 << 6;
 	path_data->path.packetlifetime = sa_path->packet_life_time | 2 << 6;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
