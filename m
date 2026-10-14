Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17DF33509B;
	Wed, 14 Oct 2026 12:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791980032; cv=none; b=TpEZJbQfk+jqoqWEdENxHS/sd+5J5XSEFIyFXR8HwH59ganjR0FCf4qBVyoURKw3cYD2YIp1yTAtcqUPO6oamcdBFFwADMsonn09xmm7RyYF8yDMSlsR7r0N9BUPyULWxZdeGe3L49rm17rnZHAH6bRq/MZzBxj6NRmMMiMA8CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791980032; c=relaxed/simple;
	bh=F2LkmKQR+sEZGJh0b3Gr8uucaWnWSNMgYMj5yL0UG1U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ihyEkEyYMR8iBpsIRTG7wsqpuMu8wqBgvTkLAmSZKi1ERRIyseeYlPPygVQAIIY9+LoX+OGlAeyKPULTA2s3nw5HHpRhYrFX5FGdt6tbkzS/AgVmu+t1DSJ+uU1Zl7eNzeOV3kcM/CahHo3QsZWYXQ0j92EKEmZgOlhV/ilbGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E50yzNZi; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E50yzNZi"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EBvEWW2587462;
	Wed, 14 Oct 2026 12:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=8jVDYUDFcHmhAW9uEM/F58CjIyPdL
	ENUSMAaBgiEOT4=; b=E50yzNZi4hvPu8Fsf8d9pHYgensZzUVN49vfrIKkXluHq
	znM11o8XlUH+QY7qc/zHUQmXJWrTGsdrHywdZz5hCAyQs1lVAeq1wpzrB+lTI+YJ
	lIERWTdCvbcDkNb0VPVo3ZOXMLHj1OIR1+Pk1Mp2a8G8rqqtHNDwlcc0AZez4hFC
	dtxV+knKxG5sfHxRdbGD83JNg9SpT6fa3gK8KfE0+nivTGoQ+sbZGSby4wLyn20N
	0E5Mbla1mu6QNLwr5NISyDO0iSVnnPccRWYo0J8zdMirdsXublvDpcCjz1h//QlD
	T/vFalqrEoCHSibIb4emTKPFleguNcfIBY/ZZybeg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddx3nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 12:13:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69EC6lxV032004;
	Wed, 14 Oct 2026 12:13:44 GMT
Received: from pkannoju-dev-build.osdevelopmeniad.oraclevcn.com (pkannoju-dev-build.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.252.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4h7btqh0wp-1;
	Wed, 14 Oct 2026 12:13:44 +0000 (GMT)
From: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
To: yishaih@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] IB/mlx4: Avoid requeueing executing CM timeout work
Date: Wed, 14 Oct 2026 12:13:44 +0000
Message-ID: <20261014121344.100048-1-praveen.kannoju@oracle.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140048
X-Proofpoint-GUID: Qhc7yg_FVjS6GWy993Ry-NWZdbb1tR0x
X-Proofpoint-ORIG-GUID: Qhc7yg_FVjS6GWy993Ry-NWZdbb1tR0x
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0OCBTYWx0ZWRfX5EUxZrypjD5Y
 +1iGYRxuRbGvFg6s3INeS96lpJ4raihSThZ4YvMeeqLfAFLW9nX8uNUta1NbeilNa2xJrbvECZA
 CoV8KeGsKNabvsQfwhLQFTLAhfzzzpLiTOCLEjhibzZhpK40AwJy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0OCBTYWx0ZWRfXwtlZE3dFr6Q9
 KmveDzCxbXIjYF1bLHpNLVjbodsSjJYMnYTPbY0TIvn9esFUFXwTrC9ewFse9cbSnSrGB80cXHm
 C6+jyqyZOlFothXxDlsGZcSA1ZFzyuWwm+ZKFSFNj/qrzf/vWFaQVJjk5OBXF15W1xsQ+HC/+uH
 8/mjc3hUsWvLGdAurz9aIQuMQeCFU6jqa70/HlRMcnafZCwVoZ6LuD+R3piTU5SUdZ7kbYpFbtw
 ENsKMZxfPokYPWOTH2Asa3kWx7M2d+HKdYSejR6ccIfJH4C9pEDLOQQa11nSnOZ6KAAigqV+lIJ
 2BCrGR9uVdtCCZdrQoIidMHjGoBiBIe6CAymookuERdC5ROm2D9ARJNP+AGQL5LOQBOqi59tbgn
 7YtdUVkm42tgntfjTbYvAfW8+hCN/m3Y9Rt1lINdfCQM6d5FPfYPknegv9OiSoUfCwJcIYtD/+A
 kvzbaiwkEwJWCw174+djXeWRO+l+Tcg4Cslb2ayQ=
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acf71f9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=ulSE4hB3ZisqW-PrT_MA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537

id->scheduled_delete is set by schedule_delayed() itself.  It is used
in two cases after the RTU timeout support was added:

* A new id_map_entry is created, and a 60-second RTU timeout is
  scheduled.
* DREQ or REJ is received for an existing entry, and the normal
  30-second teardown timeout is scheduled or adjusted.

The following race is possible when the RTU timeout expires while a
DREQ or REJ is handled:

 CPU 0: timeout work                         CPU 1: DREQ/REJ handler
 --------------------                        -----------------------
 RTU timer expires
 timeout callback starts
 waits for id_map_lock                       takes id_map_lock

                                             calls schedule_delayed()
                                             calls mod_delayed_work()

                                             drops id_map_lock

 takes id_map_lock
 removes mapping
 frees id_map_entry

                                             requeued timeout runs
                                             accesses freed id_map_entry

mod_delayed_work() may requeue the work after the timeout callback has
started.  The original timeout callback then frees the id_map_entry,
leaving the requeued work with a dangling delayed_work pointer.

When a timeout is already scheduled, first cancel its pending work.  A
successful cancellation means the callback has not started and the
timeout can safely be scheduled again.  If cancellation fails, the
callback is executing and will free the entry after id_map_lock is
released; do not requeue it.

cancel_delayed_work() is deliberately used instead of
cancel_delayed_work_sync(), because the timeout callback may be waiting
for id_map_lock, which is held by the caller.

Fixes: fa09adf4231f ("IB/mlx4: Fix stale CM id_map entries when RTU is never received")
Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
---
 drivers/infiniband/hw/mlx4/cm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index 1e5e525fea73..810f95e55fda 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -301,10 +301,20 @@ static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id,
 	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	/*make sure that there is no schedule inside the scheduled work.*/
 	if (!sriov->is_going_down || id->scheduled_delete) {
+		/*
+		 * Do not requeue timeout work that is already executing. The
+		 * timeout handler may be waiting for id_map_lock and will free
+		 * this entry after the caller releases it.
+		 */
+		if (id->scheduled_delete &&
+		    !cancel_delayed_work(&id->timeout))
+			goto out;
+
 		id->scheduled_delete = 1;
 		id->rtu_timeout = rtu_timeout;
 		mod_delayed_work(cm_wq, &id->timeout, timeout);
 	}
+out:
 	spin_unlock_irqrestore(&sriov->going_down_lock, flags);
 }
 
-- 
2.43.7

