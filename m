Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795511768;
	b=JJOzp11Jr+qo6cMu9BQIpqbgFhfgVOS+x/rIAM+0YsX5OX3Sjfu8b2xULFmKmleYCeNO
	 CdroKR85QMUVCBVu9tx9WXSMM5l9VoZHehuqdQ0X+b9ybl9ADWbpLEvyJ3SkneES7RhEh
	 /WV46I67NI9GXdeGjgoEKtQ2XVO8g94ICE1dBqaAphXN+eep8hZH5TQnxyDR+2HGhvjzI
	 SZH6YOXVuXwt9fk1cglzwJqrF3IxV5sC35dUF5K61p3c5ldF74jc5bvoS33PMJJLHOjsv
	 GEFikkRTlBIEYkBMFjHRt/Tpaipe3WzsuYW7oxy1Zt0620b1z/AOcwNVFPJeoDt3lgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795511768;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=WaQAgbQn7LYluCU0HRYFUIsBUjFMTbLtny5Gyx7kShE=;
	b=OKWrcEr3H7KIatUWIKXSmsyAb7g1R2bUA1rrRrSh3mPLc91PxZxuQ/DMCG2nDimaITEI
	 JscSkNmhMzJHuIxvO88P0x5YTGqH29bA/k66z1Vusqul2meDTjiZrA2ZxGiv6IGeMmoVn
	 A9eiJ3b7EfhXsaqevmldErZ3qJpOY1Qjc8uQcvHpRtmxQ1GJZG72tvOuKd7rFL/fhuFw0
	 Q+rFqNjeiXRoRNhd7pjsRiiaETgIuolHvcoqEHx9fh90DzVrEh7sGlxTVfiY2MZbFP6Lo
	 +8AY97IW+Iiq7NrqnEtMxZwz6j1DutFMmh+0m7M6BvywXOcWAwi8p7RGEkgh/Zuk1nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=R2WvJpZW;
	arc=none smtp.remote-ip=117.135.210.6
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D62606A31E;
	Tue, 24 Nov 2026 09:16:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3D62606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=R2WvJpZW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Wa
	QAgbQn7LYluCU0HRYFUIsBUjFMTbLtny5Gyx7kShE=; b=R2WvJpZW/7F5KdH0N6
	qF79ePd07ae+TMZtiHUDPPBxAd6WgOFIFD6jIdSlsqoqIL2FPfQjE9PlieJB7k82
	IQeDoH2bDB4E2+UucOtxBH+ZYVBX3tM+jSU5TdRslxF4xiFBcwHNvB7Z++Ka4vrI
	Hfea6YX45ZPEJCjy9WKBvz1mA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDXzz+hVQVrYLMcDQ--.60726S5;
	Tue, 24 Nov 2026 17:15:16 +0800 (CST)
From: Jin Qi <jinvas@126.com>
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
	alexious@zju.edu.cn,
	Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH net v4 1/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Tue, 24 Nov 2026 17:14:55 +0800
Message-Id: <20261124091455.1714-2-jinvas@126.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20261124091455.1714-1-jinvas@126.com>
References: <20261124091455.1714-1-jinvas@126.com>
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
X-CM-TRANSID:_____wDXzz+hVQVrYLMcDQ--.60726S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrW3Ww1Utr1fJFW5XFWrKrg_yoW5uw4rpF
	45Ga4DKF4kGF1xJa1kZ3y0q34rCa1Fyay5CF1Sy3yayr15Jr4rWFyrury5uFy7CFWrJ3sF
	yr15Zw1jyFn8JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ptQ6p_UUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBpQSaMWsFVaRM4QAA34

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

The bug was hit on a virtual mlx5 device whose firmware answers host
mailbox commands. The device took longer than the firmware's own
timeout to answer one CREATE_FLOW_GROUP command, so the firmware
reported the command as failed even though the device had completed it.
The host then took the error path and oopsed:

  Oops [#1]
  epc : mlx5e_destroy_groups+0x38/0x6c
   ra : mlx5e_destroy_flow_table+0x10/0x30
  status: 0000000200000120 badaddr: 0000000000000000 cause: 000000000000000d

Note that the host oopses on any error returned by CREATE_FLOW_GROUP,
no matter where the error comes from, so the trigger is not specific to
that firmware.

The fix has not been tested: the patched kernel was not booted, only the
original crash was reproduced.

Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
Signed-off-by: Jin Qi <jinvas@126.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index c5e62d7..6baffc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -265,10 +265,8 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 		return -ENOMEM;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		goto err_free_g;
-	}
+	if (!in)
+		return -ENOMEM;
 
 	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
 	outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc,
@@ -338,9 +336,6 @@ err_clean_group:
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

