Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C212C2E6CB8;
	Sat, 10 Oct 2026 03:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602524; cv=none; b=gRhJvdgh1i9LcQ4ealdZugxE1pHOJuCIthVVqvanzmZzPGrN8o7bK9enbzS47yxuEetcZyfsJsk6GuBzbtaA8oyHNWPfOZ5o7XPRAiE0ZA4haxtqEo2DBQq9HGnwy9PIerfplYEELOA6RsORgAaAezjUyrKBgCxFM7TDCHmo2ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602524; c=relaxed/simple;
	bh=iznYCBsnuDD7TtKTvWpvkkDtxuHJRApQbTM5v5Rs2d8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xyrzd4hqcSilKy9mhvHlr8oUIRy/C3mJEAQtz18x2LD3L9XNdMeKOlLn4Dpta/SrB0aWBZm9QzgcXknun/f6ECHbKfl8P1/pkHec09S2yV48vbl9Ez+5mSUR/klfOvL9Y8zUVw0eYdo0itV6HeiFyDLPPWah7SN4oOofoi3zg4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=OOFFvlus; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="OOFFvlus"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=nW
	Lvz8pjTi2eJKYRDz83xjnrYXYS3iiNIjJCpfNJPd8=; b=OOFFvluspDZZ/BNTLO
	1jRAxcQAWHLgAD/dpO1zO1bl5MjhhBPwTxz1Zj6g67CAs6vbE3ygwr2fcsF/CmVZ
	xIKKL66wDCpwxxuX0EfU/ltWKmiEIi1N68W4MrEuEkQbH7KoyERO1DMRG8GdpFE2
	+UZIK1tREjyc+yEAVMZzEG9pk=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCXb+Usr8lqH2_BDg--.64530S2;
	Sat, 10 Oct 2026 11:21:18 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: borisp@nvidia.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	sd@queasysnail.net
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH net v2] net: mlx5e: Fix use-after-free of the MACsec xarray entry on RX SC deletion
Date: Sat, 10 Oct 2026 11:21:15 +0800
Message-ID: <20261010032115.93545-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXb+Usr8lqH2_BDg--.64530S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw18XFyrAF13tF1rKrW7urg_yoW5tF15pa
	yfJFW7CFykGry8XryxAa1xWw15ZrZ2qa43u3W5C3yfA3Z8Z3y0vFy8Gay09r90krWrC3ZI
	vws29w47Xa15Gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UoSoXUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC+w4E52rJry5ZvwAA3S

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

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

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

