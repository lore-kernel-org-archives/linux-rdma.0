Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406828;
	b=oZnsvOJZREIk0eGlqoO1+EnhiEGT3D52rwcUkoC/Z8Y+L9REg58ztnpRHrXdGxAUxwE5
	 p6wu8auwXh0Bnetyjy4VNAYE/81k91eiVa/O+gTTkCcr/oaqDbyzCNP+zPzqKIQ4fCkIX
	 YxOe8TxZMNzTPNOcl2iqZRhclao/1UbnYdV7ckgmz8392ZQ+Akp17ad3QXH5bSElrJFne
	 seDmkrkS8Fd19z1hHd6iXr7Z+u1WdIVnoLCfQ42wtztpdOZj0N1RW0hn0xKnytmjBEFwb
	 5iEHTkMOpaKJDFb3vHzUOPf6hywNP71O9+l4fUn0yMG21J115+ztF8fhDJKp9rmoxOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406828;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=j8xUr+VsZ7j0Cv4f3WmQPH0L/AQ6itr/WOZmS/klk/4=;
	b=bKUUOq9RISeDWO7TVfQRkc5YxTcqbDx7NMFMO8AG5DSkZqWvnJcezPApuuA4bsrKCNS/
	 0MzNYBCYls4brH5Ly7Or+qw6CCkRklEZ+37GaLqtIfb0OlxL1E2epKCfqg3uZIL7hueli
	 qGrsxd2XmKfWQflO+3kY2+eQmgp+a/fH7iuY+mCbYMNSvy5xj95jWVvNkQefbPSjvQg4I
	 PflFhODTcScSbjkRX4kPKnwRY6724wZDSnto4L8FqVS0YwoBV8Iq/B8nsHWFVNv9oxvbk
	 BWIjt8mQl32nvenUBX3bqPfPFgFe01M+VGtcOf1WgPjkDeTqO06ZZXHFII6OVuAZ1jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FqGNcWRp;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AD9606A32E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 04:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9AD9606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FqGNcWRp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=j8
	xUr+VsZ7j0Cv4f3WmQPH0L/AQ6itr/WOZmS/klk/4=; b=FqGNcWRpH7MXIqreXS
	X95Xdvbs9wUm7TqiXCp07eQlHjRaHQjestZ4MVSJ0NAGuxGGX8t8CkHFdl3dYWX1
	PU2NzHCpUFO3ZLBnAvhpUzD+kKi1/MmW+fZHZDrUXfGnQ+E7iyQwUHfKqPOk0YgE
	IHUtMbZ2hEx+PrAEyTRyS1AxE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAX9yN9uwNroZpVJg--.43437S2;
	Mon, 23 Nov 2026 12:05:17 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dledford@redhat.com,
	larrystevenwise@gmail.com
Cc: linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH v2] infiniband: cxgb4: Add cleanup on failure path in c4iw_init_module()
Date: Mon, 23 Nov 2026 12:04:58 +0800
Message-Id: <20261123040458.1880180-1-fuwh1120@163.com>
X-Mailer: git-send-email 2.25.1
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
X-CM-TRANSID:_____wAX9yN9uwNroZpVJg--.43437S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrWruFW7Zr47tryfWFW3ZFb_yoWDGrc_Kr
	W0vw1kWr1Y9Fn5C3sI9FnrZrW8tw1YgFZ5Zwn2qas7Jry3ury3Xw4kurnxXw43Wr47Arnr
	W3yjgr4xGFn3KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1-6ptUUUUU==
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7R2pSWsDu31cUQAA3z

Add c4iw_cm_term() and debugfs_remove_recursive() if reg_workq is
not allocated successfully to release memory.

Fixes: 1c8f1da5d851 ("iw_cxgb4: Fix possible circular dependency locking warning")
Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
Changes in v2:
 - Add Fixes tag as suggested by Sashiko.
---
 drivers/infiniband/hw/cxgb4/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 24ac9871ce67..e337494e30ff 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1548,6 +1548,8 @@ static int __init c4iw_init_module(void)
 	reg_workq = create_singlethread_workqueue("Register_iWARP_device");
 	if (!reg_workq) {
 		pr_err("Failed creating workqueue to register iwarp device\n");
+		debugfs_remove_recursive(c4iw_debugfs_root);
+		c4iw_cm_term();
 		return -ENOMEM;
 	}
 
-- 
2.25.1

