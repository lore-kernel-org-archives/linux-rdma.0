Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794667496;
	b=sUtXQH6B3VnoagEU5G87CvDqhk7frs0OZ7uCpAcqIF20ULm2ZiQjza9HJOdGcJpuoSO/
	 2buT2T5zqc8XGe3kVOHuG2qnwQSz2NyXrvXp9aM2w/a0cpSGierSlxVktrees+mCdNa77
	 pF7i8UniOATS2Eg+7ejvJZIS+OUFP6GubPn0cwKRFoiCVZj2Kg7Poub08S6T2eKPB+AJ4
	 jDZZz/v19uCIp2s2EI3KFZoIdIpp2g3/cWQFHBwOl9xM2PcArAG2msBu4wfFvK6AFFLrJ
	 zm/YKHSBVSVxe/cH5A/FjFQme25a2C5RuquWwcxVlEr/TCai1XfVVR42vx+VPB3sSDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794667496;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=e5d7G5fQH0I1PriZkyL6VwsluxywSSfe7HXVYmJzQx0=;
	b=ytaSoByXEaqlaDW3fGOwFk7QzctD2Gfdw74CV8vCOkOFyYe24zYup1Kcq1SukTuwoTro
	 QWRo+HcEzVBKn1OyUpp6dV7ZX8+wbUOd7hKzz4yb9gPjDcyOGrVDPc9PclWHVqcBStjZ+
	 t0g1KoYhkjGHbNTWYjVSW/xOXwaq77FNuPy0r/Z5yfSLbBMMvNk02lcQZOSHKuotc/kVd
	 dREyS6FeWNWwpGDkPYwPiNG7PSUgRnNMrN7thP28zXxyZjxu5YpwiXGixxjhRx3X9F8es
	 rdk3CQkeTxCcVqLiG4uvs6AimGFb3ZDuDKcsCFj8I2GVPsC35DgmHGRi5N41RHxUVNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=d4auUGBn;
	arc=none smtp.remote-ip=117.135.210.7
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB88606A335;
	Sat, 14 Nov 2026 14:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BB88606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=d4auUGBn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=e5
	d7G5fQH0I1PriZkyL6VwsluxywSSfe7HXVYmJzQx0=; b=d4auUGBnlls3f3lucC
	4feqjnvupNI/TFEw7DtwEY1GTPk/OxABGbuul5box5H0inHyZ7ZUo/pD8SyM00Oq
	NoNHCsYzhU7ltOHK4m2AkvDmuAmErHeao8VZFKkLyLXgTJ/XYtHZaZUvG4iUHOYJ
	f/wBANQQOPLnuSuWZnpfIjqEg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXjyGec_hqHP+kDA--.56701S5;
	Sat, 14 Nov 2026 22:43:46 +0800 (CST)
From: Jinvas <jinvas@126.com>
To: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	jinvas@126.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 1/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Sat, 14 Nov 2026 22:43:25 +0800
Message-Id: <20261114144325.816-2-jinvas@126.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20261114144325.816-1-jinvas@126.com>
References: <20261114144325.816-1-jinvas@126.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXjyGec_hqHP+kDA--.56701S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrW3Ww1Utr1fJFW5XFWrKrg_yoW5Jw4DpF
	sxGryDKF1DJ3WxJa1kZ3y0q3s3Ca18JayrC3WSk3y3twnxJr1F9FWru343CFy7CF4rJasF
	qw15Zw17AF9xGa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pKsjjiUUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBswLddGr4c6K5MAAA3S

arfs_create_groups() creates up to two flow groups in ft->g[], and
increments ft->num_groups for each group that was created successfully.
If creating the second group fails, the error path frees ft->g and sets
it to NULL, but leaves ft->num_groups at 1.

The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
the error path, which calls mlx5e_destroy_groups(). The latter walks
ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
Since ft->g was freed and set to NULL, this is a NULL pointer
dereference, and the kernel oopses.

The same error path also leaks the flow group that was created
successfully before the failure, since ft->g is freed without the group
being destroyed.

Freeing ft->g here was added by commit 3c6d5189246f ("net/mlx5e: fix a
double-free in arfs_create_groups"). Before that commit, the group
failure path did not touch ft->g at all, so the caller destroyed the
flow groups that had been created and then freed the array. That
commit fixed a double free in the allocation failure path by freeing
ft->g here as well, and in doing so changed the group failure path
too.

Rather than also resetting ft->num_groups, leave the free of ft->g to
the caller: mlx5e_destroy_flow_table() frees ft->g exactly once, and
also destroys the flow groups that were created. This fixes the NULL
pointer dereference and the leak, while keeping the double free fixed.

This also makes the error handling of this function consistent with the
rest of the driver, e.g. mlx5e_create_l2_table().

Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
Signed-off-by: Jinvas <jinvas@126.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index c5e62d7..7888d38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -267,7 +267,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
-		goto err_free_g;
+		goto err_free_in;
 	}
 
 	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
@@ -338,9 +338,6 @@ err_clean_group:
 	ft->g[ft->num_groups] = NULL;
 err_free_in:
 	kvfree(in);
-err_free_g:
-	kfree(ft->g);
-	ft->g = NULL;
 	return err;
 }
 
-- 
2.28.0.windows.1

