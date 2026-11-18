Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009612;
	b=ZXMYBjQAaxf2LE7MENxmIN//8vqeqk1bCQfVzlRh/WV+S6pdB8Wijq4omOHvS65dZI3V
	 NM6yDUpK/OAXWV79k0FKineCWVOrDWuX3UNbc/Qvyj3XOnt1oHZjREviOOJksk3R7P3Dp
	 uetcD2gDCEOZsCcZgISoTSlWBhbrCO43hFeW6yBlWkJBQqdTyelrN5M8jCeFJN0Hyntin
	 yPoAGbft1g2CkH3ntup9qhEz2gCX2yf5Qdhx6KQCins7TZCCiLDycJuAFHspPYeEte+AR
	 iubaL7PRvAgiq4ypQNeq/XdvnX71VSTnzdyicp79DkaylK0w35ietYC6tKp6pICdKnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009612;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=Ej0+BcS+/DetGmL213LeSEXzNIKIImFW7sTsnOy911s=;
	b=4rnzMNDqL1pbZC/CHObh3NG5K6kxtFXNH1DDI6xB6lB5/WZtRYZWFtJNipwpJ6E7NDr8
	 C0XptpBSDJOm9vECIS9Xsr4TJ7LMl7V9slene+UcTqoXeZtHNCOxekbz2pt52RHsFE3PG
	 58V3rY7WWjtjgz6cnXIfAEZVQgMyEy4NML1Tlk/chY0n5pVaRdNfRE+OfbINRODIzJR/D
	 wbQmSnWhDoIm5JoV80RVhaBnPSEhR4LrxVFVzSoIcsBofFvMtW05yUtB+updDmdTAL37K
	 OMfpMf+4J7FYWNK2XdzjECkP7jB9o/fhAGHk8HmdpOXw8DmAisJRH+CMKD0SjJs9XdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=kG5Ag9GB;
	arc=none smtp.remote-ip=117.135.210.7
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECB8606A325;
	Wed, 18 Nov 2026 13:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ECB8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=kG5Ag9GB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ej
	0+BcS+/DetGmL213LeSEXzNIKIImFW7sTsnOy911s=; b=kG5Ag9GBo3DpxFbHEj
	m14v4Z32PGU492deFbMAxxsjWLUJvp4lVo0yu5Am9zi+7EMhylAxxm3LlmUcnSby
	izgQJ0r2ijEMhU1Ng4fFKpXe7xheZx3zuCF6tcSONcrAMlvOiMYTXJbXHJzfiGqW
	j76B34x28F17lVVLLsNZcDQBE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD37yb9q_1qGwFIDg--.29240S5;
	Wed, 18 Nov 2026 21:45:37 +0800 (CST)
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
Subject: [PATCH net v3 1/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Wed, 18 Nov 2026 21:45:14 +0800
Message-Id: <20261118134514.1765-2-jinvas@126.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20261118134514.1765-1-jinvas@126.com>
References: <20261118134514.1765-1-jinvas@126.com>
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
X-CM-TRANSID:_____wD37yb9q_1qGwFIDg--.29240S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrW3Ww1Utr1fJFW5XFWrKrg_yoW5Zw4kpF
	45GFyDKF4kGF1xJan7Z3y0qa4rAa1Fyay5C3WSy3yayr15Jr4rXFyru345uFy7CFWrJ3sF
	yr15Zw1jyF98JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRGjgsUUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBsgFF22r9rAGXlgAA3W

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
Signed-off-by: Jinvas <jinvas@126.com>
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

