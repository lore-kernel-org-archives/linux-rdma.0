Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B6F453A5E
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112090; cv=none; b=VSAq8MkvfdtwlrHeCGDANUfZBg5EtUO+018bgHhHG7kuGHOaRKWEA+7kXLIF0pS+2Ss4dvabn4ummEm0pTf+H0HzDucBqjjbIbXj+VP1KBO2bVXzv/ZdXOZLtv/q4ks8JhquQRr8T15LnYXUXKIGERh0LP5C5AzQl8TTMARvCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112090; c=relaxed/simple;
	bh=ofD9vuZ8WriYaz45r03nVr4VI+oGJALE7F2gieVLqec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kk2M3dslmVCdEdnxs3C0zxlSLvKUlj0SaKIzBiMIizThZ/N2D8J3v6pyJhuqCZckx6IvXccR4/tyl/4ePw78vmzas+wzWeIcMkMzkdeLRKJGA6DGsJ5SnMHSrN/KzujfyC5uGBATA3YOUPVqyDyhqEHfH9ROypcwC1IjGAiYCyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkQ1Y2fU; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkQ1Y2fU"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc02279so602273a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 00:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789112088; x=1789716888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=W6wVmYC8X8kmr5SDuvDPNWubkvtX+YkviT8aumfGWPQ=;
        b=ZkQ1Y2fUtTtCKjdE5Q1KGflwxOoNneCyA5lRZQdpPLxT0h1BMUgJE0pVHXCpMpK9CK
         JpnLF06X3+n9Io3ct4Ral5nV/3SDCPiXRL3GVKVqWXe16yP+15qH6BCybptEKGwTtVSK
         WcYZVZ3zfcIBUt/5ZQgkVZSgPvjLwVX0A9z2piDFkzTQZXJroRvHJE6wBrJYPhRREbrL
         UGCQD7Gf0hFX/AnwGaQzgtNW6GfC9HLjsO8xUk2V+LayJjsfNNV8uxAH5MnWwIODBcH/
         tDxfthSUVnyzI99AYnGd3N6IXfVZkMjFOyPq0wmUxq2A1M6pUxSOl0hTpHpH/wXbhzv2
         L/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789112088; x=1789716888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W6wVmYC8X8kmr5SDuvDPNWubkvtX+YkviT8aumfGWPQ=;
        b=hBTHr1W34K3x6h8j7R1OyEk7hPdc3zarYCBw9gJpQyxZHMftcR8J0Eo9qZ8MzGAlRF
         XBfom+M3Y8KNClR6TJSt775qD0pgCP8vyQmcswzf1UHWXbuyoqb28css6iWxUd4qgGNw
         xzbj83NmbUx3DKIiXaX/WQlD8QLyls2uIVQ/jxOwzjTz+ZF4r04Ke1ZZfBr7cIn5IiVW
         n3Gc2gwPpxx7g9HhFLLLmUqXmVfzb7obhvbCoO/S9xQ5S4GIsMZw26GY2NRXRrtGI6vC
         L0ON+P0BwcrmSNPOznO34sBpBOvmM5fWpF2JKQfD6NgReLvuL+e+nDxPPvmfr2T9peCt
         KvVQ==
X-Forwarded-Encrypted: i=1; AKwUvBym9a73Hje890n3VnNnW30TC677UjOkru0kM5acEBYDRFxsLJzpF6g/8xTCWD7pEr8+6IIqftYVYf6U@vger.kernel.org
X-Gm-Message-State: AFuF++mO6Y7alqqrBdl8dmTvz3s0zJ7Y2fTXzlFHQA5FUqWX31vZ99Kr
	r4sC+WX0/rsIoaj3X37hk9z0bpK3g2Ud1wm/zd5GLiidiD8stAlLTqTJ
X-Gm-Gg: AYBFou0ipMxIgVfG+N0/tnkfdmPNUNFQR4qc5W1jP9FAX7tHkAAJWcYykg8gJHd0yQq
	koG03t+AWXR+I0QqjGnchd80b9UM8zNTtAh+2F2W8b0oAWbVVu0Eqmaa/atdS6QPuHTAygDb1Bw
	tTUTtPTIcJjgc1Ul6+fmDAmlYxlk3tXDhcrg6BN4CJhMXdxojMMm9V9/UBaqPv2iCsX/PnZM/Km
	Va9wXd3ZInmtS/i7J1t2W1ONw7bz6PXCZP7JBmJ/ZNR7cEHb1XcVmRXpPiIqNauyAX/j2v1Y+HF
	DNkiFtgxX2hVsQatEBqCU4WkhJkQPWlNACeeC5Y+mQsZlXAyLwISrj+b5g1m0pjgtfCEk8UM9C9
	YSrPPOte8Un8vuB3PgbNkg+qIrhCToQ2OnEJYciwJV1YEKB70pabzdnXRLR0alYOkRRlG1DyDPq
	UdF8AFOHWjn9HXKwzNfLgsLPSZNzvywD+BzVSWzT1rYV3SGLQnBKIf0EQs94t6PhylWWkowaF8p
	gHhddA0siyCzmCDOVCHtyoIj1aiLq+BtxI4ZQ==
X-Received: by 2002:a17:90a:ec8c:b0:396:635a:9b10 with SMTP id 98e67ed59e1d1-39d9bf0af3fmr5274805a91.11.1789112087592;
        Fri, 11 Sep 2026 00:34:47 -0700 (PDT)
Received: from localhost.localdomain ([180.101.244.69])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9947b847sm3357684a91.7.2026.09.11.00.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 00:34:47 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netdev@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] rds: ib: use rds_conn_drop() on protocol version mismatch
Date: Fri, 11 Sep 2026 15:34:32 +0800
Message-ID: <20260911073436.3542080-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
conn->c_cm_lock held.  When the peer negotiates a protocol version
older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
rds_conn_destroy(), which is only safe in the rmmod path: it
synchronously tears the connection down and flush_work()es the
shutdown work cp_down_w.

That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
the very lock the event handler still holds, so the flush never
completes: the two workers wait on each other and the RDS connection
workqueues stall for good.

All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
DISCONNECTED) use rds_conn_drop(), which marks the connection
RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
it here as well.

Fixes: f147dd9ecabf ("RDS/IB: Disallow connections less than RDS 3.1")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
v1 -> v2:
- Point Fixes at f147dd9ecabf, which introduced the rds_conn_destroy()
  call in the version check, instead of the later refactor cdc306a5c9cd
  (Allison)
- Add Allison's Reviewed-by
- Link to v1: https://lore.kernel.org/netdev/20260908123356.1163970-1-henrymei@tencent.com/

 net/rds/ib_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index d46146887ba4..2909da8363f3 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -115,7 +115,7 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn, struct rdma_cm_even
 				  &conn->c_laddr, &conn->c_faddr,
 				  RDS_PROTOCOL_MAJOR(conn->c_version),
 				  RDS_PROTOCOL_MINOR(conn->c_version));
-			rds_conn_destroy(conn);
+			rds_conn_drop(conn);
 			return;
 		}
 	}
-- 
2.43.7

