From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_port: Add infrastructure for alias GUID support
Date: Mon, 11 Apr 2011 11:00:17 -0400
Message-ID: <4DA31781.7070606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


alias GUIDs are those indicated in SM GUIDInfo attribute
(other than index 0) and are created/removed via SA Set/Delete
of GUIDInfoRecord per IBTA MgtWG errata RefIDs 4704-4706.

Up to now, this attribute was unneeded by the SM as only base port
GUIDs were supported (and are available from the SM NodeInfo attribute).

In order to support alias GUIDs, a new alias GUID table is to be added
indexed by alias GUID, each containing a pointer to the base port. The
routines for creating and removing alias GUID table entries are added
by this patch. Also, a pointer to the alias port GUIDs provided by the
SM GUIDInfo attribute is added to the osm_physp_t structure.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index ee9feec..3433e31 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -105,6 +105,7 @@ struct osm_mgrp;
 typedef struct osm_physp {
 	ib_port_info_t port_info;
 	ib_net64_t port_guid;
+	ib_net64_t (*p_guids)[];
 	uint8_t port_num;
 	struct osm_node *p_node;
 	struct osm_physp *p_remote_physp;
@@ -127,6 +128,11 @@ typedef struct osm_physp {
 *		Port GUID value of this port.  For switches,
 *		all ports share the same GUID value.
 *
+*	p_guids
+*		Pointer to array of GUIDs obtained from GUIDInfo.
+*		This pointer is null for switch physical/external ports
+*		(used for endports only).
+*
 *	port_num
 *		The port number of this port.  The PortInfo also
 *		contains a port_number, but that number is not
@@ -1456,5 +1462,92 @@ osm_physp_replace_dr_path_with_alternate_dr_path(IN osm_log_t * p_log,
 *	PhysPort object
 *********/
 
+/****s* OpenSM: Port/osm_alias_guid_t
+* NAME
+*	osm_alias_guid_t
+*
+* DESCRIPTION
+*	This object represents an alias guid for an endport.
+*
+*	The osm_alias_guid_t object should be treated as opaque and should
+*	be manipulated only through the provided functions.
+*
+* SYNOPSIS
+*/
+typedef struct osm_alias_guid {
+	cl_map_item_t map_item;
+	ib_net64_t alias_guid;
+	osm_port_t *p_base_port;
+} osm_alias_guid_t;
+/*
+* FIELDS
+*	map_item
+*		Linkage structure for cl_qmap.  MUST BE FIRST MEMBER!
+*
+*	alias_guid
+*		Alias GUID for port obtained from SM GUIDInfo attribute
+*
+*	p_base_port
+*		Pointer to osm_port_t for base port GUID
+*
+* SEE ALSO
+*	Port, Physical Port, Physical Port Table
+*/
+
+/****f* OpenSM: Port/osm_alias_guid_new
+* NAME
+*	osm_alias_guid_new
+*
+* DESCRIPTION
+*	This function allocates and initializes an alias guid object.
+*
+* SYNOPSIS
+*/
+osm_alias_guid_t *osm_alias_guid_new(IN const ib_net64_t alias_guid,
+				     IN osm_port_t *p_base_port);
+/*
+* PARAMETERS
+*	alias_guid
+*		[in] Alias GUID in network order
+*
+*	p_base_port
+*		[in] Pointer to the port for this base GUID
+*
+* RETURN VALUE
+*	Pointer to the initialized alias guid object.
+*
+* NOTES
+*	Allows calling other alias guid methods.
+*
+* SEE ALSO
+*	Port
+*********/
+
+/****f* OpenSM: Port/osm_alias_guid_delete
+* NAME
+*	osm_alias_guid_delete
+*
+* DESCRIPTION
+*	This function destroys and deallocates an alias guid object.
+*
+* SYNOPSIS
+*/
+void osm_alias_guid_delete(IN OUT osm_alias_guid_t ** pp_alias_guid);
+/*
+* PARAMETERS
+*	pp_alias_guid
+*		[in][out] Pointer to a pointer to an alias guid object to delete.
+*		On return, this pointer is NULL.
+*
+* RETURN VALUE
+*	This function does not return a value.
+*
+* NOTES
+*	Performs any necessary cleanup of the specified alias guid object.
+*
+* SEE ALSO
+*	Port
+*********/
+
 END_C_DECLS
 #endif				/* _OSM_PORT_H_ */
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index 98b67b4..9c94719 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -67,6 +67,9 @@ void osm_physp_destroy(IN osm_physp_t * p_physp)
 
 	/* the physp might be uninitialized */
 	if (p_physp->port_guid) {
+		if (p_physp->p_guids)
+			free(p_physp->p_guids);
+
 		/* free the SL2VL Tables */
 		num_slvl = cl_ptr_vector_get_size(&p_physp->slvl_by_port);
 		for (i = 0; i < num_slvl; i++)
@@ -632,3 +635,22 @@ void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 
 	osm_pkey_tbl_set(&p_physp->pkeys, block_num, p_pkey_tbl);
 }
+
+osm_alias_guid_t *osm_alias_guid_new(IN const ib_net64_t alias_guid,
+				     IN osm_port_t *p_base_port)
+{
+	osm_alias_guid_t *p_alias_guid;
+
+	p_alias_guid = calloc(1, sizeof(*p_alias_guid));
+	if (p_alias_guid) {
+		p_alias_guid->alias_guid = alias_guid;
+		p_alias_guid->p_base_port = p_base_port;
+	}
+	return p_alias_guid;
+}
+
+void osm_alias_guid_delete(IN OUT osm_alias_guid_t ** pp_alias_guid)
+{
+	free(*pp_alias_guid);
+	*pp_alias_guid = NULL;
+}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
