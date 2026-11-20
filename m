Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183560;
	b=u8LQaiwR0f7Vo1HtY/M/sV0+XD7Q2nlO2Dd6hu+Llamk8VsfzUY6ltVjAFA5I2/XdZll
	 cfItxhZhv+FEfb07liuKR6nYopv2Pm5l2IH7fAhUk/Y/9zI7dmf8/waOFe/Pd3YHKPXY7
	 j00Ic86cdTpADAb9TXJiW85Te+NNpsyrHzjp2t2NIHxV5VBsASWqqSxEOwXHBRs/l8Ikr
	 O4774CAS0nG0hYCAEG5WT/004GOc4jyuIIWdSqBekJstoH8fYrpt9+e1QY/odgsb+6BkF
	 FUGDP7hpWowW9v1+RV5oLISXdBFmrqToLLpXZL+c5PipIm2NYxzyGGIjGmWTLNCEVrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183560;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uOUcQ3a3xSsnKCTkREjD+EYCb46xsY+JcFYjpDmO1o8=;
	b=BEVGsC9HawALTPXjAcV9x4GjfaADHZsqg/fbhYoMQJHS8aGFlk4xG1F/xS/RefH6xzsB
	 BcnaTr+RKZWIJvP126509eVXJMn39/s35V4w/JM1hvlhuPniB/2zu4W4gsx4VM/6G6fW+
	 4bn3/1eal10D/WawfJ1jFgBzlHUG+EmbCXw8I5vMX8Di3J6/LPPAax24ONoEAsqlvnNaC
	 LIB6EYc7/9zgOXH4WVL6AJdQeUYCxjX9og+5VMsghWlJIt2zlwzcK+udjtR7oFFgYLGAn
	 Lu9mrwRIXyZ4PS2lJI2nRW2vpMQbWoKTUbc+c/s7JdDgVDQ1xn8Dqyap1BW+PXJT0zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yvwvH3jb;
	arc=none smtp.remote-ip=209.85.217.41
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DDE606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 14:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77DDE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yvwvH3jb
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7d2ccd3c7a2so298809137.0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 06:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795183558; x=1795788358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uOUcQ3a3xSsnKCTkREjD+EYCb46xsY+JcFYjpDmO1o8=;
        b=yvwvH3jb40gsI7rgbsjulPWym+fsR0b1+x2O2W/mNCCzTBEh6hmzaboQ8dck9u5R1L
         KYsOaK3gh+fTNfKJXKvjKRTEpzijNqXOnQRFpQ9eZ9Q7J52PajPBlna24iL3xIywhwNb
         R1627L8cfNVcGyDx+GBGQoUqjr9CFUU+NP9Dgg1EQ0P/iVblt9MJ9JONnsOZUXcJK9X7
         cg2W2k2HRP+M32XskamGiex1CfckOYUEtT5i0/8NqHo6rXjDYLwfkp01wmJdMKgQfSGg
         /KDM8nOKqKF4Vu2HA6aojgswKvOebH5/oLhg8WFew9OVhl/6sTiUtfn9z3Pr+/9VE1yB
         76kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183558; x=1795788358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uOUcQ3a3xSsnKCTkREjD+EYCb46xsY+JcFYjpDmO1o8=;
        b=cKtRPQZrZbGDWND4D2eJtcI9EmFVmn5lhrwRVAS0zxWug8sougI/J8c26qoWJPmXnO
         2zKhayn9GQGEhdKSjJUUJkTg0tNrcbeR5u3P/FyNWcVfaO3S5fs/ZZKouMGL5vtAet87
         ItR9y2CEYkkHM3oCAA6E3eP7rk311eOqHTz1n4spTBNWEeAv8+VliavWNUP4l/0PgpFh
         fRz3uHVBoKP8A3Ebyp/0GI0Z6VW1+LrdnTkSU+wj50rjkAxGSuSgoSeeDV4QZc7ft8xP
         uiDyRwPBv3UIxfJR7bLxPHEcBpC7r9Fd9x4kd307awJuqCV3bdGeF2RMJVdh+u4XvBCU
         Kouw==
X-Forwarded-Encrypted: i=1; AL+hErGoAB8sJOXpTl3WJ5/65d3LVvS7M4rqB2f+RzL1ErKtlocZycEpzcpLYhuUu/RKjFKVNYSmhRYrWaOZ@vger.kernel.org
X-Gm-Message-State: APuU4Z+0/zR+a5iIVjW66Mj/HncWnQfjg7bAd7a1ipZ+6SHwJbtqHSYX
	EIkg/zNhyYKTmzkys6a1ee4jWlOCZX3mKtsfy6zQ9MtBm5Y3IdgdLWWb
X-Gm-Gg: AZFdTZfWUWGH8bbW4/2ubXSyOGB9KpzqIN4FOaDUjicAs7PRNScUE4PMjJs+Sye0jup
	F32hc2DS4dRSmsm3FNMhzg3O4ewQvofXXRlBG52I8N496lzFJhdwAD7Zat+BUSGxmlD+pA+FJiT
	U86+1Pf7IaPcNYp21fWsycAurOkBzkaYgOxBq0N6eIIQzGVM3A1FeKjGlCWMVKt19S3TCIS1sDd
	UQRzkLndeHGcw3QNl7ykPVSkT4yA3m3bRFZ30OP5yylAJIpUSp/hmt7QFRXh0Ep806kHo3SAnnw
	3PwrxlR0bqCdpBo/Qwdqxj6sr+Hs63mh/mOrSPDCU0GDPBnlSQ4R6Y1rsp7uy+6rz3A0bwT5Hqk
	IzfI3y2IHdagIoRtaWHeMbQBMRtMuHsAX729wlisIl8CIfRR/ngf4oWm7R+EhQo6OueWH3P4q46
	hSOOp++A114OYK5vb4NY6ipOh9sJWFAriepL89eoOnfoA5qjxdsfCyLdICctMaJQlNWXUgKoQbC
	iAq/0ttAQFonH9MgL4NDsPGDXposJC7OHtJPcxN/WL2LqsqY+Oe6DGaA+bwUTRhk68Mj0Yx9y3n
	TCQs+dQ4Xn7oLzPj7bMUcRtx06KQQMbJo4vcFBfqX0V5Pf72wq1DHiB9VDnfG2pq8OJuf1thQft
	op7B/uVHfwVwLAloQv4oi6m6IyB1VsSJ+qj6vVpzjxGwklJeD6e6uW0YGxcD7C9/xEAoqYOQTl6
	d7siiolUQRf/h2nOiG8q6by409jeE=
X-Received: by 2002:a05:6102:4245:b0:7d2:d45e:5c9d with SMTP id ada2fe7eead31-7d7393581c9mr1145115137.13.1795183558136;
        Fri, 20 Nov 2026 06:05:58 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:a4d9:d040:5fad:8738])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921347966desm26185216d6.3.2026.11.20.06.05.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 06:05:57 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc v2] RDMA/siw: Reject a zero length WRITE segment that announces more segments
Date: Fri, 20 Nov 2026 09:05:52 -0500
Message-ID: <20261120140552.62784-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
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

siw_proc_write() returns early for a zero length tagged segment, before
it looks up the sink STag. If that first segment has the L bit clear,
the next segment is handled as a continuation of the same message and
siw reads mem->stag through rx_mem, which was never set. A remote peer
on an established siw connection can trigger this, and it panics the
host:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
  CPU: 1 UID: 65534 PID: 119 Comm: siw001peer Not tainted 7.4.0-rc3-gaebb72744764 #16 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:siw_proc_write+0x175/0x9c0
  Code: 48 c1 ea 03 80 3c 02 00 0f 85 c3 07 00 00 48 8b ab 80 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7d 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 31 07 00 00 39 75 20 0f 85 4f
  RSP: 0018:ff1100006cf08318 EFLAGS: 00000202
  RAX: dffffc0000000000 RBX: ff11000005880000 RCX: 0000000000000000
  RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000020
  RBP: 0000000000000000 R08: ff11000005880408 R09: ff1100000588039a
  R10: 0000000000000010 R11: ff11000005880398 R12: 0000000000000010
  R13: ff110000058803fc R14: 0000000000000000 R15: ff110000058803dc
  FS:  00007f9054dd1740(0000) GS:ff110000da92e000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: dffffc0000000004 CR3: 0000000005703000 CR4: 0000000000751ef0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   ? irqentry_exit+0x31b/0x6a0
   siw_tcp_rx_data+0x20e/0x2040
   ? __pfx_selinux_netlbl_sock_rcv_skb+0x10/0x10
   __tcp_read_sock+0x1ab/0x810
   ? __pfx_siw_tcp_rx_data+0x10/0x10
   ? __pfx___tcp_read_sock+0x10/0x10
   siw_qp_llp_data_ready+0x185/0x2e0
   ? __pfx_siw_qp_llp_data_ready+0x10/0x10
   ? tcp_try_rmem_schedule+0x17f/0x1390
   ? tcp_event_data_recv+0x36a/0x7b0
   tcp_data_queue+0x1f2d/0x4b70
   ? __pfx___mod_timer+0x10/0x10
   ? __pfx_tcp_data_queue+0x10/0x10
   ? tcp_try_undo_loss+0x6d0/0x730
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   tcp_rcv_established+0x8a8/0x3990
   ? security_sock_rcv_skb+0x2b/0x40
   ? sk_filter_trim_cap+0x400/0x980
   ? __pfx_tcp_inbound_hash+0x10/0x10
   ? __pfx_tcp_rcv_established+0x10/0x10
   ? __pfx_sk_filter_trim_cap+0x10/0x10
   ? _raw_spin_lock+0x80/0xe0
   tcp_v4_do_rcv+0x45b/0x970
   ? tcp_v4_fill_cb+0x26/0x400
   tcp_v4_rcv+0x223d/0x3b90
   ? __pfx_tcp_v4_rcv+0x10/0x10
   ? __pfx_raw_local_deliver+0x10/0x10
   ? stack_access_ok+0xd9/0x200
   ip_protocol_deliver_rcu+0x61/0x2e0
   ip_local_deliver_finish+0x329/0x4b0
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ip_local_deliver+0x18f/0x2d0
   ? __pfx_ip_local_deliver+0x10/0x10
   ? __pfx___netif_receive_skb_core.constprop.0+0x10/0x10
   ? try_to_wake_up+0x239/0x17a0
   ? __asan_memset+0x23/0x50
   ? ip_rcv_core+0x4e9/0xce0
   ip_rcv+0x21a/0x270
   ? __pfx_ip_rcv+0x10/0x10
   ? __pfx_call_function_single_prep_ipi+0x10/0x10
   ? select_task_rq_fair+0xb29/0x4110
   ? __pfx_ip_rcv+0x10/0x10
   __netif_receive_skb_one_core+0x161/0x1b0
   ? __pfx___netif_receive_skb_one_core+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? ttwu_queue_wakelist+0x2a5/0x390
   process_backlog+0x1e5/0x5e0
   __napi_poll+0x9c/0x520
   net_rx_action+0x8d0/0xe70
   ? __pfx_net_rx_action+0x10/0x10
   ? rcu_core+0x250/0x1830
   ? clockevents_program_event+0x2ba/0x860
   handle_softirqs+0x1b3/0x600
   ? __pfx_handle_softirqs+0x10/0x10
   ? __hrtimer_rearm_deferred+0x156/0x450
   do_softirq+0x3d/0x60
   </IRQ>
   <TASK>
   __local_bh_enable_ip+0x6a/0x70
   __dev_queue_xmit+0x89e/0x3170
   ? __pfx___dev_queue_xmit+0x10/0x10
   ? __pfx_selinux_ip_postroute_compat+0x10/0x10
   ? __pfx_clockevents_program_event+0x10/0x10
   ? _raw_spin_lock+0x80/0xe0
   ? irqentry_exit+0x31b/0x6a0
   ? selinux_ip_postroute+0x3e9/0x9d0
   ip_finish_output2+0x765/0x1b80
   ? __pfx_ip_finish_output2+0x10/0x10
   __ip_finish_output.part.0+0x46e/0x950
   ? selinux_ip_output+0x19/0x210
   ? __pfx___ip_finish_output.part.0+0x10/0x10
   ? nf_hook_slow+0xa7/0x1e0
   ip_output+0x260/0x4c0
   ? __pfx_ip_output+0x10/0x10
   ? __pfx_ip_finish_output+0x10/0x10
   __ip_queue_xmit+0x6f8/0x1dd0
   __tcp_transmit_skb+0x2ec9/0x4720
   ? __pfx___tcp_transmit_skb+0x10/0x10
   ? kasan_save_track+0x14/0x30
   ? __kasan_slab_alloc+0x6e/0x70
   tcp_write_xmit+0x11c9/0x78d0
   ? __pfx__copy_from_iter+0x10/0x10
   ? skb_page_frag_refill+0x55/0x390
   __tcp_push_pending_frames+0x8f/0x2f0
   tcp_sendmsg_locked+0x1741/0x3fc0
   ? __pfx_tcp_sendmsg_locked+0x10/0x10
   ? up_read+0x1f/0x1c0
   ? __pfx_lock_sock_nested+0x10/0x10
   tcp_sendmsg+0x26/0x40
   sock_write_iter+0x3ef/0x4c0
   ? __pfx_sock_write_iter+0x10/0x10
   vfs_write+0xa37/0xcd0
   ? do_sys_openat2+0xd1/0x170
   ? kmem_cache_free+0xba/0x3a0
   ? __pfx_vfs_write+0x10/0x10
   ? __pfx_do_sys_openat2+0x10/0x10
   ? fdget_pos+0x53/0x4b0
   ksys_write+0x17c/0x1c0
   ? __pfx_ksys_write+0x10/0x10
   do_syscall_64+0xdf/0x4c0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f9054ef0574
  Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 80 3d d5 ea 0e 00 00 74 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 55 48 89 e5 48 83 ec 20 48 89
  RSP: 002b:00007fff4bb4ce88 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 0000000000000024 RCX: 00007f9054ef0574
  RDX: 0000000000000024 RSI: 00007fff4bb4cea0 RDI: 0000000000000003
  RBP: 0000000000000010 R08: 0000000000000073 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
  R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff4bb4cea0
   </TASK>
  Modules linked in:
  ---[ end trace 0000000000000000 ]---
  RIP: 0010:siw_proc_write+0x175/0x9c0
  Code: 48 c1 ea 03 80 3c 02 00 0f 85 c3 07 00 00 48 8b ab 80 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7d 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 31 07 00 00 39 75 20 0f 85 4f
  RSP: 0018:ff1100006cf08318 EFLAGS: 00000202
  RAX: dffffc0000000000 RBX: ff11000005880000 RCX: 0000000000000000
  RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000020
  RBP: 0000000000000000 R08: ff11000005880408 R09: ff1100000588039a
  R10: 0000000000000010 R11: ff11000005880398 R12: 0000000000000010
  R13: ff110000058803fc R14: 0000000000000000 R15: ff110000058803dc
  FS:  00007f9054dd1740(0000) GS:ff110000da92e000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: dffffc0000000004 CR3: 0000000005703000 CR4: 0000000000751ef0
  PKRU: 55555554
  Kernel panic - not syncing: Fatal exception in interrupt
  Kernel Offset: 0xb200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

A zero length DDP message consists of exactly one segment (RFC 5041,
section 5.2), so terminate the connection with a tagged buffer error
when a zero length first segment announces more segments.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with the same tool and reviewed
by me.

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
v2: Include the full dmesg trace, as Leon asked. No code change.
v1: https://lore.kernel.org/linux-rdma/20261120000829.64597-1-astellman@stellman-greene.com/

Tested in QEMU with KASAN on v7.4-rc3. The patch applies unchanged to
rdma for-rc. With this patch siw sends a TERMINATE and closes the
connection, a normal two segment WRITE is still placed, and rping over
siw works.
A reproducer is available on request.

 drivers/infiniband/sw/siw/siw_qp_rx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index e5b641c8d694..9b7e52906764 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -550,8 +550,16 @@ int siw_proc_write(struct siw_qp *qp)
 	int bytes, rv;
 
 	if (srx->state == SIW_GET_DATA_START) {
-		if (!srx->fpdu_part_rem) /* zero length WRITE */
+		if (!srx->fpdu_part_rem) { /* zero length WRITE */
+			/* A zero length DDP message is a single segment. */
+			if (unlikely(frx->first_ddp_seg && frx->more_ddp_segs)) {
+				siw_init_terminate(qp, TERM_ERROR_LAYER_DDP,
+						   DDP_ETYPE_TAGGED_BUF,
+						   DDP_ECODE_T_INVALID_STAG, 0);
+				return -EINVAL;
+			}
 			return 0;
+		}
 
 		rv = siw_write_check_ntoh(srx, frx);
 		if (unlikely(rv)) {

base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
-- 
2.43.0

