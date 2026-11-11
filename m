Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358601;
	b=qMQ0/8rkSrDf2K80aKrcSifD/4iYXvj8dB9WN6NX9LppKh2LyuIC5XHQbS8jEVaHL67d
	 5nSEM7JdyT2N7o8Wlb8iOCCMunK7N6cCT6SL53I4FrCjShVwmPIxaeXWA3jXK9rNsO4uD
	 12RC0eVN/OzsoSuC+PxhAMvz4BiM0dLX3uZ2G2BZ6ivp3J2F5IH4sqLcVS3zeyDkqgzNE
	 dnVflsGeu/NdojdRurhbxw9AHzqd/KzPXTFpbxevMqFfF7C8QADwW6Xpm8FXIKM41AfI1
	 geHo1aZ+7APrUPDGChzUp8Ln+y8UHkrO4SW1WfNtLbN9286DIO3bO5aJEWZMradHj+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358601;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=Dn6PUO1mkbadPd89Q9rOvWT8S6yCejt9adgWVeLGBZI=;
	b=B9uxEbaFaIpyb+koQci93AfnhJQFrUnviwT4pe0NEMxbdpHoISMEkHzlQdFGfEAnWLO1
	 jxZrbSUXEe6z4lzHjl1bArCYwpBrq2b33eSyAeeMwQfsm2FDzXGmONcMJ7YVV0TEByfJH
	 yT1YSBYBaH5SFhif9aPSMUim/GB/u5pqQEfgzNydazrTHQSqBHFH6x6dN1meKdyjeMo32
	 oQdjl+kUv6S8ggGfOsb/rr94+yvRZ8i3Cef6q5A+xKEJ8HB+ayZP9uakB1VFdvOEocrd6
	 hgakY+YCiCLFeB3/719GAw1KngZtD3hwHjX44h57qZEV6QyRiAgbrINuLNwOqhBF24Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=lreroVIm;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5FB60A261E;
	Wed, 11 Nov 2026 00:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C5FB60A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=lreroVIm
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WNhO3063874;
	Tue, 10 Nov 2026 16:56:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Dn6PUO1mkbadPd89Q9rOvWT8S6yCejt9adgWV
	eLGBZI=; b=lreroVIm6uYumjsiPTrRS5mKqD+6ehiJNCiL16jz7gQU9Wmh7BRso
	bIEA9ES96ZWOl/YO4JtXPRiz5zkOw1uN6apy/o5PfL03p6PckKtOkZtmguall3v/
	VIur2qxTXiaPBnheD/ezcE7W7EmFmmdXcyzk/TCcJqwsNfVOqmN8ErfPxESA4E4/
	rDhfbo4jKEOXtwS0SJN7bdvt7GII8GQVP4MAPRgeBGvyGOYkOO+d8/n3av/nVdOh
	PWlUuddEFzs/TwAmA60kj/asEtduTD8AJn+cZTJvPI6GNN9PqOL1zwaXOa3D1GM4
	tH5Wte29DWN4DMg8lBCO9Daowv8yy064g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4huqrpspky-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:10 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:05 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        <bpf@vger.kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko
	<jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "Martin
 KaFai Lau" <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed
 Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v1 06/15] net/sched: act_mirred: don't send decrypted skbs from egress to ingress
Date: Tue, 10 Nov 2026 16:55:24 -0800
Message-ID: <20261111005533.6436-7-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111005533.6436-1-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=PapqFShd c=1 sm=1 tr=0 ts=6af3bd2a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=wJHnLBeIYmV4is3nxMEA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: k3B3dcJcLez7L8aioB-cMJV3onvBpiPU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXwM6F+U5W/WCg
 ElIDhOmWrk4lFZvRvvHM5nX4AiGAVebar8M/b4DgCfxX7kPkq4XShzSaT7le3UihMdvfGi6JXY8
 0J5JxlXQL6kKlR577zrGCllkVoku2Ag=
X-Proofpoint-ORIG-GUID: k3B3dcJcLez7L8aioB-cMJV3onvBpiPU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXxQ8bo9Qz2g/V
 aHqk+m42DgciCviI0JLHWNG/wbYYJ4Gzlyc7vHuWW63RMTL+Edss0N9ej5FzhRM+zho+oNT+VbF
 8tasWyEo9mauEH/XcSAAd7bISYYI/4KfF1htS09KNPNJ5ei4AR3VfnKaNZ242V8HNf8htkH+Ohn
 fAY7JT2nVtHcL98BPUj3ctdRz5w6A0iNDyabikx+ZSkmLSzONZJGvok91l8BWpguAyiAFc7bdY6
 K5W4ei2vIrS0dzyJ8QSa1ZdJTK55Hj4LpVJqyp/Dk6z+O9ryR0LAWKmEeEpuMyONhPaTIhBDR3j
 2HhdbFi6lx/kxgPk7TXcomCcsTQldSxvjRTaXyDn0sOzd+6pbSXTQz8vxs7G0k4T4VQrxqTJa4P
 tez5Ey4WaP4ar7zdZP61SKkAgTZD2upWtBdimfW2NC9Q3uE86vlsCO82MEYc5CXbIlRfKwAh5p3
 HWJ0ra/ELd1+GfNg7hA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

on transmit, skb->decrypted means the device must encrypt the packet.
For example, a packet of a ktls or psp offload socket, or, with the tc
psp action added later in this series, one which psp encap attached a
tx association to.

on receive, skb->decrypted means the device decrypted the packet.

a packet redirected or mirrored from egress to ingress is by definition
not going to the device that would encrypt it, and on ingress
skb->decrypted now (incorrectly, for this packet) indicates it was
decrypted by the device.

this is less of a problem with socket offloads, whose packets are by
definition originated locally; more of a problem with socket-less psp,
which can also apply to forwarded traffic.

mirred also drops the dst, which for socket-less psp carries the tx
association. clearing the bit instead would let the packet be forwarded
in clear text, so that wouldn't work.

don't send decrypted skbs from egress to ingress: a redirected one is
dropped, a mirrored one isn't copied.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/sched/act_mirred.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 1c98e4d81ebe..52c3eeab381a 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -285,6 +285,12 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
 		goto err_cant_do;
 	}
 
+	/* On transmit, decrypted asks the device to encrypt the packet. Sent
+	 * to ingress, the packet would read as decrypted by the device.
+	 */
+	if (unlikely(want_ingress && !at_ingress && skb_is_decrypted(skb)))
+		goto err_cant_do;
+
 	/* we could easily avoid the clone only if called by ingress and clsact;
 	 * since we can't easily detect the clsact caller, skip clone only for
 	 * ingress - that covers the TC S/W datapath.
-- 
2.53.0-Meta

