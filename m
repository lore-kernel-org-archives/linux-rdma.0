From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH amirv] IB/ipoib: Prepare the napi in the RX flow [ib-next:
 ipoib_rx_poll() can be static
Date: Wed, 25 Mar 2015 23:53:33 +0800
Message-ID: <20150325155333.GA54248@lkp-sb04>
References: <201503252315.8wVkJr4n%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201503252315.8wVkJr4n%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Erez Shitrit <erezsh@mellanox.com>
Cc: kbuild-all@01.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Doug Ledford <dledford@redhat.com>, Alex Estrin <alex.estrin@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 ipoib_ib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index af52a01..8f31a93 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -375,7 +375,7 @@ static int poll_tx(struct ipoib_dev_priv *priv)
 	return n == MAX_SEND_CQE;
 }
 
-int ipoib_rx_poll(struct napi_struct *napi, int budget)
+static int ipoib_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct ipoib_dev_priv *priv = container_of(napi, struct ipoib_dev_priv, napi_rx);
 	struct net_device *dev = priv->dev;
