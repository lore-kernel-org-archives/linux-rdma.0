Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482417;
	b=ntKl4emCoNwHRwtRafY/3PkNntoLT3tqwHx3N2N9izeIP3KbT1cljhP9qAOR0U29vP+Q
	 rgKa0riGTlJhWba9qMqNGJdZRstF4VMC61zRqDuE0L284oP7smcXY3ox0krHPk9fS58K5
	 l3OipdLhF9ZU/qVrA1P3SlZukVZdovNhSD2uiCzSSeYb0u8/rDL+w6/BrCB3YGcz45OUH
	 hWDa80DuRJzrHM8yfSFdpjEVI0nER1gYZ5j6tJyI0WWTo0yhOuSWrkCVkDJh6f3JbBDYi
	 rAkfoe+4gMum7AVdzL8Lat14m2uGQMZfg+keHj76iYmVYecRfPSAzSINVV2ajWGX6YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482417;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=RmQwcKP1PVIE3fAapO++oNh6QzOF+zscp27peLzhV/s=;
	b=2lPndZwkTowcyqXzKLMEsRZUmU26BiCOIsrlFKtXLy6lLtYbSxRFHmhW0/KsXBlWr6HI
	 IAQfxcCU6Nij/9LCCo0+YY8wVSAd9A1oyfQixQvOCZnWCLVEBHseqFWGfm/WmrMHqrMlK
	 lkVR5zjQCEdd+4guvETesL9UbwMU3bQSc98ohCMKSAudlVIcEnGuOtUul88pOxuNbMVR2
	 wiKCrkdvEplFMIxjub0C2B7gjJlc/+sRf1cttDlWNLu6wzmolD2+kCHCR4hkUOSdp09L/
	 7UHocLvXMxk7x2Z2TGSMz5rYTcx9VNVjLKgWgYQ6GmLDNqESJT2Egy4N7nSKx32p50A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="MS/b+CX+";
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1A9606A336;
	Tue, 24 Nov 2026 01:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD1A9606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MS/b+CX+
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwFb8250094;
	Mon, 23 Nov 2026 17:06:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=RmQwcKP1PVIE3fAapO++oNh6QzOF+zscp27pe
	LzhV/s=; b=MS/b+CX+zgWXE5YXsiNhByQzQbFgOz+jkXgQXy2PqSOe7GUCZYftD
	U6cYv3D0jasN3Cez39c8jvbeEobbHpC/oxeGxwHMDyBdCnQ4PJThCUrsEcv04j3T
	Yj5k9bM87Js0ZlDyvoAqY6cFQ2asuR4TOmsDh8HPZf9I8WR+wYXHzeJdWxNR2LAC
	eIYg7xYgGAeLRNhWpqaXXSdUU8CT9tsLIZQ9w3Sk3Ao2wgJb1B7YrRTAthQOgtoJ
	APFBBtKcsHQD95CoDKajzuH4fYe4tqg9LxEpQ7qDPB21MRLL7OFuw04B2ObiBEtk
	Qhz4p/TrPik2hDAmIa1GO1SXMomyfUAeA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j39v3dtk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:31 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:30 +0000
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
Subject: [PATCH net v7 3/9] net: don't fragment decrypted skbs
Date: Mon, 23 Nov 2026 17:05:55 -0800
Message-ID: <20261124010601.3995693-4-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfXz2kd1tdw4dpG
 UuLGz84mlRLE64+38m4I2U5xHenkxFViGXwz3M49wA2x3eR9FvnmjUl7I4rHn5oJGj1wjMaw4IA
 5ap+erzbhAHvVwrJOwK1zZV7A2Dy9S8=
X-Proofpoint-ORIG-GUID: SKCvPBIvR_aiz7cjOPPfqnjZ3i_5eZ10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX4hv/bsAsDfyZ
 oJsRjRupXlt1WhbXoAc1xWQgit8N/00BYiuDwzYz/M5GrDDiQ5IY3G3swGaLakYaCTWa2TOuLWK
 o9M/GXIF9YTXlhM4vAXg7e22VA9gOjSU5XToFhXhz/Jqxn2VlZA8v2I59oWiYGJeZIBXu2oY75n
 nmFK1+iWG8SQoxrcO57xgPQ0r+LZVp3/OInZoX3vJugd2GWDMJx/XYZyAe7Mj6W6dUAhcdIPPv6
 rqPvf3Ydk8V3TZucBsKhaTlTi5j+omXzyB0WTCfGuG1EX2mlznedlXQbrTQSnu+fqmM/smrmIcr
 JQzwOjNaNXWTpdtLtwMjODzyCjH48GxI5XXYlpe7W9FcDSPYczntqc3dyEUdxbDanruWj1Xf7Db
 PVGZlr3ehDfZ5yE/Q6uJfXrnTPbrOopE+zR4ZS6BFgurFbX3Yocfqt4k1momtZOusVQSB67ke6k
 +SnjQJmBT8DJKg91ilA==
X-Proofpoint-GUID: SKCvPBIvR_aiz7cjOPPfqnjZ3i_5eZ10
X-Authority-Analysis: v=2.4 cv=a+mlZkSF c=1 sm=1 tr=0 ts=6b04e317 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=PAz_-FQ8hEVmOPYdF0yf:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=4WmOrS_ozlDB0nbKRI0A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

On transmit, skb->decrypted means the device must encrypt the skb.
If it can't do that, then the packet should be dropped, not transmitted
in the clear.

ip_do_fragment() and ip6_fragment() on a decrypted skb produce
fragments which have skb->decrypted unset, and can be sent out
unencrypted.

Tx of individually encrypted fragments would not work anyway, because
encrypting needs the L4 header, which non-initial fragments do not have.

kTLS could encrypt in software before fragmenting. That would not work
for PSP offload, which does not have a software fallback path.

TCP sizes segments to the MTU, so PSP and kTLS socket packets normally
won't reach this path. An IPv4 TCP socket can be made to send fragments
by setting a route MTU above the device MTU and disabling PMTUD on the
socket (IP_PMTUDISC_OMIT). The selftest later in the series does this.

Emitting fragments from an IPv6 TCP socket requires more steps, but is
also possible. The test setup here uses IPVS, which sets ignore_df on
forwarded packets. In ip6_fragment(), check skb->decrypted after the
ignore_df and frag_max_size too-big checks, so that a local socket still
gets PKT_TOOBIG for path MTU discovery.

Tested with TLS Tx offload on mlx5 (ConnectX-7), over IPv4. Without
this patch some fragments after the first go out in cleartext; with it
they're dropped (IpFragFails) and the connection stalls.

Tested over IPv6, with TLS Tx offload and PSP on mlx5 (ConnectX-7),
through an IPVS DR service with a local client. Without this patch,
fragments after the first go out in cleartext, and the peer reassembles
them; with it they're dropped (Ip6FragFails).

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Fixes: 659a2899a57d ("tcp: add datapath logic for PSP with inline key exchange")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv4/ip_output.c  | 8 ++++++++
 net/ipv6/ip6_output.c | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d42d776af273..94a40e7ed534 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -770,6 +770,14 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	struct ip_frag_state state;
 	int err = 0;
 
+	/* PSP and TLS offload need the packet's L4 header, which non-initial
+	 * fragments do not have.
+	 */
+	if (unlikely(skb_is_decrypted(skb))) {
+		err = -EMSGSIZE;
+		goto fail;
+	}
+
 	/* for offloaded checksums cleanup checksum before fragmentation */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		err = ip_check_csum_start(skb);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index cb648c839431..5b19683f08e0 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -929,6 +929,15 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			mtu = IPV6_MIN_MTU;
 	}
 
+	/* PSP and TLS offload need the packet's L4 header, which non-initial
+	 * fragments do not have. Checked after the too-big checks above,
+	 * so that PMTUD for a local socket works.
+	 */
+	if (unlikely(skb_is_decrypted(skb))) {
+		err = -EMSGSIZE;
+		goto fail;
+	}
+
 	if (np) {
 		u32 frag_size = READ_ONCE(np->frag_size);
 
-- 
2.53.1-Meta

