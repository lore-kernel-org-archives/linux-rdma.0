From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: iboe - address resolution in userspace
Date: Thu, 29 Jul 2010 20:09:31 +0300
Message-ID: <1280423371.16125.30.camel@mtldesk30>
Reply-To: eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland, 

This is the userspace patch implementing the outcome of the email
discussions about address resolution conducted over the last couple of
weeks.
We are planning to submit the full patch series based on your iboe
branch within the next few days with the hope that this can be pushed
upstream for 2.6.36.


>From ff1c4c562f91082126d53297e316437026fb8ac0 Mon Sep 17 00:00:00 2001
From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date: Wed, 28 Jul 2010 18:07:45 +0300
Subject: [PATCH] libibverbs: Add API to resolve GID to L2 address

Add a new API, resolve_eth_ll_gid(), which resolves a GID to layer 2 address
information. The GID resembles an IPv6 link local address and encodes the MAC
address and the VLAN tag within it. The function accepts the destination GID,
port number and source GID index and returns the MAC VLAN and indications
whether the remote address is tagged VLAN and whether the address is multicast.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/infiniband/driver.h |    7 ++++
 src/verbs.c                 |   78 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..be4ec98 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -37,6 +37,8 @@
 
 #include <infiniband/verbs.h>
 #include <infiniband/kern-abi.h>
+#include <arpa/inet.h>
+#include <string.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -143,4 +145,9 @@ const char *ibv_get_sysfs_path(void);
 int ibv_read_sysfs_file(const char *dir, const char *file,
 			char *buf, size_t size);
 
+int resolve_eth_gid(struct ibv_pd *pd, uint8_t port_num,
+		    union ibv_gid *dgid, uint8_t sgid_index,
+		    uint8_t mac[], uint16_t *vlan, uint8_t *tagged,
+		    uint8_t *is_mcast);
+
 #endif /* INFINIBAND_DRIVER_H */
diff --git a/src/verbs.c b/src/verbs.c
index ba3c0a4..a04e92f 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -148,6 +148,7 @@ struct ibv_pd *__ibv_alloc_pd(struct ibv_context *context)
 }
 default_symver(__ibv_alloc_pd, ibv_alloc_pd);
 
+
 int __ibv_dealloc_pd(struct ibv_pd *pd)
 {
 	return pd->context->ops.dealloc_pd(pd);
@@ -543,3 +544,80 @@ int __ibv_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid
 	return qp->context->ops.detach_mcast(qp, gid, lid);
 }
 default_symver(__ibv_detach_mcast, ibv_detach_mcast);
+
+static uint16_t get_vlan_id(union ibv_gid *dgid)
+{
+	uint16_t vid;
+
+	vid = dgid->raw[11] << 8 | dgid->raw[12];
+	return vid == 0xfffe ? 0 : vid  & 0xfff;
+}
+
+static void get_ll_mac(union ibv_gid *gid, uint8_t *mac)
+{
+	memcpy(mac, &gid->raw[8], 3);
+	memcpy(mac + 3, &gid->raw[13], 3);
+	mac[0] ^= 2;
+}
+
+static int is_multicast_gid(union ibv_gid *gid)
+{
+	return gid->raw[0] == 0xff ? 1 : 0;
+}
+
+static void get_mcast_mac(union ibv_gid *gid, uint8_t *mac)
+{
+	int i;
+
+	mac[0] = 0x33;
+	mac[1] = 0x33;
+	for (i = 2; i < 6; ++i)
+		mac[i] = gid->raw[i + 10];
+}
+
+static int is_link_local_gid(union ibv_gid *gid)
+{
+	uint32_t hi = *(uint32_t *)(gid->raw);
+	uint32_t lo = *(uint32_t *)(gid->raw + 4);
+	if (hi == htonl(0xfe800000) && lo == 0)
+		return 1;
+
+	return 0;
+}
+
+static int resolve_grh(union ibv_gid *dgid, uint8_t *mac, uint8_t *is_mcast)
+{
+	if (is_link_local_gid(dgid))
+		get_ll_mac(dgid, mac);
+	else if (is_multicast_gid(dgid)) {
+		get_mcast_mac(dgid, mac);
+		*is_mcast = 1;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+int __resolve_eth_gid(struct ibv_pd *pd, uint8_t port_num,
+		      union ibv_gid *dgid, uint8_t sgid_index,
+		      uint8_t mac[], uint16_t *vlan, uint8_t *tagged,
+		      uint8_t *is_mcast)
+{
+	int err;
+	union ibv_gid sgid;
+
+	err = resolve_grh(dgid, mac, is_mcast);
+	if (err)
+		return err;
+
+	err = ibv_query_gid(pd->context, port_num, sgid_index, &sgid);
+	if (err)
+		return err;
+
+	*vlan = get_vlan_id(&sgid);
+	*tagged = *vlan;
+
+	return 0;
+}
+default_symver(__resolve_eth_gid, resolve_eth_gid);
+
-- 
1.7.2



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
