Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793352325;
	b=gURpRwFH5GfZz4vjhbbxludXpTTakiYsV/tR33Uxrb2xzNI5nfk2GZZTRDzamudhGIKN
	 1tScjutYvJjRjHlWVQbU0/dl76JWc/IuCQUGMKDQ4s3AKnLPRBV/jzsvcCEkIB1OfKnqa
	 KZvonU6uJ3UiF2xy8rbH2gtcl75aAKBWX9XZzaTfJGvgHJrwQfKRobgxmuhJi/wp6WKZ4
	 8/1jLpZLI0PMxOshOmnCX68rwrjWr0c11hEvh102S2mh4KsK28A0nwQQuS6qW8vx2XV4W
	 pr2LrQtUKsu7pDs8h5sH36xZKbNWCB3muLFS8zRKd2xQB+dTlkHjO2RjHwVVB/KCy5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793352325;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=Tt3y+UuTkMpYq7CgJbHHaL9aJxvBJ2paUZeMqik7+bI=;
	b=IoS3X1FXs5T3VqQXtsSoTQ7jgTuqHQhM/f6VVoAqqzOwvBG1ZsyXGovdcMax13Z0bR3i
	 uhPnBLuFlW6KHnFoR/rMU528qA/q6qAtCdcB71wkxx1X0IhpyLUYTEtoCdE7Z4RKkprXL
	 Z0jqpFmwZ5iiudCosFN7FMsnUeex9VV0U5o+Fp4kxKD7NRG/392QbAzv8otCsG5hKWpp/
	 vrAMnrh1QnmfJuyAglpb71QFxgEfsIPQkmgI2sdaCpi0Oq+BRvXonSYB/MMho0mELMZo7
	 K6Yw2EpZe+OsMtBFaiVRoVx3OsZkQUcg7Rlj+6s7bAKY8BikzYKdlGDmDL67jzI+WFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E8606A31A;
	Fri, 30 Oct 2026 09:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B4E8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793352308;
	bh=aKX1/S2mfYw5Hzvs4bviP6L+8bTnXKeTekD7mfKGDgw=;
	h=From:To:Cc:Subject:Date:From;
	b=ifxQVelarcc6pweKaDz0CIBS+U2eVE86pII6UQw1/pmwOp7X+/57x1fhVMgzRJOfO
	 rnDwj+D/R/gfvF97C7gNDLTrFcnFip6+UMtdOSCFyf2NH3CPn0wsZ8anG7kPikd2Xa
	 1kwm1XBdFz7heKST14X36d9z6d69k5IJtAHqXrdq7gFn4m/ivD/G2ggtM+Ayb6jROr
	 HJlCt5u6tXLDkyAUHXfpbf+2DO6wJrVtS2VDdaT9oZUqz/FtG5aeymu6re0PeR5ZtN
	 bCLZcIDIRv1jpPpqCQhgztgWVvYTXtl530gbuBhR9Lfyfuab4c5ojlsrOAybC7eNjJ
	 mKMwsqKJOnM/A==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 0D90E25623;
	Fri, 30 Oct 2026 12:25:08 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Fri, 30 Oct 2026 12:25:06 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.26.228])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jGFym3NFVz1RNM;
	Fri, 30 Oct 2026 12:23:44 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10/5.15] =?UTF-8?q?RDMA/mlx5:=20Release=20the=20HW?= =?UTF-8?q?=E2=80=91provided=20UAR=20index=20rather=20than=20the=20SW=20on?= =?UTF-8?q?e?=
Date: Fri, 30 Oct 2026 12:22:55 +0300
Message-ID: <20261030092256.404-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/10/30 09:04:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 133 0.3.133 d508d579b02cdb6df47808421a9b9e12fc9fb75b, {diag_burst_silent}, {Tracking_one_susp_tld}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;patch.msgid.link:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207127 [Oct 30 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/10/30 08:35:00 #28764057
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/10/30 09:04:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Leon Romanovsky <leonro@nvidia.com>

commit 449ae7927152e46acbe5f19f97eafdae6d3a96b1 upstream.

Free the UAR index returned by the hardware.

Fixes: 4ed131d0bb15 ("IB/mlx5: Expose dynamic mmap allocation")
Link: https://patch.msgid.link/r/20260611-fix-uar-release-v1-1-f5464d845dbf@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ mdmitrichenko: Apply the index fix to mlx5_cmd_free_uar(), as
  5.10 and 5.15 predate the DevX UID-aware UAR helpers. ]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-74296

 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 56151a616b07..a0d3eba45639 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2262,7 +2262,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_free_uar(dev->mdev, idx);
+	mlx5_cmd_free_uar(dev->mdev, uar_index);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
-- 
2.43.0

