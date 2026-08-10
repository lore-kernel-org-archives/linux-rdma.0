Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F318631DDBB
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 01:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786326871; cv=none; b=AvWnyVdBgLYyDW8iFL0XRBcyWPiQoVtz/KzHEwbY0T2WwOeNnckWNWRPuwMxoIXMugtzpMAhsrec6b2YSw7IU89gxYVqmF/w8pbprUkjsTMRFcjBlTzLoP5afsf+gmIe/UULHHRswgRJUB6+QmG36eHmQvSAzYTiBk35CQIhF8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786326871; c=relaxed/simple;
	bh=l/3pnhOtXY1TfP7/TJY3Ktn6LHrXd/3LVPAqyWZkiNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JhOBsnN4F6Uzkvtemb2pV9zjoNM5EZPuhLCVo8vR2gzXw5NXe8/hD/XcDzERNfgKMgeWewUq0I1aXmdWdJkm8ppt9OAnnjdBBH/hVdCipIt90NDv6qNHsgsWmkTi/34uWLPVLAU4igjnWTrGc9vYPeZ1+7cVJjU7EnUrWCZW2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JVuEyRXv; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JVuEyRXv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786326867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uNe0mCmCa+jXQrQD6fIIPrqz8el0B25+aJ4DwDIJ64c=;
	b=JVuEyRXv51ENVAsTvTZKBAlfSjptGtrnB/b0X9mGelnpC/J46L+LqHv2dyOdI9kHom3uFh
	aMicOBoTr4eFWkSMqB8/qE7DkLgoteTXpRPM6K52dkcj1+k11m6JXVRxlF6mJhuFVc4HTR
	+wPsLL1CSHBziQlzg/PwoyJYbrBDF1Q=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	yanjun.zhu@linux.dev
Cc: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Subject: [PATCH 1/1] RDMA/cma: Fix WARNING in res_to_rt
Date: Mon, 10 Aug 2026 03:53:57 +0200
Message-ID: <20260810015357.23724-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

syzbot reported a WARN_ON(!res->dev) in res_to_rt() triggered via
addr_handler() during asynchronous address resolution:

"
WARNING: drivers/infiniband/core/restrack.c:138 at res_to_rt+0x1c4/0x230
CPU#1: kworker/u8:4/59
Modules linked in:
CPU: 1 UID: 0 PID: 59 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Compute Engine, BIOS Google 07/24/2026
Workqueue: ib_addr process_one_req
RIP: 0010:res_to_rt+0x1c4/0x230 drivers/infiniband/core/restrack.c:138
RSP: 0018:ffffc9000201f850 EFLAGS: 00010293
RAX: ffffffff88d00ce5 RBX: ffff88807f0fd4f8 RCX: ffff88801e6e0000
RDX: 0000000000000000 RSI: ffffffff8fd996f0 RDI: 0000000000000003
RBP: 0000000000000000 R08: ffff88801e6e0000 R09: 000000000000000a
R10: 0000000000000009 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff1100fe1fa9f R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff888125012000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001d559c3d2000 CR3: 0000000077c4c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rdma_restrack_add+0x5a/0x8a0 drivers/infiniband/core/restrack.c:236
 addr_handler+0x41a/0x5a0 drivers/infiniband/core/cma.c:3534
 process_one_req+0x2eb/0x540 drivers/infiniband/core/addr.c:624
 process_one_work kernel/workqueue.c:3375 [inline]
 process_scheduled_works+0xc4e/0x1630 kernel/workqueue.c:3458
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3539
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
"

The function addr_handler is invoked to process the resolved destination.
If address resolution fails or encounters a state race before an RDMA
device binding is established (that is, id_priv->id.device remains NULL),
id_priv->res.dev is not initialized.

addr_handler() previously called rdma_restrack_add(&id_priv->res)
unconditionally upon handling the resolution step. Passing an uninitialized
restrack resource with a NULL dev pointer causes res_to_rt() to hit the
WARN_ON(!res->dev) assertion.

Fix this by adding a check for id_priv->id.device in addr_handler() before
registering the CMA ID with restrack.

Reported-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
Tested-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Fixes: cb5cd0ea4eb3 ("RDMA/core: Add CM to restrack after successful attachment to a device")

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc24fddf9aaa..35e463a20ade 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3531,7 +3531,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		if (status)
 			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
 					     status);
-		rdma_restrack_add(&id_priv->res);
+		if (id_priv->id.device)
+			rdma_restrack_add(&id_priv->res);
 	} else if (status) {
 		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
 	}
-- 
2.43.0

