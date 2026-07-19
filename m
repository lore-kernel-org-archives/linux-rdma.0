Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2EF27CB02
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784495047; cv=none; b=G9nICsizdzA4hNNLbYFdOhwdrgdI/yi2CR+17uAJ1xK0pk9VkXEK0V0EMu/U6P7T5l1if56BdQmY3DgDn+e1a6C/Cchr9HHiqyTCAQcefkw4a1lLrGBmBnZEqn/hJEDYHoHIc5Gc9tXkdE9Bbe7beHXwAarytcUHeDGkJ8d8Bu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784495047; c=relaxed/simple;
	bh=CIFR9XOahPngdnnn3weJdtfH0rv6prYw3ulhwIh5rhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UTiW8M17MG8NnSGErP4ajpeCZ2pVQG8npbzBQnAikqTLscGlV3EMThWjPigC3bk1DjEBnsEKN1WqysPDJ+7uvgVCJWckcqRQ8/GpYjg8lQe9NysMQ5D/FAXw9E5RxrHfJ6cOydvmgHnVpHmwb+lnyLJmQIs6UHM0Kr/Dy/ia6zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/EcTVW/; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/EcTVW/"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-80bb41f7f3cso58128597b3.2
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 14:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784495044; x=1785099844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8vg3AeqxCBMWMGL5aOAof/FcPrmcEkWBP8wqAnrkS/8=;
        b=M/EcTVW/U1cIz8L/zcdgpG4TJPiXEedi3iesa8MWAQRgAcHKw01v1fAETC3k4qeXVD
         FFm9Smyv+XPKJw14JW8Qz9eTLxZ9GBU3oUGg86l0Fnxdc6ADDBWJXE70Ktu4BQ1q8HlQ
         5cUet5vXoeTRVvvXsJC1cncUqoUdTFb3j7hbyJFuyilb122kk8l0rTa2z9CbYYQfiud9
         EklWVpg+K5Hl+KXUEUtUoVR1ZNp2rhEyaWpktJdxF4sCDdPySoAQCRnqqISpeAg4S30t
         gWi3+PKaZDCgLTOTqL+UWxOx1+hgHVR2BoKXmKbhxyKL0yf6ngIxEhx8qBdWnM3/Ph6I
         xjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784495044; x=1785099844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vg3AeqxCBMWMGL5aOAof/FcPrmcEkWBP8wqAnrkS/8=;
        b=lsMhm4Qps/CbfHJ5NMbBGGQzjN9LexaVhIADa8gdE/IR3f/2aBPTwYf06jA7lI3taF
         aTT0rehVrb+LGdBolMiCnNFCE4FI0YRWP0neSITiFk8GCh+yxFZgPI6sCVb3D6SUbDD0
         G58J7rRd7zO+TUw23Kw2MN1qsETP1KM9gC7fKTKMAgz5ilUy6Zig0ruIU+m0l3WaEstD
         GmYehtjVR2I7pvoTW86W3giK7QwKiI2IWncYDsRxjtr/zMwfEZOBS4hCnPP4vTs11aYd
         EsV+EJvaKaStjw3334vyDi5nKCu9dcgz9/8s/4tOG0fH5ikaUIdyojxoMrvAhq+Xpfgu
         CUBQ==
X-Forwarded-Encrypted: i=1; AHgh+RqLcDebvPpSm7ODolwx0r6ykcC6dEeiCU5utfjPvj+SU+42XojGPA014lXg5h7XW7eCnjQcWIjZpWBW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2SN2esy6VZZ1Fm3TYbjulLZRZ25OqhR7wKwrHaEZ6d4maAtzi
	5CzYc/I8f0gfdtEhRYtlMbJ1Lp5jqwEeaQQeC62VRZ3LSsBqIB/2Xu6R
X-Gm-Gg: AfdE7cl4Q4O+h28Qgwwx3c2fqDLttF8RCU3RxNGhMmHDgQ/ToWCm6kYD/HLoVOwo6Zc
	zz/h+2jHve/l4CxJveo6C9P0z1+oNgLF3Z4gy+e67ILfWIlcmiwd2TqlsvxmRMVZ8r6jO2+wGPo
	7kufqhc5PPNVneC34iPvIpIQTzI4uHGx4ISJGACYWMhedwaDLjlXsI4JvcI0jWnNKSDHhTkmg++
	D8cbf7LSg0ZRLd0tus7C8T8ycO+7YrmbRMka7Pr3+uwAsEmyeCYIvd6gEi4ywDcP/15/IHEfXRQ
	kaeO6x01pWePMtEXvAs6OqAZTCmHTKEEaQfEqwPxnwbHg8YM4bqe+ifv5U+CLFwZXcfe5gXL3FO
	s1HOGzvf6VJVSDNUgoizsA6BwaIpbw3gGhoc0BCCwOhw7PyfKimQFh8ooHTaWjuenPBYstefMas
	DK7yWqpxcnU46o/xF3a6tI4cZb0JitNVjyid0iMqwwnx3BEJx9oe7QHCUHN92tNBBxJt0ZWmtWO
	IfeJtOh/MIP1g==
X-Received: by 2002:a05:690c:c4cd:b0:7cf:a117:4ece with SMTP id 00721157ae682-81ef22ca2b8mr36422087b3.10.1784495043709;
        Sun, 19 Jul 2026 14:04:03 -0700 (PDT)
Received: from LAPTOP-83ECOPAB.f7a5e5c3-cab1-4810-bdbb-207cdd06de9e.globalsecureaccess.local ([136.55.173.105])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef42c4ef3sm43156787b3.40.2026.07.19.14.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:04:03 -0700 (PDT)
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
Subject: [PATCH net v2] rds: tcp: unregister sysctl before tearing down listen socket
Date: Sun, 19 Jul 2026 17:03:57 -0400
Message-ID: <20260719210357.10179-1-blbllhy@gmail.com>
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
rds_tcp_skbuf_handler() derives the netns from 
rtn->rds_tcp_listen_sock->sk, a concurrent sysctl write can race with
netns teardown and dereference the freed socket/sk.

KASAN reports the race as:

  BUG: KASAN: slab-use-after-free in rds_tcp_skbuf_handler+0x2aa/0x2e0
  rds_tcp_skbuf_handler              net/rds/tcp.c:721
  proc_sys_call_handler              fs/proc/proc_sysctl.c
  vfs_write                          fs/read_write.c
  __x64_sys_pwrite64                 fs/read_write.c

Fix this by unregistering the RDS TCP sysctl table before calling
rds_tcp_kill_sock().  unregister_net_sysctl_table() prevents new sysctl
handlers from starting and waits for in-flight handlers to finish, so
the listen socket can then be released safely. The fix was tested
against the linked reproducer.

Fixes: 7f5611cbc487 ("rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy")
Reported-by: AutonomousCodeSecurity@microsoft.com
Link: https://lore.kernel.org/all/20260719203718.9680-1-blbllhy@gmail.com
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
---
v2:
  - Add link to KASAN report and reproducer code.
  - Add Reviewed-by tags.

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

