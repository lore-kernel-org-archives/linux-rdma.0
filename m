Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB653CA71
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870847; cv=none; b=BccyIqtkJ6F6B+LZb17yhxeKIeGX1hAljM+ugyFCloRStr4ARjDXI9F9zul2vNn+Ws4nyJ/Xgi/RmvcfW7KnDLm3Rna+do2GASYFFd447myW5atIBU0Xu+HFS0w38E8o/uFMN5pcYQJF099MPy9a4OQOg1aeqdBUbZ+CtOrId9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870847; c=relaxed/simple;
	bh=Z2b/QRv1h7ZKhOM194yWbvCAjPpxBOzc0ydTG9K6t8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nUG+Lv+wTdvMdQPHj+S9GMh9UAzuOn9PyAhZivQktr5rdGEIkYy2bpVnP1vn1fGlGTh7TNiSzB0LV8O9F//6UMn6vrAOPaBD1h+n76XFoXasUheRtDoj63NfqAgTioUnSWz4NRHE4o1vXhXzOOMFyKDq6cZyQPRqbO1CMaxqDL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOooWV10; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOooWV10"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso3091284b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 05:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788870846; x=1789475646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k+Chw6eYmS7cFDPWI/6rE8MBVC/cNonnlx5K113ikQA=;
        b=QOooWV10hWpankMQNjo7se40zz9jFVKKaH0spAI/xuQUOaip7EMNkCsU3GziFWN1K1
         nxCLXvcJlA9YIPxnwIl4Ab/CVB6dEj3IX7fJh2jhspaVH1jMYMY4MkcHT/2lrf80a2VS
         BE7sxZyWI80Ye30H8yulmBHrowhY3rVynZAe/NvQGwcIAbGcmKzwgr2dUd0a/OM9y6lO
         oY661MRazjTbDiPiBziqeRxTg8rLHhOMcDmBGBP5wCnzeTjCbtxq0QCbBZspNUTOkUjL
         aVoXRZlQ4LS+zHNXtKUvILudvi4Y/dWisbGQ+JIaoyCGlbcGAV0Wyh/QR9HD6a+UfclD
         qWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788870846; x=1789475646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k+Chw6eYmS7cFDPWI/6rE8MBVC/cNonnlx5K113ikQA=;
        b=ansX2Q5sUN/XMv6unV2Rod3+rYIHaflEsPSD7jocwg7rSY1arjdPRMU1NsuZD5L3Fz
         dBzImy0N/YluGNGjdd9T+cURzD014E33i+jTMWQ6+trBhzgbGtEhyp1IAheNdVIHg0s2
         QJEcwkxqDjjdaU5Ups+JGTkAB8BvbRDsP7VDEcmfY/NdxQcpuD7Uaiz0vmwYiShPWcpa
         3YGYVzCM1o2tfBDd+f0iHFHtq7Qkw+VCZ9ZuqJDBosJupn0yJRj0dO1bAskU/AzUbLUq
         guJvS/UlTqNxyTV8OxBlIVHnCyBscaxdRiHLlchzhsI/Yx6Uo59cuWJjUHNwHOuh0gNw
         a8OA==
X-Forwarded-Encrypted: i=1; AKwUvBxOmQdk2ARgTPNXK9MiTzfEwPFiS/SG12L4Jrc6d6kE4+wuZ1lZ2uXweaau+xhzWQJtfpv3vTPqsPj1@vger.kernel.org
X-Gm-Message-State: AFuF++luuAtadC8uoHOnTNKsjpPT7cX1uV5au/ygxRkdA2eHuqlPmmsw
	TW53yHo4nGqF1EIgypDXANZjZX36XCWWZsfDK/ZwKjPRw0nUMCyg37nR
X-Gm-Gg: AYBFou3mBRv8PiRO9pGr7VhyHgzq+2cHyJf7Lb723jdvPFwMWgT5jmHFKrz90UBO285
	yzUnxuehOuFbp1Zu25XzO2TByxYIDXnCzyXwsFM+XiwNC3yN/j6zkNBrhDDYWeaGZojPuPsesgE
	SjuLSO8fPpYUJmLK+NS9D/5bplxy2IGR1wixpr8PpE9nFeGtxKQ41IoBMAJAUU13kNp12cGZXDa
	l9oxiPFDw7qsG9DS/lbSG0y/VSAzLhsOgswrqKi6shaZSbXMcwcVzR1T9D/6yeCMSoctRCXV0Rj
	s1MG12aN8L/N0/iqpn/ruCzkOtF/EvXk1MGgEF5VZLpaSAHQedVLSXXGtDqJStnEY9K6yW7U+uu
	IKChgAxVRIIaYsmwF4fF+g/xjZkGEGjOiZTOy+qWcvlNeXi6ewSuyGUuN+VgklGONO5djY1Kohl
	uYZXPbcxbxQjPcgEUFZO+1FvU3nRwxN0BdRPsWASy4To/XxJjpdLf/diQ4X3JCiSBznsDqY89x7
	mnUeSzLX27gKwBoxRInnQ==
X-Received: by 2002:a05:6a00:3313:b0:84e:f90e:492f with SMTP id d2e1a72fcca58-86167f9be1emr41453148b3a.7.1788870845621;
        Tue, 08 Sep 2026 05:34:05 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152045f8bsm5763571b3a.15.2026.09.08.05.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 05:34:05 -0700 (PDT)
From: henrymei <ljp1205831794@gmail.com>
X-Google-Original-From: henrymei <henrymei@tencent.com>
To: netdev@vger.kernel.org
Cc: achender@kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	santosh.shilimkar@oracle.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH net] rds: ib: use rds_conn_drop() on protocol version mismatch
Date: Tue,  8 Sep 2026 20:33:56 +0800
Message-ID: <20260908123356.1163970-1-henrymei@tencent.com>
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

Fixes: cdc306a5c9cd ("rds: make v3.1 as compat version")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
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

