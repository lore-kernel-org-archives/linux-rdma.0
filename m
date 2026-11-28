Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795874926;
	b=VsSSpeng+Zbiq0Og2Hzw2JfFyxwZzhLwFYD3kh9vs915R5OmNHk24Ake9Zxyho+eje3g
	 8wVAoYBmh4IzG5WyFFxghiUiznmg6d3++SthSn/Q6a5zEOyor4AjK+5HcUmMuWxCHR3Gj
	 d/fa2RF5Mz7OBW+YBvhSKxTrjoFwRhNiXyhZsiBxCWQznJgNTsDW/zlhttCnOk+86cne9
	 WGNRkBP4pP8NVMN235g+e6yg2rA2pwGjLLAiNOsuDdAfqBoEirWd0ZjLx+rtwAL/U87y2
	 RjHThImWPe45VWBsYmdwJkqAC4kIx9SiaEiutU7QW3L8/gCle5CUCTujaoaAy80kyFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795874926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XPZKr/XcNS38JuBrrYjhIyXsANdIW2LIU3lQVRKYlF4=;
	b=1J2lle4MKEszB1zlaaT72je+zXEg8UJbcfiuFdkaC9rjhD3t+rDDIujTpW2yeoJB/PjO
	 dAWzQNYcHfgWF3S6wLnhMR65ds7sgQbilTavljB7iZ85V7jNykT8RRLGdK8pQcwpBAQ3X
	 h7Ch3GvkMAfgY5Oo84Avp1QjnV3Qw+/1I6PFmR+srXtef1jdY35dYenx4sSqpcuQI37F3
	 Iagz43AICNkEEXmeBtDOfnPIzjErFVa4SK6lP9+MCbxewBx8ozAXpTh3klxdkLN5jrF86
	 zrXQfneuSopgh+0W3j5MAeHvtbU3R8kkx1vBN1Jp5lbBjPid/xdb2j5hQ/OQnZk5hEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=none smtp.mailfrom=stellman-greene.com;
	dkim=pass header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HFVS31vz;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A209606A325
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 14:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A209606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HFVS31vz
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-949680e6d82so933637585a.2
        for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 06:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stellman-greene-com.20260707.gappssmtp.com; s=20260707; t=1795874924; x=1796479724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPZKr/XcNS38JuBrrYjhIyXsANdIW2LIU3lQVRKYlF4=;
        b=HFVS31vzjttAJ/JQxgY2hOKMSU6IlVWobEYazsUkcTJ+xMxpyKYS3Gn9h84el1jRfL
         bSpKVxlnKPG2IiWY/QAq+TwIGaqZUmCwiPi5Fmq+qs7521/rKIEXau9mmtjBU/bjD4ZO
         Y7/KYhiZ5OFbz/5pgwTilEJct/tW1Z2DJxATN/Bdo+XMo37A8pYLkJY2oxrjKPl1SJR0
         vhX3zGLURYhQqw0non+UowaOJE4tFmuDhfQkXHwhk59urc/mf8Nj46DrIKBqPGdFVIiM
         vOW6nqQvVUdfp9FM4ccqbuZB+A8mWNkYvS8kBKSYliuwJShmLypnvTXUTVTQ57Pui3cT
         U3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795874924; x=1796479724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPZKr/XcNS38JuBrrYjhIyXsANdIW2LIU3lQVRKYlF4=;
        b=dE5I8blatzfjsSI1upZKwJGEw3NJF0fkO71EEX+SMdFtn7sV9MQ2VACW63yvXzd44y
         mjEFKcNUplTy4mHyxFasVBM4AN2aHT1UkqItT3//ZNJIP2ivpWlaVhDo5KnKGxmHYnTU
         rsYdnUTzh3qMXG5ffQo9wmdGJteKjeaLb84RpqhjTuWBkHjQuaNCC7rXq0xjC8cYoC0Y
         5xZTABWBp2YABWbmL/nGMpW7YozOwSUMfsCZgxkfFK98JI4dErZnAhT/gmIxa9FHkXh3
         l2rSkvFbblMr7T31dDWx36A2zA9lAUpY7R9zT20sA1Of3DWDBoKxbgX2+PzkUyJjvEfr
         VCjA==
X-Forwarded-Encrypted: i=1; AL+hErFLx1vZlkiHwkYYMdOJOS7d+Lfad1k6qkcJANL4aXg3IgZt5DvZHAFlTf0m0vO866GewaMFZZ8teLdI@vger.kernel.org
X-Gm-Message-State: APuU4Z+KjZj8EscQ1HIcxnJCBjJ63XAe43lC8hz8hzjJICRzYLP1kRhY
	KbZtwQt3xeCUOuNTGSrXiv494w6xAxIqIanhegyUi6ZXg4r1ildyrDg06XM/qswHoYVXp0AfJMZ
	pLMHBB82EWA==
X-Gm-Gg: AZFdTZcuYs+AoqaG1mCfPXa0+AGoMj+qKn2h6dIaTXtS1Ba7IUbgxI9SjQK/zQDxjyg
	h4Ecqu/FfV2wuyux3+6PAMpiK4AVykdCz8h0ops+y68JmypJ8E2ZhzzzpkhrWVIHtqtNLsN7J/d
	o8qB/uIMfks9pXyjOszzv5DMAycCzX5Ylf3ZnbIHb9VtHFFK2603ntasSUQ+VfPB/orH3b/BY2o
	Mui2GjeJI3R7/3E7oA61xTr+3KIpmqQuQXb4ejP0qGc+P2XNBxlrtGlDXdxF4tjPTZZR92YGI92
	kcZn3CRo6jOTtYfL5GPk5YiOEiHpYl6t69bZZuT+hziaoH6ELrfN1cUFTKsj4zeHbkIK8RHU6Ub
	ypXNs0XCDtPNqWfJiYPdrD6uiIiDk9G6sLbpZCzyS1gCh/+djWF6sHsUFkOJlp2n3dqO0xCWG8u
	QhCPMVl1mqs50K5Zm4Bu+FfdZThL8TVeeQi+KFsGoLcOLtjRBPI3VyTc++mkmnZp7dHuGQ5yZgj
	4+M7w/xzOreOEM2S211gbduRuJeynLvzO5vjXRn7481qBugk0RZNd7h87CVLEva1wuw+Erv3J6u
	EZbvIADY1jG5eMAZmX76JNoTko2PBd9AkwN9GC+4F83CiRSB8Km4k1CZccSxZzxL4skgt/1jwUF
	Opw==
X-Received: by 2002:a05:620a:1313:b0:949:7b51:2dc1 with SMTP id af79cd13be357-949ba80f404mr4768760085a.2.1795874923988;
        Sat, 28 Nov 2026 06:08:43 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:a4e3:fb15:aef5:60c7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb031617sm2063542785a.1.2026.11.28.06.08.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Nov 2026 06:08:43 -0800 (PST)
From: Andrew Stellman <bugs@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Fix NULL dereference when disconnect races the RTR callback
Date: Sat, 28 Nov 2026 09:08:43 -0500
Message-ID: <20261128140843.59029-1-bugs@stellman-greene.com>
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

From: Andrew Stellman <astellman@stellman-greene.com>

siw_rtr_data_ready() releases sk_callback_lock and then calls
siw_qp_socket_assoc(), which reads cep->sock->sk before it takes the
write lock. A concurrent disconnect can disassociate the socket and
clear cep->sock in that gap.

In QEMU (arm64) on mainline as of 2026-11-28 with KASAN, a test server
accepted an MPA v2 connection that waits for the peer's RTR frame. The
server calls rdma_disconnect() when it gets the ESTABLISHED event. The
peer sent an incomplete RTR header. With a test-only one second delay
added after the callback unlock, this oopsed:

  Unable to handle kernel paging request at virtual address dfff800000000003
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  Mem abort info:
    ESR = 0x0000000096000005
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x05: level 1 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0
  [dfff800000000003] address between user and kernel address ranges
  Internal error: Oops: 0000000096000005 [#1]  SMP
  Modules linked in:
  CPU: 0 UID: 1000 PID: 366 Comm: siw037-peer Not tainted 7.4.0-rc4-g7cd8495c0f16-dirty #15 PREEMPT(full)
  Hardware name: linux,dummy-virt (DT)
  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : siw_rtr_data_ready+0x218/0x2c0
  lr : siw_rtr_data_ready+0x1ec/0x2c0
  sp : ffff8000800071f0
  x29: ffff800080007270 x28: ffff0000e396cd37 x27: 1fffe0001c942e76
  x26: ffff0000e396cd18 x25: 1fffe0001c942e6a x24: ffff0000e396c848
  x23: ffff0000e80a2c00 x22: ffff0000e846e000 x21: 0000000000000000
  x20: 1ffff00010000e3e x19: ffffd9a666b96d00 x18: ffff0000e846e38c
  x17: 0000000000000000 x16: 1fffe0001c72d974 x15: ffffd9a66521701c
  x14: ffffd9a6653f32c8 x13: 6465736f6c632070 x12: ffff700010000dd9
  x11: 1ffff00010000dd8 x10: ffff700010000dd8 x9 : dfff800000000000
  x8 : ffff800080006ec7 x7 : 0000000000000001 x6 : ffff700010000dd8
  x5 : ffff800080006ec0 x4 : ffff700010000dd9 x3 : 0000000000000000
  x2 : 0000000000000003 x1 : dfff800000000000 x0 : 0000000000000018
  Call trace:
   siw_rtr_data_ready+0x218/0x2c0 (P)
   tcp_data_ready+0xd0/0x3f8
   tcp_data_queue+0x1898/0x506c
   tcp_rcv_established+0x94c/0x2e80
   tcp_v4_do_rcv+0x400/0x660
   tcp_v4_rcv+0x177c/0x314c
   ip_protocol_deliver_rcu+0x64/0x3e0
   ip_local_deliver_finish+0x244/0x440
   ip_local_deliver+0x16c/0x288
   ip_rcv+0x120/0x218
   __netif_receive_skb_one_core+0xf8/0x17c
   __netif_receive_skb+0x24/0x14c
   process_backlog+0x15c/0x428
   __napi_poll+0x90/0x394
   net_rx_action+0x33c/0x8c0
   handle_softirqs+0x368/0x910
   __do_softirq+0x14/0x20
   ____do_softirq+0x10/0x20
   call_on_irq_stack+0x30/0x48
   do_softirq_own_stack+0x1c/0x40
   do_softirq+0xb0/0xc4
   __local_bh_enable_ip+0x208/0x284
   __dev_queue_xmit+0x744/0x2bb8
   ip_finish_output2+0xd48/0x196c
   __ip_finish_output+0x234/0x7a0
   ip_finish_output+0x34/0x2e4
   ip_output+0x15c/0x27c
   __ip_queue_xmit+0x5e0/0x18a0
   ip_queue_xmit+0x44/0x64
   __tcp_transmit_skb+0x15a4/0x3b50
   tcp_write_xmit+0xfa8/0x702c
   __tcp_push_pending_frames+0x88/0x264
   tcp_push+0x400/0x68c
   tcp_sendmsg_locked+0xe34/0x33dc
   tcp_sendmsg+0x38/0x60
   inet_sendmsg+0x90/0xdc
   sock_write_iter+0x220/0x374
   vfs_write+0x9d4/0xcc0
   ksys_write+0x198/0x1e4
   __arm64_sys_write+0x70/0xa0
   invoke_syscall+0x74/0x2c0
   el0_svc_common.constprop.0+0xac/0x230
   do_el0_svc+0x40/0x58
   el0_svc+0x38/0xa0
   el0t_64_sync_handler+0xa0/0xe4
   el0t_64_sync+0x198/0x19c
  Code: d2d00001 f2fbffe1 910062a0 d343fc02 (38e16841)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Oops: Fatal exception in interrupt
  SMP: stopping secondary CPUs
  Kernel Offset: 0x59a5e2a00000 from 0xffff800080000000
  PHYS_OFFSET: 0xfff1000040000000
  CPU features: 0x0,00000000,00600051,12300a01,280ce727
  Memory Limit: none

Take the callback's socket write lock and check that the socket still
belongs to the same CEP and QP before installing the QP callbacks. If
it doesn't, do nothing.

With the fix and the same delay, the same test ran without a KASAN
report. After reverting the fix, the oops came back. Without the delay,
an MPA v2 connection with a valid RTR frame connected and disconnected
the same way before and after the fix.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix was drafted with OpenAI GPT-6 (Codex) and this changelog with
Claude Opus 5.5, and both were reviewed by me.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
A reproducer is available on request.

Bernard, the release worker in siw_cm_work_handler() clears cep->qp and
puts the QP before it calls siw_socket_disassoc(), so the cep->qp check
here doesn't serialize against that path. I haven't reproduced a fault
on that path, so I left it alone. Would you want the worker to
disassociate the socket first, as the immediate path in
siw_qp_cm_drop() does?

 drivers/infiniband/sw/siw/siw_cm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index ed49818793ddeb..8612db3cc94e8c 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -181,8 +181,15 @@ static void siw_rtr_data_ready(struct sock *sk)
 		siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);
 out:
 	read_unlock(&sk->sk_callback_lock);
-	if (qp)
-		siw_qp_socket_assoc(cep, qp);
+	if (qp) {
+		write_lock_bh(&sk->sk_callback_lock);
+		if (sk_to_cep(sk) == cep && cep->qp == qp) {
+			qp->attrs.sk = cep->sock;
+			sk->sk_data_ready = siw_qp_llp_data_ready;
+			sk->sk_write_space = siw_qp_llp_write_space;
+		}
+		write_unlock_bh(&sk->sk_callback_lock);
+	}
 }
 
 static void siw_sk_assign_rtr_upcalls(struct siw_cep *cep)
