From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 04/18] IB/core: Check for global flag when using ah_attr
Date: Sat, 29 Apr 2017 14:41:16 -0400
Message-ID: <1493491290-31621-5-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Read/write grh fields of the ah_attr only if the
ah_flags field has the IB_AH_GRH bit enabled

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c      | 80 +++++++++++++++++++------------
 drivers/infiniband/core/uverbs_marshall.c | 12 +++--
 2 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3c426..de4753b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1847,28 +1847,33 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.alt_port_num           = attr->alt_port_num;
 	resp.alt_timeout            = attr->alt_timeout;
 
-	memcpy(resp.dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
-	resp.dest.flow_label        = attr->ah_attr.grh.flow_label;
-	resp.dest.sgid_index        = attr->ah_attr.grh.sgid_index;
-	resp.dest.hop_limit         = attr->ah_attr.grh.hop_limit;
-	resp.dest.traffic_class     = attr->ah_attr.grh.traffic_class;
 	resp.dest.dlid              = attr->ah_attr.dlid;
 	resp.dest.sl                = attr->ah_attr.sl;
 	resp.dest.src_path_bits     = attr->ah_attr.src_path_bits;
 	resp.dest.static_rate       = attr->ah_attr.static_rate;
 	resp.dest.is_global         = !!(attr->ah_attr.ah_flags & IB_AH_GRH);
+	if (resp.dest.is_global) {
+		memcpy(resp.dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
+		resp.dest.flow_label        = attr->ah_attr.grh.flow_label;
+		resp.dest.sgid_index        = attr->ah_attr.grh.sgid_index;
+		resp.dest.hop_limit         = attr->ah_attr.grh.hop_limit;
+		resp.dest.traffic_class     = attr->ah_attr.grh.traffic_class;
+	}
 	resp.dest.port_num          = attr->ah_attr.port_num;
 
-	memcpy(resp.alt_dest.dgid, attr->alt_ah_attr.grh.dgid.raw, 16);
-	resp.alt_dest.flow_label    = attr->alt_ah_attr.grh.flow_label;
-	resp.alt_dest.sgid_index    = attr->alt_ah_attr.grh.sgid_index;
-	resp.alt_dest.hop_limit     = attr->alt_ah_attr.grh.hop_limit;
-	resp.alt_dest.traffic_class = attr->alt_ah_attr.grh.traffic_class;
 	resp.alt_dest.dlid          = attr->alt_ah_attr.dlid;
 	resp.alt_dest.sl            = attr->alt_ah_attr.sl;
 	resp.alt_dest.src_path_bits = attr->alt_ah_attr.src_path_bits;
 	resp.alt_dest.static_rate   = attr->alt_ah_attr.static_rate;
 	resp.alt_dest.is_global     = !!(attr->alt_ah_attr.ah_flags & IB_AH_GRH);
+	if (resp.alt_dest.is_global) {
+		memcpy(resp.alt_dest.dgid, attr->alt_ah_attr.grh.dgid.raw, 16);
+		resp.alt_dest.flow_label    = attr->alt_ah_attr.grh.flow_label;
+		resp.alt_dest.sgid_index    = attr->alt_ah_attr.grh.sgid_index;
+		resp.alt_dest.hop_limit     = attr->alt_ah_attr.grh.hop_limit;
+		resp.alt_dest.traffic_class =
+				attr->alt_ah_attr.grh.traffic_class;
+	}
 	resp.alt_dest.port_num      = attr->alt_ah_attr.port_num;
 
 	resp.max_send_wr            = init_attr->cap.max_send_wr;
@@ -1943,30 +1948,41 @@ static int modify_qp(struct ib_uverbs_file *file,
 	attr->alt_timeout	  = cmd->base.alt_timeout;
 	attr->rate_limit	  = cmd->rate_limit;
 
-	memcpy(attr->ah_attr.grh.dgid.raw, cmd->base.dest.dgid, 16);
-	attr->ah_attr.grh.flow_label	= cmd->base.dest.flow_label;
-	attr->ah_attr.grh.sgid_index	= cmd->base.dest.sgid_index;
-	attr->ah_attr.grh.hop_limit	= cmd->base.dest.hop_limit;
-	attr->ah_attr.grh.traffic_class	= cmd->base.dest.traffic_class;
+	if (cmd->base.dest.is_global) {
+		memcpy(attr->ah_attr.grh.dgid.raw, cmd->base.dest.dgid, 16);
+		attr->ah_attr.grh.flow_label	= cmd->base.dest.flow_label;
+		attr->ah_attr.grh.sgid_index	= cmd->base.dest.sgid_index;
+		attr->ah_attr.grh.hop_limit	= cmd->base.dest.hop_limit;
+		attr->ah_attr.grh.traffic_class	= cmd->base.dest.traffic_class;
+		attr->ah_attr.ah_flags		= IB_AH_GRH;
+	} else {
+		attr->ah_attr.ah_flags = 0;
+	}
 	attr->ah_attr.dlid		= cmd->base.dest.dlid;
 	attr->ah_attr.sl		= cmd->base.dest.sl;
 	attr->ah_attr.src_path_bits	= cmd->base.dest.src_path_bits;
 	attr->ah_attr.static_rate	= cmd->base.dest.static_rate;
-	attr->ah_attr.ah_flags		= cmd->base.dest.is_global ?
-					  IB_AH_GRH : 0;
 	attr->ah_attr.port_num		= cmd->base.dest.port_num;
 
-	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd->base.alt_dest.dgid, 16);
-	attr->alt_ah_attr.grh.flow_label    = cmd->base.alt_dest.flow_label;
-	attr->alt_ah_attr.grh.sgid_index    = cmd->base.alt_dest.sgid_index;
-	attr->alt_ah_attr.grh.hop_limit     = cmd->base.alt_dest.hop_limit;
-	attr->alt_ah_attr.grh.traffic_class = cmd->base.alt_dest.traffic_class;
+	if (cmd->base.alt_dest.is_global) {
+		memcpy(attr->alt_ah_attr.grh.dgid.raw,
+		       cmd->base.alt_dest.dgid, 16);
+		attr->alt_ah_attr.grh.flow_label =
+				cmd->base.alt_dest.flow_label;
+		attr->alt_ah_attr.grh.sgid_index =
+				cmd->base.alt_dest.sgid_index;
+		attr->alt_ah_attr.grh.hop_limit =
+				cmd->base.alt_dest.hop_limit;
+		attr->alt_ah_attr.grh.traffic_class =
+				cmd->base.alt_dest.traffic_class;
+		attr->alt_ah_attr.ah_flags = IB_AH_GRH;
+	} else {
+		attr->alt_ah_attr.ah_flags = 0;
+	}
 	attr->alt_ah_attr.dlid		    = cmd->base.alt_dest.dlid;
 	attr->alt_ah_attr.sl		    = cmd->base.alt_dest.sl;
 	attr->alt_ah_attr.src_path_bits	    = cmd->base.alt_dest.src_path_bits;
 	attr->alt_ah_attr.static_rate	    = cmd->base.alt_dest.static_rate;
-	attr->alt_ah_attr.ah_flags	    = cmd->base.alt_dest.is_global ?
-					      IB_AH_GRH : 0;
 	attr->alt_ah_attr.port_num	    = cmd->base.alt_dest.port_num;
 
 	if (qp->real_qp == qp) {
@@ -2531,14 +2547,18 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	attr.sl 	       = cmd.attr.sl;
 	attr.src_path_bits     = cmd.attr.src_path_bits;
 	attr.static_rate       = cmd.attr.static_rate;
-	attr.ah_flags          = cmd.attr.is_global ? IB_AH_GRH : 0;
 	attr.port_num 	       = cmd.attr.port_num;
-	attr.grh.flow_label    = cmd.attr.grh.flow_label;
-	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
-	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
-	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
-	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
+	if (cmd.attr.is_global) {
+		attr.ah_flags          = IB_AH_GRH;
+		attr.grh.flow_label    = cmd.attr.grh.flow_label;
+		attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
+		attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
+		attr.grh.traffic_class = cmd.attr.grh.traffic_class;
+		memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
+	} else {
+		attr.ah_flags = 0;
+	}
 
 	ah = pd->device->create_ah(pd, &attr, &udata);
 
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index ed3e68f..a9739f3 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -36,17 +36,19 @@
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 			     struct ib_ah_attr *src)
 {
-	memcpy(dst->grh.dgid, src->grh.dgid.raw, sizeof(src->grh.dgid));
-	dst->grh.flow_label        = src->grh.flow_label;
-	dst->grh.sgid_index        = src->grh.sgid_index;
-	dst->grh.hop_limit         = src->grh.hop_limit;
-	dst->grh.traffic_class     = src->grh.traffic_class;
 	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
 	dst->dlid 	    	   = src->dlid;
 	dst->sl   	    	   = src->sl;
 	dst->src_path_bits 	   = src->src_path_bits;
 	dst->static_rate   	   = src->static_rate;
 	dst->is_global             = src->ah_flags & IB_AH_GRH ? 1 : 0;
+	if (dst->is_global) {
+		memcpy(dst->grh.dgid, src->grh.dgid.raw, sizeof(src->grh.dgid));
+		dst->grh.flow_label        = src->grh.flow_label;
+		dst->grh.sgid_index        = src->grh.sgid_index;
+		dst->grh.hop_limit         = src->grh.hop_limit;
+		dst->grh.traffic_class     = src->grh.traffic_class;
+	}
 	dst->port_num 	    	   = src->port_num;
 	dst->reserved 		   = 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
