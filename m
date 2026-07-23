Received: from forward200b.mail.yandex.net (forward200b.mail.yandex.net [178.154.239.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F634CFDD
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 07:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791153; cv=none; b=CiWXWBz4T44NmR+RJc9IlVT/4ZWD15iolz56lrZ+LkdtDO5ctrlTtPyzZCQ4EYq72ZbqGVzk/Y0ejfuFDiMOu66IrbgX5HnIRNVJOqt/4OmYZv4vo7nWR8QPswK+3gePdF0wl1v7JEWUkvX36X72tjat2pE+FEGzrqudp/06WkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791153; c=relaxed/simple;
	bh=MJIMtv6lBBsuULefP8FyIl2mgnKtW3LJEwGZPSirpug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aSyaq+r5gvyLgiY7EWtf1UPXdIq6FsB6nhWW9GBKBCUlRjWOtle6Q1MH0tFwEt+GFBKFbEyn3OMSdhtyB6zDX/Y+hFVonBXff2QQ6pFB+CnXU9fZgMCMbH33Mt7gDo1iJ3fZS14XSxVBXbbzMkHK6Xhs22blV8cXrotGyFJvI28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=lZ481y57; arc=none smtp.client-ip=178.154.239.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="lZ481y57"
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d101])
	by forward200b.mail.yandex.net (postfix) with ESMTPS id 4A21F81DC5
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:18:56 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1b8e:0:640:314d:0])
	by forward101b.mail.yandex.net (postfix) with ESMTPS id EBE77C1CAB;
	Thu, 23 Jul 2026 10:18:47 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net (smtp) with ESMTPSA id kISlKQ9dISw0-sIKJGkfm;
	Thu, 23 Jul 2026 10:18:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784791127; bh=qITUYaGNta4BCt2Ovkku95guiWf9gFCCWy4tKECYIT0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=lZ481y57MkJnkxiL8/r8dDvk7WEAJb6x7wabmdbkhHmozu6j/5bp4hawKR9Xg1yXA
	 2lvRPgJi0bx8BcRpUcNlXp+D5O3FGFgt2kO6YU9lbZXHN30t0DeAYAUM2g6JDegxFr
	 hdS/HtxkSmPjfrJtfH3kvCBN/ajYz0b9IsqlwFwE=
Authentication-Results: mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] RDMA/ocrdma: accept boolean value in ocrdma_dbgfs_ops_write()
Date: Thu, 23 Jul 2026 10:18:45 +0300
Message-ID: <20260723071845.568718-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since reset is actually controlled by the boolean flag rather than
long, switch to 'kstrtobool_from_user()' and use the latter for an
overall simplification of 'ocrdma_dbgfs_ops_write()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 26 +++++++--------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 0834416cb3f8..8f26f62f2243 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -635,39 +635,29 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
 					const char __user *buffer,
 					size_t count, loff_t *ppos)
 {
-	char tmp_str[32];
-	long reset;
+	bool reset;
 	int status;
 	struct ocrdma_stats *pstats = filp->private_data;
 	struct ocrdma_dev *dev = pstats->dev;
 
-	if (*ppos != 0 || count == 0 || count > sizeof(tmp_str))
-		goto err;
-
-	if (copy_from_user(tmp_str, buffer, count))
-		goto err;
-
-	tmp_str[count-1] = '\0';
-	if (kstrtol(tmp_str, 10, &reset))
-		goto err;
+	status = kstrtobool_from_user(buffer, count, &reset);
+	if (status)
+		return status;
 
 	switch (pstats->type) {
 	case OCRDMA_RESET_STATS:
 		if (reset) {
 			status = ocrdma_mbx_rdma_stats(dev, true);
-			if (status) {
+			if (status)
 				pr_err("Failed to reset stats = %d\n", status);
-				goto err;
-			}
 		}
 		break;
 	default:
-		goto err;
+		status = -EINVAL;
+		break;
 	}
 
-	return count;
-err:
-	return -EFAULT;
+	return status ? status : count;
 }
 
 void ocrdma_pma_counters(struct ocrdma_dev *dev, struct ib_mad *out_mad)
-- 
2.55.0

