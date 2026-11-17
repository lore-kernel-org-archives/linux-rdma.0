Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947607;
	b=hpoHCGShIERzUqsKI91kRHxm578tWU+N396jwgVQfggbVqEYyCwrSGdmfVEHofKQf+iA
	 NMVLuNOxJKEVifCMwCaGnENhqqmgBYf3n+3+yzwXRTdUI0jvRLvpRLytoZhMA0hooQEvp
	 PbzLtwf8jhhfaEJ80Xd2ToQBRRxcBqMsrZ5vvnPPH7QmY4Ungv4aB4agIJ08rpVtTt5GU
	 YXM+EsEVoB+ZggJi8ghyfbTEXeMiDaD/NCA8U4YN9RhKtZQ+C3Tfcha1f4+k1PBkUSQgT
	 heKqLKoTmUP/vSokr9WpDC033s/CHeS21hwo8cXkQiPYEwXNhFiDowR+NWitmxu4RPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947607;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=ltJA9djPiDGmbqOIDOCvgyBxMIZpbHwdIGl8VFOEXRs=;
	b=IIs7ip01Hrxl6WIaW5zalRWGQU3rw7eREJnf3YTKcrXtg/clEAeDTY6NrBhq9xUH6Rqh
	 jjxSLBKa61xu4AQg3FWnDX13u3jZPsZwGIx/wLHI2C3Ke66U0H9uQDMFSR6HOaYNOb/K4
	 k3ymjcn8+y/g7lWE3Ufeyz+ypYfQH4zLM8CaGiyoJ7lUcZB2z/HVLR4Rvr8yUYtDTkB90
	 RhHQCswPOjJoNGW3tv/5F4u4YVQ2uVx8Sf0V5NMgxtmEV2k2JQUoEL3IXupr5KxnftGpa
	 zr5H4gg7FCGJ7N0NXd+Qd1ned/hsmGAKonA8dygXjrZWm/6Xfcx2ys9GkiRiVIvRO5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DTrS7jFo;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA3C606A89B;
	Tue, 17 Nov 2026 20:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA3C606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DTrS7jFo
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJ9Tc31359758;
	Tue, 17 Nov 2026 12:33:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=ltJA9djPiDGmbqOIDOCvgyBxMIZpbHwdIGl8V
	FOEXRs=; b=DTrS7jFoHB0W8BxKVekX3F7HylpYWAbXKmLa9vCXM+KjntGPDvrBc
	xx2ShGal42bQ50OMct/EOQGVIoEeX+pXzHfhHsTjZVgmGhGqfTqFfXRdQU4NdfrD
	dSRhLYpx9YKVEgBfZbrI/nl955QKtUiMQzc0rzEOELhXQs75ObW++7UzygWzJj2d
	2jfgevLeDoPfCYmExZPYHKixSYUCROlELY58+Z1fi9zk72sL5jlKxk3ewTsNSzL9
	4uMG5wZTWL9yAMSNHlfJPO1C9EKpWZl5QkPmVE2S9CWHb/LPpX4oEuq3np2j9WEc
	ZSbXcOyct5huWHC3+howc3U1FeMs/pb6Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0rk6m7ce-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:33:09 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:43 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>
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
        Sabrina
 Dubroca <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH net v6 1/8] net/mlx5e: ring the tx doorbell when an accel offload drops a packet
Date: Tue, 17 Nov 2026 12:31:30 -0800
Message-ID: <20261117203137.804424-2-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261117203137.804424-1-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: Xx1OceeYUAaMX6TozBv1SHRo-1O9Odug
X-Authority-Analysis: v=2.4 cv=Q7xHcI2a c=1 sm=1 tr=0 ts=6afcba07 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=sFFrJGLWhHAlujGt_t4A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: Xx1OceeYUAaMX6TozBv1SHRo-1O9Odug
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MiBTYWx0ZWRfX/xM6JMi8FdeF
 9Okgz8+FPQjYBLZk/VE+qTJZwIvtYDL8Hs6haIyhXbVwUG8bAEL/4xgbrkU6VM1QHJO/RIPRFOt
 gm6ImVl5IBiNvOe6Vcj2tjTxrtOGsaEoCB5QeMJ2IOhMEZbQQdVqaaZs/0k6FN3ZQnwrZkbKPgN
 HT8FhCixMTrqn8oDnLWrOGC8tLt9hro1V+dKpbVa2nAA/npF1Y+YZoIKE4u3jK/+AWYdVF2cIr+
 ALyBM1vil4CjCZPOuyl6DsCKWu0sSvk+SMVpyOpsuk/Wm1Kip+ioKHlDlwp5CKkD2bUr3kwljgn
 qwgCy3DZnfp8jhYK3NiH5aOU31RkEVKr5EdyGhljDJqzWSdiVEjaJ/IdAVQRrPHSRAIkNcY1c/8
 x+ICaCLpydugixruY4UEq6FWRI6NQu0J78RaygP2oE/ANF30RkyRP0hPrvLxb0sPA7ZhiKqXtDw
 bmYW/qy8PBDCpscku+Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MiBTYWx0ZWRfX+RcSobzMjjHc
 rzsS+uIMkJX3BiY+GYlChVaWUQKpc3RclRFgpPYhxHd72vQ/MKIsmxT1x3zr6jHVroLIagXUmSg
 WdLGJpHZsKB/+nzbTfWADYzaErGGirw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

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
Cc: stable@vger.kernel.org
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
2.53.1-Meta

