Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8E3C4555;
	Sat,  6 Jun 2026 20:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777642; cv=none; b=En7qhZcUfdV2w31UhsxArFVoyp6edIYWVRuReaP188jvGYiTOUjGvn9Crp2XvMpVVuZISjit6HP8M1BaFT36lUdwAMziIg6blIxgHKm3tKQ99GxrQ5vJeFXWsKr/IfjuAuEKSfOMwBLS6HxkjmbM63hpQaJLCDhlPfeT4XsJDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777642; c=relaxed/simple;
	bh=60GhU5nfn1dcSPfNgqoEWpdbfiTpBZVEeUq8sGJ1YAs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sHdF7ZQqjiV2MzpnyiD116XQOrvnV1lmt/Kuv4yqD6U4jCnP6S1Yl7N/5dprEwyXU/pnCFUGyQItxC294TC0zPEmq/pIZ8N+Fd+oVv3KnURr5p9ZKPv0Zg+PCNs/EklHTr+lNWVXfyv0pxJCLiWdecyODFyBTQhQDLYneA1imRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=VAkh6slO; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="VAkh6slO"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbw-007NSJ-JR; Sat, 06 Jun 2026 22:27:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=OgbWETt8y3Kh2+PkVcQz64kPsl9ny/WPbqSwE3sltpc=; b=VAkh6s
	lON5LUyJIBHoFVsQdPBvKuXClWKeGlF+2pKE7rOPHzqFt1XgSSeNsnF1GuCo/4wo8okfH8NUspb+g
	isdaarBiaFWwzV1DCSVavyzlhztlLtm5i7SqTdrtWjI79vqLKdVhiHfm812nZVq6swh+GO9QKHMZp
	SJCD6whaJUf5uqW9tH0qgQxhO2kWSMtiz6T39usMXh6qlPk2BPIZpFwFWonDmuggOLhOfShaIknar
	Ltkky/YIuOK7+WQLRNtJzSPnwWv2qzVLsnMf+EXcAugSSZrCUd/+C08VBt2xS0RXNV/6joV0xT9c8
	A94+3lCl+9eFAMlu0F1XAJiELQSw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbw-0000uO-6b; Sat, 06 Jun 2026 22:27:16 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbc-006V18-UP;
	Sat, 06 Jun 2026 22:26:57 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/infiniband/core/iwcm: User strscpy() to copy device name
Date: Sat,  6 Jun 2026 21:26:04 +0100
Message-Id: <20260606202633.5018-10-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/infiniband/core/iwcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 9761d9365ffd..0b7246ec559e 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -518,8 +518,8 @@ static int iw_cm_map(struct iw_cm_id *cm_id, bool active)
 	cm_id->m_local_addr = cm_id->local_addr;
 	cm_id->m_remote_addr = cm_id->remote_addr;
 
-	strcpy(pm_reg_msg.dev_name, devname);
-	strcpy(pm_reg_msg.if_name, ifname);
+	strscpy(pm_reg_msg.dev_name, devname);
+	strscpy(pm_reg_msg.if_name, ifname);
 
 	if (iwpm_register_pid(&pm_reg_msg, RDMA_NL_IWCM) ||
 	    !iwpm_valid_pid())
-- 
2.39.5

