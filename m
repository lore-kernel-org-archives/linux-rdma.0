Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482412;
	b=TXvTl1wN46bFcAxQ3p2o+munmv6qLJ6KIUhvonemXgH9vDtz8yOS1DryZne/ZwcuOKU3
	 Oe6vfH/m9NmHo1/OkR2sr1mmBlKIS/8fHupVrYN8lvL3BI5GzcIxnr76QLOwuRZfCDote
	 MVHKT2BULC/Xcnw2b5QWZEBcP6Bj7MHkehuDgXSgfyL0w0nBtJFuoiDyNJl0UCJaOxTpo
	 1k2gs9MMXK1zxVgzdyNr3p4/Ybq9ZF+XfXN1Ggr7mxQ4Ovh+ilvu1gHc4vWSDkPKHymmw
	 sVWAXKs3MB8feNtsWpV4Bmyr9fdz+6J/jN1yyQK3d/RF63YaKbnN4aQmM9I9TxNjn6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482412;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=UcyGvThNggizuHqQMay+CIEWy4dATEZ/NyCR35GDedk=;
	b=TVsj7dntuH17m4kdq5UaRwlR+nQiU5LI2G+oSGvJ4tvsM00vMzrQnnh/tZ5LUFL8INHx
	 9ugu0sTqM2rZe7khaqJCRAR8fjytem1XlqTQ/EJoA5vIPYsX7l2MD0gQCcTfRDqGjD43Q
	 qk9OBNk/kEQT/bTf4ojXAQw8ISGXADPV+ob72ru6CaB7pie+4Fx/TVuQqwKCAU9mg5Pey
	 RZqJO7zrcKrpo26GmnGavmm8ii/FjwDo3QdrFsFsB4ranSgqOvFT0zX9k+Aq6G9cWHZNn
	 qkhYdKITpR3gEITv9kZB+7s0Ey80inCJ+Ocvpf+DCKgJmsv/iAhE9+wxdpKwR0NGLnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=SibXjPhz;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE65D606A331;
	Tue, 24 Nov 2026 01:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE65D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=SibXjPhz
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwZsI251234;
	Mon, 23 Nov 2026 17:06:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=UcyGvThNggizuHqQMay+CIEWy4dATEZ/NyCR3
	5GDedk=; b=SibXjPhzpOpJ/VxwiPbuwllkvXSwm+Gsp+fZkdhqp3IFiuCWNlGB4
	sF3d8IYBN+cgdoa1jjEI4nAuK3wYPC0boKR7m5Wox8L4rj6EmbTZzKtcxl1qjYT9
	W42yLzALWQ76akiiN6s1LUru9uYi3y8hhk9MCxn7wgUBkVnRV2cqUgsbNwpA31pv
	TvzGRAqoMVgzbkVVpYlYTK1vV1pMZSGT9kc25VMW52rVP7ZjocIplA9iCVKku3Gh
	kBjns5StKEBETYSsNsyqKzVLbs0JkDbZBKSLPlH22lLWS72T5PGLF264YjmF+q/c
	tuaXXLtxfGkT9BPvoMrukE8aFTQOmFjOw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j39v3dtk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:30 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:28 +0000
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
Subject: [PATCH net v7 1/9] net/mlx5e: ring the tx doorbell when an accel offload drops a packet
Date: Mon, 23 Nov 2026 17:05:53 -0800
Message-ID: <20261124010601.3995693-2-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124010601.3995693-1-toddfreed@meta.com>
References: <20261124010601.3995693-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX+IrbwyEWE6Sg
 wfGa/HRVaVDsNVjtNUh/VAKAcJ1BrsRnVH1+OidE1hWuqYb7lxRL9O2gJdCEjoKrhuF81ZpPdex
 7WmL9ABNLYmqi1XhRVOShrCGs0fB81o=
X-Proofpoint-ORIG-GUID: gpeTMnAq0tFa6teIIZo5g-L9Uo9wfgHs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfXz4utddXdIyUB
 pSoystuXnryNihBPv1va+VTbfwf7V6imw/QOqR/Wx6PifMo4uj/ceHzuJ4THCpy8nlI+GCQFOss
 x2WSRMHTRugh8atoA4Yk6MgalwXuzgQmlKgI8pJXFZiASLizMKMXg9o5MzE+cKbfgJjm5+DknDZ
 i2xxxwOXraI1N/6HdrmmPh9Rt8kVeZ9t8AZFMwpmH8IxMgH4N9YkRRVqixMoheGsbZxVvbQYsvf
 +Z1niv2+1DZfzzZjqPniqCL4rmZ0rZvfGZIGVpNukvd807WaboyO3jQ6EwhOxP7no4Ojaiy3tk9
 8Y46Ll8Ch01SMTxd8CjjP27WrCO2gbq57ZefAx8iQrzoAXymsLyX4X5tU3uY0ZZyrHUr+cbRH8F
 ev4nV2ASlHRseGvC+wePg4W3lpED+CRicI3udF/SsNxoGHO5MOaSPF2AhYVYYjeqeZXQGSIutrV
 8ohNpsfU2NRIbx+Sczg==
X-Proofpoint-GUID: gpeTMnAq0tFa6teIIZo5g-L9Uo9wfgHs
X-Authority-Analysis: v=2.4 cv=a+mlZkSF c=1 sm=1 tr=0 ts=6b04e316 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=PAz_-FQ8hEVmOPYdF0yf:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=1_dJyMls8txaqAh-cwMA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

When mlx5e_accel_tx_begin() drops the skb, e.g. because PSP can't
encapsulate it, mlx5e_xmit() returns without posting anything. The skbs
before it in a bulk dequeue may have been posted with xmit_more, which
defers the doorbell to the next one, and an MPWQE session may be open.
The device then doesn't see them until the next transmit on that SQ, and
since the queue isn't stopped, the TX watchdog doesn't fire.

Flush the SQ on this drop like the DMA error paths do: close the MPWQE
session, post a NOP and ring the doorbell.

mlx5e_tx_flush() doesn't check whether the NOP leaves less than
stop_room in the SQ. For the DMA error paths that is rare, but a run of
offload drops would post NOPs without stopping the queue, and could
overrun WQEs in flight. So check it in mlx5e_tx_flush(), like the other
producers do. The completion of the NOP wakes the queue again.

The next patch makes the PSP drop reachable from user space, with an
IPv6 extension header set on a PSP socket.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
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

