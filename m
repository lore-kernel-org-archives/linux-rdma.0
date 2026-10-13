Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325033F326C
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883101; cv=none; b=Z49Hw7T5O7SeYHbKXFI5mvjA2DP2hXySnjpo+Rk/paFvpDvZ/sRu/QeFrVhJqhkLG7KvM4c7dycQRk47auSZ9mzGe7BxkFpff9nOfY9QfFlSPJUSDXgm+eopWz/M4Df0cLZnfgoUKEuw4qDWq9WYLmIaJHLSZeIA/1fW40iEop0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883101; c=relaxed/simple;
	bh=sIamiAGLLTvfQREclihhC5CPbWkqynmMl8bydaDR1d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PflAkNu8Lt/x/LkkdwVr9yVuU3awSv8lj4CfJkxDT9bNJ16b+VN8RDex5UjzvaHWaViyLZ6uwsm6Pxw7KRD/U6UP6EHkfXIZgx7bsjGEuaAFAMlMNYggRjoARVZCAMQzXovd9D+gEv1xrbgl5ea5w7ls/kRFDT6q+h+brS5QOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IFt9fN3x; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFt9fN3x"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33e623bd651so321561eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 02:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883098; x=1792487898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=soQaNWm8vueueprjkOsN69vrxnkT85T3mWkfqLi7/qE=;
        b=IFt9fN3xMqeXAytaeI1qkQx783syrbjrFBqgJtlXMIOTlDs08yaAVZcp9+GZuLDS2K
         f4YJo/94X/LR5YNjppMWznqgq/dQoP42FwM1J/EgvSKSdj/ForMY/PZ+ODXpTaegPoIv
         KksgdB/WGYYoUbaqJZiBrc+JBKnfTQkBXYiA0fmfnQkmqWT2BaooUa2QsILY2Mu2r3xA
         Xs4q/MGgwjutNsm5oc89FM2zuI5EKZX2tU+0ElukH6iq/QAap3j6eULbDSI65NwwULMj
         jj9HEzJo5+P+JhJEmSzEk0405IocwMYAx5nAhVsFmP6dXhhOk34WjQCP9iUtOA3KZ7B2
         bNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883098; x=1792487898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=soQaNWm8vueueprjkOsN69vrxnkT85T3mWkfqLi7/qE=;
        b=iFJ8H3cJ6jvhiAgNsf3kfc8y+HmaO8sDZ5rp2/LHoLckU5lsygDLgHjf3IG//UIl5/
         pqK3VzU9Vmxd9lp2HQkzKRoMfUVcHnNEgMLjxbD1W44QeCaivqOMPs9Qg7ws68PDMww7
         ztIuLNOD1d35Hn+EFTOEsjZP5RPspnk50z+InpTHnK8mjSd+tZCS4zLNt/KevtOb+7g4
         4RFmTDrAZmd+GaFsxxdnHycTyRg49J2JW1DVrylkn2kVtPtN0VijuSIzIGSwhsK8YbQH
         plCEYAU4jc/h/JsIWY3pA1nK/KwnSdf5LfzVGRLhqQtSVIpAXoitDQkBy2phY05IU5d6
         AtAw==
X-Forwarded-Encrypted: i=1; AKwUvBxUwgSrJnLwnNHwKytF8s3vW8iyIdGMlIjQfFxE3VMHF8zlKPX5go4kgft6ecQeLkbtFAJXiNxUleM4@vger.kernel.org
X-Gm-Message-State: AFq9FYKO/PNc8ZAvPf/CnEvUBodavo5tdPOlFFqUeHUp873q/r1H2KS7
	yJO1bJLA7gqxbGT8tnmvFWbPJS3Ea3FQn1gCmH+b5ixBY5+4B4ds9+cL
X-Gm-Gg: AYBFou16d43qt5gERKa4la2eawpPJt3IC6vpXDgm3yj7n42d3NU9asMhdcxPZm7N8te
	mFkYUQAmMbGbU5l/JXfV5zfAu5tA6reTFZPp5nrKM7xJRoY8/0gbDe7cmjG9hVyiXYlGv8pHvyu
	RP+3LpFxLOTgAUzvujd4k5NxFueEE/6BVuYVEo1/UbMUzNwkrCPZSxYh8wdjeRBMzEbU+KX5SWE
	xPmKqfaRHvlHoOzUfyMBz1A8IzV6i+IWzL8dGBtNmtRTg5OPPF78jc3K9/hMCCcrC6D0DKTJ+LE
	KFtKTh2+nxlggg5pYZdAaNepOFMYqyqoVrJuXGfevgtjUWsrYlkLiVDly0Vymk4y5nnIaYovri7
	ETo+SRvhe6QsyKoEyyCcSkomZLzui3L2H8Of6wKZ71Bvisq8UhMku64ZFuDab2D4PlVUwkmDsJH
	pDWGdVryWdUmz3taMn2r2SqgRSiFM3vwrEzYh2vMORPiu9Gwz3UmQEr7wt1bam2AjBMFGLiGYDs
	qFkB5MsY01xfzVKqOHLTN36+LjCrMnuRqAf9vzRdMYOr36aqFtckiuy8m6AxcaX
X-Received: by 2002:a05:7300:ea0e:b0:351:6d7f:e2bc with SMTP id 5a478bee46e88-3537e04ce24mr24426729eec.2.1791883098044;
        Tue, 13 Oct 2026 02:18:18 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb6a279sm41437975eec.30.2026.10.13.02.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:18:17 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net v3 2/3] net/smc: serialize early link group cleanup with termination
Date: Tue, 13 Oct 2026 17:17:15 +0800
Message-ID: <20261013091716.1210420-3-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_lgr_cleanup_early() enters __smc_lgr_terminate() even when another
teardown path has already claimed lgr->freeing. Both callers can observe
lgr->terminating clear before either sets it, then tear down the same
link group, causing use-after-free and duplicate resource release.

  BUG: KASAN: use-after-free in __smc_lgr_terminate+0x393/0x3a0
  Write of size 1 at addr ffff8880bf2c0300 by task poc/106
  Call Trace:
   __smc_lgr_terminate+0x393/0x3a0
   __smc_connect+0x2e3d/0x4930
   smc_connect+0x42c/0x580
   __sys_connect+0xfc/0x130
   __x64_sys_connect+0x6d/0xb0

Check freeing under the link group list lock before unlinking the group
or entering termination. The existing locked freeing transition then
claims exclusive teardown ownership; an early cleanup that loses the
claim leaves teardown to the existing owner and does not remove the group
from a device teardown's private list.

Keep a temporary link group reference across smc_conn_free() and early
cleanup in smc_conn_abort(). Once the connection is unregistered, a
termination worker can finish without taking its socket lock. The extra
reference keeps the allocation alive until the ownership check returns.

A new group is published before its first connection is registered. Hold
it before publication until registration or failed-registration cleanup
finishes. The reference keeps the allocation alive, but teardown can still
destroy the group's resources before registration. Take the list lock
around the freeing check and first registration, nesting conns_lock as in
the reuse path. Reject a group already claimed for teardown and clear
conn->lgr, since that connection never acquired a group reference.

On success, acquire the connection reference before dropping the temporary
hold. A later terminator sees the registered connection and must acquire
its socket lock before removing it. On failure, keep the temporary hold
through early cleanup and then release it. Reused groups retain their
existing reference protocol.

This depends on "net/smc: serialize link group free work scheduling" for
the standalone freeing bool and the locked early-cleanup transition.

Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early()")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6.1-Sol
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v3:
- Serialize first registration with the teardown claim under the group list
  lock, nesting conns_lock in the same order as connection reuse.
- Reject groups already being freed and clear conn->lgr on that path.
- Document the scheduling fix prerequisite in the permanent commit message.

Changes in v2:
- Pin newly created link groups before publication, covering the
  registration failure handoff to early cleanup. Drop the temporary hold
  after cleanup on failure, or after the connection hold on success.
- Send after the free-work scheduling fix and reuse its standalone
  freeing bool and locked early-cleanup transition.
- Pin the link group across the smc_conn_abort() early-cleanup ownership
  check.

v1: https://lore.kernel.org/r/20260927063607.3691520-1-nicoyip.dev@gmail.com/

v2: https://lore.kernel.org/r/20261003183237.2284245-3-nicoyip.dev@gmail.com/

 net/smc/af_smc.c   |  8 ++++++--
 net/smc/smc_core.c | 21 ++++++++++++++++++---
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..97b0a0b51066 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1011,12 +1011,16 @@ static void smc_conn_abort(struct smc_sock *smc, int local_first)
 	struct smc_link_group *lgr = conn->lgr;
 	bool lgr_valid = false;
 
-	if (smc_conn_lgr_valid(conn))
+	if (local_first && smc_conn_lgr_valid(conn)) {
 		lgr_valid = true;
+		smc_lgr_hold(lgr);
+	}
 
 	smc_conn_free(conn);
-	if (local_first && lgr_valid)
+	if (lgr_valid) {
 		smc_lgr_cleanup_early(lgr);
+		smc_lgr_put(lgr);
+	}
 }
 
 /* check if there is a rdma device available for this connection. */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 660cd41ec720..c1bb284c4233 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -693,6 +693,10 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
+	if (lgr->freeing) {
+		spin_unlock_bh(lgr_lock);
+		return;
+	}
 	/* do not use this link group for new connections */
 	if (!list_empty(&lgr->list))
 		list_del_init(&lgr->list);
@@ -999,6 +1003,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
 		atomic_inc(&lgr_cnt);
 	}
+	smc_lgr_hold(lgr); /* lgr_put in smc_conn_create() */
 	smc->conn.lgr = lgr;
 	spin_lock_bh(lgr_lock);
 	list_add_tail(&lgr->list, lgr_list);
@@ -2049,15 +2054,25 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		if (rc)
 			goto out;
 		lgr = conn->lgr;
-		write_lock_bh(&lgr->conns_lock);
-		rc = smc_lgr_register_conn(conn, true);
-		write_unlock_bh(&lgr->conns_lock);
+		spin_lock_bh(lgr_lock);
+		if (lgr->freeing) {
+			conn->lgr = NULL;
+			rc = SMC_CLC_DECL_SYNCERR;
+		} else {
+			write_lock_bh(&lgr->conns_lock);
+			rc = smc_lgr_register_conn(conn, true);
+			write_unlock_bh(&lgr->conns_lock);
+		}
+		spin_unlock_bh(lgr_lock);
 		if (rc) {
 			smc_lgr_cleanup_early(lgr);
+			smc_lgr_put(lgr); /* lgr_hold in smc_lgr_create() */
 			goto out;
 		}
 	}
 	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
+	if (ini->first_contact_local)
+		smc_lgr_put(conn->lgr); /* lgr_hold in smc_lgr_create() */
 	if (!conn->lgr->is_smcd)
 		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
 	conn->freed = 0;
-- 
2.43.0

