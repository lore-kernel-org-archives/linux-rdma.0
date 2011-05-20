From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 3/13] opensm: Dump/load SA GUIDInfoRecords
Date: Fri, 20 May 2011 15:50:14 -0400
Message-ID: <4DD6C5F6.8020301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


into port alias guid table

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
In osm_sa.c:load_guidinfo, change continue to break

 opensm/osm_sa.c                 |  146 ++++++++++++++++++++++++++++++++++++++-
 opensm/osm_sa_guidinfo_record.c |    8 ++-
 2 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index bbd1a56..1a53de3 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -680,6 +680,40 @@ static void sa_dump_one_service(cl_list_item_t * p_list_item, void *cxt)
 		p_svcr->modified_time, p_svcr->lease_period);
 }
 
+static void sa_dump_one_port_guidinfo(cl_map_item_t * p_map_item, void *cxt)
+{
+	FILE *file = ((struct opensm_dump_context *)cxt)->file;
+	osm_port_t *p_port = (osm_port_t *) p_map_item;
+	uint32_t max_block;
+	int block_num;
+
+	if (!p_port->p_physp->p_guids)
+		return;
+
+	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
+		     GUID_TABLE_MAX_ENTRIES;
+
+	for (block_num = 0; block_num < max_block; block_num++) {
+		fprintf(file, "GUIDInfo Record:"
+			" base_guid=0x%016" PRIx64 " lid=0x%04x block_num=0x%x"
+			" guid0=0x%016" PRIx64 " guid1=0x%016" PRIx64
+			" guid2=0x%016" PRIx64 " guid3=0x%016" PRIx64
+			" guid4=0x%016" PRIx64 " guid5=0x%016" PRIx64
+			" guid6=0x%016" PRIx64 " guid7=0x%016" PRIx64
+			"\n\n",
+			cl_ntoh64((*p_port->p_physp->p_guids)[0]),
+			cl_ntoh16(osm_port_get_base_lid(p_port)), block_num,
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 1]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 2]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 3]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 4]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 5]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 6]),
+			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 7]));
+	}
+}
+
 static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
 {
 	struct opensm_dump_context dump_context;
@@ -687,8 +721,11 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
 
 	dump_context.p_osm = p_osm;
 	dump_context.file = file;
-	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump multicast\n");
+	OSM_LOG(&p_osm->log, OSM_LOG_ERROR /* DEBUG */, "Dump guidinfo\n");
 	cl_plock_acquire(&p_osm->lock);
+	cl_qmap_apply_func(&p_osm->subn.port_guid_tbl,
+			   sa_dump_one_port_guidinfo, &dump_context);
+	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump multicast\n");
 	for (p_mgrp = (osm_mgrp_t *) cl_fmap_head(&p_osm->subn.mgrp_mgid_tbl);
 	     p_mgrp != (osm_mgrp_t *) cl_fmap_end(&p_osm->subn.mgrp_mgid_tbl);
 	     p_mgrp = (osm_mgrp_t *) cl_fmap_next(&p_mgrp->map_item))
@@ -834,6 +871,81 @@ _out:
 	return ret;
 }
 
+static int load_guidinfo(osm_opensm_t * p_osm, ib_net64_t base_guid,
+			 ib_guidinfo_record_t *gir)
+{
+	osm_port_t *p_port;
+	uint32_t max_block;
+	int i, ret = 0;
+	osm_alias_guid_t *p_alias_guid, *p_alias_guid_check;
+
+	cl_plock_excl_acquire(&p_osm->lock);
+
+	p_port = osm_get_port_by_guid(&p_osm->subn, base_guid);
+	if (!p_port)
+		goto _out;
+
+	if (!p_port->p_physp->p_guids) {
+		max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
+			     GUID_TABLE_MAX_ENTRIES;
+		p_port->p_physp->p_guids = calloc(max_block * GUID_TABLE_MAX_ENTRIES,
+						  sizeof(ib_net64_t));
+		if (!p_port->p_physp->p_guids) {
+			OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
+				"cannot allocate GUID table for port "
+				"GUID 0x%" PRIx64 "\n",
+				cl_ntoh64(p_port->p_physp->port_guid));
+			goto _out;
+		}
+	}
+
+	for (i = 0; i < GUID_TABLE_MAX_ENTRIES; i++) {
+		if (!gir->guid_info.guid[i])
+			continue;
+		/* skip block 0 index 0 */
+		if (gir->block_num == 0 && i == 0)
+			continue;
+		if (gir->block_num * GUID_TABLE_MAX_ENTRIES + i >
+		    p_port->p_physp->port_info.guid_cap)
+			break;
+
+		p_alias_guid = osm_alias_guid_new(gir->guid_info.guid[i],
+						  p_port);
+		if (!p_alias_guid) {
+			OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
+				"Alias guid %d memory allocation failed"
+				" for port GUID 0x%" PRIx64 "\n",
+				gir->block_num * GUID_TABLE_MAX_ENTRIES + i,
+				cl_ntoh64(p_port->p_physp->port_guid));
+			goto _out;
+		}
+
+		p_alias_guid_check =
+			(osm_alias_guid_t *) cl_qmap_insert(&p_osm->subn.alias_port_guid_tbl,
+							    p_alias_guid->alias_guid,
+							    &p_alias_guid->map_item);
+		if (p_alias_guid_check != p_alias_guid) {
+			/* alias GUID is a duplicate */
+			OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
+				"Duplicate alias port GUID 0x%" PRIx64
+				" index %d base port GUID 0x%" PRIx64 "\n",
+				cl_ntoh64(p_alias_guid->alias_guid),
+				gir->block_num * GUID_TABLE_MAX_ENTRIES + i,
+				cl_ntoh64(p_alias_guid->p_base_port->guid));
+			osm_alias_guid_delete(&p_alias_guid);
+			goto _out;
+		}
+	}
+
+	memcpy(&(*p_port->p_physp->p_guids)[gir->block_num * GUID_TABLE_MAX_ENTRIES],
+	       &gir->guid_info, sizeof(ib_guid_info_t));
+
+_out:
+	cl_plock_release(&p_osm->lock);
+
+	return ret;
+}
+
 #define UNPACK_FUNC(name,x) \
 static int unpack_##name##x(char *p, uint##x##_t *val_ptr) \
 { \
@@ -1107,6 +1219,36 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 
 			if (load_infr(p_osm, &i_rec, &rep_addr))
 				rereg_clients = 1;
+		} else if (!strncmp(p, "GUIDInfo Record:", 16)) {
+			ib_guidinfo_record_t gi_rec;
+			ib_net64_t base_guid;
+
+			p_mgrp = NULL;
+			memset(&gi_rec, 0, sizeof(gi_rec));
+
+			PARSE_AHEAD(p, net64, " base_guid=0x", &base_guid);
+			PARSE_AHEAD(p, net16, " lid=0x", &gi_rec.lid);
+			PARSE_AHEAD(p, net8, " block_num=0x",
+				    &gi_rec.block_num);
+			PARSE_AHEAD(p, net64, " guid0=0x",
+				    &gi_rec.guid_info.guid[0]);
+			PARSE_AHEAD(p, net64, " guid1=0x",
+				    &gi_rec.guid_info.guid[1]);
+			PARSE_AHEAD(p, net64, " guid2=0x",
+				    &gi_rec.guid_info.guid[2]);
+			PARSE_AHEAD(p, net64, " guid3=0x",
+				    &gi_rec.guid_info.guid[3]);
+			PARSE_AHEAD(p, net64, " guid4=0x",
+				    &gi_rec.guid_info.guid[4]);
+			PARSE_AHEAD(p, net64, " guid5=0x",
+				    &gi_rec.guid_info.guid[5]);
+			PARSE_AHEAD(p, net64, " guid6=0x",
+				    &gi_rec.guid_info.guid[6]);
+			PARSE_AHEAD(p, net64, " guid7=0x",
+				    &gi_rec.guid_info.guid[7]);
+
+			if (load_guidinfo(p_osm, base_guid, &gi_rec))
+				rereg_clients = 1;
 		}
 	}
 
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 039040b..08f4b2c 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -449,8 +449,10 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 		}
 	}
 
-	if (dirty)
+	if (dirty) {
 		guidinfo_set(sa, p_port, block_num);
+		sa->dirty = TRUE;
+	}
 
 	memcpy(&p_rcvd_rec->guid_info,
 	       &((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
@@ -634,8 +636,10 @@ add_alias_guid:
 		}
 	}
 
-	if (dirty)
+	if (dirty) {
 		guidinfo_set(sa, p_port, block_num);
+		sa->dirty = TRUE;
+	}
 
 	memcpy(&p_rcvd_rec->guid_info,
 	       &((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
