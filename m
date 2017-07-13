From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] IB/IPoIB: Fix error code in ipoib_add_port()
Date: Thu, 13 Jul 2017 10:45:48 +0300
Message-ID: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Alex Vesker <valex@mellanox.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Feras Daoud <ferasda@mellanox.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, Shamir Rabinovitch <shamir.rabinovitch@oracle.com>, Paolo Abeni <pabeni@redhat.com>, David Ahern <dsa@cumulusnetworks.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We accidentally don't see the error code on some of these error paths.
It means we return ERR_PTR(0) which is NULL and it results in a NULL
dereference in the caller.

This bug dates to pre-git days.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 6e86eeee370e..ddd8114b6713 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2212,6 +2212,7 @@ static struct net_device *ipoib_add_port(const char *format,
 		goto register_failed;
 	}
 
+	result = -ENOMEM;
 	if (ipoib_cm_add_mode_attr(priv->dev))
 		goto sysfs_failed;
 	if (ipoib_add_pkey_attr(priv->dev))
