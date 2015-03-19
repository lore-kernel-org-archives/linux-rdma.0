From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH RFC] IB/verbs: introduce rdma_transport_is_ib() to check transport
 type
Date: Thu, 19 Mar 2015 14:44:54 +0100
Message-ID: <550AD2D6.7030800@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have plenty of places where we don't care what exactly the
transport type is, but only care if it's IB type.

This patch introduce rdma_transport_is_ib() as shortcuts to check
whether an 'ib_device' is infiniband transport type, which help us to
save some code.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
  drivers/infiniband/core/cm.c              |  2 +-
  drivers/infiniband/core/cma.c             | 15 +++++++--------
  drivers/infiniband/core/mad.c             |  4 ++--
  drivers/infiniband/core/multicast.c       |  2 +-
  drivers/infiniband/core/sa_query.c        |  2 +-
  drivers/infiniband/core/ucm.c             |  3 +--
  drivers/infiniband/core/user_mad.c        |  2 +-
  drivers/infiniband/ulp/ipoib/ipoib_main.c |  4 ++--
  include/rdma/ib_verbs.h                   |  5 +++++
  9 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..2c72e9e 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3762,7 +3762,7 @@ static void cm_add_one(struct ib_device *ib_device)
      int ret;
      u8 i;

-    if (rdma_node_get_transport(ib_device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(ib_device))
          return;

      cm_dev = kzalloc(sizeof(*cm_dev) + sizeof(*port) *
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..cc2b261 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -375,7 +375,7 @@ static int cma_acquire_dev(struct rdma_id_private 
*id_priv,
                       listen_id_priv->id.port_num) == dev_ll) {
          cma_dev = listen_id_priv->cma_dev;
          port = listen_id_priv->id.port_num;
-        if (rdma_node_get_transport(cma_dev->device->node_type) == 
RDMA_TRANSPORT_IB &&
+        if (rdma_transport_is_ib(cma_dev->device) &&
              rdma_port_get_link_layer(cma_dev->device, port) == 
IB_LINK_LAYER_ETHERNET)
              ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
                           &found_port, NULL);
@@ -395,7 +395,7 @@ static int cma_acquire_dev(struct rdma_id_private 
*id_priv,
                  listen_id_priv->id.port_num == port)
                  continue;
              if (rdma_port_get_link_layer(cma_dev->device, port) == 
dev_ll) {
-                if (rdma_node_get_transport(cma_dev->device->node_type) 
== RDMA_TRANSPORT_IB &&
+                if (rdma_transport_is_ib(cma_dev->device) &&
                      rdma_port_get_link_layer(cma_dev->device, port) == 
IB_LINK_LAYER_ETHERNET)
                      ret = ib_find_cached_gid(cma_dev->device, 
&iboe_gid, &found_port, NULL);
                  else
@@ -435,7 +435,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private 
*id_priv)
      pkey = ntohs(addr->sib_pkey);

      list_for_each_entry(cur_dev, &dev_list, list) {
-        if (rdma_node_get_transport(cur_dev->device->node_type) != 
RDMA_TRANSPORT_IB)
+        if (!rdma_transport_is_ib(cur_dev->device))
              continue;

          for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
@@ -633,8 +633,7 @@ static int cma_modify_qp_rtr(struct rdma_id_private 
*id_priv,
      if (ret)
          goto out;

-    if (rdma_node_get_transport(id_priv->cma_dev->device->node_type)
-        == RDMA_TRANSPORT_IB &&
+    if (rdma_transport_is_ib(id_priv->cma_dev->device) &&
          rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)
          == IB_LINK_LAYER_ETHERNET) {
          ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac, NULL);
@@ -1626,7 +1625,7 @@ static void cma_listen_on_dev(struct 
rdma_id_private *id_priv,
      int ret;

      if (cma_family(id_priv) == AF_IB &&
-        rdma_node_get_transport(cma_dev->device->node_type) != 
RDMA_TRANSPORT_IB)
+        !rdma_transport_is_ib(cma_dev->device))
          return;

      id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
@@ -2028,7 +2027,7 @@ static int cma_bind_loopback(struct 
rdma_id_private *id_priv)
      mutex_lock(&lock);
      list_for_each_entry(cur_dev, &dev_list, list) {
          if (cma_family(id_priv) == AF_IB &&
- rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
+            !rdma_transport_is_ib(cur_dev->device))
              continue;

          if (!cma_dev)
@@ -3405,7 +3404,7 @@ void rdma_leave_multicast(struct rdma_cm_id *id, 
struct sockaddr *addr)
                  ib_detach_mcast(id->qp,
                          &mc->multicast.ib->rec.mgid,
  be16_to_cpu(mc->multicast.ib->rec.mlid));
-            if 
(rdma_node_get_transport(id_priv->cma_dev->device->node_type) == 
RDMA_TRANSPORT_IB) {
+            if (rdma_transport_is_ib(id_priv->cma_dev->device)) {
                  switch (rdma_port_get_link_layer(id->device, 
id->port_num)) {
                  case IB_LINK_LAYER_INFINIBAND:
                      ib_sa_free_multicast(mc->multicast.ib);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 74c30f4..dd51b37 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3057,7 +3057,7 @@ static void ib_mad_init_device(struct ib_device 
*device)
  {
      int start, end, i;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      if (device->node_type == RDMA_NODE_IB_SWITCH) {
@@ -3102,7 +3102,7 @@ static void ib_mad_remove_device(struct ib_device 
*device)
  {
      int i, num_ports, cur_port;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      if (device->node_type == RDMA_NODE_IB_SWITCH) {
diff --git a/drivers/infiniband/core/multicast.c 
b/drivers/infiniband/core/multicast.c
index fa17b55..bdda79f 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -808,7 +808,7 @@ static void mcast_add_one(struct ib_device *device)
      int i;
      int count = 0;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      dev = kmalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
diff --git a/drivers/infiniband/core/sa_query.c 
b/drivers/infiniband/core/sa_query.c
index c38f030..ce82861 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1154,7 +1154,7 @@ static void ib_sa_add_one(struct ib_device *device)
      struct ib_sa_device *sa_dev;
      int s, e, i;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      if (device->node_type == RDMA_NODE_IB_SWITCH)
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f2f6393..ddbe0b4 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1253,8 +1253,7 @@ static void ib_ucm_add_one(struct ib_device *device)
      dev_t base;
      struct ib_ucm_device *ucm_dev;

-    if (!device->alloc_ucontext ||
-        rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!device->alloc_ucontext || !rdma_transport_is_ib(device))
          return;

      ucm_dev = kzalloc(sizeof *ucm_dev, GFP_KERNEL);
diff --git a/drivers/infiniband/core/user_mad.c 
b/drivers/infiniband/core/user_mad.c
index 928cdd2..28a8b30 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1274,7 +1274,7 @@ static void ib_umad_add_one(struct ib_device *device)
      struct ib_umad_device *umad_dev;
      int s, e, i;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      if (device->node_type == RDMA_NODE_IB_SWITCH)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c 
b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 58b5aa3..6afb30f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1655,7 +1655,7 @@ static void ipoib_add_one(struct ib_device *device)
      struct ipoib_dev_priv *priv;
      int s, e, p;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
@@ -1690,7 +1690,7 @@ static void ipoib_remove_one(struct ib_device *device)
      struct ipoib_dev_priv *priv, *tmp;
      struct list_head *dev_list;

-    if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+    if (!rdma_transport_is_ib(device))
          return;

      dev_list = ib_get_client_data(device, &ipoib_client);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..f6a04b5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1743,6 +1743,11 @@ int ib_query_port(struct ib_device *device,
  enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
                             u8 port_num);

+static inline int rdma_transport_is_ib(struct ib_device *device)
+{
+    return rdma_node_get_transport(device->node_type) == RDMA_TRANSPORT_IB;
+}
+
  int ib_query_gid(struct ib_device *device,
           u8 port_num, int index, union ib_gid *gid);

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
