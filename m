Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795766015;
	b=f2dHEZarbbuYbq0fjzkd8yFVMjjwk38F6EAgdxXZsk4V+iGk0s3wkYKIE+GFLd+k+xod
	 hNnSDtzNyC4yM19nSt1Bk49zE8G9wT+pgVZldyYF9iPDnXclD/Xl9q0k0feNNeGwKdcSI
	 LuOL7BvZaB92dICrlCqenqKr/1XD9ntSPGy8A7wxiGZaIBEWcDudmj5DWIEUMDTjtYfSy
	 Fsy5HyTPcopHd9NjoO6iDoorfIwZDnvLRSoa/qXlZ7O9g7nS6ttGTPxaj3lcI0gDLadiO
	 eLQ3tYIINhxwnYZV80MdBQU/sF7i91f7DGOtHc/RofsPxoWsIqWEVrt9TMd9nqSkx/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795766015;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=vGAl6eMkfl9Pv/bt+AVQxb3WhQXJFpGIl3WRn6Vbpsc=;
	b=ti5prnWYTWbnhfRYgQhMKndi82HMKvb2sUOLdcoJHJoP+JhLnmiiHu8/fYPZBFJwjkJC
	 nKG5OKS4wTke08LpgVnJnC8hSkH3/h6uodY9HlqDTrwAw8319R0dNqvJwAM9tBxpmduV6
	 ObRHjhz5K3r8br5Xdxf0KwJ64xeLZPgoC0Ug/WZwVT9j7bymIKCy6y0CxGVTdmN9TkRmf
	 axNNcWHYiQSzfF4pEKVmtizBibeZJKdbLfbe6WDdwlQNCyC0zSXOn/RGNrl12+q6AtpC8
	 QVfDrroiDp0XQs/RIhpwTE1TDGIF9GSJGhdfymWFaGgeuYmATuNGaKRutOLjJttbgRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="HN6Xmz/8";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E6606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 07:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 249E6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=HN6Xmz/8
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AR7Z30g1237017;
	Fri, 27 Nov 2026 07:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vGAl6eMkfl9Pv/bt+AVQxb3WhQXJFpGIl3WRn6Vbp
	sc=; b=HN6Xmz/80qhFOmXQzRsx4bekd/z7axnx4nbMMqdhv0HMTssbx3C0MFp8W
	HUXN1XieI2drjV6wJiRiwD03KHnpV+S4v43Lhh4LtpjmI5L12uJz6c57e+uNwS9b
	NEQqNlvZmSPPCr/NH0qJpDGCh3tA6E/X53v5nmPOEDom9JoGbV/xk+3DvOAvctHW
	BvES82fHzo8/aWjXdgFDMtC8jKRUOIas45AtZN69G/VaC851w6zV0vSZcXoT8rgR
	gbrq1Vr6AW09cTDjJfbrrq8nwTdEvNXYLx0fu0ybcuKwMGIWXSq5Ly9F1SzkTkJ+
	W+GWKkt2kdzbiKwappsvhWFJFunTQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34p4uwb5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 07:53:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AR7JGEM2384506;
	Fri, 27 Nov 2026 07:53:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5kfa9dd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 07:53:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AR7rPpp27853082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 07:53:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9726E2004D;
	Fri, 27 Nov 2026 07:53:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 804AA20040;
	Fri, 27 Nov 2026 07:53:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 27 Nov 2026 07:53:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 5A2EA16156E; Fri, 27 Nov 2026 08:53:25 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH rdma-next v3] RDMA/mlx5: Read the CQ consumer index under cq->lock when arming
Date: Fri, 27 Nov 2026 08:53:23 +0100
Message-ID: <20261127075323.4099367-1-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDAzMCBTYWx0ZWRfX90UdiFRlDTuU
 VfBZOV2Kf3ykeK/kadD8ywYUBWCn3HPWCaRUoqaetXiVO3DyMb2uEh8VDDIdlvLHXbTZZH5dlod
 IXhXC8zUUMDFQy9o1EtElMjBNmht2IM=
X-Proofpoint-GUID: Mf10fFiromptQ34I2FgLeFAEIl5cJIJ6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDAzMCBTYWx0ZWRfXydqQcgFOV0lh
 KftHYmP12iNf5ilZnLsfjO4qNGwVahM5SSmYDIjA9IDMex9chF7QqqqcRuNCwxEXI8LmrH36ALy
 An0Cp98kR0+AzyMd1br9rNviWBmLf985SyaAp9T1AMg6dby8VPoAkoTIihA2Rbet0nIjoN7matc
 z9S3BuDmnhZqF8WirHiaQe2HyihyyYhiO4OeGdeM95tket5SbbXCmPXdn267StnS8R68M/W+c1y
 n2OwG5G8UxOhLQ7olithd6zRBAHUjNegchLP10NP6ep9sIgJ5NJbhxmntKwfYGaHDEDLwc10Xuu
 CsXw5r1JCCtuo6zj6TQ7ljIEJ9NZmIIcZacGkxfxGNWTvNEBV9fdbA4YdfIHPSnzT+/ex8dN92e
 yzEa+RrSEr1yY6ZB/SXaF1mA5LXmrwamqMbCkF3BkSwZt9fJjlIL/wiwmCGrF4lGefdSmklj3Fa
 4ssCxYz6kt5fZLLBgTA==
X-Proofpoint-ORIG-GUID: Mf10fFiromptQ34I2FgLeFAEIl5cJIJ6
X-Authority-Analysis: v=2.4 cv=QabzLcbv c=1 sm=1 tr=0 ts=6b0936f8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=CvHD033QF2rdwJjeJMcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_01,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270030

mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
the poll path advances the index under that lock. A ULP that arms the CQ
from process context while the completion tasklet polls races on the
index, as SMC-R does from smc_wr_tx_send():

    [  312.234586] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    [  312.234707] BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / ml=
x5_poll_one [mlx5_ib]

    [  312.234933] write to 0x00000000956c9dc8 of 4 bytes by interrupt on=
 cpu 1:
    [  312.234951]  mlx5_poll_one+0xa0/0xed0 [mlx5_ib]
    [  312.235066]  mlx5_ib_poll_cq+0xda/0x340 [mlx5_ib]
    [  312.235181]  smc_wr_tx_tasklet_fn+0x92/0x1d0 [smc]
    [  312.235259]  tasklet_action_common+0x150/0x450
    [  312.235277]  handle_softirqs+0x144/0x5a0
    [  312.235294]  irq_exit_rcu+0x1ba/0x1f0
    [  312.235309]  do_io_irq+0xd2/0x1b0
    [  312.235326]  io_int_handler+0xec/0x118
    [  312.235344]  arch_cpu_idle+0xf4/0x100
    [  312.235363]  arch_cpu_idle+0x48/0x100
    [  312.235382]  default_idle_call+0xea/0x2d0
    [  312.235398]  do_idle+0xfe/0x1e0
    [  312.235412]  cpu_startup_entry+0x40/0x50
    [  312.235428]  smp_start_secondary+0x218/0x250
    [  312.235447]  restart_int_handler+0x72/0x88

    [  312.235475] read to 0x00000000956c9dc8 of 4 bytes by task 6316 on =
cpu 2:
    [  312.235492]  mlx5_ib_arm_cq+0xe8/0x180 [mlx5_ib]
    [  312.235614]  smc_wr_tx_send+0x6a/0x140 [smc]
    [  312.235691]  smc_cdc_msg_send+0x2a4/0x360 [smc]
    [  312.235770]  smcr_tx_sndbuf_nonempty+0x1f4/0x520 [smc]
    [  312.235848]  smc_tx_sndbuf_nonempty+0x238/0x2e0 [smc]
    [  312.235926]  smc_tx_sendmsg+0x92a/0xa80 [smc]
    [  312.236003]  smc_sendmsg+0x160/0x310 [smc]
    [  312.236078]  __sock_sendmsg+0x96/0x110
    [  312.236098]  sock_write_iter+0x102/0x180
    [  312.236115]  vfs_write+0x3fe/0x740
    [  312.236131]  ksys_write+0x10e/0x150
    [  312.236147]  __s390x_sys_write+0x5e/0x70
    [  312.236163]  __do_syscall+0x1b4/0x580
    [  312.236181]  system_call+0x72/0x90

    [  312.236206] locks held by iperf3/6316: 2, on CPU#2:
    [  312.236221]  #0: 00000001018dbe58 (sk_lock-AF_SMC){+.+.}-{0:0}, at=
: smc_sendmsg+0x46/0x310 [smc]
    [  312.236321]  #1: 00000001018dc358 (&smc->conn.send_lock){+.-.}-{2:=
2}, at: smcr_tx_sndbuf_nonempty+0x17c/0x520 [smc]
    [  312.236423] irq event stamp: 45730
    [  312.236435] hardirqs last  enabled at (45729): [<000003a606250966>=
] _raw_spin_unlock_irqrestore+0x66/0x80
    [  312.236461] hardirqs last disabled at (45730): [<000003a604e5d228>=
] kcsan_setup_watchpoint+0x4f8/0x590
    [  312.236485] softirqs last  enabled at (45723): [<000003a605d3aaae>=
] lock_sock_nested+0x8e/0xb0
    [  312.236509] softirqs last disabled at (45725): [<000003a5857d155c>=
] smcr_tx_sndbuf_nonempty+0x17c/0x520 [smc]

    [  312.236601] value changed: 0x0000063d -> 0x0000063e

    [  312.236623] Reported by Kernel Concurrency Sanitizer on:
    [  312.236636] CPU: 2 UID: 0 PID: 6316 Comm: iperf3 Kdump: loaded Not=
 tainted 7.4.0-rc3-kcsan-00406-g65e4fd942f72 #1 PREEMPT
    [  312.236674] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Read the index under cq->lock, which every runtime writer already holds,
so the value handed to mlx5_cq_arm() is a synchronized snapshot. A stale
index can cause a spurious completion event, never a lost one.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v3:
- Add the full untrimmed KCSAN report to the commit message, as
  requested.

Changes in v2:
- Drop the Fixes: tag. The unlocked read predates ce0f75093282; the race
  is as old as the driver and this is a KCSAN annotation rather than a
  regression fix.
- Reword the justification to cover only what the change does: the value
  handed to mlx5_cq_arm() is a synchronized snapshot. The arm record and
  the doorbell can still be overwritten by concurrent arm callers, which
  is a separate pre-existing issue and not addressed here.

Note: mlx5_cq_arm() also reads cq->arm_sn, which eq.c increments
without cq->lock. That pair is pre-existing and separate from the race
fixed here; this patch does not change it, and I have not analyzed what
a stale sn does to the arm protocol.

 drivers/infiniband/hw/mlx5/cq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
index 55ffd7d4de51..8f4389b4eb6f 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -651,6 +651,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_not=
ify_flags flags)
 	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
 	void __iomem *uar_page =3D mdev->priv.bfreg.up->map;
 	unsigned long irq_flags;
+	u32 cons_index;
 	int ret =3D 0;
=20
 	spin_lock_irqsave(&cq->lock, irq_flags);
@@ -659,12 +660,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_n=
otify_flags flags)
=20
 	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
 		ret =3D 1;
+	/* The poll path advances cons_index under cq->lock; take the
+	 * snapshot here so the doorbell sees a consistent index.
+	 */
+	cons_index =3D cq->mcq.cons_index;
 	spin_unlock_irqrestore(&cq->lock, irq_flags);
=20
 	mlx5_cq_arm(&cq->mcq,
 		    (flags & IB_CQ_SOLICITED_MASK) =3D=3D IB_CQ_SOLICITED ?
 		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
-		    uar_page, to_mcq(ibcq)->mcq.cons_index);
+		    uar_page, cons_index);
=20
 	return ret;
 }
--
2.39.2

