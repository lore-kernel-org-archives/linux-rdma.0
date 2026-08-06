Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF053B4E80;
	Thu,  6 Aug 2026 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786000848; cv=none; b=aSfaJ/cmdT3PrLznPVH1v0dEMm9JJTauAJyaKwWlMG6j7WvUuoYtJM3LPVCW/qWJ0x9M4EMV/elFpYemfSh4dggmxlCtrrTjJq9Iri4iAHLJ9d0d002IPDGjDe1fuieFCaijdi0OeUv+OyoVajgLjinWNFHbCgPGfog4KCL1v28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786000848; c=relaxed/simple;
	bh=AjM7TUzoY7kQB9SG8BSZoqJxICwSEg7lIQBFCky63AE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0qzyv9Waha+CXXSRLbDCrnISFIjjG66Wi+fANYPYRnsbWDCT6nMXJnHkgU070mmL83xHwVFrKYSK7DjX1oxDB8PGHR+DNI3hTxuLZecQtukVX1BjzxGvzlu9dNr4VjcmZKqiiOjucDvqYYNbvHbSgVB6OcpJEyk2+vTyCb+iAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRC8h+IW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRC8h+IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D731F00AC4;
	Thu,  6 Aug 2026 07:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786000847;
	bh=nom8R+xi7zAowhB7Evt/Wy9V4AxvQm7fnZiItDUg4fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRC8h+IWDKJt1D500EvIfLeYMSti+i1iStKU88WIAEnEh94DMqREanr68Z0/O44Cl
	 freNR2wIVxorVw/ql2aJgD4Av6KuOAWHQSSpXNFmn32STHVjWgP0IAekinD4nyNl43
	 bQP0s42eS2b/LdXt/deXHYE5Dmv3b1G2/TPS5ISF8fNZiR/THfhUuhFwK23KJNjw4O
	 Hy6MaXP4z35WX29Zv3pE6DvzUigUIiN58NZyNjuNouWmuPSptdsk9FgeG/ZmOfSpXh
	 pB0cUr7pqs2iN5qWQIbNwzOx/ihonFE7xOB9Z52NdmiceY3vssP5ShZS1QRSNbsS1p
	 cn22BJGgworbA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net-next 2/4] net/rds: initialize i_conn_path in rds_inc_init()
Date: Thu,  6 Aug 2026 00:20:43 -0700
Message-Id: <20260806072045.1092968-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806072045.1092968-1-achender@kernel.org>
References: <20260806072045.1092968-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: William Kucharski <william.kucharski@oracle.com>

rds_inc_init() initializes every field of the embedded rds_incoming
except i_conn_path, and incomings are not zero-allocated (IB carves
them out of a slab cache).  The field therefore holds stale garbage
for incs created by the non-multipath transports (rds_ib, loopback).

Initialize it to NULL so that any future reader trips over a clean
NULL pointer instead of a stale one, and so the two init helpers
(rds_inc_init/rds_inc_path_init) leave the structure in an equivalent,
fully-initialized state.  Hardening only; no user-visible bug in the
current code.

This mirrors Oracle UEK commit "rds: rds_inc_init() should initialize
the inc->i_conn_path field".

Signed-off-by: William Kucharski <william.kucharski@oracle.com>
[achender: port to net-next; update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/recv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index cf3884d879319..f1513dfb27165 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -47,6 +47,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
 	inc->i_conn = conn;
+	inc->i_conn_path = NULL;
 	inc->i_saddr = *saddr;
 	inc->i_usercopy.rdma_cookie = 0;
 	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);
-- 
2.25.1

