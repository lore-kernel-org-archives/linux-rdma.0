Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E712141363B;
	Fri,  5 Jun 2026 10:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780655514; cv=none; b=CJjn3DcTcAEEMQP8s9w3NBJmqyyEzmnoaL/HEEBUaZ0rzlpp4gTf0bGM08GAbcmpLCZ26LyywI9VyZZ3Y1h02LscYHd2oRw5k0oJv1qWCAsVHGi797gADY34cKtLg/y+foUZ51e+fhvJgfCbN3Oj2xYklDAHTRULvSnxC0nWwbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780655514; c=relaxed/simple;
	bh=00hwPSZA8fZYcFj+RYCIxpnKtgT+aRtEfaPpoZFZJBY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n3OKoYKMbUTV0foRfxtMN+83UL6Nf4Jyykue/5WMwZz0xuH8YF5O6kgQkeO7kT5t8B2F1lrnrfGo/RxWfF8ZH650iaF6+LQL8EFowwsDVMCFo02v1j6Hx2TmmXqbs7LMye7sAdj0XS/xW8OV3liKpNoC1gjxVTJ8R2PX3FEYZY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=qy2Po5Ez; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="qy2Po5Ez"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=8DmfM0emdEXvHwwBK/UWoQtQdiUcoSMtiKrMc4myUNY=; b=qy2Po5EzFtqBVmaUj5pARa+sAb
	5Gcdae7s3vwdeTUvF4A0iXn6EbxMpcydwhIOL1XgdABvEUbvs8BiYDr7hrdJwLe8qZiojWAMAh44l
	rwMVScrutwrmzFDX4DVm21m4XCAYYGuwvStuxYet4x2iECzK+FK04i2+dl1XKc4DVh3HnvPk+yPkQ
	Zo+b8ifcaw1AnwUrA94/R4wGYxHWAeQ7KsB63caW4IZO9OlsQ8yoPBSkfjjzgw+h5vlrXBD6CPOKZ
	xGFfeZXp1LuM9yToRcD/twQOrp6WEXnVOuZqp4nIbv+AYQ4FL+uN1WlTd+kyGpSU+dZ9g9hKc6wth
	8b3Py7FA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wVRq9-005EEs-2h;
	Fri, 05 Jun 2026 10:31:50 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 05 Jun 2026 03:31:38 -0700
Subject: [PATCH net-next v2 1/3] rds: mark snapshot pages dirty in
 rds_info_getsockopt()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-getsock_more-v2-1-80f38cdb8706@debian.org>
References: <20260605-getsock_more-v2-0-80f38cdb8706@debian.org>
In-Reply-To: <20260605-getsock_more-v2-0-80f38cdb8706@debian.org>
To: Allison Henderson <achender@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1093; i=leitao@debian.org;
 h=from:subject:message-id; bh=00hwPSZA8fZYcFj+RYCIxpnKtgT+aRtEfaPpoZFZJBY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqIqWNcVYIIJISvcnN7cwAbA0w5GLVZG8jfwZ4Q
 BxzYfinR9WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaiKljQAKCRA1o5Of/Hh3
 bcWKEACuD3qtWXMRs/X/KxwjB9YhpiCScdOL1ayjmDKa76/qXeVdgQpiS8ufbjI9rEY+mL63N84
 XpRle9/j5uLr6KkRrbcP+xOuBdFEvHA1jd3jC6imnxdOnF3JpJGDO1Ct7ZvOR3d/QOuzmjbCgvc
 /Uy6BF9GcLbEJLKhoZ+L4CC8RLEDAWrPQsuwPNMMOsjNd/liGEbNP2H8MKgfmBhRX5egLEJlM3b
 9LegD3FHsR33fZ2DEUF+ru3drqi/aVxF8LaLKGX15YwmHe1kZHKX9ILG+Avjc8HbIw2g8pX1b2C
 okXGPcsaqO7I2OedE1jpAqnC/W+AEg3yYZb6qu5tD6w208Z/Qgtdk3vi4hV6XGwFcK5Umqg7QYF
 CEeKqtxZo2Zml5P/e1ecIKHk84IJDn/WMad3xVA4H2H6zMrArR+x/XV7mQ36xwXv3mxsECTIZxg
 XjrE7Y3n/tmvnnGidXQDOKY42Sk2tj0rSqrwWXiz+++YsgB8KBCJRF50FGniLGhtx2sIWRi0Gid
 hR8/6K8NsDDc1Co70/85VIvYqAqpDrZXrmcsvVtjAu5NbPhDIQ6WyeVFmBWOSE84D6pvRidte/v
 xwea8h4aTyJvZmSFQQFKXu1NXT0zOh0KkpchhnT/0fA0nnth3LJYsVXvzNJ/rmj0bZxE+51afx7
 co8JzalAEf26YIQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

rds_info_getsockopt() pins the destination user pages with FOLL_WRITE and
the RDS_INFO_* producers memcpy the snapshot into them through
kmap_atomic(). Because that copy goes through the kernel direct map, the
dirty bit on the user PTE is never set, so unpin_user_pages() releases the
pages without marking them dirty. A file-backed destination page can then
be reclaimed without writeback, silently discarding the copied data.

Use unpin_user_pages_dirty_lock() with make_dirty=true so the modified
pages are marked dirty before they are unpinned.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/rds/info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index f1b29994934a..17061f6ff74e 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -235,7 +235,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 
 out:
 	if (pages)
-		unpin_user_pages(pages, nr_pages);
+		unpin_user_pages_dirty_lock(pages, nr_pages, true);
 	kfree(pages);
 
 	return ret;

-- 
2.53.0-Meta

