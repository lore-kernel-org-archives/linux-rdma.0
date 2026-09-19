Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE06837AA7A
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789857273; cv=none; b=OsnNF4JzSfDCjrHNSLCZ35AL2MjkBc/goTSi0Ty3bkZ4uCmULBIf6+dY0EQjBs0BkJ7gJ86tL+CRnc+LQzBZ+9wRNGl25NOMyyuLRdkvZo56lMp1OmWx9ZZJvqSj0dySzVdtozFhEAi+YU1J8H5XqhyS4HAXBoON6gPfs2Z2H5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789857273; c=relaxed/simple;
	bh=YJbTTv0t2BWIFrbdxBZVugRFfM4btTyxQU6vJrhf3OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BHx301a0eBt+8mG1EJklj+bI9amyYWqY9ESHuOG2Q8rMZEw3J/7dDSkeqIOe8NO6rnShi/fQEYW8qYBA3DyaWvNaLuUGDasLkye9WwyGeQMExT3c1XGcY0k40jSgoOouaY5vsfm5swlBFZmIXSCU8nWGgry1eE5rLD+0+EvsixU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifYVTsZn; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifYVTsZn"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccda24a3so1445278a91.0
        for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 15:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789857271; x=1790462071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UAwXKmx+R09A7nHDL9ZNtNOP7/6ryqJI8+NyxhqUBXc=;
        b=ifYVTsZnCqOjY48tPbQdI3BRb9dRV0zdTqv5LieteSjmT0VU8iVedFlA/rZKPdf7Ih
         WbMgK1oIPKQrio09BonuYkM9mBjxVyObXJHDggi2hXQnKQHn8SpNtJ+tuW/WA+Mlb5un
         bgLIb96RWYlzQXsCxylzF/GRizUTFB86FHd00pXOoBuDts5GRCRmdBLXDXBpAKPy8Sw3
         MwgtC2AnNWlqiY4KBQMZZe9pnB8YuSCZ/oaBBSD4iHR0cqXnopJYYN+Ar7iW2kSljL4o
         XOKhy8mPcVPpH9RXCMAfiML9LyEMDMp+QzpRLwepcJdxYr66oPrNrj3AQlX+8kDL4dvK
         3dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789857271; x=1790462071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UAwXKmx+R09A7nHDL9ZNtNOP7/6ryqJI8+NyxhqUBXc=;
        b=ItgGCA6inWh9Ccbt9bTnCWK1ViJ9gRj6QdlYoT/UJ9I1e9CXqzT7GHeuTEoQhbz26E
         47Bug1ddjCL57iuE69uG7U/QJfJmzZ7lnnN6bAaCMKNKPKgH1kH6W6/x5R9h8P2Rkejm
         AYY672MmrpMOxz/7/1T+JMVq/itzi1jrt339blebhI9jYRg0khNutAaNeznwZsJXj5Ip
         xj+qykGiLcZAq5Jipj8+DL3cwq6fSun5w2JG/PupGGWz/HFAYLuthBKkS9rzlm2rtCmk
         YjJtMixIK3QHLy2HToYdRTes1efE0EvsKTU7iiexa/rQ6igzgMUe+10B1vP8VpNetZuK
         /icA==
X-Forwarded-Encrypted: i=1; AKwUvBylU9qXlRJxHYhiCzVgi6KuCt5PTD+KnT1qQbN5i5Ce+py+4NbM1QVWIiuqnLXQIyr+jbbOjDem/Z7T@vger.kernel.org
X-Gm-Message-State: AFuF++mKeJ8zINYGKgVKziKYiEN+cgL1GAlY70jzGzMluJX034NiKSao
	3bxJhsO5xIfpnTKOjDq2YHFpCCF5Oz+5HifeaAOKNmYqraswb7DFaqmJ
X-Gm-Gg: AYBFou0k0uzXKh0wi6xJcJal7gFpH/kKr+wyWf6rnWfj0VERTy20uIYHVSNuGRkCUUr
	0pvPF0XteHJfePVq6T4sPnup2BgS699p5PaC/uBJlM/EGwSR43GZV7QlVQlmNWal6d482EOtKG/
	TJtQWDWrxXlqkDkGUJ9LNK9kMxYEcG0rNXVsTcNwXnqq7UhSwTzwPpfi4xWd8T1g+MshS2N7Xpn
	Vf7i4xQdk+NFos0fpRBlH4o8ZfB8XOHI1WsPCc0ZcGuVNQc3lhsH2pzZ0ZDkOU+8McsrreWNANf
	IIFfWZqt3IE2Fhkq5/4HRa3kgvbuNzj3lyYVhV1c3XAsfW5sPsyZUolB1w5SJGNfYb37lcfR+Wt
	CG09V1GePmejckIqdN1jLSTB7Jr9CKFEGIRXVbSuQXQMf2ZL9KukpaknU0hZJDsCRNudMcDsTtI
	yGyCxO/gJkMadPYt8RwpbrGWhArHuUBd+sN9OdEWT/tafhKZ5LvsRzCojGVGEDClXs3ozI+t7Rn
	dsUMW/5xYHhDjOb4Z9ZBvnu0+/YnasXzBY+VA8y1yGYlKLEPttPFBphYi3OCSnFIMkJmTGPxPP1
	/aDIVx5oXw==
X-Received: by 2002:a17:90b:3883:b0:39e:6c68:1559 with SMTP id 98e67ed59e1d1-39e6c683328mr5728171a91.33.1789857270696;
        Sat, 19 Sep 2026 15:34:30 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e55b83602sm4702164a91.1.2026.09.19.15.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 15:34:30 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: achender@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net/rds: fix incoming message refcount leak and header bounds check in rds_recv.c
Date: Sat, 19 Sep 2026 22:34:29 +0000
Message-ID: <20260919223429.3882046-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In net/rds/recv.c, ensure incoming RDS message references (rds_inc_put)
and socket receive queue bounds are properly balanced when handling
error or truncated incoming frames.

Fixes: bdbe6fbc6a2f ("RDS: recv.c")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 6204e577a90a..0743706af8ca 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -637,8 +637,10 @@ static int rds_cmsg_recv(struct rds_incoming *inc, struct msghdr *msg,
 		for (i = 0; i < rs->rs_rx_traces; i++) {
 			j = rs->rs_rx_trace[i];
 			t.rx_trace_pos[i] = j;
-			t.rx_trace[i] = inc->i_rx_lat_trace[j + 1] -
-					  inc->i_rx_lat_trace[j];
+			if (inc->i_rx_lat_trace[j + 1] &&
+			    inc->i_rx_lat_trace[j])
+				t.rx_trace[i] = inc->i_rx_lat_trace[j + 1] -
+						inc->i_rx_lat_trace[j];
 		}
 
 		ret = put_cmsg(msg, SOL_RDS, RDS_CMSG_RXPATH_LATENCY,
