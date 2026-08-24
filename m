Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AF63F39E2
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787570228; cv=none; b=kOsm6gF7+J3yyM5dLZKB7ctmzgkjhNOXMFBEY0swi7xRatuTDIaeaoBSxo41oxVt6tcxNd6QAa7hOIrhLxC6g6qYhA59KVXCdFeWEEiJMZZDRg2flCZgjAboeD+B1bIreU4eFgDwHB+sQu5qNz+HkIoEMHpNIYJE7y59TTAZtew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787570228; c=relaxed/simple;
	bh=h84y8IY73k8HDgDFbEOYAH4dnXdhVJJgku0CDx6klyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hs6ILiZoQDLT+nHF9sZdPyFeV7Cv3IorTTpftnUEnkrRGDS6aqn2IXP305i8wBz0ufmTTVIU0mmKVLwVBt1K40ORolWasDQ3yrsPZU8p52eEJEk0HpDgVcyZwSs/uLES3OZ8GtwIVuDEaniKGK5K5r+SJph1VAOjm5NJyTixmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R0ZDX0v2; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R0ZDX0v2"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso4992250a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 04:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787570226; x=1788175026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AWFyETnr9mq+FduhbKFRct19A7NzPMjqIJldSASGEJw=;
        b=R0ZDX0v2O7+AAunwhoulRU+ABxtj9hYPybsqIGu59n0/hAKF+qzgev2pzm+00awCvp
         g3WlQIi+mGFMRazzLFoVE4TU2HWzX8Qzr9dQHy+A1uxXedzQiX4iuWMM+oWf0vtlKKQd
         Loj89xjBpq4SN1GDBj9dqrpvqWp3ntStd8+PEETJKHXttVjq4QJVaVCbMcIwGD3LV7oR
         ujPW/ffEi+1ek9eDYEOM1vHSbsQFJATp8bVZremwEQXhAvdYHXGP5X4Of6SbhY3zhlBO
         1NGBtLOViNuaBZ4/kv4459BnS4b2Eifjr3T1Cij3f/6a758urDabhuCa4+g1/oZAywwT
         DQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787570226; x=1788175026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AWFyETnr9mq+FduhbKFRct19A7NzPMjqIJldSASGEJw=;
        b=py2LB4deiRGIBnBYJxCBAQt1E9QN2rrmTT0CapZSw06So5KbCzvN11e9VcIfVWXN2W
         DbaUSBx3kAYHQkvMx9NIldinzlVXBe5TK81giKpwptbSWoR8hRixB5mv03MsEBYczvl2
         KYU4OIg+Bn0ivF/d07wbEqaJEYodJXlA5QXjTdJ/EIUD4bR25IpW0BZ70ky3nnNLjnZG
         a3AHALvAvosQvd2U0OYB36xixYZrGkW60yx+L3wQATkd06wbVf+1r4uysQsvj387J0f4
         sofD8WoNjWiJl6Z1lx21O9fywrcOIfIO/NsQfGTlaA/oQy8ZOAvgactLHeEx2WwuPQZf
         mqJg==
X-Forwarded-Encrypted: i=1; AHgh+RrUhWvKmY00RJEeWcqjweA6Voz4iI1QqBf3OSP/NpGRGA/TWn0y1N0ju0G7/Q5TCUd05qHb+S8J6vVK@vger.kernel.org
X-Gm-Message-State: AFuF++kyj+3OX5NtEkKVles1J5ODEAFsNtm+MjZEGlFEq+TLUf6Lsagw
	rAAWt8n5cyMONEhdK56amVRFcJ+yRfAWeQYTmXo51KwjH3xhTMMsvawkpB4UFQ==
X-Gm-Gg: AR+sD11WQAxTBb/k6D82YfF41lE3iMgclTXqQ75P+Y8eiq4pQab/QXlBSEXmroYJcQO
	M06KH9OUhvYe0/wlGlADui+yPzBc3QYyNgDGbOkC8nn75IBBKl5Nd4HUqocZBcABDiK6wdFKV6A
	t9JdOWTzjYFv7ewRmUEubj6Zun1bUhe66q2C5LntHtLsq8cbNzxlcT8lYRgIorRrWgn3B/v+8ru
	ET6pD0EuKneGC+ibV4KlXqNpkPOOSf/3e5LF9d3lCJEthQuSneDkIE+gU7VekICOtwRovjU4KDa
	MdQTUAq3z+nFGQhexnmhlzmTbxd6Zo0S6vFydMdfcwea8bZYLwxAnWpC0TDX6IutZ0Y19s/1KkT
	/D5oh24d8Qw1G0MiZrRpImZHpIhSir1FCKDgCqXKpBqL5TDiZePxic9fKH9hysKCvNGu13ypPJy
	SdZiEfkPiAKzYv75Hf2osgEibi0R8LOt8Z8IFrddxp+Yt2cve+XLO/uBxBzA1O4Gcq5OYmVccgd
	wjnJFzG9sAhe/Xui8sjO0m2xBg=
X-Received: by 2002:a17:90b:4a81:b0:38e:6f90:eabd with SMTP id 98e67ed59e1d1-395c355c570mr44450182a91.5.1787570226249;
        Mon, 24 Aug 2026 04:17:06 -0700 (PDT)
Received: from localhost.localdomain ([180.101.244.72])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4996691sm9650165a91.6.2026.08.24.04.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:17:05 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netdev@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	Jason Xing <kerneljasonxing@gmail.com>,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH net] net: rds: fix uninitialized trans dereference in CM event handler
Date: Mon, 24 Aug 2026 19:17:01 +0800
Message-ID: <20260824111701.2979194-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

rds_rdma_cm_event_handler_cmn() assigns trans only when the RDMA
device is an InfiniBand CA (RDMA_NODE_IB_CA).  On any other device
type, e.g. an iWARP RNIC such as siw, trans stays uninitialized, but
the event switch dereferences it: unconditionally in the
RDMA_CM_EVENT_CONNECT_REQUEST case via trans->cm_handle_connect(),
and (with a connection context) in the ROUTE_RESOLVED and
ESTABLISHED cases.

An RDS listener on an iWARP device therefore crashes the kernel as
soon as a connect request arrives: with CONFIG_INIT_STACK_ALL_ZERO
the wild load becomes a NULL dereference at offset 0xa0
(&trans->cm_handle_connect) in the iw_cm_wq workqueue.

GCC masks the bug in default builds by folding the uninitialized
load into &rds_ib_transport; Clang-built kernels take the real
uninitialized path and oops.

Reject events that arrive on device types without an RDS transport:
initialize trans to NULL and bail out before the event switch when
no transport matched.

Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
 net/rds/rdma_transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a..ad9244a09848 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -52,7 +52,7 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 {
 	/* this can be null in the listening path */
 	struct rds_connection *conn = cm_id->context;
-	struct rds_transport *trans;
+	struct rds_transport *trans = NULL;
 	int ret = 0;
 	int *err;
 	u8 len;
@@ -80,6 +80,14 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		}
 	}
 
+	/* No RDS transport exists for this device type (e.g. iWARP RNIC),
+	 * so trans was never assigned; reject instead of dereferencing it.
+	 */
+	if (!trans) {
+		ret = 1;
+		goto out;
+	}
+
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		ret = trans->cm_handle_connect(cm_id, event, isv6);
-- 
2.43.7

