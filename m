Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992045;
	b=Z0IwAZ9znPtSGYB6DO5hfgSoUyQPRD0eO/RUnvtplxnupt8AHh+QvrXA2mIFHTxjiBo6
	 QSlFN/tbRY7ghtuyDScKo5cf0bjwR5PbUHlCixU22wUwVrBuDqIs90NrrIbwLRYehm8Kd
	 Vtrdmu947OWn5nNLjo/6ivt9Vt6KJZjInmhEa55YVNnVxwUhkuRfyOj/4n713N4s/6y2g
	 4BdGh4hol/uOonvQFMKSmLMYu77mOL9JyKvGu6CTPnhcFGLa7i5sGXkElCaEoGVWuYR0f
	 KGdUi37Ygf6kp/QXpXhB+sPoVWoV4tmWIhUzu+YrLEVhqOaiWVOkn1lyYjxOLJvJpZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992045;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XvlIgy8HAuD18Pu9SXVycEWxWyGIpi2gLi2fcEDWRe8=;
	b=FjcHiEIWE1/TFAAigx6rbFzVaq5FTKDW/H3/l5OdemMnRX3qABezJVd2msbpq3wGMC6r
	 jr9yVUR8E9dBCS7LLHmxAorj29KPRF4M80YRJQ0MKtdbcsqeZ4+VLyOE7bGtEUYanwrDU
	 oxH3XVzrrLBUX1M/5St4ps9bVpGwYreqzPIsQaNHNQVvCSeQNlO/KPQcGlA3vaKhaSf5R
	 riznsXiUpCDyAqZLcDPbspEi+hoyJMeXWWUGfd+aQovxTf8mnQyuTSHDdtZP9EKZQa+gk
	 z+uqKixdUaZzR5/8/Tnj6UUZjpNW+4wo//2o358hOca977xgPDECT8PvAlum3H1DF4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Cdr4P81v;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF33606A327
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 05:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FF33606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Cdr4P81v
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-156cbe59524so1699365c88.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 22:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792992044; x=1793596844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XvlIgy8HAuD18Pu9SXVycEWxWyGIpi2gLi2fcEDWRe8=;
        b=Cdr4P81vE2Fl0scL/6optiq2L6r4udH2U3nQi0SdgL7UdUZsuzbeWvrJ6jjzdk7tKD
         XYO9r8WCjaeTf9LnYOIKcP5LdO6EzuqYuBK82Je2HBRGM1wcSTLf/a+ZkfGto02++wvc
         Ntbi5hm8DyqIAD3EBzIcJzHLP2oF2uACm3zEO0XGLp0Sx9tMpng1bDvChbRfWScYrndq
         8HTPy7ytBoeT1XKYOOmsvg1wtlCpQtCk/6+FWYnaDU2F3zSk3c+2eEIcK+xhb0+0bROD
         mNJSvNMlZbwOaOWR6qs6I1E7Ca8JkCzPcPCpeBXRoUcLJL5fFTYsxErpVUPuvaJWWAEg
         Xsdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992044; x=1793596844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XvlIgy8HAuD18Pu9SXVycEWxWyGIpi2gLi2fcEDWRe8=;
        b=IqF/g9IP+qDyqRg6RahcisfsV/QZJEoBy7jesjvsYJzbdilyITUgfn7MpaMf075Eu4
         0OZah0pvqcsenYNx+yK93KllekVo1uDitrhZZzJDS8P8rNIyBOCgwuq2F+qzcEaB0NwG
         OYwwsF8vQWntFa5ACNGJomqQ45PtDfB0VVPv399HSdKlHtRz9wToKkK9BUEo1FIi0g4S
         8oGX1Naag6eFGCmUhTC7zmH5Ttq2MOpsvAt8h62MT9EiG8woZ+TgRkzIKnMktshSo7EN
         78njb5r4+NKSpVOzDBWhBdEZlaT+oPM3/FHYAoI2Jg7gSvqDuU5PBpNxR4YIhsZyo8vY
         mEWQ==
X-Forwarded-Encrypted: i=1; AKwUvByEGY7+Q1Y4cusRY4389midQIcKMqQWmi6xF7qivwsIycuoIHIBZzq6o90e4yZTZ96FyakvBWarCGKt@vger.kernel.org
X-Gm-Message-State: AFq9FYISjykjr9L67SL6Js6ZWwHQQkaN8m7NbqwehBKfiCTZlTt7I+Ee
	dEmHPUJoTxst/wrU1DpspwhaUry+QrffM5KrZPZOUonRH1pSJF8ZLp7Ip35A0IFCm0o=
X-Gm-Gg: AYBFou30Bnj21TUq/6mPsEeh6yXLWjwOttG5Ti1gH8dHL3O9OOM5ytYeoFFLGkIIlJ6
	+3IHTd+1ihY18VoZVY+XTbxoK+rLFBq4bJEDXZ6TjJBMAxqVjDmbu1UxV5FuUGHgPlrWsFs2Grm
	DhB9UT2g93jhrYuu0d092FCmlHFi7FeonbRcAlYudAKvxU3W7mfI4giGM/BG3ZvXKU1Rpq0EV1O
	5QOhgadP9hjzZyKJ2jiOZc708mwu3xRFcyNUzrRAarUMYYvUmvncta5+ll0dndgl8GdeD38JZ7s
	SjVMHLShKifyMzRBnt38ZamZJyQWaI6kX5SXkHX3SrPxLEQl8a6ACrbPgGPq/pNTiqiDTvo9X2v
	YpAZcaPPDFLtrTKJapt/Vsm3N7hAJu3SBfaE0dCz/znLCdV6pschu6BDRGC0ruLQEL0xitwFqP/
	klT7rFDcrsosI6/6Mf3TSwMS1GiTMSqGL7AjNx13Nm2I0zST2zcujJBZiWK3eypxWI8/4SfSTwD
	9pfu4JqU+K/LeFKDEDRp8dU9Yo5uIKjkUN/i1L+fgZlFy1r+NxObCGaCaNNBi6KDiLyB9NxQ6Aq
	J+n8mfxfdd6y7E4mT0afl3KZgN3MQkkKR61FivnuMy8Jq/8pncdAJAkJO4CRFjMTwn5wzA==
X-Received: by 2002:a05:701b:2311:b0:16a:8ffd:4977 with SMTP id a92af1059eb24-199363a356emr7729321c88.17.1792992044011;
        Sun, 25 Oct 2026 22:20:44 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0f83cedsm26765774c88.13.2026.10.25.22.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:20:43 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 1/2] RDMA/srp: refuse a target that cannot receive an SRP_RSP
Date: Mon, 26 Oct 2026 14:20:28 +0900
Message-ID: <20261026052030.296361-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
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
