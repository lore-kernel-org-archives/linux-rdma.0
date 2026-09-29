Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22BD3F58E9
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 05:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790660632; cv=none; b=nfPM/dY8estoVs5b3PPYXTKSWim1Rf49gsPggoQwmo56jDUCsC+rTxGnBPuFBR1S2AreSc0RcL9CepfhjL/EAUkWrzhpQMaDHz6WxAP/XNZ9zsHmUWB6zjxCxGu6Y9L1dXVXL3YgAClvsp/R11FUAAWGyVNd8jqa3txEtmU4E5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790660632; c=relaxed/simple;
	bh=sQv+3EQ/YpC4KBY6er3ezC/52sPg6K8xe3lTdLTN1/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eON6cZXLbGHqOxfNu4LLaxwnV2/gPPAYxs0L9rNDwrb0eKjkjQj2e2UVrKBzHBFbSehNtrtliaOi3pC7mTy0cCxhJpa2Y232lt/Kek+Sh5SZCFgVgN2DPdmZyq91PGFGfiAskmj+Cn+ty9YdsOcv8o29KLLjt3KLQ1a92sHZeyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=w39jUsCJ; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="w39jUsCJ"
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7c4c92477so153877a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 22:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790660628; x=1791265428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ms7L8HqUGt31K1Ab3M9o1OoA83EPLyzTDgllkVMwSho=;
        b=w39jUsCJtIkQsLIXVnuptYwv/KryvVQN4yLyVbiRJkfXGg4klGFS/NvQEwSwyobwRp
         vdU2xbLC6KWjIOGKEAol8KZE/ZdxwOoXltEXaj2CUeyh2MqmJ6+NN+77mkDQlBzLs6kB
         Z81EsbDboH4rwdfkU5zYR9kL/uIiOJfM9OyKL8Lxdve6+vk2Cw6Ko4JtVpux7sGLl9A9
         tsAdhhDVyo332DiEvJuMWXXUAmWjw7sBGZ4e/5o/yoQnIZAamIoXmkOSQdQzBMWto/CJ
         C66jTZAmgGsFW8FMz4RsNqDBpNQwtYbaCGA0SkmGMDKEpl+Q+bA3xuVZBcBwB2legBIv
         TBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790660628; x=1791265428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ms7L8HqUGt31K1Ab3M9o1OoA83EPLyzTDgllkVMwSho=;
        b=BXz/IMUr85d0e54m0ul8ypihfIVnczgnmMkwJWvtma+bFb1av4zF6BBe3uHzcw50j/
         WSolYJgvu3lo9c6LMlLdM8WG5comyNIe2I0CBkpiLmNHQMZB7/szM5PMOSOXb3ZTx7Br
         UREV8Qk1ISailPzDlnFBjJ9MtQv1EO8I11K8r/zQzQ/s+TEgQ+oz7sUI6mjX5TfSv1TN
         bZujyDTTkTdY4ZpjTN+1kGLCTlyG4c7fbv+dmw2L6qtNRxlzgIByWXoWGrL7B59POBrI
         7nKphYiZW0cSqTQi2WioRLMkoJKnDmVYEY8vrzHl8nxXLwdCYBL/ZB70EViU6xRACBvR
         A64A==
X-Forwarded-Encrypted: i=1; AKwUvByv6FFFGMXrqonBGYPqbBKH4BZ3ddj9PRzlkHre3DG0+ulFU4lC5c9rb2C0GhwkQpkilRAyb3TYkoFB@vger.kernel.org
X-Gm-Message-State: AFq9FYI9RbPGDXEBnR8L+hDY2YvxnXYCKWRga8L29zzBLoJRD5jjDO9e
	856vmpQxfV7z+iv/BF86NLBwulcxH/TZPGjSLq+1kzlEdtrZLhqh1ZAXtcr5MtUf3Dk=
X-Gm-Gg: AYBFou11KeHn9mTVw+IJWJtgyrU+8gQGSsnAmn9PZr1EPC5MIykVQq29M8wnJ6Axk09
	Lhlbf8i3UTqIvEX+GZ59edN3/Hv9DrYbMBtH/zjMLWgArvh55se+G/4PLGYNhGFFWiBqSzsewuE
	jO8ElJTjBfUy56NCUsLV0bBE/3EarotKMVsKSsDxc8Gs0wSpDsFqQf2Sb0AIs2MpuAhhATF34mA
	WGr5q4fZtB1r549SwsuJ9YAJmEXc9DMCgcCwQ8H2Rwtu6UZJOpTnU+c2dIfE3IiYSUv2088/Ddm
	7QEpbty0Mt7V4fCnO4lio++tJgyGXhEoG/jqek8HQukX3wBgcL7qr/6+ZDKv6qwt3Uw78FRP5tg
	JcJCaUoDf35WqD5IpXR/unzNeYBwpXEafjscGhJoK4PPEupEly/D1/RPfRyKRyccZINnhZ911tZ
	UqEvZcwbXzR3QEiCtwRkz0xFDP+FlIN5/8B4Rn38yRzSMovZPdgEhsV7ZLq68JMX83wX/b774cQ
	P4v1w==
X-Received: by 2002:a17:90b:1c92:b0:39e:6c68:c77d with SMTP id 98e67ed59e1d1-3a098e0515cmr13918632a91.51.1790660627617;
        Mon, 28 Sep 2026 22:43:47 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a49818b39bsm3233581a91.15.2026.09.28.22.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 22:43:47 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/rtrs-clt: Reject a zero queue_depth in the connection response
Date: Tue, 29 Sep 2026 14:42:22 +0900
Message-ID: <20260929054222.1576877-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtrs_rdma_conn_established() stores the queue_depth the server advertises
in its cid 0 connection response without checking that it is usable.  The
only bound it ever had was an upper one, dropped in commit 0e8558476faf
("RDMA/rtrs: Avoid Wtautological-constant-out-of-range-compare") because
it cannot fail for a u16; a lower bound was never there.  A server that
reports zero therefore leaves clt_path->queue_depth at 0, and setting up
the first I/O connection trips

	if (WARN_ON(!clt_path->queue_depth))

in create_con_cq_qp().  The connect is aborted, but the peer has already
tainted the kernel, and on a kernel built with panic_on_warn it panics
outright -- all from one field in the response to a connect.

The rbufs array is sized from the same value one statement earlier, so it
is also allocated with zero elements, which kzalloc_objs() returns as
ZERO_SIZE_PTR.  Nothing dereferences it: the WARN aborts the connect
before any buffer is registered and the path is then freed, and a path
that already carries a nonzero depth is caught on reconnect by the
existing "queue depth changed" test.  The WARN is the whole of the damage.

The in-tree server never sends zero -- check_module_params() rejects
sess_queue_depth < 1 -- so this needs a hostile or broken server, but the
client should not rely on the peer for that.  Reject it before rbufs is
sized from it and before it is stored, but after the existing "queue depth
changed" test, so that a server which drops a nonzero depth to zero across
a reconnect still takes that path and still disables auto-reconnect.

Reproduced with rnbd-client over soft-RoCE against an rtrs-server patched
to advertise queue_depth = 0:

  WARNING: drivers/infiniband/ulp/rtrs/rtrs-clt.c:1688 at
    rtrs_clt_rdma_cm_handler+0x1b27/0x29f0, CPU#0: kworker/u8:5/56
  Modules linked in:
  CPU: 0 UID: 0 PID: 56 Comm: kworker/u8:5 Not tainted
    7.3.0-rc5-nvmerdma-atk-g72d3fcf802c4-dirty #23 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
    1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: ib_addr process_one_req
  RIP: 0010:rtrs_clt_rdma_cm_handler+0x1b27/0x29f0
  Call Trace:
   <TASK>
   ? arch_stack_walk+0x94/0xf0
   ? __pfx_rtrs_clt_rdma_cm_handler+0x10/0x10
   ? ret_from_fork_asm+0x1a/0x30
   ? process_one_work+0x6b4/0x10e0
   ? stack_trace_save+0x8e/0xc0
   ? __pfx_stack_trace_save+0x10/0x10
   ? __kasan_slab_free+0x43/0x70
   ? stack_depot_save_flags+0x29/0x7e0
   ? worker_thread+0x45b/0xd10
   ? kthread+0x2c8/0x3b0
   ? ret_from_fork+0x36e/0x5a0
   ? _raw_spin_lock_irqsave+0x86/0xe0
   cma_cm_event_handler+0x3e/0x240
   addr_handler+0x1e0/0x300
   ? __pfx_addr_handler+0x10/0x10
   ? pick_task_fair+0x46f/0x1a60
   process_one_req+0x10d/0x510
   ? finish_task_switch.isra.0+0x1d9/0xa70
   ? __pfx_process_one_req+0x10/0x10
   process_one_work+0x6b4/0x10e0
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_process_one_req+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  ---[ end trace 0000000000000000 ]---

  rtrs_client L2644: <s1>: init_conns() failed: err=-EINVAL
    path=<invalid address family>@ip:10.0.0.1 [rxe0:1]

With the check in place the same server is refused without a splat, and an
honest server is unaffected:

  rtrs_client L1870: <s1>: Invalid RTRS message: queue_depth is 0
  rtrs_client L2649: <s1>: init_conns() failed: err=-ECONNRESET
    path=<invalid address family>@ip:10.0.0.1 [:0]

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/linux-rdma/CA+0ovCg_sG8gaZXXj9zmOrpxRt=8+-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index eac38b57b00d7..5c2c65c15a65a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1866,6 +1866,11 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 			return -ECONNRESET;
 		}
 
+		if (!queue_depth) {
+			rtrs_err(clt, "Invalid RTRS message: queue_depth is 0\n");
+			return -ECONNRESET;
+		}
+
 		if (!clt_path->rbufs) {
 			clt_path->rbufs = kzalloc_objs(*clt_path->rbufs,
 						       queue_depth);
-- 
2.43.0

