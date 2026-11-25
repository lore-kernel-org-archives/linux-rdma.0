Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795639266;
	b=fPocv79cFJlu4hO4YzHy3fgmLeZInpQCIGom2db6O6oY97etfkesOPMBkWgMJDf3WFp+
	 XJlxgHFZLx4oUJU6c/kUl7KO3uJfohT9aPUVd3SCHXjB6kb8ahrcYmRZDTOXws+ImSVST
	 uOxe2+/zOoCpf8FmharTIiD+xaMI8VbueQgqoagLI2JacSN2K6+dEmZcoCVcUErg9Nb8l
	 1oenkIFk0Yn0Gkbz3AYWDF64GVdsDqK/gSLYoAbnNhImIuEFaFdy9wjNC7fHHBe3fts/9
	 UksqxFO+Yvygxkq6L3Zvooc16J8WANVYdoIr7fS0udPuC+REfglZ82BysNQ96x6sFwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795639266;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mPgJdzejzQ0AMs9If5NnUjMgCZP05Z66kYzfdC09fEI=;
	b=ULJ/aXFy52kVXsgCdoLszdelY73+2Q8rf2Fb8Sv8b7F8atmbXYI0Oq9IFQZlYmWzYDi7
	 AcBsRLO+B+9JRvNX6mFoRjpzT6fbzrhBNpms7PZ5Ex5xwjdG3qMRLmm+pFPUs64ByOqi8
	 RwCtkxAgLoF9xQ+QKoov0pztd6x4ljur2fAeSjvIzh3aQ4d+uh1EmdkRqZEmYcQb+tAHM
	 70Tk5tP1sQymS2RvS8ekBBdjFdXhC0qhUtm8E1N949jpxF0ywRi0NEXSRGvciBFnLnNWG
	 e96CK1QoNtwx7F4zoLgj6iHR8DV56AEo77QZ72eZDlMFp++coiODNov2fibvvBpA1Jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ikuyo.dev;
	spf=pass smtp.mailfrom=ikuyo.dev;
	dkim=pass header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b="HDFGtW/R";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9D606A31E;
	Wed, 25 Nov 2026 20:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93A9D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=HDFGtW/R
ARC-Seal: i=1; a=rsa-sha256; t=1795639252; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=K18Z8kKlwrCYssoEPura8AR4mtRkR6oh9hRc9iPtPVh8kp3g/VRSpa4j3yPsthXeRB99TEPT5Tgqp4W/bz/9ys5uBH6IZ1Lo/fWVVqjCMpdOtO4DayDA/kLrVVvO9f0O3R1599NRWvqmnQRwYERfPICKyZqu8bYwh+e/6tnt3k4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795639252; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=mPgJdzejzQ0AMs9If5NnUjMgCZP05Z66kYzfdC09fEI=; 
	b=mSDPjG2X9LuAQQUiZTl3enTh5TyqKDr4F+MD7dVtGv1Lt51Sh8Q2uuNh/K6JJ71a+f13Tkk5pyOiBqCyIa9ND6mG/OhM2uXbpVWyFM42SOyG2umqllwVhzER5HSDep+4/KQEXPMTuqUgL253LDwD5H2xWN7FAZff5OTibSmuZVQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ikuyo.dev;
	spf=pass  smtp.mailfrom=eritque-arcus@ikuyo.dev;
	dmarc=pass header.from=<eritque-arcus@ikuyo.dev>
DKIM-Signature: a=rsa-sha256; b=HDFGtW/ReKP68I1uGawXgF56mpy4zlQf7iSe2wx3TtWUAdIIY2j+Cy5/aUkv5SraKc1sqLLQkLA+dZeANS75zh7xbVY8vFFC4omnh7wbloi5TbS59UxL60Wo2JlJF+8dEOSfWTHEVeh5rc7UzyZhOPNru2O/i6xa5a0Gua4y6vhIR3cyy5b90yoF3Oqh67i9yzidK3uruBKw5ervMl0f9P7iJ7IHlfjZvyCsjQJHmM1bPWmjGdIz9kl3iCdfH516KlFb+ZHGnxaJ5DJcARaQHJj+Ve79VEyurTaCfTx+T5w/exZ53AYZ+iB7ZPDBccRQwD/MEbubqgbN+es3cUtCfg==; c=relaxed/relaxed; s=s1; d=ikuyo.dev; v=1; bh=mPgJdzejzQ0AMs9If5NnUjMgCZP05Z66kYzfdC09fEI=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795639250543545.3695521399388;
	Wed, 25 Nov 2026 12:40:50 -0800 (PST)
From: Cygnus Qiu <eritque-arcus@ikuyo.dev>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yanjun.zhu@linux.dev,
	Cygnus Qiu <eritque-arcus@ikuyo.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3] RDMA/rxe: reject MRs whose iova range wraps, keep ODP lengths unsigned
Date: Wed, 25 Nov 2026 15:40:24 -0500
Message-ID: <20261125204024.517458-1-eritque-arcus@ikuyo.dev>
X-Mailer: git-send-email 2.56.1
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

rxe_check_pagefault() bounds the ODP page index against the umem inside
a loop over the pages of the access. When the access ends at 2^64,
iova + length is 0 and the loop does not run, so neither that bound nor
the HMM_PFN_VALID and HMM_PFN_WRITE checks apply. mr_check_range()
admits such an access when the MR's own iova range ends at 2^64, which
rxe_reg_user_mr() accepts. __rxe_odp_mr_copy() and the atomic write and
flush helpers then index map.pfn_list[] with (iova - ib_umem_start()) >>
page_shift, which the registrant controls, and the page derived from the
entry past pfn_list[] is copied to or from the peer.

rxe_check_pagefault() also keeps the index in an int, so an index of
2^32 or more passes the bound truncated, while the atomic write and
flush helpers use all of it.

Reject an MR whose iova + length overflows u64 in rxe_reg_user_mr();
mr_check_range() then keeps every access below 2^64. Carry the length
as unsigned int through mr_check_range() and the ODP helpers, the page
index as unsigned long, and the fault byte count as u64, the type
ib_umem_odp_map_dma_and_lock() takes and rxe_odp_init_pages() needs for
the whole umem.

Found with afb-afl, an LLM-driven kernel audit/repro pipeline; the fix
and this changelog were also drafted with LLM assistance. Reproduced on
an unmodified KASAN build, with the ODP MR registered by an unprivileged
user and the requests sent by a RoCEv2 peer. An RDMA READ of 0x100
bytes at the end of a two-page MR whose iova range ends at 2^64:

  BUG: KASAN: slab-out-of-bounds in rxe_odp_mr_copy+0x357/0x400
  Read of size 8 at addr ffff888103e11390 by task kworker/u16:0/13
  Workqueue: rxe_wq do_work
  Call Trace:
   rxe_odp_mr_copy+0x357/0x400
   rxe_receiver+0x16cc/0x9830
   do_work+0x15d/0x490
   process_one_work+0x6ef/0xf20
   worker_thread+0x501/0xd60
   kthread+0x34d/0x460
   ret_from_fork+0x339/0x620
   ret_from_fork_asm+0x1a/0x30
  Allocated by task 180:
   __kvmalloc_node_noprof+0x210/0x770
   ib_init_umem_odp+0x21e/0x3a0
   ib_umem_odp_get+0x229/0x350
   rxe_odp_mr_init_user+0x5b/0x330
   rxe_reg_user_mr+0x1d5/0x2e0
   ib_uverbs_reg_mr+0x3ce/0x920
   ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2b5/0x470
   ib_uverbs_cmd_verbs+0x2291/0x3410
   ib_uverbs_ioctl+0x175/0x280
   __x64_sys_ioctl+0x13c/0x1d0
   do_syscall_64+0x95/0x480
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  The buggy address belongs to the object at ffff888103e11380
   which belongs to the cache kmalloc-16 of size 16
  The buggy address is located 0 bytes to the right of
   allocated 16-byte region [ffff888103e11380, ffff888103e11390)
  Oops: general protection fault, maybe for address 0xffff888100d586ca: 0000 [#1] SMP KASAN NOPTI
  Workqueue: rxe_wq do_work
  RIP: 0010:memcpy+0xc/0x30
  Call Trace:
   rxe_odp_mr_copy+0x28f/0x400
   rxe_receiver+0x16cc/0x9830
   do_work+0x15d/0x490
   process_one_work+0x6ef/0xf20
   worker_thread+0x501/0xd60
   kthread+0x34d/0x460
   ret_from_fork+0x339/0x620
   ret_from_fork_asm+0x1a/0x30

An ATOMIC WRITE to an ODP MR whose iova is 2^44 above the user address:

  BUG: unable to handle page fault for address: ffffed112051c110
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  Workqueue: rxe_wq do_work
  RIP: 0010:rxe_odp_do_atomic_write+0x131/0x2f0
  Call Trace:
   rxe_receiver+0x1cb3/0x9830
   do_work+0x15d/0x490
   process_one_work+0x6ef/0xf20
   worker_thread+0x501/0xd60
   kthread+0x34d/0x460
   ret_from_fork+0x339/0x620
   ret_from_fork_asm+0x1a/0x30

With this patch the first MR is not registered (EINVAL), the ATOMIC
WRITE is NAKed with no report, and in-range READ and ATOMIC WRITE
results are unchanged. The int lengths also made ODP MRs of 2 GiB to
4 GiB fail to register and NAKed a 2 GiB FLUSH; both now succeed. The
rdma-core v65.0 tests, ODP included, pass with and without this patch.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Signed-off-by: Cygnus Qiu <eritque-arcus@ikuyo.dev>
---
Changes in v3:
- Reject the wrap when the MR is registered instead of on each access
  in rxe_odp_map_range_and_lock(), as Leon asked. An MR without ODP
  whose range ends at 2^64 is now rejected too. Zhu's Reviewed-by is
  dropped since the fix changed.
- Carry the access length as unsigned int through mr_check_range() and
  the ODP helpers, as Leon asked. It was unsigned int in rxe_mr_copy()
  and rxe_flush_pmem_iova(), size_t in mr_check_range(), int in
  rxe_odp_mr_copy() and the helpers below it, and u64 in
  ib_umem_odp_map_dma_and_lock().
- Full call traces in the changelog.
- v2: https://lore.kernel.org/r/20261121215426.50988-1-eritque-arcus@ikuyo.dev

Tested in QEMU on rdma.git wip/leon-for-next 94e81a1f3ffa (v7.4-rc2+),
where the traces above come from. Applies to for-next and for-rc. The
wrap was run only through READ and the 2^44 index only through ATOMIC
WRITE; neither was tried on the flush path.

This completes commit 7797bbb0e86f, whose bound sits in the loop that
a wrapping range skips; stable trees need that commit first.

process_flush() has the same mix: for IB_FLUSH_MR it passes the u64 MR
length to rxe_flush_pmem_iova(), which takes an unsigned int, so only
length mod 4 GiB of a larger MR is written back. That was found by
reading, not run; I can send a fix as a separate patch if you want.

Without KASAN, on mainline 4405c18c95d2, an RDMA READ or WRITE at the
end of the range reads or overwrites a physical page the registrant
chooses. On that lab kernel, with CONFIG_RANDOMIZE_BASE=n, this was
taken from an unprivileged user to uid 0; with KASLR the chain also
needs an address leak. The rxe link has to be created by an
administrator; the trigger needs only the uverbs device. A reproducer
and the test logs are available on request.

 drivers/infiniband/sw/rxe/rxe_loc.h   |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_mr.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_odp.c   | 22 ++++++++++++----------
 drivers/infiniband/sw/rxe/rxe_verbs.c |  4 ++++
 4 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 9a8e96dfb7..aa09279f24 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -72,7 +72,7 @@ enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
 enum resp_states rxe_mr_do_atomic_write(struct rxe_mr *mr, u64 iova, u64 value);
 struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 			 enum rxe_mr_lookup_type type);
-int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length);
+int mr_check_range(struct rxe_mr *mr, u64 iova, unsigned int length);
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
 int rxe_invalidate_mr(struct rxe_qp *qp, u32 key);
 int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe);
@@ -197,8 +197,8 @@ extern const struct mmu_interval_notifier_ops rxe_mn_ops;
 #if defined CONFIG_INFINIBAND_ON_DEMAND_PAGING
 int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 			 u64 iova, int access_flags, struct rxe_mr *mr);
-int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
-		    enum rxe_mr_copy_dir dir);
+int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
+		    unsigned int length, enum rxe_mr_copy_dir dir);
 enum resp_states rxe_odp_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
 				   u64 compare, u64 swap_add, u64 *orig_val);
 int rxe_odp_flush_pmem_iova(struct rxe_mr *mr, u64 iova,
@@ -215,7 +215,7 @@ rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 	return -EOPNOTSUPP;
 }
 static inline int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
-				  int length, enum rxe_mr_copy_dir dir)
+				  unsigned int length, enum rxe_mr_copy_dir dir)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 13cb28d391..152438bf2d 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -24,7 +24,7 @@ u8 rxe_get_next_key(u32 last_key)
 	return key;
 }
 
-int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length)
+int mr_check_range(struct rxe_mr *mr, u64 iova, unsigned int length)
 {
 	switch (mr->ibmr.type) {
 	case IB_MR_TYPE_DMA:
diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 73ed4c45fe..522013ce22 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -41,7 +41,7 @@ const struct mmu_interval_notifier_ops rxe_mn_ops = {
 #define RXE_PAGEFAULT_DEFAULT 0
 #define RXE_PAGEFAULT_RDONLY BIT(0)
 #define RXE_PAGEFAULT_SNAPSHOT BIT(1)
-static int rxe_odp_do_pagefault_and_lock(struct rxe_mr *mr, u64 user_va, int bcnt, u32 flags)
+static int rxe_odp_do_pagefault_and_lock(struct rxe_mr *mr, u64 user_va, u64 bcnt, u32 flags)
 {
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
 	bool fault = !(flags & RXE_PAGEFAULT_SNAPSHOT);
@@ -120,12 +120,12 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 }
 
 static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
-				       int length, bool write)
+				       unsigned int length, bool write)
 {
 	bool need_fault = false;
 	u64 access = HMM_PFN_VALID;
 	u64 addr;
-	int idx;
+	unsigned long idx;
 
 	if (write)
 		access |= HMM_PFN_WRITE;
@@ -161,14 +161,15 @@ static unsigned long rxe_odp_iova_to_page_offset(struct ib_umem_odp *umem_odp, u
 	return iova & (BIT(umem_odp->page_shift) - 1);
 }
 
-static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u32 flags)
+static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova,
+				      unsigned int length, u32 flags)
 {
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
 	bool write = !(flags & RXE_PAGEFAULT_RDONLY);
 	bool need_fault;
 	int err;
 
-	if (unlikely(length < 1))
+	if (unlikely(!length))
 		return -EINVAL;
 
 	mutex_lock(&umem_odp->umem_mutex);
@@ -194,11 +195,12 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 }
 
 static int __rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
-			     int length, enum rxe_mr_copy_dir dir)
+			     unsigned int length, enum rxe_mr_copy_dir dir)
 {
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	unsigned int bytes;
+	unsigned long idx;
 	struct page *page;
-	int idx, bytes;
 	size_t offset;
 	u8 *user_va;
 
@@ -230,8 +232,8 @@ static int __rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 	return 0;
 }
 
-int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
-		    enum rxe_mr_copy_dir dir)
+int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
+		    unsigned int length, enum rxe_mr_copy_dir dir)
 {
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
 	u32 flags = RXE_PAGEFAULT_DEFAULT;
@@ -273,7 +275,7 @@ static enum resp_states rxe_odp_do_atomic_op(struct rxe_mr *mr, u64 iova,
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
 	unsigned int page_offset;
 	struct page *page;
-	unsigned int idx;
+	unsigned long idx;
 	u64 value;
 	u64 *va;
 	int err;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 46d0810ea2..8b591b75e6 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1263,10 +1263,14 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd, u64 start,
 	struct rxe_pd *pd = to_rpd(ibpd);
 	struct rxe_mr *mr;
 	int err, cleanup_err;
+	u64 end;
 
 	if (dmah)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (check_add_overflow(iova, length, &end))
+		return ERR_PTR(-EINVAL);
+
 	if (access & ~RXE_ACCESS_SUPPORTED_MR) {
 		rxe_err_pd(pd, "access = %#x not supported (%#x)\n", access,
 				RXE_ACCESS_SUPPORTED_MR);
-- 
2.56.1

