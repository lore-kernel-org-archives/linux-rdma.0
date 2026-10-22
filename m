Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664361;
	b=mJKr0gLqwVhZ3PtcU+KRmwByg1OaSgpg+zgJTHMp01fc16EfF2RFciBvynLUKLWQbA0J
	 ZJ7tYjsoxJfr2Z0Xe9vegs8jLPY9oDRN/BdY323pOX6Z2eJjWTU8Vq9cLYL2KpumIzxgU
	 zlpt5ivbzCfCbw5wTaJ9ums6Dz3EAhpcibsaP+YdfSOZcibj8MxbCE2DfZQ2guQVdGaHm
	 bcSj65fdRKLrOJ+9++liSfVIDgHfpPSbjguct5XUoEqHW6uhbN2QI/qes4t3GqsnB/CRy
	 myhOrbBCC7SLXJ4HlV94VEIgBjnkomtui78rMRgWqlJvgq0IZ9Inuko4Q+ELODCR5Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664361;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+RfBOdb+jBzd/ieyymYqVh+qhtFAqnJNDc6I2YUHE+U=;
	b=dQ3bViBM4rdP3nyYtYKm5pbwb6aJ2zkItaW+wzY1K30lfgoWyklJ0dU4y17DAivAogDe
	 wPwZPMC45wJ0JCVbkCjrkVkHNNmEbBpxO2a/QkKEf4uEe5n4lrM20C5HaWnXPX8LPfozy
	 FvdyBB0vIcG9TOmS1EfUkXDQ3Z+xQMAfqsaOWt22IiX7niWzgPjYmlvfHL7raJyQU9fKn
	 X3QK2KutCbngVEnR/OFZMDjYiNz77ljtnbzlhJNb9Uhj/Xi6MzE9PlT68SjIDXsVOwxEA
	 eMZl02Y4wv0m2mWFNh4LYQ/GlEYddQE9wDIWlLOhBAzHVnv4605VB/OjvPuXGg4gT0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHTKymez;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D425E606A319;
	Thu, 22 Oct 2026 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHTKymez
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290B71F000C1;
	Thu, 22 Oct 2026 10:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792664360;
	bh=+RfBOdb+jBzd/ieyymYqVh+qhtFAqnJNDc6I2YUHE+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LHTKymezZyGY17PnqmuH/Lzxr0GlKLRF4EphWEOhZUAOtKND+9H5qiXY5i+zjodcK
	 ZAPMV0zGIodTbcMyrZ6guSE9D6Yv7XncwQGRQaQElvKiZJgpQWp/SuHLL/tOVqOxMs
	 qIeivexw25wL3qurO5BRfeigpp02p3AF7JHKzAfdAO95sUtewv44wUOsP5iSF1EHev
	 dmwr5OD2v7WHtNsTkZ8INbU6flEFHj74q9/NgZeRqqFg52wHLW4gPeaIZx2YT7ziwb
	 wwXnWrjzAgwjoqHuA7zEyI/CJf7sIq/f4EuRM4FCp8EQn/lGh27ZyWpAlH2ACVFABo
	 xjqByno+03Utw==
Date: Thu, 22 Oct 2026 11:19:15 +0100
From: Simon Horman <horms@kernel.org>
To: Peter Morrow <pdmorrow@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>, Yishai Hadas <yishaih@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
Message-ID: <20261022101915.GD708417@horms.kernel.org>
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020164239.3808903-1-pdmorrow@gmail.com>

On Tue, Oct 20, 2026 at 05:42:39PM +0100, Peter Morrow wrote:
> Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
> an IB port or a device that advertises IBoE. Before it, each mlx4
> interface was offered every device and decided in its own add callback.
> mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
> for raw packet QPs only.
> 
> ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
> v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
> packet QPs, then cannot open them:
> 
>   net_mlx4: cannot access device, is mlx4_ib loaded?
> 
> Restore the old behaviour by creating both auxiliary devices for every
> device and letting mlx4_en and mlx4_ib decide in probe, as their add
> callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
> ports, and mlx4_en_probe() binds a device without Ethernet ports but
> creates no netdevs, as mlx4_en_add() did.
> 
> Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
> eth and an ib auxiliary device, and DPDK attaches both VFs and passes
> traffic through them.
> 
> Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary bus")
> Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail.com
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>

Thanks, this looks good to me.
And I think the minimal approach taken here is appropriate for net.

Reviewed-by: Simon Horman <horms@kernel.org>

I do, however, wonder if a follow-up is warranted.
It seems to me that the is_supported callback could
be removed entirely. Leaving either:
1. struct mlx4_adev_device with a single member, .suffix
2. mlx4_adev_devices as an array of of strings

To explore this idea a little further I tried coding-up approach 2.
Which lead to the following (compile tested only):

diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index 82e467c45d23..f2f35306aeb3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -41,34 +41,7 @@
 static DEFINE_MUTEX(intf_mutex);
 static DEFINE_IDA(mlx4_adev_ida);
 
-static bool is_eth_supported(struct mlx4_dev *dev)
-{
-	for (int port = 1; port <= dev->caps.num_ports; port++)
-		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
-			return true;
-
-	return false;
-}
-
-static bool is_ib_supported(struct mlx4_dev *dev)
-{
-	for (int port = 1; port <= dev->caps.num_ports; port++)
-		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
-			return true;
-
-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
-		return true;
-
-	return false;
-}
-
-static const struct mlx4_adev_device {
-	const char *suffix;
-	bool (*is_supported)(struct mlx4_dev *dev);
-} mlx4_adev_devices[] = {
-	{ "eth", is_eth_supported },
-	{ "ib", is_ib_supported },
-};
+static const char * const mlx4_adev_devices[] = { "eth", "ib" };
 
 int mlx4_adev_init(struct mlx4_dev *dev)
 {
@@ -109,8 +82,8 @@ static void adev_release(struct device *dev)
 
 static struct mlx4_adev *add_adev(struct mlx4_dev *dev, int idx)
 {
+	const char *suffix = mlx4_adev_devices[idx];
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	const char *suffix = mlx4_adev_devices[idx].suffix;
 	struct auxiliary_device *adev;
 	struct mlx4_adev *madev;
 	int ret;
@@ -222,7 +195,7 @@ int mlx4_do_bond(struct mlx4_dev *dev, bool enable)
 		priv->adev[i] = add_adev(dev, i);
 		if (IS_ERR(priv->adev[i])) {
 			mlx4_warn(dev, "Device[%d] (%s) failed to load\n", i,
-				  mlx4_adev_devices[i].suffix);
+				  mlx4_adev_devices[i]);
 			priv->adev[i] = NULL;
 			continue;
 		}
@@ -269,21 +242,13 @@ static int add_drivers(struct mlx4_dev *dev)
 	int i, ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(mlx4_adev_devices); i++) {
-		bool is_supported = false;
-
 		if (priv->adev[i])
 			continue;
 
-		if (mlx4_adev_devices[i].is_supported)
-			is_supported = mlx4_adev_devices[i].is_supported(dev);
-
-		if (!is_supported)
-			continue;
-
 		priv->adev[i] = add_adev(dev, i);
 		if (IS_ERR(priv->adev[i])) {
 			mlx4_warn(dev, "Device[%d] (%s) failed to load\n", i,
-				  mlx4_adev_devices[i].suffix);
+				  mlx4_adev_devices[i]);
 			/* We continue to rescan drivers and leave to the caller
 			 * to make decision if to release everything or
 			 * continue. */
@@ -297,23 +262,15 @@ static int add_drivers(struct mlx4_dev *dev)
 static void delete_drivers(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	bool delete_all;
 	int i;
 
-	delete_all = !(dev->persist->interface_state & MLX4_INTERFACE_STATE_UP);
+	if (dev->persist->interface_state & MLX4_INTERFACE_STATE_UP)
+		return;
 
 	for (i = ARRAY_SIZE(mlx4_adev_devices) - 1; i >= 0; i--) {
-		bool is_supported = false;
-
 		if (!priv->adev[i])
 			continue;
 
-		if (mlx4_adev_devices[i].is_supported && !delete_all)
-			is_supported = mlx4_adev_devices[i].is_supported(dev);
-
-		if (is_supported)
-			continue;
-
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
