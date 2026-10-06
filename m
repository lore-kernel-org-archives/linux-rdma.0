Received: from cvsmtppost14.nm.naver.com (cvsmtppost14.nm.naver.com [114.111.35.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1D92BE639
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 21:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320543; cv=none; b=UUkJaRjDXp9Za9BlLusfcWEu8ieA4ODzjA7pJs0pnFaKjFQRDgFuVtL52NnbGp84Rg3RH1NRPJScquqlCbqDMxRdTHUiMEqvGkhTFZYNeSaVIM/JsyjbF4bF/b9uta1jsa7qZL2ecxvWxzKzJWzHI8C5JSTwH7Q46SLwYJqhpnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320543; c=relaxed/simple;
	bh=4+EiP65+bvq41LfgEMYvnEnAvMWgqDXCp767t8pZaEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tIW2HEH1pu7TahIXTUZlbswTFGKp4JQZKqwZ85H3h28SW6uvWcID83NPzvDVBRoRa6Ex+MrMKJdbLPEdtCPHyzhGzmxJZCNbpr2OMxIYYV3dCfc05B3jrQnHdCivTxPi+e5mqjtbsWN6+dzmSifJRJkol4j/K3c/EkzrhGCnLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=RFD99k4W; arc=none smtp.client-ip=114.111.35.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="RFD99k4W"
Received: from cvsendbo025.nm ([10.112.18.59])
  by cvsmtppost14.nm.naver.com with ESMTP id qENHbPFHQm+DvVtgKC3mgA
  for <linux-rdma@vger.kernel.org>;
  Tue, 06 Oct 2026 20:52:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791319933; bh=4+EiP65+bvq41LfgEMYvnEnAvMWgqDXCp767t8pZaEU=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=RFD99k4WHj8sfxQTNa76PEgxs4gKp1/Gkn8yvq9zMo0uQS1E8gS1HMks8GNHuFYro
	 xTiMeGfRSvoiEnXLhmOqhOruo1dtXVjTOTMm5RoBTrbJ8kExoH+TbFjvL5RJF1xfl3
	 PRe9HK4O0A359+2X8nbW5k2URqxyCedkAHGO2cDghHtDjWhCBlkHpNX+hCfWEOSwOW
	 IH+Pn6FtpwS9ZTWa2KCNCwJGWfrAczG33STEFKbFCniMve1Zn2uaqX7rnbVGiHWFTn
	 sQPFxGgv0vE9Tp1BswM4G4cElfwrcJ4BAnDeJ8Wf4qqYvEvmkfbMfjQdoSDpNIdkii
	 AeQri21w0NZdA==
X-Session-ID: M0sCso7tQtycFRTn8XrBHA
X-Works-Send-Opt: O9RwpzGdjHmdKHFOMr39Ko3YKHmwKBmwFAbrFxKrKqEmjJkaBd9YKBmm
X-Works-Smtp-Source: Yqb/KoulFqJZ+HmZKqEX+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp003.nm.naver.com with ESMTP id M0sCso7tQtycFRTn8XrBHA
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 20:52:12 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andy Grover <andy.grover@oracle.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] RDS/IB: validate receive completion payload length
Date: Wed,  7 Oct 2026 05:52:04 +0900
Message-ID: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An RDS/RDMA peer can declare a fragment length larger than the payload
reported by the receive completion. The receive path attaches the recycled
receive fragment without validating those lengths, allowing recvmsg() to
return stale bytes beyond the actual payload.

Validate data_len against the expected current-fragment length before
transferring fragment ownership. Disconnect and reconnect on mismatch.

The issue reproduced in two clean QEMU boots. A peer declared 4096 bytes
while posting only 16 bytes, and a receiver under a different UID obtained
4080-byte tails from prior messages in all 256 attempts in each boot. With
this change, the malformed message was not delivered, reconnection
succeeded, and a subsequent normal 4096-byte message was delivered intact.

Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: sungbyeongchan <tjdqudcks0424@naver.com>
---
 net/rds/ib_recv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index bd6cb3ffaa571..0daddb108c8a7 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 		}
 	}
 
+	if (data_len != min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
+		rds_ib_conn_error(conn,
+				  "incoming fragment payload length %u, expected %u; "
+				  "disconnecting and reconnecting\n",
+				  data_len,
+				  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
+		goto done;
+	}
+
 	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
 	recv->r_frag = NULL;
 
-- 
2.43.0

