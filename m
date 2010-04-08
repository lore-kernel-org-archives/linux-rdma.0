From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/4] opensm: added function that dumps PathRecords
Date: Thu, 08 Apr 2010 16:29:02 +0300
Message-ID: <4BBDDA1E.7030102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schut <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Dumping SL, MTU and Rate for all the
non-switch-2-non-switch paths in the subnet.

PRs that are dumped:

  for every non-switch source port
      for every non-switch target LID in the subnet
          dump PR between source port and target LID

This way number of sources is equal to number of physical
non-switch ports in the subnet, and only number of targets
depends on LMC that is used.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_sa.h     |   21 +++++++++
 opensm/opensm/osm_sa.c             |   81 ++++++++++++++++++++++++++++++++++++
 opensm/opensm/osm_sa_path_record.c |   12 +++++
 3 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
index d516310..40622ff 100644
--- a/opensm/include/opensm/osm_sa.h
+++ b/opensm/include/opensm/osm_sa.h
@@ -462,6 +462,27 @@ int osm_sa_db_file_load(struct osm_opensm *p_osm);
 *
 *********/

+/****f* OpenSM: SA/osm_sa_path_records_file_dump
+* NAME
+*	osm_sa_path_records_file_dump
+*
+* DESCRIPTION
+*	Dumps the SA Path Records to the dump file.
+*
+* SYNOPSIS
+*/
+int osm_sa_path_records_file_dump(struct osm_opensm *p_osm);
+/*
+* PARAMETERS
+*	p_osm
+*		[in] Pointer to an osm_opensm_t object.
+*
+* RETURN VALUES
+*	 0 on success
+*	!0 if some error occurred.
+*
+*********/
+
 /****f* OpenSM: MC Member Record Receiver/osm_mcmr_rcv_find_or_create_new_mgrp
 * NAME
 *	osm_mcmr_rcv_find_or_create_new_mgrp
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 8aab548..83da258 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -718,6 +718,87 @@ int osm_sa_db_file_dump(osm_opensm_t * p_osm)
 	return res;
 }

+typedef struct _path_parms {
+	ib_net16_t pkey;
+	uint8_t mtu;
+	uint8_t rate;
+	uint8_t sl;
+	uint8_t pkt_life;
+	boolean_t reversible;
+} path_parms_t;
+
+extern ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
+				    IN const osm_port_t * p_src_port,
+				    IN const osm_port_t * p_dest_port,
+				    IN const uint16_t dlid_ho,
+				    OUT path_parms_t * p_parms);
+
+static void sa_dump_path_records(osm_opensm_t * p_osm, FILE * file)
+{
+	osm_port_t *p_src_port;
+	osm_port_t *p_dest_port;
+	osm_node_t *p_node;
+	uint16_t dlid_ho;
+	uint32_t vector_size;
+	osm_physp_t *p_physp;
+	path_parms_t path_parms;
+	ib_api_status_t status;
+
+	vector_size = cl_ptr_vector_get_size(&p_osm->subn.port_lid_tbl);
+	for (p_src_port = (osm_port_t *) cl_qmap_head(&p_osm->subn.port_guid_tbl);
+	     p_src_port != (osm_port_t *) cl_qmap_end(&p_osm->subn.port_guid_tbl);
+	     p_src_port = (osm_port_t *) cl_qmap_next(&p_src_port->map_item)) {
+
+		p_node = p_src_port->p_node;
+		if (p_node->node_info.node_type == IB_NODE_TYPE_SWITCH)
+			return;
+
+		p_physp = p_src_port->p_physp;
+		CL_ASSERT(p_physp->p_remote_physp);
+
+		fprintf(file, "%s 0x%016" PRIx64 ", base LID %d, "
+			"\"%s\", port %d\n# LID  : SL : MTU : RATE\n",
+			ib_get_node_type_str(p_node->node_info.node_type),
+			cl_ntoh64(p_src_port->guid),
+			cl_ntoh16(osm_port_get_base_lid(p_src_port)),
+			p_node->print_desc, p_physp->port_num);
+
+		memset(&path_parms, 0, sizeof(path_parms_t));
+
+		for (dlid_ho = 1; dlid_ho < vector_size; dlid_ho++) {
+
+			p_dest_port = (osm_port_t *) cl_ptr_vector_get(
+				&p_osm->subn.port_lid_tbl, dlid_ho);
+
+			if (!p_dest_port || !p_dest_port->p_node ||
+			    p_dest_port->p_node->node_info.node_type ==
+			    IB_NODE_TYPE_SWITCH)
+			continue;
+
+			status = osm_get_path_params(&p_osm->sa,
+				p_src_port, p_dest_port, dlid_ho,
+				(void*)&path_parms);
+
+			if (!status)
+				fprintf(file, "0x%04X : %-2d : %-3d : %-4d\n",
+					dlid_ho, path_parms.sl,
+					path_parms.mtu, path_parms.rate);
+			else
+				fprintf(file, "0x%04X : UNREACHABLE\n",
+					dlid_ho);
+		}
+		fprintf(file, "\n");
+	}
+}
+
+
+int osm_sa_path_records_file_dump(osm_opensm_t * p_osm)
+{
+	return opensm_dump_to_file(p_osm, p_osm->subn.opt.path_rec_file ?
+		p_osm->subn.opt.path_rec_file : "opensm-path-records.dump",
+		sa_dump_path_records);
+}
+
 /*
  *  SA DB Loader
  */
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index c4c3f86..b168428 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -743,6 +743,18 @@ Exit:
 	return status;
 }

+ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
+				    IN const osm_port_t * p_src_port,
+				    IN const osm_port_t * p_dest_port,
+				    IN const uint16_t dlid_ho,
+				    OUT osm_path_parms_t * p_parms)
+{
+	ib_path_rec_t pr;
+	memset(&pr, 0, sizeof(ib_path_rec_t));
+	return pr_rcv_get_path_parms(sa, &pr,
+		p_src_port, p_dest_port, dlid_ho, 0, p_parms);
+}
+
 static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 			    IN const osm_port_t * p_dest_port,
 			    IN const ib_gid_t * p_dgid,
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
