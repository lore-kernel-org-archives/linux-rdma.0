Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECB72E0B5C
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620124; cv=none; b=XomPKqTyZghl300bC0wg2hFBjzhpQeNm3OD5kUKBX1KvjnFr4O7q5nsRb3cIp2QzJ4yC9VN/0LolEKGksUEmLep3U5fTMvfY2aScXdlHVGUhYJk4OGw4BeIDFMs37e+y84ID61vj0MEueaeqt7YKVcnhnTEyCfzZaYYh3KUCJcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620124; c=relaxed/simple;
	bh=Uf/oosQ/UAQy81xB9H7Rsx1eC7q8VdIACUuGXMPsPNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DZnI9+UtwERy28rlv9LkVNMS2INIt7uZu95Bew1EbkCr9e5eGP0v+CYPfvdg7RS4/pHfPd/X4tpLUhQp63eO28c3f5pX3MChkjTvlvDHSgTLd6ky3tsjECpFIedCCQ8Ed9IOiFRgPIzBLvKXUOHxHRdzUA/k0uUpyt+cavIlt2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IfCRkZGK; arc=none smtp.client-ip=74.125.231.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfCRkZGK"
Received: by mail-oo2-f11.google.com with SMTP id 006d021491bc7-6e55f7a1ce4so45060eaf.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791620121; x=1792224921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/b9AkOusiOjPBsWU4XsABElpJcJY0c8yQLeU8F399Ww=;
        b=IfCRkZGK1vl8aNQnmZ1Tz1GIj6Mqj6rmQZI7dheMnOJDLRDnedgS4oNz3mZiixGmi1
         EGNlqzplQZsloPkDwaWOVYSL7sjHvi0MQKVrQI8/ceBKjkIIP/HZQZBZu0kqgl6tAPJS
         yyfa5+umi0Pfi0PUFEbvKlLrQtEfkljIviODG8Gwm4pwFTQ72SqNeaZIW0VOzZ/1kWym
         tVWb7+z0OQD9pAQICqvD+o91/jpPGFy41eK7W0ImOU4lE7aOyq6iL2KtzyRbgeU+w4UG
         AxmHOwdwvbBMM63KQB71JMpX+3Hkhwc0VV83dO0QTToXAIM2QhrU7oMy+ex6124QCWd3
         VM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791620121; x=1792224921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/b9AkOusiOjPBsWU4XsABElpJcJY0c8yQLeU8F399Ww=;
        b=mRQuE7S3ZAA0AeYIlh5jQeChkcy6hnQ9J5CSzzMbcz8aKZIhmrmSKvz3/wlMuLBnsD
         ozuWBCYMaTGRJZM5PTLWq3xMD9bCbGDUkr/QUPv+7jBvX9gFYxoDrvgGNrJi2ugvA4Er
         IgPF0IhmualNmBrmJ2r6JVD2mbvln0qsihE6AiEPKv4xbF/iYBoUuKWMxGxJW9JjgzvH
         xoNa2yfQ5wMv1XRx1g1fAxCtB5LmOamOqd7bK91Nj68vTiYKBllMdlSX3cwky5zkIy63
         dKEnUF9cLhaDLMav7TIBBGXJYanhwGArhfJABwEFP4UHnMgeHkOEISlDMoNzursXubco
         X3Vg==
X-Gm-Message-State: AFq9FYJs5aBTRhSW6BqRMLMVN9ouFiepar8vXXBMEYd13D7BT3MlTfYS
	QT1k2GJHt0jVpsBD72crPa4aGlZ8JgE03/qNnj8ZSvN5FPgg9yLzdJos
X-Gm-Gg: AYBFou0VtZK+aaOCWnVLrW17lOW4D45aAfBWFlm6DGFR9+63XkLZQ5QyyoornBFyHSG
	BtNVM0HczQHrNZz3ZP+IXkdoV5ZeX6D2Hf4NJWoqZqIoSs+IG93KlEe62KDU5QUXomhGS4UOhul
	mfbCAyauGSfM3zgXdVWOW7/ISD0OSXOE6/xqCeRk3hJTqhNRLiP+4BlaFoWgWVEj3vmeVao9uO8
	OdzYyg5XTgDjclNhbgttHRaIhCTVE3XNpElYOfBQEdyY/frNFIjSH0QwXfEpkq+cX2VsTndnbrK
	CA+r6x92ZDqORNNdPp7STvNJxSGYjx2KQwxPZqNHH8gtfkexDweuJxupWcfv1nxVmSZ+upEMw83
	4JeMcaVZf7/lJYv+eg5/xi0qQ6eTP4zbxxOrUhEKCGK8vxXBdZCihBmNNT9vnpFqeZaXgrIx80y
	2xh2rzn1fvuMEDyun8K9IgTdSOH3E18wZlOuLZISoXORw4nAssjQWbvu6/cW5Gs4MjljTzyccUs
	Widcj9/yLQbSbgBxBO+7PsQaGgSf+UoLpOj
X-Received: by 2002:a05:6820:1ca7:b0:6dd:d08d:7900 with SMTP id 006d021491bc7-6ef0fbb6725mr3230261eaf.54.1791620120710;
        Sat, 10 Oct 2026 01:15:20 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8302f625a10sm4067822a34.0.2026.10.10.01.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 01:15:19 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] rds: fix transport reference leak on rds_add_bound() failure
Date: Sat, 10 Oct 2026 16:14:46 +0800
Message-ID: <20261010081446.3112217-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_bind() takes a module reference on the chosen transport via
rds_trans_get_preferred().  If the subsequent rds_add_bound() fails,
rs->rs_transport is reset to NULL without dropping the reference,
and rds_release_sock() later only calls rds_trans_put() when
rs_transport is non-NULL.

Every failed bind therefore leaks one rds_tcp module reference,
unprivileged and unbounded: a few hundred failed binds (e.g. to
port 1) make "rmmod rds_tcp" permanently impossible.  The reference
was originally balanced because the failed bind left rs_transport
in place for the release path; commit 05733434ee9a ("net/rds: Check
laddr_check before calling it") added the NULL-out without the
matching put.

Drop the reference in the failure branch; rds_trans_put() already
tolerates NULL.  The symmetric SO_RDS_TRANSPORT leak is covered by
the same fix.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: 05733434ee9a ("net/rds: Check laddr_check before calling it")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/rds/bind.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rds/bind.c b/net/rds/bind.c
index f800d920d9690..e4667b3128940 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -264,8 +264,10 @@ int rds_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int addr_len)
 
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
-	if (ret)
+	if (ret) {
+		rds_trans_put(rs->rs_transport);
 		rs->rs_transport = NULL;
+	}
 
 out:
 	release_sock(sk);
-- 
2.43.7

