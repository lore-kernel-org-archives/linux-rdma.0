Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324373E3166
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 07:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784790914; cv=none; b=ImTS3Nnh5Nqi4fTstTIGFVIGVYml67xS2GkDMeO6WGy82PUI/eeeL3K7O5sXWGhwC3a1/QC3uYt86i9fYmFnFSDlS9jNfB1u8XtxRj6eMelzcO41TGWIIAq76nIcpaahzE0xBgJC8ofkFcBSY6du3fQcfpWg5Nu9RtIP2BjnYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784790914; c=relaxed/simple;
	bh=jFSMBFPUdgDMijtbvqwBNQav9kK5/Ksd/D6pePswIw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iPKvVG0d9J6cC6OeFInechZS6sy86TLDgxounYmkUCduar4AbDFxTuxMrzXdUAGQ+X7uJTh31aRxLn6I/PCyyI/2Qvs8m+9sHLm9rIKXbLYNpzgX5JruuqoLi9zBTHrFRqN4VGa/aqmQFobM5IYqHxLINyefJDo/rAvD3Beo5DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=pnGj5Qhx; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="pnGj5Qhx"
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward205a.mail.yandex.net (postfix) with ESMTPS id D9EE1C7F15
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:14:57 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5c28:0:640:9ea3:0])
	by forward100a.mail.yandex.net (postfix) with ESMTPS id 7C1F9C0597;
	Thu, 23 Jul 2026 10:14:50 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net (smtp) with ESMTPSA id nESVFT9dLOs0-nuHaV9uU;
	Thu, 23 Jul 2026 10:14:50 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784790890; bh=8i2ueuNicXkX3jKYYjV344BtobGzRRR4SYJr4pWsh/A=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=pnGj5QhxbadqdBIwlyeqbFs7yZNmy1HU5PLmRQPIZvGpUgAOf2AF8Amm7MJSypgAu
	 ypOfJHXxvStxMfqQSNapi5ZNCXci01LYpQp3QnExDwOgDQdB8INnjuDkDlKKZtEdXD
	 A/kkC5pQ6R5aXd3unTmOak60uuJX+z4WdHf1Du7Y=
Authentication-Results: mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] IB/mlx5: simplify set_param()
Date: Thu, 23 Jul 2026 10:14:48 +0300
Message-ID: <20260723071448.568641-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify 'set_param()' by using the convenient 'kstrtou32_from_user()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/infiniband/hw/mlx5/cong.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index d0edf83a2f20..98c90d0dbab4 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -373,22 +373,12 @@ static ssize_t set_param(struct file *filp, const char __user *buf,
 {
 	struct mlx5_ib_dbg_param *param = filp->private_data;
 	int offset = param->offset;
-	char lbuf[11] = { };
 	u32 var;
 	int ret;
 
-	if (count > sizeof(lbuf))
-		return -EINVAL;
-
-	if (copy_from_user(lbuf, buf, count))
-		return -EFAULT;
-
-	lbuf[sizeof(lbuf) - 1] = '\0';
-
-	if (kstrtou32(lbuf, 0, &var))
-		return -EINVAL;
-
-	ret = mlx5_ib_set_cc_params(param->dev, param->port_num, offset, var);
+	ret = kstrtou32_from_user(buf, count, 0, &var);
+	if (!ret)
+		ret = mlx5_ib_set_cc_params(param->dev, param->port_num, offset, var);
 	return ret ? ret : count;
 }
 
-- 
2.55.0

