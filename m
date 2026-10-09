Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852034DD3A2;
	Fri,  9 Oct 2026 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550916; cv=none; b=k2LI+84HN1D1mmXn9SYsauBnzM51xAZYdT/A+l0JZq0//mmSu+kN/y6ddQ82t6NcEOEnmm10ggLPgIXPAUndAXsOnQuv3iljuCvjxmyMi8YvHBc7gGSS5lEfXKCyQWrtfTswH6oJc66bBlQlTTTp4GOxSD8hL7NO/Ugd0XLPbgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550916; c=relaxed/simple;
	bh=CUd0ECXCvbhVZPxZOv8ucRUjU1xqC/NwFCjPQnXpwrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fsRktZEB8qgwubUb9QrDoT17JWd7/DBusjMlmeWz6UjpOkwshRKObzp/MtFfTDHAitkOZOXSHf7giLq/B7TzjvINbV7kuDjyVP9CUrpfWf9NfSdGcNLmHDXo4sUiL4aMj7EXN8+NKWm2Eb885s+9Sht46PHBsxFeytjLRS7BQcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=B/3v3Wk5; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="B/3v3Wk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Uu
	g7uV2g8XMp/s1ee273siKCW6QSESXO1p0kxsq5poM=; b=B/3v3Wk5dP5025LkES
	MwgctF0yVjKpPs5FPi6kObiAPfZwsDwxSZ4s9JtvP27FBPRJ8nZDdRL8RGjVkOO+
	hpXCk8csr//JL/H5orJsN/L2P0F0hOsIQT1YAi7tlAjsD6/+APciZeBU5jV5gOPK
	Betpn06o8k2rB+59mM6tdZ6hU=
Received: from colol4bi5.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnj9aF5chqGnLCDg--.6195S2;
	Fri, 09 Oct 2026 21:00:55 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	sd@queasysnail.net
Cc: horms@kernel.org,
	raeds@nvidia.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH net v1] net: mlx5e: Fix use-after-free of the MACsec xarray entry on RX SC deletion
Date: Fri,  9 Oct 2026 21:00:49 +0800
Message-ID: <20261009130050.37694-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnj9aF5chqGnLCDg--.6195S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw18XFyrAF13tF1rKrW7urg_yoW5Zr47pa
	yfJFW7CF1kGry8Xr1xZa1xWw45ZrZ7Xa4a93W3C3yfA3Z5X3y0vFy8CFW09r90krWrC3ZI
	vws29w47Xa15Gr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UUEfrUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4AdnS2rI5YenWQAA31

In macsec_del_rxsc_ctx(), the RX secure channel is torn down with:

	list_del_rcu(&rx_sc->rx_sc_list_element);
	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
	dst_release(&rx_sc->md_dst->dst);
	kfree(rx_sc->sc_xarray_element);
	kfree_rcu_mightsleep(rx_sc);

The comment above the sequence claims that "xa_erase which uses rcu to
sync" hides the RX SC from the data path, but this is not sufficient:
the RCU protection of xarray covers only its internal nodes (making
xa_load() safe against concurrent erase); it does not extend to the
object pointed to by the entry value.  A reader that has already
obtained the pointer from xa_load() is not covered by any grace period,
and the bare kfree() releases the entry object immediately.

The reader is mlx5e_macsec_offload_handle_rx_skb() in the NAPI RX
path, which runs under rcu_read_lock() only:

	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
	rx_sc = sc_xarray_element ? sc_xarray_element->rx_sc : NULL;

An RCU read-side critical section protects only against deferred frees
(call_rcu()/kfree_rcu()); it provides no protection against the
immediate kfree() above.  If the NAPI reader loads the entry pointer
and is then delayed while another CPU executes the deletion path, the
subsequent read of sc_xarray_element->rx_sc dereferences freed memory.

The path is reachable with CAP_NET_ADMIN while an RX SC has in-flight
traffic: CQEs carrying the fs_id metadata can still arrive after the
offload rule has been removed, so deleting an RX SC concurrently with
reception can race the reader.

Note that the same function already releases rx_sc itself via
kfree_rcu_mightsleep(): the author was aware that this teardown needs a
deferred free, but the intermediate entry object was missed.

Fix this by adding an rcu_head to the entry object and releasing it
with kfree_rcu().

Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index daff53ba7d09..d4caa7affae6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -75,6 +75,7 @@ struct mlx5e_macsec_rx_sc;
 struct mlx5e_macsec_rx_sc_xarray_element {
 	u32 fs_id;
 	struct mlx5e_macsec_rx_sc *rx_sc;
+	struct rcu_head rcu_head;
 };
 
 struct mlx5e_macsec_rx_sc {
@@ -839,7 +840,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
 	list_del_rcu(&rx_sc->rx_sc_list_element);
 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
 	dst_release(&rx_sc->md_dst->dst);
-	kfree(rx_sc->sc_xarray_element);
+	kfree_rcu(rx_sc->sc_xarray_element, rcu_head);
 	kfree_rcu_mightsleep(rx_sc);
 }
 
-- 
2.43.0

