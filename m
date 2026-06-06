Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3453CAE76;
	Sat,  6 Jun 2026 20:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777646; cv=none; b=dVExTfpZIKyYYqDDmUND05sp4y3IgdSzeWiABNRQ1dwEKYaM5fAy3en/nOX4hjI/s7IJ0JqLlvdXpJniKOBG2/2g/g/yIjaka1Mn8ufVCQbZAxQP2BFdzeI4iPtWSXOR65ng9RzR0jXOOLilzWEmsw31Wb+bY6HrZQAnB4hdMZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777646; c=relaxed/simple;
	bh=HWs0FkqPXtMy/MWhuNYJlIC7daCtqMaA7oHhC+ZF5ak=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M+JcYsu8ymjdVeQkOk5mHsfz0fVOIJt+yLPoox1KvNR+Dj10Pcrxff8n8Wjrwx6WEg+VUYyQUNTHl811sPeEmE0bnZmyS1FR9ymKeYQKorcSxnEblZqttcn7plBLQ8La6bmh4lb+wXdzxsGtLEBF9oqC1HQn41g0BbZLxwKt9MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=cevgEdbC; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="cevgEdbC"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxc1-007NTw-JP; Sat, 06 Jun 2026 22:27:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=px8InogY6DsQ6dUdF2v3Rtc1TvmbDF6g6As3N88gmIE=; b=cevgEd
	bCm/DltSvHeF9x0nEqF/WnNUng8A1IKMs4Sjr2iYOuYYgZnJ9g2z3py1gJSKGzNVBgPhNt30TgRYL
	TqMPivf2ZA3dXg+t/mlxKDhU1XXuqj5wjryGbbx6x9W1WrHTVsHP9WgC9OkKLi2aywoomP9UZ7dZW
	WipMvFgt3M8UqNHkABj5UknHwJHiyvJ/8k6KvUoahFfXnisaOunQpY8/ZlgwYA/2yLq18CjxIG3HG
	vvxEJBpea7SiJlSbmKeQYacH/nY2azlw7FvCmpVwbGxwP2pOUz/v5suJnSUgLfuypuofytIMrQsPr
	NQhMsJ6MPlkzJZNfIxb83KcHuUcQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbv-0000uI-Uy; Sat, 06 Jun 2026 22:27:16 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbd-006V18-BN;
	Sat, 06 Jun 2026 22:26:57 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/infiniband/hw/usnic/usnic_fwd: User strscpy() to copy device name
Date: Sat,  6 Jun 2026 21:26:05 +0100
Message-Id: <20260606202633.5018-11-david.laight.linux@gmail.com>
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

 drivers/infiniband/hw/usnic/usnic_fwd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.c b/drivers/infiniband/hw/usnic/usnic_fwd.c
index 39cdd72eabf6..59c363db0355 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.c
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.c
@@ -93,7 +93,7 @@ struct usnic_fwd_dev *usnic_fwd_dev_alloc(struct pci_dev *pdev)
 	ufdev->netdev = pci_get_drvdata(pdev);
 	spin_lock_init(&ufdev->lock);
 	BUILD_BUG_ON(sizeof(ufdev->name) != sizeof(ufdev->netdev->name));
-	strcpy(ufdev->name, ufdev->netdev->name);
+	strscpy(ufdev->name, ufdev->netdev->name);
 
 	return ufdev;
 }
-- 
2.39.5

