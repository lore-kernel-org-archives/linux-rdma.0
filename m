From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibdiag_common.c: Fix endian conversion in
 resolve_self for umad_port GID prefix and GUID
Date: Thu, 13 Apr 2017 08:24:01 -0400
Message-ID: <976c8c54-4c09-a84b-7a3e-0b3340121985@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


commit 96db7b90 to rdma-core
libibumad: Annotate endianness of second umad_get_ca_portguids() argument

annotated umad_port struct gid_prefix and port_guid fields as __be64
so proper conversion is cl_ntoh64 rather than cl_hton64.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 0fe2190..eda2901 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -608,8 +608,8 @@ int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
 		*portnum = port.portnum;
 	if (gid) {
 		memset(gid, 0, sizeof(*gid));
-		prefix = cl_hton64(port.gid_prefix);
-		guid = cl_hton64(port.port_guid);
+		prefix = cl_ntoh64(port.gid_prefix);
+		guid = cl_ntoh64(port.port_guid);
 		mad_encode_field(*gid, IB_GID_PREFIX_F, &prefix);
 		mad_encode_field(*gid, IB_GID_GUID_F, &guid);
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
