Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450672;
	b=k7phSdOTl5kND2DwSDMJtbj0rEHYgxcBIJu8+9IuyMBJDjUaVLqOpq+JyE9crcUFWiT0
	 Cp3V2mtcVllEjbmIWrBQIJ/OT2tyRGb66bmRuznNUJ6wYAKBez3D69LVkjAMmMiTVtpEN
	 lzQ1EFiDJbIayfIYqwD35BRAQxPHWiP99yJyt5ahdWITnV3Hax4qjhMPpOz9xg3O5YAY/
	 HP0KpceOpcYfv0UU1J0z3dyT0DQY+LtmxGVkCrpUWcK+mZR4Z+7XOXMAF2GVaJ2I6whMx
	 jYkOwzTQS/xiMMMHsm0lxS/WdC9sTDaQ6ZvS1zkYdY17sKJptQlOi8YeI5olJWHHjYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450672;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3CWR+vMXWt3mBJZisyf3GWzxuDJnUbQNp9mDBk4w9RQ=;
	b=W0grcm9IvdBDlJyZfQOTymDKokg8bv8N0NZmNe9iBruch7W4laoLjxJbYaujnTyvLSmy
	 hNHurdK4poiogtSfjXpeOYD2aIM8JycGuDUShzmTvsGnemxnwYYiAaQoa3M4LZWI3rx37
	 3KawTdemkxPXo/2LFuUobfR0c8jbXc+BRClHSkUMKuf8M+lkNFA8co+AEL0DFdLBt7b7X
	 ChfvNkDcikxWxNsOtKUxLtOmVFKKF41zoMzaU9n/2/D0yWveAfdVAmgwHk70bgw6E8cQ9
	 2AtJTosamly6qOZotECT1DIEsohywxb9tCzDCv10qkD1nun8emjXGbQxEdaAPHNyRkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ofhdVLAz;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227C2606A323;
	Thu, 12 Nov 2026 02:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 227C2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ofhdVLAz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ofhdVLAzTPFZcSZJsyOyCT2XgijXo1G1dU/Zi+Fp50nH1GmOKo0BEb399k7ARZxZuUreX+8V6+oaN
	 efuT6RQmMiYFEP8bq5eECCWTyeF/gZPNEBIWog3BOgbAXaV4PTauVpWKyuOjpsL+WScHjiY2zVNexd
	 WTJxH/GNJYEO4A2Y=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56af524eda15-da11f;
	Thu, 12 Nov 2026 10:31:10 +0800 (CST)
X-RM-TRANSID:2ee56af524eda15-da11f
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36af524ecf54-ee2e3;
	Thu, 12 Nov 2026 10:31:09 +0800 (CST)
X-RM-TRANSID:2ee36af524ecf54-ee2e3
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] RDMA/mlx5: Return ENOMEM when allocating a MEMIC operation fails
Date: Thu, 12 Nov 2026 10:31:08 +0800
Message-ID: <20261112023108.118187-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
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

When a MEMIC operation is not already mapped, map_existing_op() leaves
err set to -ENOENT. If allocating the new operation entry then fails, the
handler returns that stale lookup error instead of -ENOMEM.

Set err to -ENOMEM before allocating the operation entry.

OpenAI Codex assisted with analysis and patch preparation.

Fixes: cea85fa5dbc2 ("RDMA/mlx5: Add support in MEMIC operations")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 drivers/infiniband/hw/mlx5/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 7a6fe4fea3e2..61727118d1b4 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -228,6 +228,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 	if (!err || err != -ENOENT)
 		goto err_unlock;
 
+	err = -ENOMEM;
 	op_entry = kzalloc_obj(*op_entry);
 	if (!op_entry)
 		goto err_unlock;
-- 
2.51.0



