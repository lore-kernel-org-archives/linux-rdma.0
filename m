Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795C626E6F2
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784399665; cv=none; b=RiHF98BcLR48dtSEpFU8gAg4LkxqxVkkxzkICdhlJnFXGq9EgUvMyDDtyWtPM9CmSVntZqLogtObhUMYiYCUA+u+uiv5Ji10cGa0e6bCW7VoXVVdLlw1zgkXbLGrZxrrYYEbO0CdZoYt6nnAlWS/hwTiA5vQidWNIQ4CPeUshXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784399665; c=relaxed/simple;
	bh=g7Mj5txpJ8vBF81drD5/4LBlaLwjK/+72i4WalIkhew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=spTCXAKSZtZD5WZqfRBg4yOL27e8CQaT+F3gYfgPerAQN+Wez/Usd8zrDmDp4X3zVtCnzb8MNs5uikV5DTlNIWUyr2hXb8fD+4blNe6sf80uvaeHenyfd+1/GxQjX+woyb52bF3I3REIu13ZRBpE5vL/vJtO6SZd8ePQZcVucFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJC2Ubwq; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJC2Ubwq"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81e9d8f3289so65996757b3.1
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 11:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784399662; x=1785004462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KIMgeRzIphzaOxlDnYtmNHPxi4S7Tx1b1pmPrwhcJMs=;
        b=QJC2UbwqDWeeUQAfHhUVfgKovfQvbXTJ8L/T4p1f+VDNk/IMokHoGnt6ya7PAQDZpT
         Yh58dFG++lpwG9qEkIH+voTfgyhqK1pV71WMkIfm3G6qaGdRtp2q6Tf0m5ODzSL2iUWq
         b7+bQl2hjwriZN6l8w+OEzR2nH/H9QcicnyoJwV6auO27K5pBSKH8F4LaeXeZ2F5d0Ei
         29dQCRdpruJPPD+2B6QiCZn4x48okIL9El5Z8Eq/tF9JJyCwXt3yW0c/vWXo5LYVPfi7
         D2BTxXkk19d7ChgTdHvS9cFWFFQHS+Wtk8zdEipdkdD/d/CxauXUUFDNQGljJxOKYdit
         5LVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784399662; x=1785004462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIMgeRzIphzaOxlDnYtmNHPxi4S7Tx1b1pmPrwhcJMs=;
        b=QhbjxeEGQ+hePrw9qRaw8Sr82AOvmbd+47Ijc5+tjv7ZM/e0iPEC0Obfq+OSd+JBlT
         kEPWYy58E6P10nRktksvVp5yY/2pQ473H8UFud6Ln0Gn/AOPsJ50gT7fE3s/oG45Q5m7
         gHXwNDHdbxzk0qQahPoRT88e+Sl5+7If8WtDQnkdaY4EEwgB8BmIQnu5s4ou93lamXRi
         NkMvY0TEeL55qkScy4lIytaV+40H331hgx6FohZHlYWDbv7bNP8RgglPmd0YCFzkXkXR
         +PN5vVCd6A/hmxDGCU8rdLTgZeqPnvtMhA55fXD5Csy2U/1T29xQUFIZIBftJVjBgpU9
         jPxg==
X-Forwarded-Encrypted: i=1; AHgh+RrORdbJ+UAiz4AX7+xPFVnw+Srssmt1JIwR8G3xhZ3yES1RQ/nvV9r6hegOoGWIY9gpkQ70ZemH350U@vger.kernel.org
X-Gm-Message-State: AOJu0YyNCpIqT0mmIYGIk1JYYxwpA9UXmom4YTqzZ7lkwoGONrXPrOo5
	RUs4i3vuzfbxvLzeYmX7KSTEtcTQ9IdfcdnOBqvk8dl25zKmvj52Pt5u
X-Gm-Gg: AfdE7ck7Qa0IrByavFl8oH3BDCjV87s4mz9IYeqERz+2aVHayjdPKHxC5RVjFv/9nXt
	bEROPKyOAG6e79W5YNkFl733xLJP+1P1wu1rjV91xXhnn74eGF17nFx+C9+4ReGCBPmGtKv0e14
	HG5mKWYXewGFj8k+JVdCQlMnS33abQ6D3xAKbYJ2MXhDcSaH3uzBewfriZR7Lda16gokPV72Y1L
	ubJIDX9wLSonYMt/7VUQQ9jsbxbTuEV8S/Pm7fEGtQa05umowtx+Fxd9F0fjLLfRIflWU3YP2U0
	AaFzfHdiO+tZs8SYTzXiDFpsW+qOVhVvwgEfSHwXGcvYFLH02DTqH4h3HWojsJ+PViRi5JAokmg
	cqfOgE30JsxYwUJ09QvNG/oTc1aYDXRrKQRoeXIUF1DGshQlQiQqJ1YvxvvE8Uz1pst+EKhD3IX
	sYLyDZvUWuOlDcGzksVqo=
X-Received: by 2002:a05:690c:d8d:b0:81e:cda5:5149 with SMTP id 00721157ae682-81ef252c29fmr25092147b3.28.1784399662373;
        Sat, 18 Jul 2026 11:34:22 -0700 (PDT)
Received: from LAPTOP-83ECOPAB.localdomain ([136.55.173.105])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef42eb72asm33671137b3.47.2026.07.18.11.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 11:34:21 -0700 (PDT)
From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
To: achender@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	blbllhy@gmail.com
Subject: [PATCH net] rds: tcp: unregister sysctl before tearing down listen socket
Date: Sat, 18 Jul 2026 14:34:20 -0400
Message-ID: <20260718183420.13301-1-blbllhy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_tcp_exit_net() frees the per-netns RDS TCP listen socket via
rds_tcp_kill_sock() before unregistering the per-netns sysctl table.  Since
rds_tcp_skbuf_handler() derives the netns from rtn->rds_tcp_listen_sock->sk,
a concurrent sysctl write can race with netns teardown and dereference the
freed socket/sk.

KASAN reports the race as:

  BUG: KASAN: slab-use-after-free in rds_tcp_skbuf_handler+0x2aa/0x2e0
  rds_tcp_skbuf_handler              net/rds/tcp.c:721
  proc_sys_call_handler              fs/proc/proc_sysctl.c
  vfs_write                          fs/read_write.c
  __x64_sys_pwrite64                 fs/read_write.c

Fix this by unregistering the RDS TCP sysctl table before calling
rds_tcp_kill_sock().  unregister_net_sysctl_table() prevents new sysctl
handlers from starting and waits for in-flight handlers to finish, so
the listen socket can then be released safely.

Fixes: 7f5611cbc487 ("rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
---
 net/rds/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index a1de114d5e2e..453d4077a85e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -655,13 +655,13 @@ static void __net_exit rds_tcp_exit_net(struct net *net)
 {
 	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
 
-	rds_tcp_kill_sock(net);
-
 	if (rtn->rds_tcp_sysctl)
 		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
 
 	if (net != &init_net)
 		kfree(rtn->ctl_table);
+
+	rds_tcp_kill_sock(net);
 }
 
 static struct pernet_operations rds_tcp_net_ops = {
-- 
2.53.0

