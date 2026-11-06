Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975632;
	b=Ry7k+qJm0o3yNb0FYgv84Yep8Wa2Dza9HhkdY5Qs9L3xj0kqyjliptCUJH0Lnw7vcOco
	 Eyf+OIvrZmG99X6sJXPLrkJZ/Eo14vsnwGwj27UCdsmUDChJJmIR6DSS3718Ps0AGpPt5
	 dg5bsVqjIP7wdBmpzmSelfA2e5iHZU4K97aJylLlHj3WVJDOONdWnvvtkH1TLXBmaaR6W
	 hOOs+K6D/SHDHa33/HXQvItC/QM2vAYge74YEL4bpaARqD0hasM7eyFtaXKcP8Az77Egc
	 QM3043U02/wll85NI1vUcv9dWvNLLrIg8HsX3z8QPDskCnVk5nItYbnvF4R67m3HBqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975632;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=/1+8e3Hg2HFZU7LiS9ocY4f7VYXwvsrnE+JnKJYAl20=;
	b=flrLzzejat6sQfNGae5bQXPId+u5bA0Mb9zZt7KX7H2sgL7o6zH2avzgMb2q7u9+GbLd
	 tNsMTqVJv0711d+pIwHo4Rf3AC609EV2H9/apCb1qRko0WxSfmzxOfnqhdamdWtXl+Dl1
	 mZ0dws4EnxCbKvTFNiqZ+7ueWWhlAu9fGjoE7mefED7qonMmhn/XyY2dizyBEsvDuYhPs
	 zahxbWGxtAnS4k0hPC6cGgbZkZCjiAIy9gMiIQSuWseHnwkT0N9DDBux+/y5PqkXokL88
	 fctwmCbXCtuITW2aWof3ZFD8OPrHltg1b22YLC1gkiBJf1hxMvGQ48FczVR119NbYPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b="HjDsYe/l";
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A83606A329;
	Fri,  6 Nov 2026 14:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12A83606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=HjDsYe/l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793975616;
	bh=LuNdlr7/2G4byaAbA1MPs/7s62mjQQWWG7PWDKZH23k=;
	h=From:To:Cc:Subject:Date:From;
	b=HjDsYe/l+D0+xAaVeB0PFHXMgKDGG6+Twb3O2h4rozdT2RcxetKL3VURn2dP/o9BF
	 g3dTRB9geivJnmtpWR5PWdii01GV7FmnbmVjdh7bxfzzmz2BUd25N6pFU9JtUqd0Af
	 k4FmGZl4Bi+D93ef7L8vg/AjPga/NlP++RrheE+mlAtPVaYBLVjqAtgZyrVAooABRn
	 g0tcgX4nfP7sPyfUiNzmBcktqhR86/U0IF3w/L21uV/Oo2Gb4Y8X8pJIHYQiCnXOPx
	 DFNcU/JZ9jfLfwDxEdUrZKxsG/q85o95RrcjTpsLIU5Jcwb/8489e0dmHYTqPpib3i
	 ytWV6kHzwnzOw==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 608F724FCA;
	Fri,  6 Nov 2026 17:33:36 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Fri,  6 Nov 2026 17:33:35 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.54.9])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jLhW267jrz2SC3;
	Fri, 06 Nov 2026 17:33:34 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Liu Yi <asatsuyu.liu@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH 5.10/5.15] RDMA/rxe: Fix null deref on srq->rq.queue after resize failure
Date: Fri,  6 Nov 2026 17:32:53 +0300
Message-ID: <20261106143254.1997-1-mdmitrichenko@astralinux.ru>
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
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/11/06 13:09:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 133 0.3.133 d508d579b02cdb6df47808421a9b9e12fc9fb75b, {date_rfc_vio_soft_silent}, {Tracking_one_susp_tld}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;new-mail.astralinux.ru:7.1.1;patch.msgid.link:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207325 [Nov 06 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/11/06 11:41:00 #28808023
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/11/06 13:09:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Zhu Yanjun <yanjun.zhu@linux.dev>

commit 503a5e4690ae14c18570141bc0dcf7501a8419b0 upstream.

A NULL pointer dereference can occur in rxe_srq_chk_attr() when
ibv_modify_srq() is invoked twice in succession under certain error
conditions. The first call may fail in rxe_queue_resize(), which leads
rxe_srq_from_attr() to set srq->rq.queue = NULL. The second call then
triggers a crash (null deref) when accessing
srq->rq.queue->buf->index_mask.

Call Trace:
<TASK>
rxe_modify_srq+0x170/0x480 [rdma_rxe]
? __pfx_rxe_modify_srq+0x10/0x10 [rdma_rxe]
? uverbs_try_lock_object+0x4f/0xa0 [ib_uverbs]
? rdma_lookup_get_uobject+0x1f0/0x380 [ib_uverbs]
ib_uverbs_modify_srq+0x204/0x290 [ib_uverbs]
? __pfx_ib_uverbs_modify_srq+0x10/0x10 [ib_uverbs]
? tryinc_node_nr_active+0xe6/0x150
? uverbs_fill_udata+0xed/0x4f0 [ib_uverbs]
ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2c0/0x470 [ib_uverbs]
? __pfx_ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x10/0x10 [ib_uverbs]
? uverbs_fill_udata+0xed/0x4f0 [ib_uverbs]
ib_uverbs_run_method+0x55a/0x6e0 [ib_uverbs]
? __pfx_ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x10/0x10 [ib_uverbs]
ib_uverbs_cmd_verbs+0x54d/0x800 [ib_uverbs]
? __pfx_ib_uverbs_cmd_verbs+0x10/0x10 [ib_uverbs]
? __pfx___raw_spin_lock_irqsave+0x10/0x10
? __pfx_do_vfs_ioctl+0x10/0x10
? ioctl_has_perm.constprop.0.isra.0+0x2c7/0x4c0
? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
ib_uverbs_ioctl+0x13e/0x220 [ib_uverbs]
? __pfx_ib_uverbs_ioctl+0x10/0x10 [ib_uverbs]
__x64_sys_ioctl+0x138/0x1c0
do_syscall_64+0x82/0x250
? fdget_pos+0x58/0x4c0
? ksys_write+0xf3/0x1c0
? __pfx_ksys_write+0x10/0x10
? do_syscall_64+0xc8/0x250
? __pfx_vm_mmap_pgoff+0x10/0x10
? fget+0x173/0x230
? fput+0x2a/0x80
? ksys_mmap_pgoff+0x224/0x4c0
? do_syscall_64+0xc8/0x250
? do_user_addr_fault+0x37b/0xfe0
? clear_bhb_loop+0x50/0xa0
? clear_bhb_loop+0x50/0xa0
? clear_bhb_loop+0x50/0xa0
entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Tested-by: Liu Yi <asatsuyu.liu@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20251027215203.1321-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[mdmitrichenko: The cleanup block removed here is labelled err2
 instead of err_free.]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2025-68379.

 drivers/infiniband/sw/rxe/rxe_srq.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 4e523d91e7dc..523791dbe69a 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -139,16 +139,11 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 				       &srq->rq.producer_lock,
 				       &srq->rq.consumer_lock);
 		if (err)
-			goto err2;
+			return err;
 	}
 
 	if (mask & IB_SRQ_LIMIT)
 		srq->limit = attr->srq_limit;
 
 	return 0;
-
-err2:
-	rxe_queue_cleanup(q);
-	srq->rq.queue = NULL;
-	return err;
 }
-- 
2.43.0

