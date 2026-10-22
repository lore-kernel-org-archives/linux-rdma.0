Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679994;
	b=y2jnWjYLZ2xAh7Im2pU6OsYcuYjjuCaQK2yT8GNABmOUVKbUg4ULvnfrKKgxQnXmWgao
	 r29M8EFUsHSlYz+Krm3XvPptA1FxZdTg/p+zZOU15nBaB2cJ19D7BMXyKPuAQ05l+XhcV
	 MsLDQWudEwufErwXak8RTsXOO2CEx1nXVyRL3RIYEDWgf4hXO8YNTmT5WXqETvp/fLrr6
	 AO8n3sJzHgNZVPzENHIo0OOp2yvpR36FVHYX2HM9/ltuDZfAS9tbYAdKbHo9bUqG5+h1p
	 ebXXBO0WfXtRMLoG3zVOsIR8q5JRLaVWgEJskypha4rt2yjm/ktJeJXMmury/fbZqEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679994;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6GGMKrOc7lyQki5JLMpUTllqUsowmWvQtYFIkrSVo20=;
	b=vQC3rXiCsUrMb0UMbPrNY+6B3IhWN/V+ZT5jI+oXBlwtcPKLKLc7XcY0PvZsEdbKHSNM
	 T0YkAb3XoZLQ7Jr1OuoyB5CBqD9lcfdFb2HoNw7cnbRtLXf/0tNmDTtUwGU5qG9VPXBYV
	 0PUfc4kS/wcH+eqMe6V3NMJ0QqbdO3TXtwGQfTe3f+13vakxTQFd251gyILP8obWFB9m8
	 KVpl84EyYtIt+pm9noy4mGWNX2O2YTOkPzxzfTLV2Njzu0lWXL4gjop6cWoPkLi2spURc
	 54XyoRiZTe+3gaDry2qPSKzG8hgd+WH2/fKPVx5QtXyrbkIvXQo/iF+hznKA+wwSC3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Dse13JcB;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1A4606A326
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A1A4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Dse13JcB
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc147d86bebso692336a12.0
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 07:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792679993; x=1793284793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6GGMKrOc7lyQki5JLMpUTllqUsowmWvQtYFIkrSVo20=;
        b=Dse13JcB9u4hnKJMQtNhuSb+IAz6YYm5Qcm2vC1EUxNv+T8Vf9yExs7BtXGV02trFQ
         txCGCc+ZsYhPBbVR4Mep6WexjupniMiyBlAiA6QU1f9TJUAWhxpiBLmQR20d9PDltiuD
         NoyJQ+LjUl2eoyd75/moNl1OzD5qUl0BpASS/p0CO7n3heYY3/cnRqbYDUmtsFrexA9/
         CcYChIx+XsAbdfvfvjn3drpIEEM0uRDB0Xg0Z5reraROiUScEgx/e2pf/LiBSlFL8lDy
         gJLSDgCbn5Ao/sx13KFWa0BBk+fpUYkuF1q2DG/9XKM7eWOQp0uN7lWatu2bjO9cA57J
         Q9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679993; x=1793284793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6GGMKrOc7lyQki5JLMpUTllqUsowmWvQtYFIkrSVo20=;
        b=ewPYXjuaSrYEMndtPIvwaReUtY+Ii0KIU3YzHHSsO4XFhj91dOjVTcedKpvXYMvufw
         RAZD79eGTIzioxGOJGYeoJoNbxTZYaiQSmKzeBm5Ryh5ULi7mT5x6wEjEUy93hJbSuV/
         kVkeBZdHHmWOipsGkyx89ZItOrAt2SO512GxQXEpbM0pY46tOmACX4FXzDPtgA4Hp0WR
         GZX0UHAQsfUBLaEEENnKZN3OxBaptY72c/Q5N7jZiGJ2zQy0rFo3E8KRawctRJiy4Cx0
         J+h7T65eUmFVUhaypYrGwg+9yUC8zLbwC+fQuL3zIfsNMKKs8dtfAChxQszn9dCxkHog
         wcug==
X-Forwarded-Encrypted: i=1; AKwUvBw10Ysu/GJ4WqUTv0bbV1qsBRbCkfh8TwBiiBwOXDEMF1bDhzI7hq4FmLNhWSRGZrxAWI4jAVNfXASk@vger.kernel.org
X-Gm-Message-State: AFq9FYKVt/Pagvq3tn15FyBkj7fxJ/pNU9ZFZPOz0Ch4KZ5g2vVYpEkR
	iCehc4Y1h7jpNKR9sJ/RqlXtbiIvAKm5yo2k5hfIXZWJioapNCBRxs8XEx6XqkCwHWQ=
X-Gm-Gg: AYBFou32SwJ4tSvzB9HhZ5IUVwyp+/TWDbyFxAKN9wQjbJ62s0K/TI3qqvfbj0Kn8T4
	nzQ/wXgjG03PUkfmmIFrQEBaYyV2clyDz/4I1VOHVMNr57mIgiTFubNtQylDNEtxEiaaLeSX40G
	IdzswUij2cw5/0TPMDrKZr4hQ/Snsl6e+Bd6QbZVKXDU/YXCAwKX+a0m+BQHFOo0es7YeE3dkFg
	iPtmek0iJk1+PA9HBZTMRQbVT6GXboVOzusFI+KNB3733d6N89LXBvGw3tyoSSjqrHNWZRxYBUD
	I4UJixSukrBTJK8u9YD8ZXA15xRuAccK68DJptszpDYoOQicxilg0rJX48kWfLZGmKqCkmT8o4o
	71cw7HQn8W+mB2umFxINi8gH8UZV3jrgX1FfLkhn71/Qsn3ic5mzAB9PO3FwYIJIN/O5sco0wmb
	u1rBfL+iBhFW+fokt6tpEzm17H3YKEq1zbU5agS5ycMUHvdA1MqG3Cb0SvpxzoQrdq/DuVBxuTE
	feKhQrPaUJYthlyVb6qT1kpWDcYLphRprEGzWzYI4PLGtAbiSnEXpYWS7MRbzMavqebLV+qsqbH
	Tf8=
X-Received: by 2002:a17:90b:590e:b0:39e:6c68:fd91 with SMTP id 98e67ed59e1d1-3ada6cb4b5emr1409865a91.38.1792679993350;
        Thu, 22 Oct 2026 07:39:53 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4887669sm4719043a91.2.2026.10.22.07.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:39:53 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Thu, 22 Oct 2026 23:39:00 +0900
Message-ID: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
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

srpt_get_desc_tbl() takes the number of INDIRECT descriptors from
idb->table_desc.len, which the initiator controls, and checks it only
against data_out_desc_cnt + data_in_desc_cnt, two more initiator fields.
Both are u8, so the pair admits up to 510 descriptors, and nothing
compares the table against the receive IU it has to live in.
srpt_alloc_rw_ctxs() then walks idb->desc_list for that many entries.

With the default srp_max_req_size of 8276 the table fits as long as the
additional CDB is short, but ADDITIONAL CDB LENGTH is an initiator field
too, and at its maximum of 252 bytes 510 descriptors end at
48 + 252 + 20 + 510 * 16 = 8480, which is past the end of the object:

  BUG: KASAN: slab-out-of-bounds in srpt_alloc_rw_ctxs+0x64c/0x820
  Read of size 4 at addr ffff888002d3a05c by task kunit_try_catch/44

  CPU: 0 UID: 0 PID: 44 Comm: kunit_try_catch Tainted: G                 N  7.3.0-dirty #1 PREEMPT(lazy)
  Tainted: [N]=TEST
  Call Trace:
   <TASK>
   dump_stack_lvl+0x3f/0x50
   print_report+0xcd/0x620
   ? alloc_pages_node_noprof+0xa2/0x140
   ? srpt_alloc_rw_ctxs+0x64c/0x820
   kasan_report+0xde/0x110
   ? srpt_alloc_rw_ctxs+0x64c/0x820
   srpt_alloc_rw_ctxs+0x64c/0x820
   srpt_test_run.constprop.0+0x13b/0xc50
   ? __pfx_srpt_test_run.constprop.0+0x10/0x10
   ? pick_task_fair+0x126/0x1950
   ? update_curr.constprop.0+0x4a/0x390
   ? __set_cpus_allowed_ptr+0x181/0x240
   ? __pfx_read_tsc+0x10/0x10
   ? ktime_get_ts64+0x192/0x250
   kunit_try_run_case+0x1ca/0x4b0
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? kthread_affine_node+0x247/0x360
   ? __pfx_kthread_affine_node+0x10/0x10
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36a/0x4f0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34d/0x620
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x22/0xde0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x19/0x30
   </TASK>

  Allocated by task 44:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_slab_alloc+0x6e/0x70
   kmem_cache_alloc_noprof+0x11d/0x2f0
   srpt_test_ctx_init.constprop.0+0x481/0xfa0
   srpt_test_run.constprop.0+0xf4/0xc50
   kunit_try_run_case+0x1ca/0x4b0
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36a/0x4f0
   ret_from_fork+0x34d/0x620
   ret_from_fork_asm+0x19/0x30

  The buggy address belongs to the object at ffff888002d38000
   which belongs to the cache srpt-kunit-iu of size 8276
  The buggy address is located 8 bytes to the right of
   allocated 8276-byte region [ffff888002d38000, ffff888002d3a054)

The KUnit harness that forces this is not part of this patch.

Compare the count against the room the IU actually leaves for the table.
recv_ioctx->byte_len is signed, so a byte_len too small to cover even the
descriptor header yields a negative room and the same test refuses it.

The header itself is always inside the buffer. The largest offset
srpt_get_desc_buf() can return is 48 + 252 and the header is 20 bytes, so
it ends at 320, while srp_max_req_size is at least MIN_MAX_REQ_SIZE,
which is 996. Only the table needs bounding, so one test placed after the
existing count check is enough.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216b..97758082f71d2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1117,6 +1117,8 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		int desc_off = (u8 *)idb - (u8 *)srp_cmd;
+		int room;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1130,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		room = (recv_ioctx->byte_len - desc_off - (int)sizeof(*idb)) /
+			(int)sizeof(struct srp_direct_buf);
+		if (nbufs > room) {
+			pr_err("received SRP_CMD with %d descriptors but room for %d in the IU\n",
+			       nbufs, room);
+			return -EINVAL;
+		}
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
-- 
2.43.0

