From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [RFC] Add source address binding to iSER
Date: Fri, 2 Jun 2017 13:13:54 -0600
Message-ID: <CAANLjFqUh4rhDKrv9gWQEuPiYUkZJTrpWtgw7kEBayZkRmetfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

First off, I've never done anything this complicated, please be gentle.

Second, I know this will need to be broken up, but I'm not clear if
each commit should be able to compile. It seems having a commit for
each driver would make sense, but it won't compile cleanly without the
others. How do I go about that?

Third, this required a change to the kernel API(?) and I'm not sure
the best way to to make that change backwards compatible.

Forth, I'm getting an error on login. I don't think the kernel is even
trying the login. Maybe I can get a pointer to help me get this
resolved.

# usr/iscsiadm -m iface -I iser3
# BEGIN RECORD 2.0-874
iface.iscsi_ifacename = iser3
iface.net_ifacename = <empty>
iface.ipaddress = fd00::14
...
# usr/iscsiadm -m iface -I iser4
# BEGIN RECORD 2.0-874
iface.iscsi_ifacename = iser4
iface.net_ifacename = <empty>
iface.ipaddress = fd00::114
...
# usr/iscsiadm -m discovery -t st -p fd00::13 -I iser3 -I iser4
[fd00::13]:3260,1 iqn.2016-12.com.betterservers
[fd00::13]:3260,1 iqn.2016-12.com.betterservers
# usr/iscsiadm -m node -T iqn.2016-12.com.betterservers -p [fd00::13]:3260 -l
Logging in to [iface: iser3, target: iqn.2016-12.com.betterservers,
portal: fd00::13,3260] (multiple)
Logging in to [iface: iser4, target: iqn.2016-12.com.betterservers,
portal: fd00::13,3260] (multiple)
iscsiadm: Could not login to [iface: iser3, target:
iqn.2016-12.com.betterservers, portal: fd00::13,3260].
iscsiadm: initiator reported error (12 - iSCSI driver not found.
Please make sure it is loaded, and retry the operation)
iscsiadm: Could not login to [iface: iser4, target:
iqn.2016-12.com.betterservers, portal: fd00::13,3260].
iscsiadm: initiator reported error (12 - iSCSI driver not found.
Please make sure it is loaded, and retry the operation)
iscsiadm: Could not log into all portals

Patch to open-iscsi
----------------------------
diff --git a/usr/netlink.c b/usr/netlink.c
index 1a0bf80..c474375 100644
--- a/usr/netlink.c
+++ b/usr/netlink.c
@@ -848,10 +848,13 @@ krecv_pdu_end(struct iscsi_conn *conn)
 int
 ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
 {
-        int rc, addrlen;
+        int rc, addrlen = sizeof(struct sockaddr_storage);
         struct iscsi_uevent *ev;
-        struct sockaddr *dst_addr = (struct sockaddr *)&conn->saddr;
+        struct sockaddr_storage *dst_addr = (struct sockaddr_storage
*)&conn->saddr;
         struct iovec iov[2];
+        struct iscsi_session *tmp_session = (struct iscsi_session
*)conn->session;
+        node_rec_t *tmp_rec = (node_rec_t *)&tmp_session->nrec;
+        iface_rec_t *tmp_iface = (iface_rec_t *)&tmp_rec->iface;

         log_debug(7, "in %s", __FUNCTION__);

@@ -868,19 +871,16 @@ ktransport_ep_connect(iscsi_conn_t *conn, int
non_blocking)
                 ev->u.ep_connect.non_blocking = non_blocking;
         }

-        if (dst_addr->sa_family == PF_INET)
-                addrlen = sizeof(struct sockaddr_in);
-        else if (dst_addr->sa_family == PF_INET6)
-                addrlen = sizeof(struct sockaddr_in6);
-        else {
+        if (dst_addr->ss_family != AF_INET && dst_addr->ss_family !=
AF_INET6) {
                 log_error("%s unknown addr family %d",
-                         __FUNCTION__, dst_addr->sa_family);
+                         __FUNCTION__, dst_addr->ss_family);
                 return -EINVAL;
         }
         memcpy(setparam_buf + sizeof(*ev), dst_addr, addrlen);
+        iface_copy(setparam_buf + sizeof(*ev) + addrlen, tmp_iface);

         iov[1].iov_base = ev;
-        iov[1].iov_len = sizeof(*ev) + addrlen;
+        iov[1].iov_len = sizeof(*ev) + addrlen + sizeof(iface_rec_t);
         rc = __kipc_call(iov, 2);
         if (rc < 0)
                 return rc;

Patch to kernel
----------------------
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a887ef..7ba5ed9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -59,6 +59,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/inet.h>

 #include <net/sock.h>

@@ -808,12 +809,16 @@ static int iscsi_iser_get_ep_param(struct
iscsi_endpoint *ep,
  *         if fails.
  */
 static struct iscsi_endpoint *
-iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
-                      int non_blocking)
+iscsi_iser_ep_connect(struct Scsi_Host *shost, struct
sockaddr_storage *dst_addr,
+                      int non_blocking, struct iface_rec *iface)
 {
         int err;
         struct iser_conn *iser_conn;
         struct iscsi_endpoint *ep;
+        struct sockaddr_storage src_addr;
+        struct sockaddr_in *tmp_addr;
+        struct sockaddr_in6 *tmp_addr6;
+        memset(&src_addr, 0, sizeof(src_addr));

         ep = iscsi_create_endpoint(0);
         if (!ep)
@@ -828,8 +833,28 @@ static int iscsi_iser_get_ep_param(struct
iscsi_endpoint *ep,
         ep->dd_data = iser_conn;
         iser_conn->ep = ep;
         iser_conn_init(iser_conn);
-
-        err = iser_connect(iser_conn, NULL, dst_addr, non_blocking);
+        if (iface && iface->ipaddress[0]) {
+                if (strchr(iface->ipaddress, ':')) {
+                        tmp_addr6 = (struct sockaddr_in6 *)&src_addr;
+                        tmp_addr6->sin6_family = AF_INET6;
+                        if(!in6_pton(iface->ipaddress, -1,
+                                 tmp_addr6->sin6_addr.s6_addr,
+                                 -1, NULL)) {
+                                err = -EINVAL;
+                                goto failure;
+                        }
+                } else {
+                        tmp_addr = (struct sockaddr_in *)&src_addr;
+                        tmp_addr->sin_family = AF_INET;
+                        if (!in4_pton(iface->ipaddress, -1,
+                                 (u8 *)&tmp_addr->sin_addr.s_addr,
+                                 -1, NULL)) {
+                                err = -EINVAL;
+                                goto failure;
+                        }
+                }
+        }
+        err = iser_connect(iser_conn, &src_addr, dst_addr, non_blocking);
         if (err)
                 goto failure;

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h
b/drivers/infiniband/ulp/iser/iscsi_iser.h
index c1ae4ae..1eda6ff 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -628,8 +628,8 @@ void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
                          enum iser_data_dir dir);

 int  iser_connect(struct iser_conn *iser_conn,
-                  struct sockaddr *src_addr,
-                  struct sockaddr *dst_addr,
+                  struct sockaddr_storage *src_addr,
+                  struct sockaddr_storage *dst_addr,
                   int non_blocking);

 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c
b/drivers/infiniband/ulp/iser/iser_initiator.c
index 12ed62c..361d5e4 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/kfifo.h>
+#include <linux/if.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c
b/drivers/infiniband/ulp/iser/iser_memory.c
index 9c3e9ab..c9d95b9 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -36,6 +36,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
+#include <linux/if.h>

 #include "iscsi_iser.h"
 static
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c
b/drivers/infiniband/ulp/iser/iser_verbs.c
index c538a38..0a43009 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/if.h>

 #include "iscsi_iser.h"

@@ -941,8 +942,8 @@ void iser_conn_init(struct iser_conn *iser_conn)
  * sleeps until the connection is established or rejected
  */
 int iser_connect(struct iser_conn   *iser_conn,
-                 struct sockaddr    *src_addr,
-                 struct sockaddr    *dst_addr,
+                 struct sockaddr_storage *src_addr,
+                 struct sockaddr_storage *dst_addr,
                  int                 non_blocking)
 {
         struct ib_conn *ib_conn = &iser_conn->ib_conn;
@@ -968,7 +969,8 @@ int iser_connect(struct iser_conn   *iser_conn,
                 goto id_failure;
         }

-        err = rdma_resolve_addr(ib_conn->cma_id, src_addr, dst_addr, 1000);
+        err = rdma_resolve_addr(ib_conn->cma_id, (struct sockaddr *)src_addr,
+                                       (struct sockaddr *)dst_addr, 1000);
         if (err) {
                 iser_err("rdma_resolve_addr failed: %d\n", err);
                 goto addr_failure;
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index a79a5e7..6617f2a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -13,6 +13,7 @@
  */

 #include <scsi/iscsi_proto.h>
+#include <linux/if.h>

 #include "be_main.h"
 #include "be.h"
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 97dca46..90adf20 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -12,6 +12,7 @@
  *
  */

+#include <linux/if.h>
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/scsi_transport.h>
@@ -1161,8 +1162,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
  * This routines first asks chip to create a connection and then
allocates an EP
  */
 struct iscsi_endpoint *
-beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
-                   int non_blocking)
+beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
+                   int non_blocking, struct iface_rec *iface)
 {
         struct beiscsi_hba *phba;
         struct beiscsi_endpoint *beiscsi_ep;
@@ -1198,7 +1199,8 @@ struct iscsi_endpoint *
         beiscsi_ep = ep->dd_data;
         beiscsi_ep->phba = phba;
         beiscsi_ep->openiscsi_ep = ep;
-        ret = beiscsi_open_conn(ep, NULL, dst_addr, non_blocking);
+        ret = beiscsi_open_conn(ep, NULL, (struct sockaddr *)dst_addr,
+                                       non_blocking);
         if (ret) {
                 beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
                             "BS_%d : Failed in beiscsi_open_conn\n");
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index b9d459a..68616f8 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -68,8 +68,9 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn);

 struct iscsi_endpoint *beiscsi_ep_connect(struct Scsi_Host *shost,
-                                          struct sockaddr *dst_addr,
-                                          int non_blocking);
+                                          struct sockaddr_storage *dst_addr,
+                                          int non_blocking,
+                                          struct iface_rec *iface);

 int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f862332..aab7772 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/bsg-lib.h>
 #include <linux/irq_poll.h>
+#include <linux/if.h>

 #include <scsi/libiscsi.h>
 #include <scsi/scsi_bsg_iscsi.h>
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index c737753..926afa4 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -13,6 +13,7 @@
  */

 #include <linux/bsg-lib.h>
+#include <linux/if.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/scsi_bsg_iscsi.h>
 #include "be_mgmt.h"
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 42921db..ce87ce2 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -15,6 +15,7 @@
  */

 #include <linux/gfp.h>
+#include <linux/if.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libiscsi.h>
 #include "bnx2i.h"
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f32a66f..5151063 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -16,8 +16,10 @@
  */

 #include <linux/slab.h>
+#include <linux/if.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libiscsi.h>
+#include <scsi/scsi_transport_iscsi.h>
 #include "bnx2i.h"

 struct scsi_transport_template *bnx2i_scsi_xport_template;
@@ -1771,8 +1773,9 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
  *        sending down option-2 request to complete TCP 3-way handshake
  */
 static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
-                                               struct sockaddr *dst_addr,
-                                               int non_blocking)
+                                               struct
sockaddr_storage *dst_addr,
+                                               int non_blocking,
+                                               struct iface_rec *iface)
 {
         u32 iscsi_cid = BNX2I_CID_RESERVED;
         struct sockaddr_in *desti = (struct sockaddr_in *) dst_addr;
@@ -1792,7 +1795,7 @@ static struct iscsi_endpoint
*bnx2i_ep_connect(struct Scsi_Host *shost,
                  * check if the given destination can be reached through
                  * a iscsi capable NetXtreme2 device
                  */
-                hba = bnx2i_check_route(dst_addr);
+                hba = bnx2i_check_route((struct sockaddr *)dst_addr);

         if (!hba) {
                 rc = -EINVAL;
@@ -1887,11 +1890,11 @@ static struct iscsi_endpoint
*bnx2i_ep_connect(struct Scsi_Host *shost,
         clear_bit(SK_TCP_TIMESTAMP, &bnx2i_ep->cm_sk->tcp_flags);

         memset(&saddr, 0, sizeof(saddr));
-        if (dst_addr->sa_family == AF_INET) {
+        if (dst_addr->ss_family == AF_INET) {
                 desti = (struct sockaddr_in *) dst_addr;
                 saddr.remote.v4 = *desti;
                 saddr.local.v4.sin_family = desti->sin_family;
-        } else if (dst_addr->sa_family == AF_INET6) {
+        } else if (dst_addr->ss_family == AF_INET6) {
                 desti6 = (struct sockaddr_in6 *) dst_addr;
                 saddr.remote.v6 = *desti6;
                 saddr.local.v6.sin6_family = desti6->sin6_family;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39e..62f6230 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2499,8 +2499,9 @@ int cxgbi_get_host_param(struct Scsi_Host
*shost, enum iscsi_host_param param,
 EXPORT_SYMBOL_GPL(cxgbi_get_host_param);

 struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
-                                        struct sockaddr *dst_addr,
-                                        int non_blocking)
+                                        struct sockaddr_storage *dst_addr,
+                                        int non_blocking,
+                                        struct iface_rec *iface)
 {
         struct iscsi_endpoint *ep;
         struct cxgbi_endpoint *cep;
@@ -2520,15 +2521,15 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct
Scsi_Host *shost,
                 }
         }

-        if (dst_addr->sa_family == AF_INET) {
-                csk = cxgbi_check_route(dst_addr);
+        if (dst_addr->ss_family == AF_INET) {
+                csk = cxgbi_check_route((struct sockaddr *)dst_addr);
 #if IS_ENABLED(CONFIG_IPV6)
-        } else if (dst_addr->sa_family == AF_INET6) {
-                csk = cxgbi_check_route6(dst_addr);
+        } else if (dst_addr->ss_family == AF_INET6) {
+                csk = cxgbi_check_route6((struct sockaddr *)dst_addr);
 #endif
         } else {
                 pr_info("address family 0x%x NOT supported.\n",
-                        dst_addr->sa_family);
+                        dst_addr->ss_family);
                 err = -EAFNOSUPPORT;
                 return (struct iscsi_endpoint *)ERR_PTR(err);
         }
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 18e0ea8..e2e0c4d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -596,7 +596,7 @@ int cxgbi_set_host_param(struct Scsi_Host *,
                         enum iscsi_host_param, char *, int);
 int cxgbi_get_host_param(struct Scsi_Host *, enum iscsi_host_param, char *);
 struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *,
-                        struct sockaddr *, int);
+                        struct sockaddr_storage *, int, struct iface_rec *);
 int cxgbi_ep_poll(struct iscsi_endpoint *, int);
 void cxgbi_ep_disconnect(struct iscsi_endpoint *);

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa5..4fccb58 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -119,8 +119,9 @@ static int qla4xxx_get_iface_param(struct
iscsi_iface *iface,
                                    int param, char *buf);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 static struct iscsi_endpoint *qla4xxx_ep_connect(struct Scsi_Host *shost,
-                                                 struct sockaddr *dst_addr,
-                                                 int non_blocking);
+                                                 struct
sockaddr_storage *dst_addr,
+                                                 int non_blocking,
+                                                 struct iface_rec *iface);
 static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
 static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep);
 static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
@@ -1656,8 +1657,8 @@ static int qla4xxx_get_iface_param(struct
iscsi_iface *iface,
 }

 static struct iscsi_endpoint *
-qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
-                   int non_blocking)
+qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
+                   int non_blocking, struct iface_rec *iface)
 {
         int ret;
         struct iscsi_endpoint *ep;
@@ -1681,12 +1682,12 @@ static int qla4xxx_get_iface_param(struct
iscsi_iface *iface,

         qla_ep = ep->dd_data;
         memset(qla_ep, 0, sizeof(struct qla_endpoint));
-        if (dst_addr->sa_family == AF_INET) {
+        if (dst_addr->ss_family == AF_INET) {
                 memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct
sockaddr_in));
                 addr = (struct sockaddr_in *)&qla_ep->dst_addr;
                 DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
                                   (char *)&addr->sin_addr));
-        } else if (dst_addr->sa_family == AF_INET6) {
+        } else if (dst_addr->ss_family == AF_INET6) {
                 memcpy(&qla_ep->dst_addr, dst_addr,
                        sizeof(struct sockaddr_in6));
                 addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
@@ -6569,7 +6570,7 @@ static struct iscsi_endpoint
*qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
                 addr->sin_port = htons(le16_to_cpu(fw_ddb_entry->port));
         }

-        ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
+        ep = qla4xxx_ep_connect(ha->host, dst_addr, 0, NULL);
         vfree(dst_addr);
         return ep;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c
b/drivers/scsi/scsi_transport_iscsi.c
index a424eae..64157a1 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -34,6 +34,7 @@
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_bsg_iscsi.h>
+#include <linux/inet.h>

 #define ISCSI_TRANSPORT_VERSION "2.0-870"

@@ -2794,7 +2795,8 @@ static int iscsi_if_ep_connect(struct
iscsi_transport *transport,
                                struct iscsi_uevent *ev, int msg_type)
 {
         struct iscsi_endpoint *ep;
-        struct sockaddr *dst_addr;
+        struct sockaddr_storage *dst_addr;
+        struct iface_rec *iface;
         struct Scsi_Host *shost = NULL;
         int non_blocking, err = 0;

@@ -2813,8 +2815,9 @@ static int iscsi_if_ep_connect(struct
iscsi_transport *transport,
         } else
                 non_blocking = ev->u.ep_connect.non_blocking;

-        dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-        ep = transport->ep_connect(shost, dst_addr, non_blocking);
+        dst_addr = (struct sockaddr_storage *)((char*)ev + sizeof(*ev));
+        iface = (struct iface_rec *)((char*)ev + sizeof(*ev) +
sizeof(*dst_addr));
+        ep = transport->ep_connect(shost, dst_addr, non_blocking, iface);
         if (IS_ERR(ep)) {
                 err = PTR_ERR(ep);
                 goto release_host;
diff --git a/include/scsi/scsi_transport_iscsi.h
b/include/scsi/scsi_transport_iscsi.h
index 6183d20..c146e90 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -37,6 +37,7 @@
 struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
+struct iface_rec;
 struct iscsi_iface;
 struct bsg_job;
 struct iscsi_bus_flash_session;
@@ -132,8 +133,9 @@ struct iscsi_transport {

         void (*session_recovery_timedout) (struct iscsi_cls_session *session);
         struct iscsi_endpoint *(*ep_connect) (struct Scsi_Host *shost,
-                                              struct sockaddr *dst_addr,
-                                              int non_blocking);
+                                              struct sockaddr_storage
*dst_addr,
+                                              int non_blocking,
+                                              struct iface_rec *iface);
         int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
         void (*ep_disconnect) (struct iscsi_endpoint *ep);
         int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
@@ -291,6 +293,100 @@ struct iscsi_endpoint {
         struct iscsi_cls_conn *conn;
 };

+/* max len of interface */
+#define ISCSI_MAX_IFACE_LEN        65
+#define NI_MAXHOST 1025
+#define ISCSI_HWADDRESS_BUF_SIZE 18
+#define ISCSI_TRANSPORT_NAME_MAXLEN 16
+#define ISCSI_MAX_STR_LEN 80
+
+struct iface_rec {
+        struct list_head        list;
+        /* iscsi iface record name */
+        char                        name[ISCSI_MAX_IFACE_LEN];
+        uint32_t                iface_num;
+        /* network layer iface name (eth0) */
+        char                        netdev[IFNAMSIZ];
+        char                        ipaddress[NI_MAXHOST];
+        char                        subnet_mask[NI_MAXHOST];
+        char                        gateway[NI_MAXHOST];
+        char                        bootproto[ISCSI_MAX_STR_LEN];
+        char                        ipv6_linklocal[NI_MAXHOST];
+        char                        ipv6_router[NI_MAXHOST];
+        char                        ipv6_autocfg[NI_MAXHOST];
+        char                        linklocal_autocfg[NI_MAXHOST];
+        char                        router_autocfg[NI_MAXHOST];
+        uint16_t                vlan_id;
+        uint8_t                        vlan_priority;
+        char                        vlan_state[ISCSI_MAX_STR_LEN];
+        char                        state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
+                                                           * 1 = enable */
+        uint16_t                mtu;
+        uint16_t                port;
+        char                        delayed_ack[ISCSI_MAX_STR_LEN];
+        char                        nagle[ISCSI_MAX_STR_LEN];
+        char                        tcp_wsf_state[ISCSI_MAX_STR_LEN];
+        uint8_t                        tcp_wsf;
+        uint8_t                        tcp_timer_scale;
+        char                        tcp_timestamp[ISCSI_MAX_STR_LEN];
+        char                        dhcp_dns[ISCSI_MAX_STR_LEN];
+        char                        dhcp_slp_da[ISCSI_MAX_STR_LEN];
+        char                        tos_state[ISCSI_MAX_STR_LEN];
+        uint8_t                        tos;
+        char                        gratuitous_arp[ISCSI_MAX_STR_LEN];
+        char
dhcp_alt_client_id_state[ISCSI_MAX_STR_LEN];
+        char                        dhcp_alt_client_id[ISCSI_MAX_STR_LEN];
+        char
dhcp_req_vendor_id_state[ISCSI_MAX_STR_LEN];
+        char                        dhcp_vendor_id_state[ISCSI_MAX_STR_LEN];
+        char                        dhcp_vendor_id[ISCSI_MAX_STR_LEN];
+        char                        dhcp_learn_iqn[ISCSI_MAX_STR_LEN];
+        char                        fragmentation[ISCSI_MAX_STR_LEN];
+        char                        incoming_forwarding[ISCSI_MAX_STR_LEN];
+        uint8_t                        ttl;
+        char                        gratuitous_neighbor_adv[ISCSI_MAX_STR_LEN];
+        char                        redirect[ISCSI_MAX_STR_LEN];
+        char                        mld[ISCSI_MAX_STR_LEN];
+        uint32_t                flow_label;
+        uint32_t                traffic_class;
+        uint8_t                        hop_limit;
+        uint32_t                nd_reachable_tmo;
+        uint32_t                nd_rexmit_time;
+        uint32_t                nd_stale_tmo;
+        uint8_t                        dup_addr_detect_cnt;
+        uint32_t                router_adv_link_mtu;
+        uint16_t                def_task_mgmt_tmo;
+        char                        header_digest[ISCSI_MAX_STR_LEN];
+        char                        data_digest[ISCSI_MAX_STR_LEN];
+        char                        immediate_data[ISCSI_MAX_STR_LEN];
+        char                        initial_r2t[ISCSI_MAX_STR_LEN];
+        char                        data_seq_inorder[ISCSI_MAX_STR_LEN];
+        char                        data_pdu_inorder[ISCSI_MAX_STR_LEN];
+        uint8_t                        erl;
+        uint32_t                max_recv_dlength;
+        uint32_t                first_burst_len;
+        uint16_t                max_out_r2t;
+        uint32_t                max_burst_len;
+        char                        chap_auth[ISCSI_MAX_STR_LEN];
+        char                        bidi_chap[ISCSI_MAX_STR_LEN];
+        char                        strict_login_comp[ISCSI_MAX_STR_LEN];
+        char                        discovery_auth[ISCSI_MAX_STR_LEN];
+        char                        discovery_logout[ISCSI_MAX_STR_LEN];
+        char                        port_state[ISCSI_MAX_STR_LEN];
+        char                        port_speed[ISCSI_MAX_STR_LEN];
+        /*
+         * TODO: we may have to make this bigger and interconnect
+         * specific for infiniband
+         */
+        char                        hwaddress[ISCSI_HWADDRESS_BUF_SIZE];
+        char
transport_name[ISCSI_TRANSPORT_NAME_MAXLEN];
+        /*
+         * This is only used for boot now, but the iser guys
+         * can use this for their virtualization idea.
+         */
+        char                        alias[TARGET_NAME_MAXLEN + 1];
+        char                        iname[TARGET_NAME_MAXLEN + 1];
+};
+
 struct iscsi_iface {
         struct device dev;
         struct iscsi_transport *transport;

Thank you,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
