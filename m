Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859352;
	b=R+tXFKmYmndlfIWMpiD9tf9wL6psQJyaJR+5+CHQTiaPYbfr+VlGgD6CAcyWmWzWPjJL
	 GHkFYNji+9IiqxQQJ0RGYNq4Ms2spDMhUNSazLpTmJT7Y2cVtP5R3P/ZyUPPS9KeoQzCZ
	 YAqLs95qFDQbiSzzE1VEsTd/QQBg9ghR5BHqk3OHl7D4dCI1vMQsuryXZP9WdfOTie5kj
	 1hJrH2svSaJvkCGHrL+h0eYPB0X7FjEEPlqlu3FcR8u1TqiW89XZxvcjjXXtUEB0eTeh7
	 BhEqAh2QfGTlTP8BPbSoyK7qR0oJCbe3qS6DUiWUqzN7eanr+QHRHB84tZmoaJuV+kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wD5HFmyo5C/86og7luOdITnA/REDozwGyCESntnCzBg=;
	b=bv0zp7fbQnsbm6wNg1agR5yOujrpaIZZbZWa9Pyar2CWUf18ocUZl0N5sjOu0vnUR9Tu
	 4ftOHCpWQ9TJg1PkfOUrY1nj9kgi2/6h4tXCuUVyIy579SnOhVmx8k3F/fc4LmG0utQYR
	 +MuJ2ShVherIj6GTBYPjXivfh/NvqftMpytpaDLaZFUVQQwWFb5fudxGx8IBn/4g1dqI1
	 8TJ6xNdoawTo5fTIa7FQtSv4I8Ouwnwn8eQ5KqPqYGE31QtjecBWz8eZLSprLIYnkbBxn
	 6dXeP+85VYDU8xuvAtuAT6JjyKBLoLXGSzVSXr+L9Ztw7VcjTve5+HENZRAIg6uo2uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=ceH85emB;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5F606A333
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AD5F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=ceH85emB
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-35f1f76ea84so3009233eec.1
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 09:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792859351; x=1793464151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wD5HFmyo5C/86og7luOdITnA/REDozwGyCESntnCzBg=;
        b=ceH85emBaB8Vvp9FWcfVPOzFqyhZAy8apUxp0dsiUCHGszhG9mvsvXGfrw1oZXG5fL
         2pqCnA+0jbqEoOshBECqoSQ9hY8QqWjlivGdDH8tieZZVG22b6VBUM7xR6ayeg+N4EsD
         BPhmsyX+DgN4zM0Kfd9vaJHDoO9NDt+K8zJ5TS4Hq2sJ/DkowuJMB4bpw+1X91LUX3di
         TczARTEfraLeFluqo5eTXT8dSzNogusSG6TSuDI9njMZecCZ3B35kvfJ0ddZYr2HGz/d
         qIcQF/h0bDnAq2DORZUDzEzpgnLAheNF1j130Ob6d9+ncDH8ZCWTccyVZ7rX5GVrcL1A
         tTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792859351; x=1793464151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wD5HFmyo5C/86og7luOdITnA/REDozwGyCESntnCzBg=;
        b=v9VHvDQ0mKSrtLuhw7p3xcLo3wjEY+mPjbTtqCMLgseWHhqVjw64L87nfbXNd+MHdY
         WG2Mt2ThqY8Ch9yd4rm+CjMCgJkVQ2FefqPpGwmacf18Vyw+dXjOGFXRq+4jPkPvTFWQ
         B2pSHH31BLAAl33UiGuc1Of73C1Chyya2hOBH7RK3Xy1uzSMXp4wanEE1qnUPb2DT9iW
         6ouYAWqPbtkzbAV/90zFVfDBR7H9faxYYq4u/SjmAcMr3nLdzk7/S4rZzR25LUde4I7Z
         cvI5mv3Jn1VrbThHhX+grpyXTtUwb6NzAXcEMNOnkR149CD9iNyOnwPcZ85f3bAt6j0f
         irUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgATftxdEI65Mkvpra8QDSGER+R0e3Fj/O9Xxr92Blqit9HChCj53FV8OXLPYekPtAt1mzBA9PXIqA@vger.kernel.org
X-Gm-Message-State: AFq9FYKSNCP7zkqsQjqN5ar43XQJjjZebE+BSqDrSKst8GbuafRGO3q8
	XqNYvKg/5LU2nqj+U2QdP0oZ0SBjSrStphQO69Bv/UJJO16uWyTYQ6Ti6N0Lke4eZVrgJQGUaSf
	C/i56
X-Gm-Gg: AYBFou3bfK+k0LMZyoBiIkqSpCbRgTu0hFqw2VamL3rEpbkoMaii+bBt+mFJushWr+o
	d4KltYsQaLBjakd2ygWBY2+yc0D6QrJqx0uInpGYxz/BexcUypOY4HYmVWNj2vemZRN7kszp1L1
	7FOJcEKA5klHyrCmCd7vMro87GYKIUQH3YBgjvlC4/vNkHSLkeBjI8nCPtW5kFq5SVmSgP8WIHb
	rZSG9e8TuuMbwGnYz27JCzfYISE1q35xMvlFTNdbvkVd33lx5j7tfPlXy/7r99AqaK4OyBytrbX
	V5JD5DE8lSfECnhStZpaloTfHLtgmexfinmiV/WYUGhNZztKchn4ABlqezVQCXEb2szax4uqmnb
	Zga2ZQuUfY/jVDxJpnjE91up9+iTXWrdo7le/BgS3StU/rvrQdRMUgzK9K4SoBqak07RiMcDzRH
	u5QMobKleF0AYV1b3ne96rbmvZHEzkzpW9IdFxI9AntSFt25ftALGrZqE0K2f7v5YP3nESjpPrP
	KfuXn8fR3eSYtqAhltsnrFXJt8WW7dl3qhcbJ9QyhcRRgwNlpAISBk1o2t6ljoUOip9wLeKela9
	TUBY4fQBPCe6hIpUA0OZQvRlwGfEG1fcnUKEKElW18uzl3TnyLBuGp3iX1i/3x6R
X-Received: by 2002:a05:701b:2419:b0:163:c5eb:d42f with SMTP id a92af1059eb24-199291058eemr2654183c88.5.1792859350550;
        Sat, 24 Oct 2026 09:29:10 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19a3736d16fsm7192350c88.12.2026.10.24.09.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:29:10 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Sun, 25 Oct 2026 01:28:51 +0900
Message-ID: <20261024162852.3528224-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
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

  BUG: KASAN: slab-out-of-bounds in srpt_alloc_rw_ctxs+0x660/0x860
  Read of size 4 at addr ffff888002d6a05c by task kunit_try_catch/43

  CPU: 0 UID: 0 PID: 43 Comm: kunit_try_catch Tainted: G                 N   7.3.0-11999-g5b0764a53235-dirty #1 PREEMPT(lazy)
  Tainted: [N]=TEST
  Call Trace:
   <TASK>
   dump_stack_lvl+0x3f/0x50
   print_report+0xcd/0x620
   ? alloc_pages_node_noprof+0xa2/0x140
   ? srpt_alloc_rw_ctxs+0x660/0x860
   kasan_report+0xde/0x110
   ? srpt_alloc_rw_ctxs+0x660/0x860
   srpt_alloc_rw_ctxs+0x660/0x860
   ? __dequeue_entity+0xb12/0x1ba0
   srpt_test_run.constprop.0+0x135/0xc50
   ? __pfx_srpt_test_run.constprop.0+0x10/0x10
   ? pick_task_fair+0x126/0x1950
   ? update_curr.constprop.0+0x4a/0x390
   ? __set_cpus_allowed_ptr+0x181/0x240
   ? __pfx_read_tsc+0x10/0x10
   ? ktime_get_ts64+0x192/0x250
   kunit_try_run_case+0x1ca/0x4b0
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? kthread_affine_node+0x24b/0x370
   ? __pfx_kthread_affine_node+0x10/0x10
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36e/0x500
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34d/0x620
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x22/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x19/0x30
   </TASK>

  Allocated by task 43:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_slab_alloc+0x6e/0x70
   kmem_cache_alloc_noprof+0xfc/0x2b0
   srpt_test_ctx_init.constprop.0+0x481/0xfa0
   srpt_test_run.constprop.0+0xf1/0xc50
   kunit_try_run_case+0x1ca/0x4b0
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36e/0x500
   ret_from_fork+0x34d/0x620
   ret_from_fork_asm+0x19/0x30

  The buggy address belongs to the object at ffff888002d68000
   which belongs to the cache srpt-kunit-iu of size 8276
  The buggy address is located 8 bytes to the right of
   allocated 8276-byte region [ffff888002d68000, ffff888002d6a054)

The KUnit harness that forces this is not part of this patch.

Compare the span the table occupies, which is the table offset plus the
descriptor header plus nbufs descriptors, against byte_len directly. A
short IU that cannot hold even the header is refused, and so is a
table_desc.len below one descriptor, with no division and no dependence on
a sign. nbufs is at most 510 once the existing count check has passed, so
the multiplication cannot overflow.

The header always lies inside the allocated buffer, since the largest
offset srpt_get_desc_buf() can return is 48 + 252 and the header is 20
bytes, so it ends at 320 while srp_max_req_size is at least
MIN_MAX_REQ_SIZE, which is 996. It does not always lie inside the bytes the
initiator actually sent, which is why the span starts at the table offset
and covers the header as well.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8e7e..21264264356a2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1117,6 +1117,7 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		size_t desc_off = (uintptr_t)idb - (uintptr_t)srp_cmd;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1129,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		if (desc_off + sizeof(*idb) +
+		    (size_t)nbufs * sizeof(struct srp_direct_buf) >
+		    (size_t)recv_ioctx->byte_len) {
+			pr_err("received SRP_CMD indirect table (%d descriptors) that does not fit the %d-byte IU\n",
+			       nbufs, recv_ioctx->byte_len);
+			return -EINVAL;
+		}
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
-- 
2.43.0

