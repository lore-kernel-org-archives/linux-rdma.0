From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: WARNING in cma_exit_net
Date: Mon, 1 Apr 2019 14:45:54 -0300
Message-ID: <20190401174554.GE6209@ziepe.ca>
References: <0000000000008096f305857b74d1@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0000000000008096f305857b74d1@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: danielj@mellanox.com, danitg@mellanox.com, dledford@redhat.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 01, 2019 at 10:36:05AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    e3ecb83e Add linux-next specific files for 20190401
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13bc36cd200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=db6c9f2bfeb91a99
> dashboard link: https://syzkaller.appspot.com/bug?extid=2e3e485d5697ea610460
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com
> 
> WARNING: CPU: 1 PID: 7 at drivers/infiniband/core/cma.c:4674
> cma_exit_net+0x327/0x390 drivers/infiniband/core/cma.c:4674
> Kernel panic - not syncing: panic_on_warn set ...

Matt: This is why the WARN_ON(!xa_empty()) is so valuable. Magically
syzkaller can find something in this code is buggy.

Mellanox is also showing a different testing failure over the weekend
(use after free or something) from your 'cma: Convert portspace IDRs
to XArray'

If you seem something obvious wrong in that patch please speak
up.. Below is what I applied.

Thanks,
Jason

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 68c997be242930..a8b9c66c85252b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -39,7 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/igmp.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <linux/inetdevice.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -191,10 +191,10 @@ static struct workqueue_struct *cma_wq;
 static unsigned int cma_pernet_id;
 
 struct cma_pernet {
-	struct idr tcp_ps;
-	struct idr udp_ps;
-	struct idr ipoib_ps;
-	struct idr ib_ps;
+	struct xarray tcp_ps;
+	struct xarray udp_ps;
+	struct xarray ipoib_ps;
+	struct xarray ib_ps;
 };
 
 static struct cma_pernet *cma_pernet(struct net *net)
@@ -202,7 +202,8 @@ static struct cma_pernet *cma_pernet(struct net *net)
 	return net_generic(net, cma_pernet_id);
 }
 
-static struct idr *cma_pernet_idr(struct net *net, enum rdma_ucm_port_space ps)
+static
+struct xarray *cma_pernet_xa(struct net *net, enum rdma_ucm_port_space ps)
 {
 	struct cma_pernet *pernet = cma_pernet(net);
 
@@ -247,25 +248,25 @@ struct class_port_info_context {
 static int cma_ps_alloc(struct net *net, enum rdma_ucm_port_space ps,
 			struct rdma_bind_list *bind_list, int snum)
 {
-	struct idr *idr = cma_pernet_idr(net, ps);
+	struct xarray *xa = cma_pernet_xa(net, ps);
 
-	return idr_alloc(idr, bind_list, snum, snum + 1, GFP_KERNEL);
+	return xa_insert(xa, snum, bind_list, GFP_KERNEL);
 }
 
 static struct rdma_bind_list *cma_ps_find(struct net *net,
 					  enum rdma_ucm_port_space ps, int snum)
 {
-	struct idr *idr = cma_pernet_idr(net, ps);
+	struct xarray *xa = cma_pernet_xa(net, ps);
 
-	return idr_find(idr, snum);
+	return xa_load(xa, snum);
 }
 
 static void cma_ps_remove(struct net *net, enum rdma_ucm_port_space ps,
 			  int snum)
 {
-	struct idr *idr = cma_pernet_idr(net, ps);
+	struct xarray *xa = cma_pernet_xa(net, ps);
 
-	idr_remove(idr, snum);
+	xa_erase(xa, snum);
 }
 
 enum {
@@ -4655,10 +4656,10 @@ static int cma_init_net(struct net *net)
 {
 	struct cma_pernet *pernet = cma_pernet(net);
 
-	idr_init(&pernet->tcp_ps);
-	idr_init(&pernet->udp_ps);
-	idr_init(&pernet->ipoib_ps);
-	idr_init(&pernet->ib_ps);
+	xa_init(&pernet->tcp_ps);
+	xa_init(&pernet->udp_ps);
+	xa_init(&pernet->ipoib_ps);
+	xa_init(&pernet->ib_ps);
 
 	return 0;
 }
@@ -4667,10 +4668,10 @@ static void cma_exit_net(struct net *net)
 {
 	struct cma_pernet *pernet = cma_pernet(net);
 
-	idr_destroy(&pernet->tcp_ps);
-	idr_destroy(&pernet->udp_ps);
-	idr_destroy(&pernet->ipoib_ps);
-	idr_destroy(&pernet->ib_ps);
+	WARN_ON(!xa_empty(&pernet->tcp_ps));
+	WARN_ON(!xa_empty(&pernet->udp_ps));
+	WARN_ON(!xa_empty(&pernet->ipoib_ps));
+	WARN_ON(!xa_empty(&pernet->ib_ps));
 }
 
 static struct pernet_operations cma_pernet_operations = {
