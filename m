Received: from forward201d.mail.yandex.net (forward201d.mail.yandex.net [178.154.239.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CA339A7FE
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 07:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791415; cv=none; b=KfQQRo1YWGgji+F83CeiRsi0cTksI/2WpyvZnzPZGElNWMWbQhW7twCMZHdQl5vwdYVUu57lcgfvXgWPkjyEW3nsDwNG+HPruYtmDivh+2byGzXvjXffSzp9QDpR2ewyY7xG6SgblGaN/hHUBIcOWIE9cmc5C8IpMghg5aMCQXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791415; c=relaxed/simple;
	bh=ooEUQWjxV8v5SQgITmqdR3ilWoOZLdqiiRzSgF6VdUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qJvNij9SCRdnQv3A2Exzxbm6lO6MWhgUf8BjnTiUJgP4DqJt2Pi+N1p8fkwLKnmnDxfBevkx9Uc+ZKnfCEEDaqmHt3XmnUhksXGu6mvWEpwuPola3u2kf6IktAQcKHLcJBG1mFZ2/m9E/mjQOInxkAtk0QCy9wfwQg5FNEo6NQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=h2ECycRp; arc=none smtp.client-ip=178.154.239.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="h2ECycRp"
Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d103])
	by forward201d.mail.yandex.net (postfix) with ESMTPS id 3E56082E1F
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:17:03 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net [IPv6:2a02:6b8:c43:d788:0:640:6e4d:0])
	by forward103d.mail.yandex.net (postfix) with ESMTPS id 29D93C46B4;
	Thu, 23 Jul 2026 10:16:55 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (smtp) with ESMTPSA id rGSxKKCfB4Y0-VMQza2a1;
	Thu, 23 Jul 2026 10:16:54 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784791014; bh=zxfifl0QK0rDVYxxz0lUKL38no/swF3UcTCxMGtW9uY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=h2ECycRpQ8Gb1WaH5kaKWBMn0AuiI/+TVbxRCdhwJcvnoO11fRmbMOxLdmkGWt3+9
	 p4lgDXdKkhpC5QhDBCxB+GxQLJwtTeDG49HwKXOurRKjrT95kuhthDxqboKTrN8TMD
	 uXLhjfN7owoJPaEtrNL0SXrPdZWy4m9aQRh29rho=
Authentication-Results: mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] RDMA/bnxt_re: simplify bnxt_re_cc_config_set() and cq_coal_cfg_write()
Date: Thu, 23 Jul 2026 10:16:29 +0300
Message-ID: <20260723071629.568675-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify 'bnxt_re_cc_config_set()' and 'cq_coal_cfg_write()'
by using the convenient 'kstrtou32_from_user()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/infiniband/hw/bnxt_re/debugfs.c | 31 ++++++-------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/debugfs.c b/drivers/infiniband/hw/bnxt_re/debugfs.c
index 143e9bfc6b79..efcfec8ec25c 100644
--- a/drivers/infiniband/hw/bnxt_re/debugfs.c
+++ b/drivers/infiniband/hw/bnxt_re/debugfs.c
@@ -308,21 +308,12 @@ static ssize_t bnxt_re_cc_config_set(struct file *filp, const char __user *buffe
 	struct bnxt_re_dev *rdev = dbg_cc_param->rdev;
 	u32 offset = dbg_cc_param->offset;
 	u8 cc_gen = dbg_cc_param->cc_gen;
-	char buf[16];
 	u32 val;
 	int rc;
 
-	if (count >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(buf, buffer, count))
-		return -EFAULT;
-
-	buf[count] = '\0';
-	if (kstrtou32(buf, 0, &val))
-		return -EINVAL;
-
-	rc = bnxt_re_configure_cc(rdev, cc_gen, offset, val);
+	rc = kstrtou32_from_user(buffer, count, 0, &val);
+	if (!rc)
+		rc = bnxt_re_configure_cc(rdev, cc_gen, offset, val);
 	return rc ? rc : count;
 }
 
@@ -374,20 +365,12 @@ static ssize_t cq_coal_cfg_write(struct file *file,
 	struct seq_file *s = file->private_data;
 	struct bnxt_re_cq_coal_param *param = s->private;
 	struct bnxt_re_dev *rdev = param->rdev;
-	int offset = param->offset;
-	char lbuf[16] = { };
+	int ret, offset = param->offset;
 	u32 val;
 
-	if (count > sizeof(lbuf))
-		return -EINVAL;
-
-	if (copy_from_user(lbuf, buf, count))
-		return -EFAULT;
-
-	lbuf[sizeof(lbuf) - 1] = '\0';
-
-	if (kstrtou32(lbuf, 0, &val))
-		return -EINVAL;
+	ret = kstrtou32_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
 
 	switch (offset) {
 	case BNXT_RE_COAL_CQ_BUF_MAXTIME:
-- 
2.55.0

