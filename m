Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834319;
	b=jNQ8hVv9/QgqDgGPlLOJ+bKYDfWGud0ApeAb8sy8AMWS5cW+T3Cf/9a2TExzwNmcrDWC
	 Io80gUEceaSyLzT9RcdkQ8X1UHjJjOTB+sCUrETF5jc7veRNDIB7IYiu2BN33cfNkP2z2
	 v5SU7jsz9+Eceli/E1wVUuMzIVWUHqN8BkR9c61i84mU1C4rZ+L/DYO5CtrUiNSdutqf0
	 eZRMYY+uoRsjSDLdWOEQyOhB02CtbldyE2WVtwUI5ZOTd/uwgYXYZ0Ys8qcav5+tfC6O5
	 V5fgrkMH1N/SJwLmguXM4xIAwLc8gF8zNkt/DzVuO7f7ReZgMJLwehiJp4IGoTmIuWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834319;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=e5d7G5fQH0I1PriZkyL6VwsluxywSSfe7HXVYmJzQx0=;
	b=i2ATKWohWBRqi5ZAHY3bg+iPyuRd3i8r29bVqRF0Nalbq8ScawUWk/zgwN5AkV42yZvB
	 Pvi0dkXAaUB/nfOIrQu5WbLApg+kp9sFn74bIjm0PL4EuLcUWXCB5txkPeMecCdFdeWeO
	 Qi7KUsBjW+srA/kEN1p3s14HHlM1iNV7dYARppddsUc07ACCkuXZfcPZqtwayLdh3LXpq
	 1hiOlaq4poZBbDZA44RrPZcXxEiHr4ZgBkBgtZUHT4GlyK0IzQpZIisllmlw4ofiWDvlY
	 QcP3+f/P1A4dXjHSUNGq2wDezAfKgyo9nKDyl6NtftYYq/R0aBMAQ0B7tZkevvif0LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=bvDASxuK;
	arc=none smtp.remote-ip=117.135.210.7
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C522606A33D;
	Mon, 16 Nov 2026 13:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C522606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=bvDASxuK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=e5
	d7G5fQH0I1PriZkyL6VwsluxywSSfe7HXVYmJzQx0=; b=bvDASxuKqIfuA+y0Lw
	NZ2Y5Zq+0Ma66gOjLM1lPa2d433jiXRYixdB5LFW7QGfkRBy08I1jXHkvNgmt/8u
	csjd/Ljkzh1c6+HQokIjt6cm5Ff0/9YnsdOsDXrxK2l5MsIzgKdljIbDQZp+0ZGl
	IEy9e77J5x9ONUG9zecCkC15I=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCkvCgD3HwFW__pqIFseDg--.45028S5;
	Mon, 16 Nov 2026 21:04:26 +0800 (CST)
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
	linux-kernel@vger.kernel.org,
	horms@kernel.org,
	alexious@zju.edu.cn
Subject: [PATCH net v2 1/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Mon, 16 Nov 2026 21:04:06 +0800
Message-Id: <20261116130406.1171-2-jinvas@126.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20261116130406.1171-1-jinvas@126.com>
References: <20261116130406.1171-1-jinvas@126.com>
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
X-CM-TRANSID:QCkvCgD3HwFW__pqIFseDg--.45028S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrW3Ww1Utr1fJFW5XFWrKrg_yoW5Jw4DpF
	sxGryDKF1DJ3WxJa1kZ3y0q3s3Ca18JayrC3WSk3y3twnxJr1F9FWru343CFy7CF4rJasF
	qw15Zw17AF9xGa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRGjgsUUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBshpvBmr6-1r6aAAA3m

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

