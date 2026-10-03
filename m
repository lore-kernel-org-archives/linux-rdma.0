Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2D7377ECC
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791052388; cv=none; b=Oj9G6JGk3rZi41GO+qNit8XHIrTH3Bs8hls3Ya9iVFu1Yrz/y/AO8hBo/c6UNjkM84f+jHnwibd5737zarKHBNN3U9jr77pMAAr5rUQZ+cQsIhUWJIGm06Y6H3iCymnY1JrtGGmMEup9AKISmLaRVLode27n5jJouZspiWYJ45k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791052388; c=relaxed/simple;
	bh=/h6lOlOa1TOSE6/YjJjYsJ0AjizmijOCWan0WqqB9oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0AAy8rfhiIF6IFghQPfdqRYPXQ9/14EokZ6fYTCIqsBmD799PfXWv39XMhjQP87gEVNzh70hzUWHgAg2D49991Q8pJUBweH3kJLnxnXKquob51N6IokzPnaTSQNh0NGSF2VTbjNBYebOlvap+g1MhjosQGuo5UJH3vHagcXRPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0WpIzaM; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0WpIzaM"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-35120bd8ea6so11487eec.2
        for <linux-rdma@vger.kernel.org>; Sat, 03 Oct 2026 11:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791052386; x=1791657186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cuY5nPRthZWhch4MsboYh+YgCm2kORhdKEQMo3rY0hU=;
        b=F0WpIzaM6tSQn+CNycvLFISX+cx69ZeNXtg2a8BKWIg8Q2fWh4uiFviZ8Qis+H0Z2c
         T4am0OTIweASubfA/lTGDoVFVnzet/hy2Z46tnNUQ9ETazQqdYP6G1B5ZxBwNdukx295
         IgT6l0A51kYcvMVEgdS+yWicheKgJYsCndIG+pMnCFGIswrKTPmH8KRlC2RsJvjKoTM7
         D/gK38O3zQC2EVdjChOIYSqDnJUp/WwqMEaRPcWVpXXevzk2HgxltgElN+jBpKqxLMBq
         6KbPiI6c5qKfbo/aW3oXel0QmhvcI/bpRyuEVLs53VS1g9aGPuLL+wArLvxRw/cvqnvE
         tRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791052386; x=1791657186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cuY5nPRthZWhch4MsboYh+YgCm2kORhdKEQMo3rY0hU=;
        b=koYO0NjAoWb7vmQZVcElSmpNF7bJ/KJy4I/EPwUiiW0qNWsKDNKoB/CgqaJ9Q/avfm
         zSgOW5rBxYz9qYGYJGr3K3E+T0binl1JbBiVTHSz86iAmEtiWoyB1Ul6LzE/v4Ccjr+G
         M37UvKDAbTpFXjFmDcWMUFJcxqtZZYhq39hw/psF9e9+Bg/QMRuAKjn5x+wnDty84Zxq
         LbTOUZAiIbvpF2Cs7PuAm63V4noHt747qO6mBT2izVyoaU1a5/LuetzZoR7uj1f2pZ/B
         6wqCFVnybElg+HFRouaPdUt5KxGTyYM/YDxcGF4ysgfD9uUZddPjVWjkqz8deT4hloGk
         B+oQ==
X-Forwarded-Encrypted: i=1; AKwUvBxIgmEvNaZ8yw7LGyB20opTGZjmpQZzmxmtWcgcvDIu89bRXP+ULBVyWzDz5DIGycDbmndYkCAFAQJ/@vger.kernel.org
X-Gm-Message-State: AFq9FYKNYAEVhtwR5zWgF1REDGGjW1BrRM5RGge2LWq+exgCmUkvjbG8
	IEXVuk/GipAIh0n5lDf/U2nUDs9Lx1XTVMpAapOdqqjXrVsl1YzcZOilvb1A+/nbjXZiLg==
X-Gm-Gg: AYBFou2tv0pC9VIvrI2wq/SaFLToMeAiDXJ7+VRbNuJ3e5LPcfdRBzXFaOLXUoftGxP
	JLx3eWVuVrkm5BuJ7RlW0IC4Yxe+uYtvOt+fu4tcC0ywTH0nfBCsn/7cLvnqvqA/QHJHmiX8pL/
	BDavKsAiwDqe6V0qvN6eLMGzG1MtoLqwm7N4AUEyxzAESvtTEGtyHy4nH9pX15fuBJ9cbT+l7Xa
	ujS6CbaXAnWlast5VnzPy3WiCAz+0FU+QNdb2fOMPdLCw2x3zCn8r+LuHoETNLzqyOQdd4BgUK4
	E8idvJTWdUlShrRBF09k91mdidvBPttLiZF9+VuseMKbrqs1KMAvf1ZnZ98RtquY1Q+hpJWTYnG
	maJlRtk6im+qaQQIDeF0mBxxFzlJtzHo5iUCsYv0ZqG7f5SzrRewLPjm1A9QvBdNe28aI9+I60w
	SNyWIaAcdbq1lMQ0sHtAY7hRY2h7+XNR4a9U6Q0CsfcHPACN6MVYbUCs2L2e8WrTp53hW1RSCQd
	J3yLrXyPS19siTnO43htCosbRZcpXoE/5NFo2ThLDTFRUoSJYUOQCiua+Gk3gW2eTt0Cg==
X-Received: by 2002:a05:693c:8858:b0:33e:8552:6e06 with SMTP id 5a478bee46e88-34f06674f4fmr11369817eec.0.1791052386124;
        Sat, 03 Oct 2026 11:33:06 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14fd9698sm17118191eec.23.2026.10.03.11.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 11:33:05 -0700 (PDT)
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
Subject: [PATCH net v2 2/2] net/smc: serialize early link group cleanup with termination
Date: Sun,  4 Oct 2026 02:32:37 +0800
Message-ID: <20261003183237.2284245-3-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003183237.2284245-1-nicoyip.dev@gmail.com>
References: <20261003183237.2284245-1-nicoyip.dev@gmail.com>
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

The registration failure path in smc_conn_create() needs the same
protection. A new group is published before registration, but the
connection reference is taken only on success. Concurrent termination
can release the group after conns_lock is dropped and before early
cleanup. Hold the new group before publication and release that temporary
reference after failed-registration cleanup. On success, acquire the
ordinary connection reference before releasing the temporary hold.
Reused groups retain their existing reference protocol.

Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early()")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6.1-Sol
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v2:
- Pin newly created link groups before publication, covering the
  registration failure handoff to early cleanup. Drop the temporary hold
  after cleanup on failure, or after the connection hold on success.
- Send after the free-work scheduling fix and reuse its standalone
  freeing bool and locked early-cleanup transition.
- Pin the link group across the smc_conn_abort() early-cleanup ownership
  check.

v1: https://lore.kernel.org/r/20260927063607.3691520-1-nicoyip.dev@gmail.com/

 net/smc/af_smc.c   | 8 ++++++--
 net/smc/smc_core.c | 8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

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
index 478c8bc2759a..1918a79ff60e 100644
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
@@ -2054,10 +2059,13 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		write_unlock_bh(&lgr->conns_lock);
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
