From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 2/4] IB/cma: Separate port allocation to network namespaces
Date: Thu, 27 Aug 2015 17:29:30 +0300
Message-ID: <1440685772-14076-3-git-send-email-haggaie@mellanox.com>
References: <1440685772-14076-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440685772-14076-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Keep a struct for each network namespace containing the IDRs for the RDMA
CM port spaces. The struct is created dynamically using the generic_net
mechanism.

This patch is internal infrastructure work for the following patches. In
this patch, init_net is statically used as the network namespace for
the new port-space API.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 94 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0530c6188e75..f40ca053fa3e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -44,6 +44,8 @@
 #include <linux/module.h>
 #include <net/route.h>
 
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <net/tcp.h>
 #include <net/ipv6.h>
 #include <net/ip_fib.h>
@@ -110,22 +112,33 @@ static LIST_HEAD(dev_list);
 static LIST_HEAD(listen_any_list);
 static DEFINE_MUTEX(lock);
 static struct workqueue_struct *cma_wq;
-static DEFINE_IDR(tcp_ps);
-static DEFINE_IDR(udp_ps);
-static DEFINE_IDR(ipoib_ps);
-static DEFINE_IDR(ib_ps);
+static int cma_pernet_id;
 
-static struct idr *cma_idr(enum rdma_port_space ps)
+struct cma_pernet {
+	struct idr tcp_ps;
+	struct idr udp_ps;
+	struct idr ipoib_ps;
+	struct idr ib_ps;
+};
+
+static struct cma_pernet *cma_pernet(struct net *net)
+{
+	return net_generic(net, cma_pernet_id);
+}
+
+static struct idr *cma_pernet_idr(struct net *net, enum rdma_port_space ps)
 {
+	struct cma_pernet *pernet = cma_pernet(net);
+
 	switch (ps) {
 	case RDMA_PS_TCP:
-		return &tcp_ps;
+		return &pernet->tcp_ps;
 	case RDMA_PS_UDP:
-		return &udp_ps;
+		return &pernet->udp_ps;
 	case RDMA_PS_IPOIB:
-		return &ipoib_ps;
+		return &pernet->ipoib_ps;
 	case RDMA_PS_IB:
-		return &ib_ps;
+		return &pernet->ib_ps;
 	default:
 		return NULL;
 	}
@@ -145,24 +158,25 @@ struct rdma_bind_list {
 	unsigned short		port;
 };
 
-static int cma_ps_alloc(enum rdma_port_space ps,
+static int cma_ps_alloc(struct net *net, enum rdma_port_space ps,
 			struct rdma_bind_list *bind_list, int snum)
 {
-	struct idr *idr = cma_idr(ps);
+	struct idr *idr = cma_pernet_idr(net, ps);
 
 	return idr_alloc(idr, bind_list, snum, snum + 1, GFP_KERNEL);
 }
 
-static struct rdma_bind_list *cma_ps_find(enum rdma_port_space ps, int snum)
+static struct rdma_bind_list *cma_ps_find(struct net *net,
+					  enum rdma_port_space ps, int snum)
 {
-	struct idr *idr = cma_idr(ps);
+	struct idr *idr = cma_pernet_idr(net, ps);
 
 	return idr_find(idr, snum);
 }
 
-static void cma_ps_remove(enum rdma_port_space ps, int snum)
+static void cma_ps_remove(struct net *net, enum rdma_port_space ps, int snum)
 {
-	struct idr *idr = cma_idr(ps);
+	struct idr *idr = cma_pernet_idr(net, ps);
 
 	idr_remove(idr, snum);
 }
@@ -1300,7 +1314,8 @@ static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
 		}
 	}
 
-	bind_list = cma_ps_find(rdma_ps_from_service_id(req.service_id),
+	bind_list = cma_ps_find(&init_net,
+				rdma_ps_from_service_id(req.service_id),
 				cma_port_from_service_id(req.service_id));
 	id_priv = cma_find_listener(bind_list, cm_id, ib_event, &req, *net_dev);
 	if (IS_ERR(id_priv)) {
@@ -1378,7 +1393,7 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 	mutex_lock(&lock);
 	hlist_del(&id_priv->node);
 	if (hlist_empty(&bind_list->owners)) {
-		cma_ps_remove(bind_list->ps, bind_list->port);
+		cma_ps_remove(&init_net, bind_list->ps, bind_list->port);
 		kfree(bind_list);
 	}
 	mutex_unlock(&lock);
@@ -2663,7 +2678,7 @@ static int cma_alloc_port(enum rdma_port_space ps,
 	if (!bind_list)
 		return -ENOMEM;
 
-	ret = cma_ps_alloc(ps, bind_list, snum);
+	ret = cma_ps_alloc(&init_net, ps, bind_list, snum);
 	if (ret < 0)
 		goto err;
 
@@ -2688,7 +2703,7 @@ static int cma_alloc_any_port(enum rdma_port_space ps,
 	rover = prandom_u32() % remaining + low;
 retry:
 	if (last_used_port != rover &&
-	    !cma_ps_find(ps, (unsigned short)rover)) {
+	    !cma_ps_find(&init_net, ps, (unsigned short)rover)) {
 		int ret = cma_alloc_port(ps, id_priv, rover);
 		/*
 		 * Remember previously used port number in order to avoid
@@ -2754,7 +2769,7 @@ static int cma_use_port(enum rdma_port_space ps,
 	if (snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
-	bind_list = cma_ps_find(ps, snum);
+	bind_list = cma_ps_find(&init_net, ps, snum);
 	if (!bind_list) {
 		ret = cma_alloc_port(ps, id_priv, snum);
 	} else {
@@ -3974,6 +3989,35 @@ static const struct ibnl_client_cbs cma_cb_table[] = {
 				       .module = THIS_MODULE },
 };
 
+static int cma_init_net(struct net *net)
+{
+	struct cma_pernet *pernet = cma_pernet(net);
+
+	idr_init(&pernet->tcp_ps);
+	idr_init(&pernet->udp_ps);
+	idr_init(&pernet->ipoib_ps);
+	idr_init(&pernet->ib_ps);
+
+	return 0;
+}
+
+static void cma_exit_net(struct net *net)
+{
+	struct cma_pernet *pernet = cma_pernet(net);
+
+	idr_destroy(&pernet->tcp_ps);
+	idr_destroy(&pernet->udp_ps);
+	idr_destroy(&pernet->ipoib_ps);
+	idr_destroy(&pernet->ib_ps);
+}
+
+static struct pernet_operations cma_pernet_operations = {
+	.init = cma_init_net,
+	.exit = cma_exit_net,
+	.id = &cma_pernet_id,
+	.size = sizeof(struct cma_pernet),
+};
+
 static int __init cma_init(void)
 {
 	int ret;
@@ -3982,6 +4026,10 @@ static int __init cma_init(void)
 	if (!cma_wq)
 		return -ENOMEM;
 
+	ret = register_pernet_subsys(&cma_pernet_operations);
+	if (ret)
+		goto err_wq;
+
 	ib_sa_register_client(&sa_client);
 	rdma_addr_register_client(&addr_client);
 	register_netdevice_notifier(&cma_nb);
@@ -3999,6 +4047,7 @@ err:
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
 	ib_sa_unregister_client(&sa_client);
+err_wq:
 	destroy_workqueue(cma_wq);
 	return ret;
 }
@@ -4010,11 +4059,8 @@ static void __exit cma_cleanup(void)
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
 	ib_sa_unregister_client(&sa_client);
+	unregister_pernet_subsys(&cma_pernet_operations);
 	destroy_workqueue(cma_wq);
-	idr_destroy(&tcp_ps);
-	idr_destroy(&udp_ps);
-	idr_destroy(&ipoib_ps);
-	idr_destroy(&ib_ps);
 }
 
 module_init(cma_init);
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
