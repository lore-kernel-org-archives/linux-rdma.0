Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8995317163
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754238; cv=none; b=IfFvfa8yFFdfGkuRIv9qZmw62KA/85QyvqmOdj8HB2CUlwktN2t2QnjPFpGMwc9O+ebfxBZw62oE3DDjZJ4D8K1X2b/y3dLeuJAkXQpW3JiCvboUjxx39uTd9Y8/DRfAdNQqMs3XAWlhzLzk7vNEC80H4A8z2AK/CxuPu0D2pbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754238; c=relaxed/simple;
	bh=Zlb82+IdVuCl9xn/laV+Lll23Ks6kbcvYCU87g1yLoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cO9OPC8WWPOgwqn1FxLvmz5sY5qnb5HnYDSKR1A1fO6Xr2hcGeXDF315E0hHkeW6hiQQIu4RS0uEvvmvte8cRVR6OTFHrswOsl9nDPpBa/i2AP3lPW/8y99yQwletNlME91whV//UXL1C0zpiKFIxg0DZ6vWW7WJnIy5aalvzKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=V/9GfggO; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="V/9GfggO"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso9985527b3a.2
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 14:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784754236; x=1785359036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mBm3wrv4Ky7/5MDSknvd1rCNVUs8d17vGheoqukyOXk=;
        b=V/9GfggOGW1PTz/eGEH+H2Sim0uSRFcV3zQVvh2Bw7Ks+bKaGTJ1BdA+R5FCLIKYnS
         GGAYIiQdKstOWq9fRyqZq1mdf1kReNP5Izg5FfWNta01i0MRKOt72uYwG0KVSw5pgpM7
         ZUXINrtFJRcFy1M7pqeXTsnSmIM+dfISuFYMj3GZKwXVbhqeHmZlxOTvpZp9ipC7e1Wl
         G4xOmfMlxtkoPUk8D8/nMJj7zb8/tQYqEaAhNdQnXZ+CKhoLaQmeGELN56VuRIidbpAi
         8Jn0xuGH3yRmrQ65ZNVx3TlqPjnb9WXNgSAnikz4eN2QLE/BoX9z1ABGU+gt6PMzRXG6
         NQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754236; x=1785359036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mBm3wrv4Ky7/5MDSknvd1rCNVUs8d17vGheoqukyOXk=;
        b=soOriElGzLuvnOdavvA7NLvXD+W2k/MI2JfUbTawQUyJ5FqY3RgWk7kdORqheO8Vk2
         9InlJTJcNVqceZl7Ysu04apBkzVurpsi1D+GCDWHsQNRCbfyPiAmtFUbejS9uJyaQpa8
         CwWag8VGIjlaxB5L+Ti1cXSJwRKlVE38eeJzD3vq1BjZLCN2VdZqAZGgR7R00u/qMUNk
         lTGlkT2l8TyV0OavG/sEqVLLES9m6+VjBpt89HFDtqMKb18V/nZHLdVTT04DgNrfkoVU
         ZWMQ/5IVeXnUSzWemR8sRvqZQsmJCs/PpW83Vo3iAMmg5GZ+HsB2SdITFoS/wt6/yGVv
         MhfQ==
X-Forwarded-Encrypted: i=1; AHgh+RpNPzhLuNlF7V7vJkSPxC8xIokX8FiyG/rbxDcnZRxf84iYL04MIDE444QjeVd/UqGJwcG5zvIU9BXg@vger.kernel.org
X-Gm-Message-State: AOJu0YzOkCY+vdpTCijggh5LHJXWozwVc73f0wJiwrsUZVPZE+ufg9dy
	IgqypOSzbjwFxg8e2NMDnFtnsWSP83DNX2u1q0caDFahIf5BKfjBOXxpJw7RFv2mEQ==
X-Gm-Gg: AR+sD13SFDQbo4GFzfxteV6p15Sn2QallL+cKtY+EemWF+87iQS8txjv3kclX7CHqq4
	v86lsqkSmOstFwRmgB6Zeg6BT+ee1TCQqOwOWIaAKw8e8RKC4g/N0HDTiCRvFjQKDeKQ1XWUhND
	QEn/V4NRShYMT+AIfLIjhUzpSk375eDGtqr0G6HBckBsgGAAg+pavRacUgoxwZhbEdSdaZNyra0
	+2L/yPd+OGdwZ+B13/AKwthlg4TZ86ABGMeUIjqq8nDf8NF+bhvsltjZUlZGy687PYz3A5ajBWE
	4iN5q45gwZPuGt0UmrsNpKuq0drBuzsF78xcx+9ketyWK1ojgQCK6kcJJ07z1Gy+guX3M/6Q3wA
	iF/6yG/xWQgEP4SvFBMrhPcIlWFwe4bvXHB6elaZA4q79g1m9aWdFlQ1tLUTJHA==
X-Received: by 2002:a05:6a00:2d1a:b0:848:2a55:7110 with SMTP id d2e1a72fcca58-84e2bb53625mr447822b3a.36.1784754235842;
        Wed, 22 Jul 2026 14:03:55 -0700 (PDT)
Received: from p1.. ([2607:fb91:1582:c77:30c3:296e:133d:928d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e175a3d6csm1839028b3a.40.2026.07.22.14.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:03:55 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Jakub Kicinski <kuba@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	bestswngs@gmail.com,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH net v4] rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()
Date: Wed, 22 Jul 2026 14:02:03 -0700
Message-ID: <20260722210203.565803-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_tcp_laddr_check() looks up a scoped IPv6 interface with
dev_get_by_index_rcu(), drops the RCU read-side lock, and only then
passes the bare struct net_device * into ipv6_chk_addr().

dev_get_by_index_rcu() only keeps the device alive within the same RCU
read-side section. After rcu_read_unlock(), a concurrent RTM_DELLINK can
free the net_device; ipv6_chk_addr() then dereferences the stale pointer
in __ipv6_chk_addr_and_flags() (e.g. l3mdev_master_dev_rcu(dev)), reading
freed memory.

Keep the RCU read-side lock held across the ipv6_chk_addr() call instead
of dropping it right after the lookup, so the device cannot be freed
while it is in use.

  BUG: KASAN: slab-use-after-free in __ipv6_chk_addr_and_flags (... net/ipv6/addrconf.c:1998)
  Read of size 8 at addr ffff8880106ec000 by task exploit/153
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   __ipv6_chk_addr_and_flags (... net/ipv6/addrconf.c:1998)
   ipv6_chk_addr (net/ipv6/addrconf.c:2031 net/ipv6/addrconf.c:1972)
   rds_tcp_laddr_check (net/rds/tcp.c:370)
   rds_bind (net/rds/bind.c:248)
   __sys_bind (net/socket.c:1920)
   __x64_sys_bind (net/socket.c:1956)
   do_syscall_64 (arch/x86/entry/syscall_64.c:63)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Allison Henderson <achender@kernel.org>
---
v2: Use rcu_read_locks and rebase on rds: Fix inet6_addr_lst NULL
    dereference when IPv6 is disabled
v3: Add change log to commit message as Allison suggested
v4: remove the changelog in the commit message since that was my misunderstanding

 net/rds/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 955d92277d5a..30cfb0087f2c 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -355,23 +355,25 @@ int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
 	/* If the scope_id is specified, check only those addresses
 	 * hosted on the specified interface.
 	 */
+	rcu_read_lock();
 	if (scope_id != 0) {
-		rcu_read_lock();
 		dev = dev_get_by_index_rcu(net, scope_id);
 		/* scope_id is not valid... */
 		if (!dev) {
 			rcu_read_unlock();
 			return -EADDRNOTAVAIL;
 		}
-		rcu_read_unlock();
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (ipv6_mod_enabled()) {
 		ret = ipv6_chk_addr(net, addr, dev, 0);
-		if (ret)
+		if (ret) {
+			rcu_read_unlock();
 			return 0;
+		}
 	}
 #endif
+	rcu_read_unlock();
 	return -EADDRNOTAVAIL;
 }
 
-- 
2.43.0

