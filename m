Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743F635C681;
	Thu, 20 Aug 2026 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787237270; cv=none; b=hUXU3lkNc4ZwKhEISUP304es8J7t1a6/HVAZoMR4wn7oB/v4WHOuj+AyOVK9Zbs0vR/K4as6onbkEwkVhz/VnQNFhYtGZQGfAeUXMiywT5g38AoCSOPSlkLMAzm8tbDFoJLhkpyJvuO2btFBKBovj/WcQgywz15he1cKZ8UV86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787237270; c=relaxed/simple;
	bh=arChOdlx8rIeYlNNqtWf0HvAV6gvlp/4oRxegmFuifs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N7MtL/5IqOwVl19C8bTpRHqduLI3g0iViwFICLz3B35O2knZHN0G514cpL7FDVz/rl59E49umSgzkOdv0fo5KQYFuiG0VAFPfgUvsRicCRvmRFavfoFXPvHPcPFTKY0wKG4jR9CzIdh+zUWpqOgsvaNby9idYRmhV2+lewaebVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=isLHpSKk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="isLHpSKk"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KEVdAw872857;
	Thu, 20 Aug 2026 14:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=M6DyRkSuMoqMLORXqiM3rYRtdD8L+5McAvJFbP+st
	DY=; b=isLHpSKkDaajhqvwV4VQVBt3GlW6Ny6c8ZU7jT5tpPMH3KrXAVDO6Cdkv
	/V43TFuGgrlPjP+5KJOlgsDBxahMsuGdTOCTrd0uAmu/xuy9nD6DNQRXsHZvBdPX
	U/qrsK4Sa45Bup44eeYGorUkWhM60I5Gtbqv6xKrAsD2YiAU5+lou7wdVDddIp7C
	FLEWPaBbEPE3eJyS005bT/9cMmmJpmGpeJGjG3088139CNkWCwbdOJCez5PSJU1q
	Dn25GSwa6pHpDc3+f+Hxqwe5WN9zmwM2343TeJ1ySi6jFtxEvUGbQZezekSk94iY
	cIqR/VfcAgOF2uNgMktWpp7HIbzhg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu0b0mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 14:47:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67KEfGL2013289;
	Thu, 20 Aug 2026 14:47:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xhf3a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 14:47:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67KElTCx49217938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 14:47:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA91E2004B;
	Thu, 20 Aug 2026 14:47:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C96920043;
	Thu, 20 Aug 2026 14:47:29 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Aug 2026 14:47:29 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        horms@kernel.org, pasic@linux.ibm.com, hidayath@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net v2] net/smc: fix socket refcount leak in smc_switch_conns()
Date: Thu, 20 Aug 2026 16:47:29 +0200
Message-ID: <20260820144729.1019399-1-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: M8d_DPZNN10dRYlw7H3bifNP7G8oJ_J6
X-Proofpoint-GUID: n04lYuaoW0nZuDn2q6O7ZsX9GCgwxUqP
X-Authority-Analysis: v=2.4 cv=RoX16imK c=1 sm=1 tr=0 ts=6a871387 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=xNf9USuDAAAA:8
 a=NyngIuOBHUP6-Bjl12gA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDEwOSBTYWx0ZWRfXydQn5DFT0UL/
 050eYD8bwUNC8eGBcy6ojbigzqDZeP7u46FiRHCKei26v/O0DPXAF3LtUg+r2S2m6MJdfjfglzf
 wOZ/sYGElULAX1gbH1qpOO6KOiz6P/w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDEwOSBTYWx0ZWRfX+uFuvdf48T8w
 PIC9wpCmNSiyOf+gqq6JdCUOj4ylOwGM3mEKE+Bnods9A7ZOu73+LVuaEHpVyGYJnIrV2DDcBKl
 jOMhpv0tkfeuigkEeIstSn/Kt5NC84wB9NaDvpBK/Fuukkg+V3NWPSGSoWmbHXU0XpA+z3eFg/l
 zRgzZj6y0T4vEAXgdzdCWVrGcJpHYu2usx7sQ1w+nuBI/llR0xhf1ezGJlBFXC80MucRSYxo0Zz
 B77mhue94OIUVKU2fxtsGFv9ngyiIkW8pXCR6K05ko8oUkjNqNXnomXBvsiSUsw4/0iPFmIQmN8
 TRFqF1CEErTDdhfEBjh1Fmg2Zi/0FI0OtCpnKsPB9qDMwK7qAdF5Dq0tng3BFVqqPlMPcLw+DgT
 keLC1ZCMl3Yw/sqHPwJedjhFPlFPBfr8slF4LVd9Iv+YZHog4KW7WwsHYT8Y1nnlDvlhyBe4isM
 h/tnhEPi2ajXmbj2oGg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200109

smc_switch_conns() takes a reference on the SMC socket before dropping
lgr->conns_lock, so the connection stays alive while the CDC slot is
fetched:

        sock_hold(&smc->sk);
        read_unlock_bh(&lgr->conns_lock);
        /* pre-fetch buffer outside of send_lock, might sleep */
        rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
        if (rc)
                goto err_out;

The err_out label only drops the wr_tx link reference, so this early exit
returns without the matching sock_put(). The second error exit is not
affected, because sock_put() has already run by then.

A leaked sk_refcnt means the smc_sock is never destroyed. Its send and
receive buffers stay allocated, and for a user socket the reference held
on the network namespace is never released, so the netns can no longer be
torn down.

smc_cdc_get_free_slot() fails when the target link goes down or when the
connection has been killed while the switch is in progress. Both are
reachable during the link failover this function implements, so the leak
is triggered by the same hardware events that make smc_switch_conns() run
in the first place.

Restructure so there is a single sock_put() covering both outcomes,
instead of adding a second one to the error path.

Fixes: 95f7f3e7dc6b ("net/smc: improved fix wait on already cleared link")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
v2:
- Restructure to a single sock_put() on the common path rather than
  adding one to the error path (Breno Leitao).

 net/smc/smc_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b4208cb186c5..2f7f9d469272 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1148,13 +1148,13 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		read_unlock_bh(&lgr->conns_lock);
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
-		if (rc)
-			goto err_out;
-		/* avoid race with smcr_tx_sndbuf_nonempty() */
-		spin_lock_bh(&conn->send_lock);
-		smc_switch_link_and_count(conn, to_lnk);
-		rc = smc_switch_cursor(smc, pend, wr_buf);
-		spin_unlock_bh(&conn->send_lock);
+		if (!rc) {
+			/* avoid race with smcr_tx_sndbuf_nonempty() */
+			spin_lock_bh(&conn->send_lock);
+			smc_switch_link_and_count(conn, to_lnk);
+			rc = smc_switch_cursor(smc, pend, wr_buf);
+			spin_unlock_bh(&conn->send_lock);
+		}
 		sock_put(&smc->sk);
 		if (rc)
 			goto err_out;

base-commit: a13dc7dafebe1643676c3d995f0a5651c08387c6
-- 
2.52.0

