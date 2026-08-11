Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0442FCB9
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 23:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786490425; cv=none; b=iXW3lfOR9WqWxAWi54lhyJQ/x9hFMGDe2O7UTQh1g5PE2X1G26JsUSlH1r20OCBp9AbhA+DtfCXHM/1weG+vdpdnULB6dJujEfykL0zX8f3/LCNbacjezjwpo4xtu4qt+NJZchZnQrWCfgukTtI4BV9qWqcUUKhAk0fy6+ra4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786490425; c=relaxed/simple;
	bh=ramlrnMJG12sU1HSKRzL6k/DNzPk28iC5T5uY9kAm5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3Gv5bL8SwYKhp23nThIrHSe60Bbnsq3BFstbzVVDxCodlXiL7fqTLH3lmSs53q301eEpUU8aMjPBgmnqUKy4Pzz6n0yCuEAwjw8/gwQLoW6Yjs7kUZLDNIf3x6xohOi05hPq5MEWgD4E139jzMpZabzoQxczcK98vl6Y4RaavM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=zo5xmlbe; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="zo5xmlbe"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8486ac3f347so1542942b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 16:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786490423; x=1787095223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PqM4RUHFJHYgsOUI3et1n95pYjRwiyC2guAXCJsd3iE=;
        b=zo5xmlbeC6APkEWF+G1XPa2Wl6vGEzTMo0LDtltgLuRXx5turDxF9MB+D6khH83WVS
         Oq5ChSXJK8KR7/f7PfhVAi0yH0NzW6Bg6qCAc2iZW+wMKk9j+LWpiz6ojtR+D4fdI8Km
         WEVF5WSFFaNzPrWOo9VrJ0jJEkt2n4ZGH3WExRdzt2OawT+HknBUi512Fep5PhaI63Dc
         2iLLILJIAtdgRsKFY8Q6pStOqzvbAebOO2eMcxVTWy9uHAIDR/xMXjHc/gGygKHoiBfS
         2yZWIRPA0NgsWLr6hygoi6b27hoKHx3Pya/7lyfqjyjiRkVZ0hHfpFFpw9vdGhQpuiWp
         awtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786490423; x=1787095223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PqM4RUHFJHYgsOUI3et1n95pYjRwiyC2guAXCJsd3iE=;
        b=lnDda2W7MKDzZ5C5SglSYycPaYgtPrXSXj0axPPbSFpit+T3vtRaLLBXHEqrY+1LNZ
         i1L1IDxpkQ2u83dLXFnxrDv5WPjVSR/2H/rvHJHfrphCZtvjcI3uXZFZ4lxViJ0DdnBc
         IH+6oH/6OnALTHWwuKzp3uZEqWmauPTMGFFDEBAvyQEd1ZVdIPi0TXX5LUekh8DfnUT6
         gx9X2+xVZkAVl1c2YN8AKdypkO0K7LH41v/3tk2IWeidqj9m2mpAZHjuuUt/6Kl2lm/E
         9aYvWXnF2UeqAHe9AbIK2faLSVMRpmJe9UvaT5sJjcTDKBzFPsicM18XLiAOeJ+Bx86f
         oBJw==
X-Forwarded-Encrypted: i=1; AHgh+Rr0GSfzq8lDicLVMic+6KtiiVlSFZlecXC89jNn7B7N233o5PpW9bdJFPMmTNNGqR/gAQi2S6zDjHMh@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj4rpJ6U1TXOIyfg+1eQdaXrJVuDMcn5Gv3DNvp9bpCftOuVwU
	zWR1zqrHjDHp4Sv3ZITFmNIEKNC2+bTg2qedVkTwqenvyzwe5bxC2cy3gkHEjq+2WgA=
X-Gm-Gg: AR+sD128X7jlcTwlN/VLBoWS7EVt6+oe/JmonxmfaLRUh2pGgV+RZCVPCh5w3fa4jyN
	B8dnDOI8s4ngvgbtRHJSqitbYJKL5R9axajFp9JFV3noVK5drx82R2+3HuvTa+5cWViiJZQtm2x
	xHA/hAaHotqRn4LM+usZ2XgHqkopbKan0OyKP4gIjykcdDKfgu1rGxHiMp7zTTOEl5NyPMapDBk
	T7h5Fuk8gkI2+e5Ca21inEDHdt1L6cZ/A1shL2nPVBiHbI+08FCCVL5uPELP9WVbwHpzV1E5GAN
	cmXp4TlyfOZuSj/lRYoL36xdrPQ8Fw8tJ+878KdocoLqVusoaA+D5XQJlhsxBhla7ip+VwVYH9J
	aU2ehS1FImTTJv+9b0isa/cc93u/i7eMBppMiKWsXPkjRAJQcEFeNZWbIHFxIwO9Nkf9S2MxxPe
	Y0F9KikDDPKUjLOEvoT6xZcvTdlon+PijGkg/H0zjmVlkj4NS789J3WOP4QgPuTOAXbWQ4PWEnr
	tlXAhW5WFg=
X-Received: by 2002:a05:6a20:9f93:b0:3b5:530d:d96d with SMTP id adf61e73a8af0-3cc3f8c2a31mr378177637.12.1786490423253;
        Tue, 11 Aug 2026 16:20:23 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:365f:6c09:b402:1986])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbedbac8842sm1177810a12.30.2026.08.11.16.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 16:20:22 -0700 (PDT)
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
Subject: [PATCH net v6 2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
Date: Wed, 12 Aug 2026 08:19:01 +0900
Message-ID: <20260811231902.47089-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
References: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
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
ext->num_rkeys at offset 94 is already past it.  This happens on every
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
declares 255 rkeys reads much further.  smc_llc_rmt_delete_rkey() has the
same shape for llcv2->rkey[].

Bound both loops by the buffer they read from, and skip the extension
altogether when there is no shared v2 receive buffer.  The extension
does arrive on the link, but smc_llc_enqueue() copies only
sizeof(union smc_llc_msg) into the queue entry, so what that code read
past the 44 inline bytes was heap and not peer data.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v4 -> v5: corrected the reason given for skipping the extension.  It does
arrive on the link; what is not there is the copy in the queue entry.  No
functional change.

Measured over rxe with KASAN and max_recv_sge forced to 1, five test cells
(plain 1-rkey delete, delete declaring 255, plain ADD_LINK v2, ADD_LINK
declaring 255, and an SMC-Rv1 link group).  Without this patch four of the
five report; with it none do.  With kasan_multi_shot the unpatched kernel
reports 491 times in a single ADD_LINK run, the patched one not at all.

Changes since v5: none.

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

