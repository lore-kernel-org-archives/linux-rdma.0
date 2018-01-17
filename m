From: Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] net/mlx5e: Fix trailing semicolon
Date: Wed, 17 Jan 2018 12:09:15 +0000
Message-ID: <20180117120915.18837-1-luisbg@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, "David S . Miller" <davem@davemloft.net>, Alex Vesker <valex@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Luis de Bethencourt <luisbg@kernel.org>
List-Id: linux-rdma@vger.kernel.org

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards,
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index bf9dc4516d2c..3ff81411ae93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -485,7 +485,7 @@ static int mlx5i_close(struct net_device *netdev)
 	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qp.qpn);
 	mlx5i_uninit_underlay_qp(epriv);
 	mlx5e_deactivate_priv_channels(epriv);
-	mlx5e_close_channels(&epriv->channels);;
+	mlx5e_close_channels(&epriv->channels);
 unlock:
 	mutex_unlock(&epriv->state_lock);
 	return 0;
-- 
2.15.1
