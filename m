Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B23C3BE0
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495158; cv=none; b=C6kdqcsMIUDkPi/ecNae4+XJIRe0MDwQ6dMrhb59aMSkYNZGtENCVFBEyTB+tpqJBcjitdfouAvVPVkoYuTca+vj+W68I13lPqDAe8k6e5Yhy0O1HZzlkjIwmdayfdJzSkehnjUypYxV4Ax/TlhBhhd8KpIzKcTUZFgB8jq4MiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495158; c=relaxed/simple;
	bh=mOrp6IPpJz5ZZROAj3Iql3ESnh8Md7fCHDF3PGCEI0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kuY/4tUrC6JaJfcPaoP+WJQHCHhX8x8iVrgFx28KYym2BBhHJAMw7jl0guaA6X/OYyWyRSgrqgolQH38SK3hYwEhsZGyFMP9pyWZNejMA7men5B3Lo+2AiF7UFgbDy9WGVcnh4GOylJpHfcDsue0ZTXzZbLIDC3AMx7uijgyEJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UvsUWUf3; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UvsUWUf3"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3427977d677so146358eec.0
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 00:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790495156; x=1791099956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cJAzxgjLnHgIeW9gGXT3PZ4JfVayI07h54Pz46uXNhQ=;
        b=UvsUWUf3QgFZJwyjitEFjDrj7eYKSSQwOZylhYSBUqQjtUP7cCpYVS9YTrZVbo7mOg
         NEZ4V0rzFDp00DTlCvrXiBrGfrD4/fuvvDdlQjXJCTm2h+KamP66ZATQrcHXZq8kOBsq
         sT7S1UYy/89ayO2XBo5oCqeOW2UY0CJtE6N1UxPL62edQ7nZscnec3JZZYMAbOrnOI0J
         S7ASbVu4LaKI7myqOTC92uxCIpacqosigmz3ggtLMOBdLnEbRPj7vixfNdnjSYCiCxig
         rl8qSDdDhWE6pSPhSxv+DFViRQwxN4TS3QVykPyCvmURhOICmMVQvY7W+pBz8FUPMInd
         WwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790495156; x=1791099956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cJAzxgjLnHgIeW9gGXT3PZ4JfVayI07h54Pz46uXNhQ=;
        b=IAyB566KpP3wcojJa6BHgPk646FCqIxHjZFW7P4CXYq2PlIZW/9ypCWHMaCc+/mCsj
         HDFtXT/UVGG2cD7DrQK9s1JpIIu0BphTPWiWS4gtUwm31pGWgXilzOgB8hPomA02+LKR
         oPKTVuX0xeoq5HMkmDAv4wG48BOOv42BLEdgDUJ+IOdHKF3wDtCJoMottbok5c5y2J5P
         75jC9zhC36EJHmetfdUrL8RuEcsnmorX6PkmkxHQ6pAppumNR6JaNTBCNVILp9Ynmeuo
         HDP+OV9MGP9X/ztbTukAswPg2Onjk8EhdNctf+Z4fLetKOQnsEZ4c2oyHiKT52qbovpo
         4qHA==
X-Gm-Message-State: AFq9FYJ6lSgAYMGeMNsUwBZIhXSYzw9fJL5o1bghH/NRZY6BdnBrqZAB
	YTAALk4cQi7XAfliS0Pefw9Tcx+g5JfMw7QLdImp5XlJ1fz/O9HwaHZD
X-Gm-Gg: AYBFou32xFbbOwqjL3L7TPOeys43gqfrRdvzJHuNyx2dZD7gYLh/Bx8BGkIC3tY2wCO
	6Fk15HssA1UCYvQHYCH/MLcjVrghDupXNE72cIlXvOSrbhLfUa2RU/9xIuMFtAs0dEUketT+5It
	zmaJKvM97fVIUOAmXIXSaMMQIcvbri/Ts9sEhSB6US2XSFo0bCL7zaODbiebr6u5l4s9Q6t6uZW
	0AnWCYZsY6c8pH1HNeRFWdi065neYEfLFGf+U30GKMGAi1aLK13AJKdVl5r11Cwj6Bi6MXdJErS
	t58s355v2eT41eRYrmXTxf4vfZ04P7nkk5gV2AGWFJR/v6ji5QRrbctTJr37YOBfCig8upzapyU
	JC2h46FzgVDa24cqpkvIZP+Ml3rJeB5x6bqAO1aNcs+ybE5aofP+kq3+heG9vFiHa0PbWl3+dkl
	1Lm8DUIq4gp46Xf5edwiC77Jfd+wCSYueDwE8FOesTa6ubK8U+HwV1JU4fBMxlttjzatJVlr74V
	hitnbjsNfXzGCmmvagmyW9sEnmEgXBpBPRxEx2yNKYgLFkE6pHVcbsaqMDGTajvWQtIrnkE90va
	lFIe
X-Received: by 2002:a05:7301:540e:b0:33c:1bd2:1db6 with SMTP id 5a478bee46e88-3426d0df371mr8389965eec.0.1790495155628;
        Sun, 27 Sep 2026 00:45:55 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34571658054sm1941791eec.8.2026.09.27.00.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 00:45:54 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] net/smc: Serialize link activation with teardown
Date: Sun, 27 Sep 2026 15:45:47 +0800
Message-ID: <20260927074547.3694742-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_llc_link_active() marks a link active before scheduling its testlink
work. The first-link confirmation paths call it without llc_conf_mutex,
allowing link-down processing to clear the link between these operations:

  Connection setup                    Link-down worker
  smc_llc_link_active()
    link->state = SMC_LNK_ACTIVE
                                      smcr_link_clear()
                                        link->clearing = 1
                                        smc_llc_link_clear()
                                          cancel_delayed_work_sync()
    schedule_delayed_work()

The connection reference keeps the link alive during activation, but the
newly queued work outlives that reference. Later cleanup skips clearing
an already-clearing link, leaving its timer armed when the link group is
freed. KASAN reported:

  BUG: KASAN: use-after-free in __run_timers+0x723/0x8d0
  Write of size 8 at addr ffff88810f108810 by task swapper/1/0
  Call Trace:
   __run_timers+0x723/0x8d0
   timer_expire_remote+0xd3/0x120
   tmigr_handle_remote_up+0x4f4/0xab0
   __walk_groups_from+0x40/0x150
   tmigr_handle_remote+0x229/0x2c0
   run_timer_softirq+0x1f5/0x250

Hold llc_conf_mutex around first-link activation on both sides so that
link-down processing cannot cancel the work before it is queued. Also
protect the client's initial optional add-link processing, which can
activate a second link without the lock. The other add-link paths already
hold llc_conf_mutex. This serializes every activation with link teardown
without changing the handshake sequence or error handling.

Fixes: 877ae5be421d ("net/smc: periodic testlink support")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/smc/af_smc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..221643624ace 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -665,8 +665,10 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 	if (rc < 0)
 		return SMC_CLC_DECL_TIMEOUT_CL;
 
+	down_write(&link->lgr->llc_conf_mutex);
 	smc_llc_link_active(link);
 	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
+	up_write(&link->lgr->llc_conf_mutex);
 
 	if (link->lgr->max_links > 1) {
 		/* optional 2nd link, receive ADD LINK request from server */
@@ -682,7 +684,9 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 			return rc;
 		}
 		smc_llc_flow_qentry_clr(&link->lgr->llc_flow_lcl);
+		down_write(&link->lgr->llc_conf_mutex);
 		smc_llc_cli_add_link(link, qentry);
+		up_write(&link->lgr->llc_conf_mutex);
 	}
 	return 0;
 }
@@ -1909,8 +1913,10 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	/* confirm_rkey is implicit on 1st contact */
 	smc->conn.rmb_desc->is_conf_rkey = true;
 
+	down_write(&link->lgr->llc_conf_mutex);
 	smc_llc_link_active(link);
 	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
+	up_write(&link->lgr->llc_conf_mutex);
 
 	if (link->lgr->max_links > 1) {
 		down_write(&link->lgr->llc_conf_mutex);
-- 
2.43.0

