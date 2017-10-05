From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] IB/ipoib: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:45:54 -0700
Message-ID: <20171005004554.GA22669@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, "kernel@kyup.com" <kernel@kyup.com>, Kees Cook <keescook@chromium.org>, Paolo Abeni <pabeni@redhat.com>, Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>, Feras Daoud <ferasda@mellanox.com>, Alex Estrin <alex.estrin@intel.com>, Shamir Rabinovitch <shamir.rabinovitch@oracle.com>, linux-rdma@vger.kernel.org, Yuval Shaia <yuval.shaia@oracle.com>, Thomas Gleixner <tglx@linutronix.>
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Alex Vesker <valex@mellanox.com>
Cc: Erez Shitrit <erezsh@mellanox.com>
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Yuval Shaia <yuval.shaia@oracle.com>
Cc: linux-rdma@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   | 6 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 4a5c7a07a631..7cc2b755413d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -500,7 +500,7 @@ void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
 struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
 					const char *format);
-void ipoib_ib_tx_timer_func(unsigned long ctx);
+void ipoib_ib_tx_timer_func(struct timer_list *t);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
 void ipoib_ib_dev_flush_normal(struct work_struct *work);
 void ipoib_ib_dev_flush_heavy(struct work_struct *work);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 6cd61638b441..918930a0bc70 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -821,9 +821,11 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 	return 0;
 }
 
-void ipoib_ib_tx_timer_func(unsigned long ctx)
+void ipoib_ib_tx_timer_func(struct timer_list *t)
 {
-	drain_tx_cq((struct net_device *)ctx);
+	struct ipoib_dev_priv *priv = from_timer(priv, t, poll_timer);
+
+	drain_tx_cq(priv->dev);
 }
 
 int ipoib_ib_dev_open_default(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index dcc77014018d..77c1b7adbb40 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1666,8 +1666,7 @@ static int ipoib_dev_init_default(struct net_device *dev)
 	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
 	priv->dev->dev_addr[3] = (priv->qp->qp_num) & 0xff;
 
-	setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
-		    (unsigned long)dev);
+	timer_setup(&priv->poll_timer, ipoib_ib_tx_timer_func, 0);
 
 	return 0;
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
