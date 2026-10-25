Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792928533;
	b=TTeR+kGnHt/BT19sD5i0Hi0bBnN1qQZeVNQ5dHojTQRw3x9QbD0na/UJam8Jp21s1qRL
	 wt4zuzEpdImBVBXAqV/7huAh1VPosWqKq4zpRPt/ycNlRd+V7kpqX8dSZ0dGtbOCvasuj
	 DtE7XFNv1ElIFzYVL1YwTYf97MHaDdLJ4G3JbDAOd1QE2P28KafL0PsKFoAnrneD4sDYT
	 oSeaavCSq0tuofqOByrBchtFLhBixKVL0M/u8h0ktBFHxFY28Ca37h4VZkyBXhxV6rKyD
	 XOa3QAqUr6uwaIYuOwCEzCGagq7b8W+nOO4sy9elrS6LSGcs+UAZStnjZShW6rZ8uKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792928533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhmTqIVrhZ/NvlRobX5Y+GvIs1MtU8Z4kfjwx8mwLL8=;
	b=UD0siQ5M7uPOpP+uCyS5/gzDC3ykzarzD+ivP540A/fQ8BpLBwb61oi1E+MynR7WghhX
	 d1i2TlnufG5uP8I/iXYFFr0PeWukzTDnAww38z+Pr3nAD/pZixi4RnzNtcBwexda+BjoZ
	 KXOWEm0+ls1YH4Tbg9yqdn4vjDCvbU/esToyVpRiYPoHoKFhdvxNxw/P9dYZZI3R36Ctw
	 HpvV5cRoWhb0nI4Zq/AWvdUtbl2tNveK+6Jj4MiihliIHAfWz+9EPMSLTw6unJn2Hl5xX
	 GULz+CnRJUjlX7xFqWsfRXcsbFpCAbH1WJe/MSADCYmiLFgeo5UetW/DofOsKeEFVOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=TpvUiXJN;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15547606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 11:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15547606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=TpvUiXJN
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e942864693so11320795ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 04:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792928531; x=1793533331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PhmTqIVrhZ/NvlRobX5Y+GvIs1MtU8Z4kfjwx8mwLL8=;
        b=TpvUiXJNriwwOkpJktK38zjrXmnZIWyTAL2b6oxnVhFEW3kV0nnOZ6u6FIB7KkO+bU
         zSdSEADvARbfHupOrx4iQLTtbfGPaCSTVmNN74amYLqPxJJIP/ez2Kcf/3JgrUWpfbow
         YCu9VvW4eSvCBbT1jfF+GbzH54MXoqzqMqcKT2BHhWZBwjYCEFr/JZCuoG0KTNCdfm8n
         X/kVyVFIOOrj4QGKCCUSNY/cfYXKwL/ImQmPy4V1w+eLzwGoLJTWSX8iv6qv6nJ/h9bD
         8gaH9Rez9Avi8gyzdHfrPGNXe4GvX4NhtvKlJkhLVe3UNAUPR/T74cPMStbvGTDQWqQH
         k27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792928531; x=1793533331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PhmTqIVrhZ/NvlRobX5Y+GvIs1MtU8Z4kfjwx8mwLL8=;
        b=gmeZ5y/nDes4ChcUMmFcGjV3BIQ7YRbLEbEMdw608E74ry6Cwi8c/1eDRtp53MzE+2
         BLATM+o7NUe0Zezx8P12WRYYRa3vsSgBcj694Kp7PzygCrPuBzYet5fVUqjMqmcCL8I4
         jZw9FL5QL/Y5mwOPwVIzWmBSBMUW21GVbw+h1oG733btZpQoxY1tXhPNolN49BVnfKIe
         Uf3CdUsQVbF5c1osawn/QMIxqZd4KhK/+yxoo60Gm91Ht4Aw0Bb8frsywjRMzTyZYD//
         OlUL+OFNJ4WwMwUp2iIXDe3BZ2MR2o2Oy85k4BFgllTREnyhejesh5Fkb4IdsqS+qaNj
         mr9A==
X-Forwarded-Encrypted: i=1; AKwUvByrOdrdNSxEa6mjl6fiyDxZtAfl5QmF5FboLubXpMVF6Cqz1dQAqQuBsxSfKcI8srPVTqmj76PY/ojL@vger.kernel.org
X-Gm-Message-State: AFq9FYKSHkW5D78lRtiQmEVvyiAdVhiQagYeTAoaWbGMH/f2KKHXIX71
	fQEd3csBJAHsAOQfFl3ZLZDRZpcuuKzG9Kwi3Oh68x6lmQ4KR9Iau4EJUL76v4DeOi0=
X-Gm-Gg: AYBFou2adMzz3yEz7SKkd3LXPZe3JlhkyysQdI1MAgk+RS9sqOSatqeEPXa5SbFXjna
	tRAVIYHcI1+F5ORI1s7YiOncNvuQaOEhMsmDoN1SczZ3cPaiU/WQ7xMp8Df91WDXQ5CtKUiK1cN
	jNhHx2z/RaPs0y2G0H/yw8/t5WHdt7jtGy3b6GUELyYGap4LhDpDV+LrIXXc4t+p0OA4/f8jXrD
	Vo+zJNCbDEO0xKjGCvuzgPKotg0dtcqICw4TKuhh5LYsOhlQqRSVOGecyg9i9s42smomt5hfH9U
	Yx382oK+ik+C5cYSknJ/MzuzsyH1CN61Q8SaD+CLBupNPouIInl5vn6I1KTa4Ze0G+EH9fmHNdj
	7XFPc3bzfghLgJfYFunjJ0Ut2bmyRsQYX0rqlIizW6U50stq9eRU4gun3ZLznP15+9gNcKeVgLx
	xiGI9oc0x/KMIg04b/10qge2fepBehNwDsKd35IASVA+fr+0kmHS1h1Dr+iyNP3oFwRrw2HMBuJ
	EvjUbXUzCdgLnLOk3LCC7gReEG18Ca0ETQ+MSfpfPyjTNxefTiJ/hVjg/3fOrmVpGfulzdD75zJ
	JaPCBekwMV2H1lY/N/ny/I0f9jOexgwuwtRYfMyuy1FFWRwkKK7b7R1bOTiZgjmM
X-Received: by 2002:a17:90b:4ac7:b0:3a4:77b8:1770 with SMTP id 98e67ed59e1d1-3adeaae6dfdmr3592234a91.15.1792928531192;
        Sun, 25 Oct 2026 04:42:11 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba32e38sm5219705a91.2.2026.10.25.04.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 04:42:10 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 1/2] RDMA/srp: refuse a target that cannot receive an SRP_RSP
Date: Sun, 25 Oct 2026 20:41:54 +0900
Message-ID: <20261025114155.4007867-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
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

srp_cm_rep_handler() takes max_ti_iu_len straight from the target's
SRP_LOGIN_RSP and srp_alloc_iu_bufs() then sizes every receive IU with it,
so the target alone decides how large the initiator's receive buffers are.
Nothing enforces a lower bound.

The initiator parses a 36 byte header out of those buffers. A target that
reports a smaller max_ti_iu_len gets undersized buffers, and the header
reads in srp_process_rsp() then run past the allocation. A report of zero
is worse, because kzalloc() answers it with ZERO_SIZE_PTR, and on a
transport that maps addresses virtually ib_dma_map_single() returns that
pointer without looking at the length and ib_dma_mapping_error() reports
success, so the buffer reaches srp_recv_done() and the read of the opcode
is already out of bounds.

  BUG: KASAN: slab-out-of-bounds in srp_process_rsp+0x757/0xbe0
  Read of size 4 at addr ffff88800243f120 by task kunit_try_catch/42

  CPU: 0 UID: 0 PID: 42 Comm: kunit_try_catch Tainted: G                 N   7.3.0-13249-gcea86339412a-dirty #2 PREEMPT(lazy)
  Tainted: [N]=TEST
  Call Trace:
   <TASK>
   dump_stack_lvl+0x3f/0x50
   print_report+0xcd/0x620
   ? vprintk_emit+0x21d/0x380
   ? srp_process_rsp+0x757/0xbe0
   kasan_report+0xde/0x110
   ? srp_process_rsp+0x757/0xbe0
   srp_process_rsp+0x757/0xbe0
   srp_oob33_test+0x305/0x700
   ? __pfx_srp_oob33_test+0x10/0x10
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

  Allocated by task 42:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_noprof+0x179/0x3b0
   srp_alloc_iu.constprop.0+0x69/0x5c0
   srp_cm_rep_handler+0xc2e/0x1bb0
   srp_test_login+0xc8/0x630
   srp_oob33_test+0xaa/0x700
   kunit_try_run_case+0x1ca/0x4b0
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36e/0x500
   ret_from_fork+0x34d/0x620
   ret_from_fork_asm+0x19/0x30

  The buggy address belongs to the object at ffff88800243f100
   which belongs to the cache kmalloc-64 of size 64
  The buggy address is located 32 bytes inside of
   allocated 33-byte region [ffff88800243f100, ffff88800243f121)

The KUnit harness that forces this is not part of this patch.

Refuse the login instead. Both the largest messages the initiator parses,
SRP_RSP and SRP_AER_REQ, are 36 bytes, and a target that cannot send one
cannot speak the protocol, so nothing that works today is turned away.

Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5811f02df9805..a85d28b95306a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2379,6 +2379,13 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 
 	if (lrsp->opcode == SRP_LOGIN_RSP) {
 		ch->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
+		if (ch->max_ti_iu_len < sizeof(struct srp_rsp)) {
+			shost_printk(KERN_ERR, target->scsi_host, PFX
+				     "Target reported max_ti_iu_len %u, too small for a %zu byte SRP_RSP\n",
+				     ch->max_ti_iu_len, sizeof(struct srp_rsp));
+			ret = -ECONNRESET;
+			goto error;
+		}
 		ch->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
 		ch->use_imm_data  = srp_use_imm_data &&
 			(lrsp->rsp_flags & SRP_LOGIN_RSP_IMMED_SUPP);
-- 
2.43.0

