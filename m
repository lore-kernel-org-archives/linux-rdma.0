From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/opensm] Fix SANodeRecord.nodeInfo.localPortNum
Date: Tue, 1 Mar 2011 17:29:41 -0700
Message-ID: <20110302002941.GA22729@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This value must match the portGUID, so it needs to vary on a per port
basis like portGUID and not simply reflect the value opensm acquired
during the sweep.

Prior to this patch opensm returns the same value for localPortNum for
all ports on a HCA, now it returns the correct localPortNum for the
portGUID.

Also fixes query matching in the same way

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 opensm/opensm/osm_sa_node_record.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

Eg corrected output:
$ ibtool saquery nr nodeInfo.localPortNum=1
NodeRecord dump:
                LID.....................8
                Reserved_16.............0
                Base version............1
                Class version...........1
                node_type...............1
                num_ports...............2
                sys_guid................0002:c903:0000:14a7
                node_guid...............0002:c903:0000:14a4
                port_guid...............0002:c903:0000:14a5
                partition_cap...........128
                device_id...............0x634a
                Revision................0x000000a0
                port_num................1
                vendor_id...............0x0002c9
                NodeDescription.........MT25408 ConnectX Mellanox Technologies

$ ibtool saquery nr nodeInfo.localPortNum=2
NodeRecord dump:
                LID.....................10
                Reserved_16.............0
                Base version............1
                Class version...........1
                node_type...............1
                num_ports...............2
                sys_guid................0002:c903:0000:14a7
                node_guid...............0002:c903:0000:14a4
                port_guid...............0002:c903:0000:14a6
                partition_cap...........128
                device_id...............0x634a
                Revision................0x000000a0
                port_num................2
                vendor_id...............0x0002c9
                NodeDescription.........MT25408 ConnectX Mellanox Technologies

diff --git a/opensm/opensm/osm_sa_node_record.c b/opensm/opensm/osm_sa_node_record.c
index 87f00fd..ff08219 100644
--- a/opensm/opensm/osm_sa_node_record.c
+++ b/opensm/opensm/osm_sa_node_record.c
@@ -70,7 +70,8 @@ typedef struct osm_nr_search_ctxt {
 static ib_api_status_t nr_rcv_new_nr(osm_sa_t * sa,
 				     IN const osm_node_t * p_node,
 				     IN cl_qlist_t * p_list,
-				     IN ib_net64_t port_guid, IN ib_net16_t lid)
+				     IN ib_net64_t port_guid, IN ib_net16_t lid,
+	                             IN unsigned int port_num)
 {
 	osm_nr_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
@@ -97,6 +98,9 @@ static ib_api_status_t nr_rcv_new_nr(osm_sa_t * sa,
 
 	p_rec_item->rec.node_info = p_node->node_info;
 	p_rec_item->rec.node_info.port_guid = port_guid;
+	p_rec_item->rec.node_info.port_num_vendor_id =
+		(p_rec_item->rec.node_info.port_num_vendor_id & IB_NODE_INFO_VEND_ID_MASK) |
+		((port_num << IB_NODE_INFO_PORT_NUM_SHIFT) & IB_NODE_INFO_PORT_NUM_MASK);
 	memcpy(&(p_rec_item->rec.node_desc), &(p_node->node_desc),
 	       IB_NODE_DESCRIPTION_SIZE);
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
@@ -110,6 +114,7 @@ static void nr_rcv_create_nr(IN osm_sa_t * sa, IN osm_node_t * p_node,
 			     IN cl_qlist_t * p_list,
 			     IN ib_net64_t const match_port_guid,
 			     IN ib_net16_t const match_lid,
+			     IN unsigned int const match_port_num,
 			     IN const osm_physp_t * p_req_physp,
 			     IN const ib_net64_t comp_mask)
 {
@@ -173,7 +178,11 @@ static void nr_rcv_create_nr(IN osm_sa_t * sa, IN osm_node_t * p_node,
 				continue;
 		}
 
-		nr_rcv_new_nr(sa, p_node, p_list, port_guid, base_lid);
+		if ((comp_mask & IB_NR_COMPMASK_PORTNUM) &&
+		    (port_num != match_port_num))
+			continue;
+
+		nr_rcv_new_nr(sa, p_node, p_list, port_guid, base_lid, port_num);
 	}
 
 	OSM_LOG_EXIT(sa->p_log);
@@ -189,6 +198,7 @@ static void nr_rcv_by_comp_mask(IN cl_map_item_t * p_map_item, IN void *context)
 	ib_net64_t comp_mask = p_ctxt->comp_mask;
 	ib_net64_t match_port_guid = 0;
 	ib_net16_t match_lid = 0;
+	unsigned int match_port_num = 0;
 
 	OSM_LOG_ENTER(p_ctxt->sa->p_log);
 
@@ -249,10 +259,8 @@ static void nr_rcv_by_comp_mask(IN cl_map_item_t * p_map_item, IN void *context)
 	    p_rcvd_rec->node_info.revision)
 		goto Exit;
 
-	if ((comp_mask & IB_NR_COMPMASK_PORTNUM)  &&
-	    ib_node_info_get_local_port_num(&p_node->node_info) !=
-	    ib_node_info_get_local_port_num(&p_rcvd_rec->node_info))
-		goto Exit;
+	if (comp_mask & IB_NR_COMPMASK_PORTNUM)
+		match_port_num = ib_node_info_get_local_port_num(&p_rcvd_rec->node_info);
 
 	if ((comp_mask & IB_NR_COMPMASK_VENDID) &&
 	    ib_node_info_get_vendor_id(&p_node->node_info) !=
@@ -265,7 +273,7 @@ static void nr_rcv_by_comp_mask(IN cl_map_item_t * p_map_item, IN void *context)
 		goto Exit;
 
 	nr_rcv_create_nr(sa, p_node, p_ctxt->p_list, match_port_guid,
-			 match_lid, p_req_physp, comp_mask);
+			 match_lid, match_port_num, p_req_physp, comp_mask);
 
 Exit:
 	OSM_LOG_EXIT(p_ctxt->sa->p_log);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
