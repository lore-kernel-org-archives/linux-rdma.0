Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60733BED1E
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 02:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787106814; cv=none; b=Lp+tij/wvli4AaGWrlLUPzWZ8RZwTbijleE4N8AbnYhq5pVRSiqjo9Jw7hAyWY/jZ5Np9x+vZbX+AC3aYhquRDNGUkWyo7of0O9oAqCjzRLp57G85LBz5zLXZFTOE+R1hbZwqSA48xKCbTDVt7L4GQsKi6CeRXu0m/5YjmbsSZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787106814; c=relaxed/simple;
	bh=NvUKtwCwLfTUlAPaeeoxkGpCIrYBqVMKcCKXISoLcZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGgQ5H+IcQmODDCh30Kqn/v7PcxIWwz3gTtRqhEj08PW4TFU05MTxcpXGp4CHqUU89iWArYSDuzbWo1ckz4Vx31WAQji3MvLC/4ClGKNf/IAOc1//C/64EUtotAYk+1REIiEp9g8JCw5vn+AFscFLMhlZtgsMOGUlj/9Ddi41pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=em5o3Ujn; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="em5o3Ujn"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso6065425ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 19:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787106811; x=1787711611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tbeC9QALWzzC4pxWLz9RtusejQaR6vKots2JJ46k/0I=;
        b=em5o3Ujn38tApQIgrPOFgD6H9wXqLe8L/R/jx7tsNzf8fdRXaErg9rOGh9OPTJpIdi
         Jnia/mR5IzZh4Rzfm4vNxUnEccMC18YxuhRG5Kj1NBfl4E9exdsJZHJHDWH7y13pngxx
         cKEArI66rqQ6Q6OxmHPZsMmzwLcpe85/DlF717avVxogIyz0slcpFILGdg2xfWUFJE5P
         0f3C35TJTEByL0H+kclZd54Yyz/quesn5aBsozUtgT5tL1IDRvYwBbnZF960PGs1m9yC
         1Ht1wcKgrupxZbY9icS41AYpDxjmx9EHCTmJBA4JwOXvU8p6nvZJ6rqwG+hwTUMXPadK
         MrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787106811; x=1787711611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tbeC9QALWzzC4pxWLz9RtusejQaR6vKots2JJ46k/0I=;
        b=EYLXa5+YzvkGyw1r2anR5YgBBZmK04As1BchHkiHUu6gKitz02/YrjgGir36/vZN6j
         Z2NEHFS3CQeIZ94EbEeF3P4Nk6nidh8Dj6NTROlHnhYSuXE08fcS8CrlCxnLeN1JvraR
         ogGQ75KyOJGIk2v7l1TGrqqODWnjQ5LSgSY2OdqjZChaIaXxvgskzJYwS/EeRG2Oa8KA
         R+KZVtrfknR1F9JPZxZFHlAoo4VgLrumwSYdv3jvKtnAHPjebxPxnz3OJ/UvY8SeBa5O
         696CY+IVkHNkzWsTGrXotyJIlW52Ods/DsPv2GX9Bno8cx/7Lth8+4GrbymXAoMMtSUP
         Y8aw==
X-Forwarded-Encrypted: i=1; AHgh+Ro3mwqJ2j92iL1JwG8CH6XWUw+cvOqQWCvZrR6Nyc/lOChxQoVwUFDKRI94gcZuAjDugNkPSJ5Jhp+i@vger.kernel.org
X-Gm-Message-State: AOJu0YyBZsXKygFIlfu6fEFwRHaktbKaNurrv3blThK7eE/yBNU7RAFS
	m/DFICtlOT4u00BcCPdPAIAaVzzPUMhV9teACNN4Q1RUdineeVTQ3pNeAw4EWDTRVmo=
X-Gm-Gg: AR+sD13oq3t7d2eYWFb+wxkZtgxpHGskA3NRU351HbmD4r04zQOiZqC/Sqals4GxAjI
	8OAE//S9FwatJouLfi5CzMQjLZZInuaSdjEKzlNsMBr58aoBsGodP5ahCtePy+iASjXfIIQbnNq
	OVgs910g3ukMwc+SqOCGU77a4ZIffFwa+/jGxTPYTztE+VfiiuH5Q90IjnYosKjiCOGpnuP6Dwo
	O1T6+OhYnX8AdqOwB2f6vWE3ucQkSBTkdYVjCHD+sg9oWBTsONsBWFWg3t83Mma4jpd/8+Sgjp0
	RiOuHUyCod2A1H7dF2xMAzWZdPX0XVx9dYSKBxtC71n46BNLE/CwU2I8dCXQKckXSrP++Dq2Fwx
	1rqMLpVV5YOJkgfumFcLkfSZXlINWJvvAAuL9Fvt/it4MNyLv0y4Fj/LVk6AZYLc7/mYq1vnO5E
	8WTpxYnItSoVjX2czp8tdXr10/b9w4C6DGbd3KE4WrV/XL4L20c6a4IoNU3ttpmijeNKFl
X-Received: by 2002:a17:90b:4c8c:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-3958108a4bbmr2251257a91.10.1787106810789;
        Tue, 18 Aug 2026 19:33:30 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f9aaa12sm786281a91.5.2026.08.18.19.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 19:33:30 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: leitao@debian.org,
	horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH net v7 2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
Date: Wed, 19 Aug 2026 11:33:05 +0900
Message-ID: <20260819023306.644849-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
References: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a link whose device has max_recv_sge == 1 there is no shared v2 receive
buffer, and smc_llc_save_add_link_rkeys() takes the v2 extension from 44
bytes past the start of the queue entry's inline message:

  ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg + SMC_WR_TX_SIZE);

The entry is a 72-byte allocation and the extension starts at offset 68, so
ext->num_rkeys at offset 94 is already past it. This happens on every
SMC-Rv2 link addition, whatever the peer sends:

  [    2.490065] BUG: KASAN: slab-out-of-bounds in smc_llc_save_add_link_rkeys+0x333/0x350
  [    2.490431] Read of size 2 at addr ffff8880056406de by task smctest/106
  [    2.490709] 
  [    2.490792] CPU: 0 UID: 0 PID: 106 Comm: smctest Not tainted 7.2.0-rc5-p1-g77a5d9d9c99f #32 PREEMPT(lazy) 
  [    2.490795] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    2.490798] Call Trace:
  [    2.490803]  <TASK>
  [    2.490805]  dump_stack_lvl+0x53/0x70
  [    2.490810]  print_report+0xd0/0x630
  [    2.490828]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
  [    2.490832]  ? smc_llc_save_add_link_rkeys+0x333/0x350
  [    2.490834]  kasan_report+0xce/0x100
  [    2.490836]  ? smc_llc_save_add_link_rkeys+0x333/0x350
  [    2.490837]  smc_llc_save_add_link_rkeys+0x333/0x350
  [    2.490839]  ? smcr_buf_map_lgr+0x1bf/0x2b0
  [    2.490844]  smc_llc_cli_add_link+0xca7/0x1e80
  [    2.490848]  ? smc_llc_wait+0x355/0x810
  [    2.490850]  ? __pfx_smc_llc_wait+0x10/0x10
  [    2.490851]  ? __pfx_smc_llc_cli_add_link+0x10/0x10
  [    2.490853]  ? __pfx_autoremove_wake_function+0x10/0x10
  [    2.490863]  __smc_connect+0x3f5c/0x4980
  [    2.490873]  ? __pfx_kernel_connect+0x10/0x10
  [    2.490888]  ? __pfx___smc_connect+0x10/0x10
  [    2.490891]  ? release_sock+0x148/0x1d0
  [    2.490894]  smc_connect+0x42c/0x580
  [    2.490896]  __sys_connect+0xfc/0x130
  [    2.490898]  ? __pfx___sys_connect+0x10/0x10
  [    2.490900]  ? handle_mm_fault+0x1a1/0x430
  [    2.490908]  __x64_sys_connect+0x6d/0xb0
  [    2.490909]  ? fpregs_assert_state_consistent+0x56/0xe0
  [    2.490917]  do_syscall_64+0xf9/0x540
  [    2.490921]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [    2.490924] RIP: 0033:0x421bb4
  [    2.490927] Code: ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d ad 34 09 00 00 74 13 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 10 89 55
  [    2.490929] RSP: 002b:00007ffd473b01a8 EFLAGS: 00000202 ORIG_RAX: 000000000000002a
  [    2.490935] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000421bb4
  [    2.490936] RDX: 0000000000000010 RSI: 00007ffd473b01d0 RDI: 0000000000000003
  [    2.490937] RBP: 0000000000003930 R08: 0000000000000004 R09: 0000000000000000
  [    2.490938] R10: 00007ffd473b0f98 R11: 0000000000000202 R12: 0000000000000006
  [    2.490939] R13: 00007ffd473b0f87 R14: 0000000000000003 R15: 00007ffd473b0f90
  [    2.490940]  </TASK>
  [    2.490941] 
  [    2.499545] Allocated by task 44:
  [    2.499693]  kasan_save_stack+0x33/0x60
  [    2.499860]  kasan_save_track+0x14/0x30
  [    2.500026]  __kasan_kmalloc+0x8f/0xa0
  [    2.500190]  __kmalloc_cache_noprof+0x158/0x370
  [    2.500393]  smc_llc_enqueue+0x72/0x560
  [    2.500559]  smc_wr_rx_tasklet_fn+0x474/0xa80
  [    2.500747]  tasklet_action_common+0x20f/0x8a0
  [    2.500945]  handle_softirqs+0x18e/0x590
  [    2.501115]  do_softirq+0x3b/0x60
  [    2.501266]  __local_bh_enable_ip+0x61/0x70
  [    2.501446]  __alloc_skb+0x732/0x890
  [    2.501604]  rxe_init_packet+0x16b/0x4f0
  [    2.501783]  prepare_ack_packet+0xb8/0x830
  [    2.501962]  rxe_receiver+0x495/0x96e0
  [    2.502125]  do_work+0x144/0x470
  [    2.502269]  process_one_work+0x633/0x1030
  [    2.502450]  worker_thread+0x45b/0xd10
  [    2.502617]  kthread+0x2c6/0x3b0
  [    2.502762]  ret_from_fork+0x36e/0x5a0
  [    2.502925]  ret_from_fork_asm+0x1a/0x30
  [    2.503103] 
  [    2.503177] The buggy address belongs to the object at ffff888005640680
  [    2.503177]  which belongs to the cache kmalloc-96 of size 96
  [    2.503692] The buggy address is located 22 bytes to the right of
  [    2.503692]  allocated 72-byte region [ffff888005640680, ffff8880056406c8)
  [    2.504227] 
  [    2.504300] The buggy address belongs to the physical page:
  [    2.504535] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5640
  [    2.504865] flags: 0x100000000000000(node=0|zone=1)
  [    2.505076] page_type: f5(slab)
  [    2.505221] raw: 0100000000000000 ffff888001041280 dead000000000122 0000000000000000
  [    2.505544] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
  [    2.505867] page dumped because: kasan: bad access detected
  [    2.506102] 
  [    2.506176] Memory state around the buggy address:
  [    2.506380]  ffff888005640580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
  [    2.506683]  ffff888005640600: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
  [    2.506987] >ffff888005640680: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
  [    2.507291]                                                     ^
  [    2.507548]  ffff888005640700: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
  [    2.507850]  ffff888005640780: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc

Whatever that read finds then bounds the ext->rt[] loop, so a peer that
declares 255 rkeys reads much further. smc_llc_rmt_delete_rkey() has the
same shape for llcv2->rkey[].

Bound both loops by the buffer they read from, and skip the extension
altogether when there is no shared v2 receive buffer. The extension
does arrive on the link, but smc_llc_enqueue() copies only
sizeof(union smc_llc_msg) into the queue entry, so what that code read
past the 44 inline bytes was heap and not peer data.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Cc: stable@vger.kernel.org
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v4 -> v5: corrected the reason given for skipping the extension. It does
arrive on the link; what is not there is the copy in the queue entry. No
functional change.

Measured over rxe with KASAN and max_recv_sge forced to 1, five test cells
(plain 1-rkey delete, delete declaring 255, plain ADD_LINK v2, ADD_LINK
declaring 255, and an SMC-Rv1 link group). Without this patch four of the
five report; with it none do. With kasan_multi_shot the unpatched kernel
reports 491 times in a single ADD_LINK run, the patched one not at all.

Changes since v5: none.

Changes since v6: collected Sidraya's Reviewed-by; removed the extra
spaces after sentence-ending punctuation. No functional change.

 net/smc/smc_llc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 055a03eee5b5..748d65186f68 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1000,13 +1000,21 @@ static void smc_llc_save_add_link_rkeys(struct smc_link *link,
 					struct smc_link *link_new,
 					u8 *llc_msg)
 {
+	const u32 rt_off = offsetof(struct smc_llc_msg_add_link_v2_ext, rt);
 	struct smc_llc_msg_add_link_v2_ext *ext;
 	struct smc_link_group *lgr = link->lgr;
 	int max, i;
 
+	/* Without a shared v2 receive buffer the extension is not copied
+	 * into the queue entry, so not even ext->num_rkeys is there.
+	 */
+	if (!smc_link_shared_v2_rxbuf(link))
+		return;
 	ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg +
 						     SMC_WR_TX_SIZE);
 	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
+	max = min_t(u32, max, (SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE - rt_off) /
+			      sizeof(ext->rt[0]));
 	down_write(&lgr->rmbs_lock);
 	for (i = 0; i < max; i++) {
 		smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
@@ -1811,17 +1819,25 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 	link = qentry->link;
 
 	if (lgr->smc_version == SMC_V2) {
+		const u32 rkey_off =
+			offsetof(struct smc_llc_msg_delete_rkey_v2, rkey);
 		struct smc_llc_msg_delete_rkey_v2 *llcv2;
+		u32 buf_len;
 
 		if (smc_link_shared_v2_rxbuf(link)) {
 			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
 			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
+			buf_len = SMC_WR_BUF_V2_SIZE;
 		} else {
 			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
+			buf_len = sizeof(qentry->msg);
 		}
 		llcv2->num_inval_rkeys = 0;
 
 		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
+		/* bound by the buffer llcv2 points at */
+		max = min_t(u32, max, (buf_len - rkey_off) /
+				      sizeof(llcv2->rkey[0]));
 		for (i = 0; i < max; i++) {
 			if (smc_rtoken_delete(link, llcv2->rkey[i]))
 				llcv2->num_inval_rkeys++;
-- 
2.43.0

