Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974EE3845B0;
	Mon,  8 Jun 2026 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912531; cv=none; b=uts/UigW82bZchfpAxaYao8rKLLlYWMv3Rmfjmcp2Grn+IRczEFvs4SmiJoRE2v5L6wzmBsCFXFsR+qDWE9rd9SssCY3r6Bdv0ix1Qw3YF7J29LOgHfozoax6hBdqCmw3tUUfsrzvvRSPRhMcVjxKNKd5AVtoGR6C+Qtq3yYFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912531; c=relaxed/simple;
	bh=Zztz1u/duImZ6qDe/hG/IhE4Fydnxy/Lc+F0nVUd0fA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p6zNEGq4J7d5M+JtJeZSqZdDX7/9G5nqYQMDlpJUdWcXLfx6zJ/hIiV/mGqusMpaoRqyIWKmxqLeMW68W1uFyVsHbu0SgRSCw54QZhXOgFwQnhtURzaG61FQkDKKvSrubKKUMFBlCGREqGy2y8ShkAWFhJ3iq6QO1XerDiDrK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=OS5PYBjr; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="OS5PYBjr"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhR-00Bqzp-J4; Mon, 08 Jun 2026 11:55:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=voJBsb3A4wHwFuXD3vB4XhY6D6VfDleS4LElZswx2V0=; b=OS5PYB
	jrPusINDAB6ohzpxQfSzeDNkQn9/V+ryXRGSN6UmGJDr9LXDk5Z5DuBXApGhzdlR0zp7jSZaai1hj
	iHw69Qdp3phS6q+CfKKIBDnEdnUPuQJQPdKNbDTO9ug+Q3twshy/y+IVvkS0ec3mcYVpbvcxUtu/S
	A8TlaoqA78s/apP5UfrmN5oNiZz8HogeDOmWfhSSSzpJMd8PaWzAgKoyj0U+CXniex73q0HWiMpIC
	rdmMogVdNlalUtqPc6gyDlY0c4/7zvHWXivbV0PQiaDAdztaM5dYatqknPE+fqaLW4aovYX1yl6iG
	sevPla9gFWSaB8hfV8RpGb9xB3lA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhR-0003ZU-3T; Mon, 08 Jun 2026 11:55:17 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhF-00Afz8-36;
	Mon, 08 Jun 2026 11:55:05 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/infiniband/hw/mlx5/data_direct: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:57 +0100
Message-Id: <20260608095500.2567-2-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

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

 drivers/infiniband/hw/mlx5/data_direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index 8e89dbe40c23..d57484245c38 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -88,7 +88,7 @@ int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid)
 		return -ENOMEM;
 
 	reg->ibdev = ibdev;
-	strcpy(reg->vuid, vuid);
+	strscpy(reg->vuid, vuid);
 
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(dev, &mlx5_data_direct_dev_list, list) {
-- 
2.39.5

