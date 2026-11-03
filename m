Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710837;
	b=Nf9IuMUQ/tb0eBC4+N81osVj/eVv1Xx0Ap6Xsy3wV7MCCevNmuQrdqON6IXnB1k4vB7o
	 ApOJezIaSDnsHFbM0xqrHE/UWxT4+UcSP9RcvP0QLZuJaCLPxy8JYlyhVos0rMAuslopE
	 bTdPH/FvAzDpOJOXcistNAnine+wL6qi4EPCumzbI3NHSlXyaY2Eopsh1NdXsFnMs+aIO
	 pxdzrC5/vo3wHHP8dAbmeBhRitu3yGcV9v+sDijLEBGRR4bXWYq2PB9VeBIGDeHtQkvo4
	 n8USsj3xvmv0msreU1ucnJgNpbA6iAaGkSdE/TWlF1pzFIHEQeaIUOuYWuOzYZoZUiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNfhVmOoSlL3wC6OcMbKZaKfB8BCmJy4Z72sfxwNi3U=;
	b=FtVyc4hi9YaXX5O7n+joKCYp5ss88sAS/Nxi6ZReT3TYZy+1zlEJpjQHVcUUZ8Smc7LB
	 0KWrJORyIs+h7XQ7CdxY0kBlqaIdlOxr0knXHIuiCJ+BK2ga46DAdBJnqAV/PXr6nfPeX
	 Kh9bkpVxZ+xcelJ5WnSo5YOaCE294mnvXJkkczaBMRJ/mNOixUjKQi1ntpy9MjmE0INPQ
	 8CFR2seBGMASRqiQBxmgctsVzyFkB6RMhv1Mhr/vb5XW8I5YP6yYel3y7CxiudgK2/Gvw
	 YgdroKgVKZS5RNmV1/x0CCAI6N12UcROqpQ8Wj2UN2cdTZrmZFH3WVggmmNcP7OvV4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n+7N2zLj;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD062606D82E
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD062606D82E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n+7N2zLj
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a315ed211so777014eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 05:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793710836; x=1794315636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CNfhVmOoSlL3wC6OcMbKZaKfB8BCmJy4Z72sfxwNi3U=;
        b=n+7N2zLjLtLWK1Yw0CAZ/wlvP/ZuYsE2Yjyy/iIIOpfMm5/jZyuVwRcdfvjFZfZaq1
         ravxpr4Pkhv+Filz6Fo68H5w8bkzNUmS8HNqQKwBK3icjCI0hkNRTm3OCrWX922Ksutq
         g50F4w2RR3zWdsZ62uV6zaTzCVJZxDnrRuWlVpGD6Z9fk0nO2//LpB26ucs4w39ROQ+x
         43D+L74k+Ht60vImHeDpoAOcSV3eh/xICxHCxRMVmC/hGZAyoKkTq32s1OwEdMTTL43E
         kPTCzBIWDPCOmu1vl33laheK2ZUQ9n2h21tGMubOCD+cs46UMxUzkDkelBBt2UeO9qlf
         swYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793710836; x=1794315636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CNfhVmOoSlL3wC6OcMbKZaKfB8BCmJy4Z72sfxwNi3U=;
        b=XBm3Qy0vR8iNUQK6F4ZVAF3Xuhf6XTK4gvinnvU8LzFwz/337rJhvn+fYgevWvmUH4
         zszu5fYcH0OMToNXvcyidapXVFuLwost7ZTNhOEvEX6HyXE/nQhiibX6/KaLIgC6Ix2Y
         tlL9cvHZsmlQ1GDqrG5KNPqiN+tPaNPaUlGpg3EY4O0n3Z3+usNFRTeLQgjAkTXYCCOU
         ctmWyqhGFiUEsfDktJu0fNlxTqbPDMOzOsyEwUfDvKh3yRZGp0dC/dSsvQANH9MOsnWn
         qh9gA8RaX0/VFCXrE2n83Q3IagBFH8d9OuVsPGuPKy05000lhHxx+bcZTyJbYthNROHM
         po4A==
X-Forwarded-Encrypted: i=1; AKwUvBxoCP1NVDOodBt1dy5a+XCq9+vnF7r53KFeNdi+vJm8f4vGZmCyBgzEfHKFkPPUDKohIrSn5nOGtheP@vger.kernel.org
X-Gm-Message-State: APuU4Z9YtPcIeP395OLx0guGquCElnlfdSLUyABC5ad4Mg0VHRQGpsel
	A36EcFLL/iRwzW16jOeyrJ6Tq564AzHbWgvOVKdefNxiphCqtuNVu5Yp0+6cSKadITE=
X-Gm-Gg: AYBFou1Dl+qKlzmXvINcyVozEOPWXOx1oR6P1+RVfVpQeO2S8T30HTpSRylI5vjjMPw
	pAjEtIFC+cfVZJu5TOSTZDM6JeXGpixuJEWyoViAgd5Pu59L6j0E7UkdDrSjLCbOJGH1xekfY4K
	hUqzh5VCTC0zDv4qg70f9NjFGVLZQ0cQCKlo+HHBIIIcWDpmsajfy3kOQyv470j2zk9bjPkPnCJ
	qBZiPzI2hWugYb/9pgND+oIkww06i3VjaXvx4dFXjBDTeaRp3EF13g8ZhJ8v1s+eKbtDfhNfalM
	KLXXD1g60Di+Qy+5OMIMZIqZT0KejuHEMOJmjmpOLae2111d00AZgg5m5THWyYDZmE3BcgP8bc+
	WzotbXFWTUaaC2OKpMyC2YPPcQU1M/CIHt+V5SPmeMjXbTMSyR7K6y7fvzn3MR7z+wwVCuR1bUn
	X+O8utCWIsKthFrzEvfdXefSC5lBZd9JFmvGVaVF8tBIls8BKIUVe0y7ldjlttF0gzliZeawvZr
	B92isLYM9usebBb3pLIPpzuPq5mAl4ipqg3DtbVPxlfH22Rueb8NOXTvt3KXFiT43Kao/U4f37H
	eGSVeHV0RJ0zwXpdhUlwvtOAgiEw5YWMrenQGh9SdZlZCG95R4LY1W2qYogsIsGUyVPV87G2MU1
	r+Fs5n6YnvwwOQuYSNal8WGU0udn8f3IYPSPyNKGiA2FTabBNROONZ0E9OgA=
X-Received: by 2002:a05:7300:ce81:b0:357:ee3a:267a with SMTP id 5a478bee46e88-36a422062e1mr4531194eec.2.1793710834800;
        Tue, 03 Nov 2026 05:00:34 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm50806107eec.3.2026.11.03.05.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:00:34 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v5 4/5] IB/isert: drop the promotion reference when a connection errors out
Date: Tue,  3 Nov 2026 21:59:54 +0900
Message-ID: <20261103125955.1530355-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
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

isert_connected_handler() takes a reference when it moves a connection to
ISER_CONN_UP, and the paths that give a promoted connection up drop it
again.  isert_connect_error() does not: it drops one reference for any
state.  A promoted connection that then gets an error event keeps one
reference for ever, so isert_connect_release() never runs and the
isert_device reference it holds is never returned.  isert_remove_one()
waits for that in wait_for_completion(&removal_comp).

A REJ after the RTU reaches this path.  cm_rej_handler() accepts
IB_CM_ESTABLISHED while lap_state is IB_CM_LAP_UNINIT, and a passive id
stays in RDMA_CM_CONNECT after ESTABLISHED, so cma_ib_handler() passes the
event on as RDMA_CM_EVENT_REJECTED.

Drop the promotion reference too when the connection being given up was
promoted.  A test-only knob delivered that event to eight promoted
connections.  On patches 1 to 3 of this series the device delete did not
return within 240 seconds in any of three runs, each printed ten hung task
warnings, and isert_device_put() ran once, twice and twice, the first of
those being the one isert_remove_one() does itself.  Three runs with this
patch ran it nine times and the delete returned in 15 seconds.

  INFO: task rdma:206 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-NR3-00004-g11e5479fd20e #123
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:rdma            state:D stack:26592 pid:206   tgid:206   ppid:1      task_flags:0x400100 flags:0x00080800
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? filter_irq_stacks+0x71/0x90
   ? __pfx___schedule+0x10/0x10
   ? kasan_save_track+0x14/0x30
   schedule+0x70/0x1f0
   schedule_timeout+0x1cd/0x200
   ? __pfx_schedule_timeout+0x10/0x10
   ? vprintk_emit+0x200/0x2f0
   ? __pfx__raw_spin_lock_irq+0x10/0x10
   __wait_for_common+0x29e/0x420
   ? __pfx_schedule_timeout+0x10/0x10
   ? __pfx___wait_for_common+0x10/0x10
   ? mutex_lock+0x79/0xd0
   ? mutex_unlock+0x7b/0xd0
   ? __pfx_mutex_unlock+0x10/0x10
   isert_remove_one+0x529/0x710
   ? xas_load+0x1a/0x250
   ? __pfx_isert_remove_one+0x10/0x10
   ? xa_load+0xbf/0x120
   ? __pfx_xa_load+0x10/0x10
   ? __pfx_up_read+0x10/0x10
   remove_client_context+0xa4/0xf0
   disable_device+0x128/0x240
   ? __pfx_disable_device+0x10/0x10
   ? __pfx_mutex_lock+0x10/0x10
   __ib_unregister_device+0x226/0x3f0
   ? __pfx_mutex_unlock+0x10/0x10
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   ? kernel_text_address+0xa7/0x130
   ? __pfx_nldev_dellink+0x10/0x10
   ? __pfx_down_read+0x10/0x10
   rdma_nl_rcv_msg+0x29c/0x4e0
   ? __pfx_rdma_nl_rcv_msg+0x10/0x10
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   ? __pfx_rdma_nl_rcv_skb.constprop.0.isra.0+0x10/0x10
   netlink_unicast+0x68f/0x940
   ? __pfx_selinux_socket_getpeersec_dgram+0x10/0x10
   ? __pfx_netlink_unicast+0x10/0x10
   netlink_sendmsg+0x810/0xf20
   ? __pfx_netlink_sendmsg+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? selinux_socket_sendmsg+0x8c/0x270
   ? __sys_sendto+0x337/0x390
   __sys_sendto+0x337/0x390
   ? __pfx___sys_sendto+0x10/0x10
   ? fdget+0x53/0x3b0
   __x64_sys_sendto+0xdb/0x1b0
   ? fpregs_assert_state_consistent+0x56/0xe0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7fe0ecec20d7
  RSP: 002b:00007fffe9d34978 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00005621db1ab390 RCX: 00007fe0ecec20d7
  RDX: 0000000000000018 RSI: 00005621db1aa2a0 RDI: 0000000000000004
  RBP: 00007fffe9d349b0 R08: 00007fe0ecfb9200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007fffe9d34ba0
  R13: 00007fffe9d34984 R14: 00007fffe9d34bc0 R15: 00007fffe9d34ba0
   </TASK>

Fixes: 954f23722b57 ("iscsi,iser-target: Initiate termination only once")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4812dabd939453..712d6165150e3c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -721,7 +721,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
-	bool owned = false, bound = false;
+	bool owned = false, bound = false, promoted = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
@@ -730,6 +730,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 			isert_conn->state == ISER_CONN_FULL_FEATURE;
 	} else {
 		owned = true;
+		promoted = isert_conn->promoted;
 		list_del_init(&isert_conn->node);
 	}
 	mutex_unlock(&isert_np->mutex);
@@ -748,6 +749,8 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 	}
 
 	ib_drain_qp(isert_conn->qp);
+	if (promoted)
+		isert_put_conn(isert_conn);
 	isert_put_conn(isert_conn);
 
 	return -1;
-- 
2.43.0

