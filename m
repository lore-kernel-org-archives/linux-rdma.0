Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC99175A5
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791127988; cv=none; b=d8hrxfyjIS60JXE/VrJ3KoPg4mOGFp3bq3FYuo1RoHcn7pbIiDmlhlCLPNY0f/b0NUw7N8/k08BJNCXILTUekbDPir0x75K0bVw8FBeqADo6sOrzu00ab0xMUDOV507naC2TqTMec7V7SuL+PFeR4narpzVYt2Bb9lH17vBE3sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791127988; c=relaxed/simple;
	bh=frEu0+YHCYEAIISEUSqAHXn1SA2CikdbNDhLxgGORsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rXunljFkWeqOId/zVSOlUhKnY9cYXrKE20q9EDigYar+KqdCXvyRHuqplyBvy/jWB6/BTZ/lrbhfKX7GrEhes0DZRauQt0EIIjzC1hpk9e06hrMVq0lzAoHKbul9VTG3rdL5qc7bsavX3M3b1zj60JKtlNPzm2u3DzynlEs3Su0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jMrRmUqr; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jMrRmUqr"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-381b831d535so806529a91.0
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791127986; x=1791732786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TL/5kgxzdG0IO6VNLnymmQGflm7TnGNgH/JOmRhyvJE=;
        b=jMrRmUqrm3c/mvzSNVa5TAlkV8M71INBsVt1bsdTNxq9JXSG77L8ROR3v5hLgFqg+L
         /MSHyNSy0S0weSdM1Tx5EAe9ah/BEqRKQY/wwM3mvdjVXbihHd0guoq91yK1xIQLWs/r
         i1qI7+wA5VEI0ZywnyC1iDc2AVIipUAv2zQG6ri+74rqsMnqiQiQhbAedKlmcnvC4n7f
         ZVZh7Dfi/3hOgh0D5vSj5eHNE2DaEC2PDSEHaxgGYyvokHMPmRhzniAh1tyO+NNI4fn1
         hpcsKwNLJkd9nqV9xjw/lVU4Q3joVcAfBpzC7AHaXEMHiTtlhEo3V0EHPcngYB6ivtm1
         ctUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791127986; x=1791732786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TL/5kgxzdG0IO6VNLnymmQGflm7TnGNgH/JOmRhyvJE=;
        b=jMQUwIzkQQthw1733z4XyIa4/qIshS01Q5nPaCNEUPqKh6AYhN9xX6GSGRD924W4Rg
         PDe8gC3n9uORgKJSB8zrvz7MDprUPuXVvmlf4KMFlKkMRXTAIN+L/kzB3EnT1ABl4EKH
         74o+QdRF9xaowHM+yMDFk2UmJZSTJ3fMpaLuaVkZwgNWDibPV0SF3utb5Kf80gFhneaG
         MWMy9U7ctoo0jPzddMt0AmaU6IpOVuzVdY9+O7Yji7MWor//0RcL7Mka1ha1q8qKONOX
         WSZlV8aYtqAReXp1ZT4iFQWh53HpwhiOQMDCyxhMzpYRlTzkqlewHmj8BMiCOq4cGH8j
         6skg==
X-Gm-Message-State: AFq9FYJ5WvN20pgLQhdc/iLBwTjuxwgxEDS8FT4rFbOvq4+ummC0C9Y3
	ra9wFIw1tg7zSfhucW+GY6QxSAAw7RDrGXJ3T88zsp9M2w3RzHjd9FSs
X-Gm-Gg: AYBFou0Mj6GAo3sHzU8OlWAvMD/xAflV8PLWr2RacA2xIThNTAGS6rWS0gYErVrSG1t
	Cijs2MQHM7Wfno/e11lApD371FUnVGzbEMiz7kaHxUCw17nvAYxvdCdVvfYGgHb8t7EIBYsNZqI
	oimzKiXqRX159Nay/+7fbxFLkLaCsOvpUqGIT2brK9qZwl2xhJhy5Cd6h/Q3e23QMGQpf3f4HlG
	VPR7ocy4U0/WyVYxQBmnjKDoNpjlydZGz+lmq6IUPd6z2WdRtuInhDVkr69NvMHG7lhjdwEvz2q
	PjwLNjqu3T2864eBpvnqF9q7FqWfyjdufGbDIOreVQcw+fx4e9P59Ly68Rjjque+O0VrjyPrx1E
	341becIFoB1nLlgrqptEJakHHcEJvssebDkjWNy4WfM7VHMhgkPtAVEAHyxqoFs+4mXF5KL6F8P
	YMDWU5P7QaeR0jPObZWQVlVmfciqxhIiBrN8GAVEhvCczwGuglsWD8XMioaOjSXe/guFI7NKVbY
	sMOd2r+eg==
X-Received: by 2002:a17:90b:55cc:b0:3a7:f64f:6467 with SMTP id 98e67ed59e1d1-3a7f64f6837mr658082a91.57.1791127986369;
        Sun, 04 Oct 2026 08:33:06 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e61386csm7363090a91.17.2026.10.04.08.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 08:33:05 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH v3] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Date: Mon,  5 Oct 2026 00:32:46 +0900
Message-ID: <20261004153246.2951263-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An ODP MR has a page array, map.pfn_list[]. Its size is computed from
the umem start address. But rxe_check_pagefault() builds the index into
that array from an iova that is relative to the same start, while the
access itself was range-checked against the MR's iova (ibmr.iova).

Those two bases do not have to match. reg_mr only requires that start
and hca_va have the same page offset, so a user can register an MR with
hca_va = start + N*PAGE. The difference then becomes an index skew of
(hca_va - start) >> PAGE_SHIFT. Nothing compares the result with the
size of pfn_list[], so the read goes past the end of the array.

An unprivileged local user can reach this with a single RDMA operation
on a self-connected rxe QP. KASAN reports a slab-out-of-bounds read. If
the out-of-bounds qword happens to look like a writable HMM pfn, rxe
then copies the payload into a page the user never registered.

Reject an index that falls outside the umem and take the fault path
instead. That path rejects the out-of-range access in
ib_umem_odp_map_dma_and_lock(), which does check the umem range. The
other users of pfn_list[], __rxe_odp_mr_copy() and the atomic helpers,
run only after a successful map, so this single check covers them too.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Assisted-by: LLM
---
v3: no code change. I am sending it as a standalone mail this time,
because v2 was sent as a reply to v1. I also dropped the Cc: stable
trailer. Both were asked for on the list.

Test results. The kernel is an unpatched KASAN x86-64 build of 7.3-rc4
(93f51579e7df). The reproducer runs as uid 1000, against an rxe link on
lo. It registers an ODP MR with length 0x8000 and
hca_va = start + 0x8000, that is 8 pages of skew. So map.pfn_list[] has
8 entries and the valid indices are 0..7. The reproducer then posts a
recv WQE in which every field is legal (num_sge=1, cur_sge=0,
sge_offset=0, sge.addr == ibmr.iova) and sends 64 bytes to its own QPN.
The skewed index lands on entry 8:

  BUG: KASAN: slab-out-of-bounds in rxe_odp_map_range_and_lock+0x13b/0x280
  Read of size 8 at addr ffff888102bf3f40 by task kworker/u8:1/32
  CPU: 0 UID: 0 PID: 32 Comm: kworker/u8:1 Not tainted 7.3.0-rc4 #3
  Workqueue: rxe_wq do_work
  Call Trace:
   kasan_report+0xce/0x100
   rxe_odp_map_range_and_lock+0x13b/0x280
   rxe_odp_mr_copy+0x7f/0x1e0
   copy_data+0x124/0x2d0
   rxe_receiver+0x20a6/0x3cb0
   do_work+0xb6/0x250
   process_one_work+0x3d1/0x790
   worker_thread+0x296/0x500
   kthread+0x194/0x1e0
   ret_from_fork+0x2ac/0x3c0
  Allocated by task 86:
   rxe_odp_mr_init_user+0x52/0x180
  The buggy address belongs to the object at ffff888102bf3f00
   which belongs to the cache kmalloc-64 of size 64
  The buggy address is located 0 bytes to the right of
   allocated 64-byte region [ffff888102bf3f00, ffff888102bf3f40)

The 64-byte region is map.pfn_list[] itself, which is 8 entries of 8
bytes. The "Allocated by" stack names rxe_odp_mr_init_user(), so the
object really is the pfn_list of this MR. The read is exactly one entry
past the end. That is the (hca_va - start) >> PAGE_SHIFT skew described
above. rxe_check_pagefault() is inlined, so the report names
rxe_odp_map_range_and_lock() instead.

The code is unchanged in mainline 551c722f4080 (2026-09-29). This patch
itself is only compile-tested (KASAN + CONFIG_RDMA_RXE). I have not run
the reproducer again on a patched kernel.

You may prefer to index relative to ibmr.iova instead, the way the
non-ODP rxe_mr_iova_to_index() does, so that MRs with a legitimate skew
keep working. This patch takes the smaller and safer route. Please tell
me if you want the other approach.

The reproducer needs CONFIG_INFINIBAND_ON_DEMAND_PAGING. The fix is not
merged yet, so I am not posting it on the list. I can send it to you
off-list, as I did for the wr_opcode patch.

 drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index ab21b620e94c..07a30c60fc62 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -136,6 +136,11 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
 	while (addr < iova + length) {
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
 
+		if (idx >= ib_umem_odp_num_pages(umem_odp)) {
+			need_fault = true;
+			break;
+		}
+
 		if ((umem_odp->map.pfn_list[idx] & access) != access) {
 			need_fault = true;
 			break;
-- 
2.43.0

