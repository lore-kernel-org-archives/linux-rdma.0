Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576BC3CF02B;
	Fri, 28 Aug 2026 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900105; cv=none; b=RSqsYZbL+CdzpU4I/6LksFjt4+/LfWwhFwZXg2qK7lUIn8C5QaZoH9k3c2/kVRebi9wRuDE/toTt0T1Q7QtJ9VD+0IMvI++DWpPdkAzm0tCftgi8L1L0nLqVoAXJ47KloDUG779t0JI+iO4h4GgJq5Se1kLzLwXniHNtFqyT4AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900105; c=relaxed/simple;
	bh=l41zUspAh+qmhn7uwJLvG+3Y7/5ZXAUzEciuqKYPDsk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rk0DD4C7cRk+a7iLOUOvzlD3q2JsIzJo1jfG6dWRjiFgpctGzkBU2X0KaJh1Pt06aw8pAXKrUhlog20wTO3Zhbe3yzkvfqmU2KQupMEIFT0HXOtoa9QFKhxdx31TUso4uQdKcgS3wnLTYzL/RSBBaSpV+baEutNnJNXmFeQAb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UBxaa5YD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UBxaa5YD"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S6VkgV1265489;
	Fri, 28 Aug 2026 06:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=HHYkdyg73wJgmX64yNGfYkgX35vMJPxiVSXVO/W+w
	kg=; b=UBxaa5YDXEAyuxJrzRkMf2Yyb1Fa25wUsv/2WWZoz77yR96B9+eG6vh00
	BHzYyp37hLTxpEcgKytBKSY+Nf1uAZ0SDVkZ4XeetBPDQYlk/BeqpxQuFJbX1uUS
	gH0/eZFnLvqQNutj5Txx2LbTPUXIqPsCr+aSjlRPhnWlPVnVLptxvOOBkmyhP/1K
	WsB74T/QLv4Np2/i8UDDZcd6VPtwqGDUUTkUIPOix32fHUqGgxgGwL3lgAex0Ag0
	OLzh/TutEjLpGgoFa3bXtaJW8t5I5M6XjsB/SYqk048oEiEL1mS+jSr1m//XSpu/
	6/x5nIOcmepp8+rRPndbbHSvXU/Vw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73dxt6e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:54:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67S6fH7b010764;
	Fri, 28 Aug 2026 06:54:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7q3kcsa8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:54:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67S6sovt39977424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 06:54:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EE9A20049;
	Fri, 28 Aug 2026 06:54:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A0A920040;
	Fri, 28 Aug 2026 06:54:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 28 Aug 2026 06:54:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 506C016161F; Fri, 28 Aug 2026 08:54:50 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
Date: Fri, 28 Aug 2026 08:54:37 +0200
Message-ID: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA1NCBTYWx0ZWRfX819p3qPm1mpH
 uANQwbH71rAvICOdoBNAFk5uMWzcRDiGUJda7DSstTZcRLxUGC1ay4Oe9K/yrhjRE6uXPIAJBA2
 uM/AlFK2WIuXiO1TMA610+/nE/SA1II=
X-Authority-Analysis: v=2.4 cv=AYuB2XXG c=1 sm=1 tr=0 ts=6a9130c0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=ehLVjgcsvBZ5JExnJ7cA:9
X-Proofpoint-ORIG-GUID: IlQBeDv2NyJWc6MfDU9_ByVg0UMjRF-C
X-Proofpoint-GUID: 04OZQBG-dxKnRPr96Hcdi1oMCmBbKPBQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA1NCBTYWx0ZWRfX478x3ZuU/cgw
 y62bCUqspcAYQqoCStIXIMqyD8e5K1OX5OTa3ZTm8wNMzhRBgv7VVGQEz7zp2dsOMcNQgxK9BON
 jC8JKk4gyBY556zus2uKrfAzLMUlBI2w1mpMxUW2QFrcNO7F2yAUOPXwltWjId1Al20EaoU+9ID
 Ob59r1lfB2ySboX6ykjwDo0yAmxDBJS5yLxnDpkVU/riXoWA4nPOefxyKllPoUy3PgYzo2Caywv
 KnoaoveR8xvONlnxyPJrnElWdRbc2XUvkzNLymUgtQBSzHz6ni2YltTe+30IiDuSseZUE8Pe0GP
 tkPVbAgGOz0KlCnlGWcQS1n2jxX1BKuqslVaF1e/bSibc3vBqFnRDh9vGG6lLM7zSReRhr7hnXP
 izwPYMoXBh6HW6cyrFTRBpLJegq5PlFcSG/Zd9VKMV7P+1mueerQocw/i0mQvIhn7wksvaEWfFZ
 6k8alS1yYXfZzcZV5yQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608280054

This series fixes multiple lifetime races in the SMC diag dump path.

The first patch adds the basic infrastructure needed to synchronize diag =
readers
against connection-owned conn->lgr/conn->lnk updates. It introduces a
per-connection spinlock and uses it in the link switch and connection fre=
e
handoff paths. conn->lgr and conn->lnk are NULLed under the lock before t=
he
borrowed references are released, so a non-NULL conn->lgr seen under the =
lock
guarantees the lgr object is alive. The diag reader can rely on this inva=
riant
without borrowing any extra reference.

The second patch fixes two races in smc_diag itself:

- serialize clcsock field access against smc_clcsock_release() with
  mutex_trylock()
- take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
  smc_conn_lgr_valid() inside the lock to check that the connection is
  still registered, then snapshot all required fields and call nla_put()
  after releasing the lock

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v2:
- this is v2 of the series; the earlier submission was mislabelled
  [PATCH v3] but was in fact the first version sent to the list
- split into a 2-patch series; patch 1/2 adds per-connection lgr_lnk_lock
  infrastructure to smc_core, patch 2/2 fixes the diag dump path using it
- dropped lock_sock()/release_sock() from __smc_diag_dump(); v1 held the
  socket lock across all lgr/lnk dereferences, requiring the hash read_lo=
ck
  to be dropped and re-acquired around each socket
- dropped the restart-from-head loop in smc_diag_dump_proto(); the new
  design does not drop the hash read_lock mid-walk so the hlist truncatio=
n
  concern no longer applies
- dropped refcount_inc_not_zero() socket pinning from the dump loop for t=
he
  same reason: the hash read_lock is now held for the full walk
- added per-connection lgr_lnk_lock spinlock to struct smc_connection;
  conn->lgr and conn->lnk are NULLed under this lock in smc_conn_free()
  before borrowed references are released, establishing the invariant: a
  non-NULL conn->lgr seen under lgr_lnk_lock guarantees the lgr is alive
- added lgr_lnk_lock to smc_switch_link_and_count() to protect the conn->=
lnk
  pointer swap from concurrent diag readers
- replaced mutex_lock() on clcsock_release_lock in smc_diag_msg_common_fi=
ll()
  with mutex_trylock(); mutex_lock() was valid in v1 because the hash
  spinlock had been dropped, but the new design holds the hash read_lock
  throughout so only a non-sleeping trylock is safe; a failed trylock lea=
ves
  address fields zeroed, which is acceptable for a monitoring tool
- all conn->lgr and conn->lnk accesses in __smc_diag_dump() use a
  snapshot-then-use pattern: fields are copied into local stack variables
  under lgr_lnk_lock and nla_put() is called after releasing the lock,
  avoiding any sleeping operation under the spinlock
