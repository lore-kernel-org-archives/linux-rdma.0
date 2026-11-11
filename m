Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356341;
	b=nq5YxxDJqfEnqbVts29teY3IayA4d/DATJyOG/4E6K33qQc5YxFXCNYKnwF529YEGYPk
	 U3Mtoy05F6YwJrbLYmtNFa/TdXiTrqwmu4ZlkQXXFyppk4YZsDuLsMDtv/SNLHAhqfDWS
	 hPjTLAhSn+nWZeZtdI11b9M9Wf+kwlwoeq6Tr7Yc+5k9DslUV3szq9e/33W6UmxG2rAfX
	 98Ri21y6QcihYKzOy6w73NuCU+mKUZDRdqHxQHLJm+tLVm2jWHmCgRxOqfp7VlCRVW8qj
	 5kMHfx06FtT8shtIyT2guovk+l6q1fPUe5m+RjT24zkkZWtgBk76UHc8Zz9s0ZMG/tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356341;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=WHb0hzx8cWmOhywRwGKf7VzpziQy/svHfSiouIwp1PE=;
	b=PS4V66q+AIz75OS1Gg3cYb/YwtylnMKGPM7zA5F4NjOTgjXU29+eHp6v9YfVFX2PgKYl
	 il3i+y4XtD4VFuYKumric6+rkeg0b6TiSojfzOzb6ksKT459aBIKByZtmhE1tDAW9kTV5
	 dGWfvHdvLVSKpbOIOSXH0VUAteESzAxD8F2frgmuJ2IjVjzsPivK6ctaCOsLm92g3YNyI
	 F9cRgtJxrk9uI0E/99rm7JbdhZdz0KyJ4nrUOGBPleAW2hxUxspwxJiictx0pDg7iosPC
	 2d2u1C+midITiVejLSDjmofp4VPO3zFxAgs8BHgpwHrTqvSpnu9CcN/GFa4m6NNMgUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=eBoAQT9H;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B7606A320;
	Wed, 11 Nov 2026 00:19:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC1B7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=eBoAQT9H
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMKcx2602412;
	Tue, 10 Nov 2026 16:18:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=WHb0hzx8cWmOhywRwGKf7VzpziQy/svHfSiou
	Iwp1PE=; b=eBoAQT9H7ENV+8X8V2RhmHKVU5s3yVwrytuEEH+H3aAy3B4GQALll
	dQaXOGI0rwQOSO8AjYMY6vlHtSLkGHBZPjSP5BORChx35CqVuYWtCQGzSyvy7zV5
	iD4KdXKrib4rMR/d8zQ/Vj+UlDuuYEeNQqLQeZeX7uHKbJ6F8Qfgxq5PXULllzM/
	5tpHpZn6/M9DAkKZekoqOOXGzmuubFl5v93WudycFkZfWDZwCeJa/iV9lGNrsAvg
	R8trwJk/fmHqVkn+idgBFYrtuzcNBd3JbBCNWO+GIGDcgQUu/bptFHpHifBxf71l
	qp8UaDbqhlqFBLwb53blqOJ5fHeBmSjtg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv75dujyr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:18:46 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:45 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        David Ahern
	<dsahern@kernel.org>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski
	<kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Mark Bloch
	<mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem
	<raeds@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Sabrina
 Dubroca" <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v5 1/8] net/mlx5e: ring the tx doorbell when an accel offload drops a packet
Date: Tue, 10 Nov 2026 16:18:24 -0800
Message-ID: <20261111001831.3710881-2-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111001831.3710881-1-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=RthQvymK c=1 sm=1 tr=0 ts=6af3b466 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=PAz_-FQ8hEVmOPYdF0yf:22 a=VabnemYjAAAA:8 a=sFFrJGLWhHAlujGt_t4A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX35fMa1cjzIQ7
 5jN5UOqhh0C7msjuaBcDWgfceZa5eYwNuxx/k8no81slBrUvhdvbBBfOncfEgsETh4a1eDJmDBg
 NdkpKNg3RyXtilSZ2qDHMmLDg4Oy49QKzenmPdH4N9gPXMKxp8+uJ66f+qO7jdJ5S0DGyeJMQ1T
 1jKmPVXidskrt0i45x3RKPvf/9qkMvpTJPcTnRGckUWseZRjKKgvuNuugi4+YVvy7AgY9UocFPq
 6HeLqsU0jntMf09f8bviuLxQJ2OqFN6oFKW2nUoQ351iTaLdA3uluiUEfOjzhDbtET3NCn5qoi2
 /iKnMMNORQfpWi6TiRLj7PEsD7+UbPen/MHYbhuN5c94EqeJF2aUnPw1Hc2s78zag0R9Ke3MXcX
 Zodm48ZU+OhY8O9qy/tR5+EFTLypWzLrRcTER6XGJboCpCV+KLhZXt/mJvsBL3QGMMslJEWJgpF
 vf80Xrgxv0PLUOSkrQw==
X-Proofpoint-ORIG-GUID: fwykXEwVlh9QnUgv-3okvJahMHR1yhZi
X-Proofpoint-GUID: fwykXEwVlh9QnUgv-3okvJahMHR1yhZi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX/8DHZHgp3fCw
 yqJ96vKp65UN94KlkRhVsi+H/WJIuyAlAqz/B/64llkuVU/KxLar12Jta6XTuhgJ+2PyF/t/KCf
 139SDMSWlEUSxHb+dcm0LQ9oPhI0O4k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

when mlx5e_accel_tx_begin() drops the skb, e.g. because psp can't
encapsulate it, mlx5e_xmit() returns without posting anything. the skbs
before it in a bulk dequeue may have been posted with xmit_more, which
defers the doorbell to the next one, and an mpwqe session may be open.
the device then doesn't see them until the next transmit on that sq, and
since the queue isn't stopped, the tx watchdog doesn't fire.

flush the sq on this drop like the dma error paths do: close the mpwqe
session, post a nop and ring the doorbell.

mlx5e_tx_flush() doesn't check whether the nop leaves less than
stop_room in the sq. for the dma error paths that is rare, but a run of
offload drops would post nops without stopping the queue, and could
overrun wqes in flight. so check it in mlx5e_tx_flush(), like the other
producers do. the completion of the nop wakes the queue again.

the next patch makes the psp drop reachable from user space, with an
ipv6 extension header set on a psp socket.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 14479da98f42..006bf976def1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -365,6 +365,7 @@ static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
 	};
 
 	wqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
+	mlx5e_tx_check_stop(sq);
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
 }
 
@@ -672,8 +673,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	/* May send SKBs and WQEs. */
-	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
+	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel))) {
+		/* The skb was dropped: ring the doorbell which the previous
+		 * ones may have deferred to it
+		 */
+		mlx5e_tx_flush(sq);
 		return NETDEV_TX_OK;
+	}
 
 	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
 
-- 
2.53.0-Meta

