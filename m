Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947603;
	b=RFeBQ+IT+/YjI6WMbda2dCi314/HOMuRfhlpxrqZmWPB863n5g9NI2RJdMcACY228LnZ
	 D9Kg1f81eRTthzIXe2wXHicbvXEgiwX3xR7btxErW3QZh5SlI0G7qFx7gZBJOP57cWD1C
	 aTfl0B3m/KCpdD02xG8sSJffgZftkVK08GSsXjEX5RcfUHKr54NvzFrrcV2GzUg68xzE4
	 Whrgb8hph3eYr3hL8F2Fdhc7pS6z/uaGpkfqkZXgHDtrkIVaOUdcx9Y7TO+bYzESui0t7
	 2RR0wm/AbfywFP2FqfOoef+cHraub8DeTKbtuJt7isx0PZfA5ZP3o3PrM5wTUcg5BCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947603;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=Glt4fRn151D30stLS+CFcAhAPmeUJdhpgqjiPf78iY8=;
	b=VMiKwOD4Znjyy5CVdcIdrilF5QttIASRd7ZxN/1TojfH37oBaPlC7qtUwtSJM3ZtIyl8
	 z9RttctFDf5AzvgTCBae/7JiJO0TEY2Y6LL57NftJxR8SI0wDymVt2h98XppBAZQBuZv/
	 ndcwDCfaPg2P2akE7h1iq1kzL8/I1qzZt/sNgQyBzk4HXFUltUqKZKCD6C2TFjKohH8TX
	 U0amH3ISqJDpNGRm8DHNtcCc2MsOty3MPAZYGlCQ3EOs78jOCyJdruKfbZbEqBfW2oKrU
	 Wnp2nAiiaoreoqvAcS5yQPgffrfHSVmhq8tHq8SFhOkmen6+jqj1XDZymrcYI947iUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KQe4f52t;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8EF606A32A;
	Tue, 17 Nov 2026 20:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F8EF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KQe4f52t
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJKHvi1701466;
	Tue, 17 Nov 2026 12:33:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Glt4fRn151D30stLS+CFcAhAPmeUJdhpgqjiP
	f78iY8=; b=KQe4f52tpPcCYit8JfauSvoCSIMscjGbeCQ+E0UccrihM9h2Y6nBl
	ZisGOO2dP37tm3VaMdE6DGThrS/xDXAH/SuXAFrK5xnjS8Wzb70OoHhGMOJTXcN8
	NKbVJGRHQlPmCdqr2sM7kKx6OENyLHlNCwJ+qmsUzb3giYe20s4VgjlXcT6Huh+O
	yHiYsfuvyjCWNpzKyPuSHB+HnZmYrHAqBO0Chl7TRpf8DAq89mBj3w1gY8Q3G58P
	+mtdEskC562RDDaffzqa5+zIwv/iLMvmrRlptSU9ecz3EaZR6irC+A2xDxvDfkAt
	PTLi8vs1ggviyiQh+DjWeFUvhHQor6wPg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0w0brvfq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:33:06 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:45 +0000
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
Subject: [PATCH net v6 3/8] net: don't fragment decrypted skbs
Date: Tue, 17 Nov 2026 12:31:32 -0800
Message-ID: <20261117203137.804424-4-toddfreed@meta.com>
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
X-Proofpoint-GUID: m5b4mS4mUgFck7tBQ_dsz7h3gGo3G68I
X-Proofpoint-ORIG-GUID: m5b4mS4mUgFck7tBQ_dsz7h3gGo3G68I
X-Authority-Analysis: v=2.4 cv=NM1AaE6g c=1 sm=1 tr=0 ts=6afcba03 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=4WmOrS_ozlDB0nbKRI0A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfXxO9qZ1TD+Emc
 W3OkIA38ubYC9YgfKf2qS6cFr8vsL+oJp5X67QgZZP/BbMD+Zo0n6RSzHYe9LLHG6Y5ZznCwj08
 S5MKrnKDU1wlLcaO4UwMsBNEe4j7NYQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX/tHTEz1R4T4D
 9EP7nVTtkH/7+c0XYQgL2FVtYYYrckEGy9GzUI8KcOhXQiSdYsqlcURdjh35rsZvrVyA9BHxXtg
 OQHNL+VkE8DOTZtBhpphTpSWBSCnMByGqNm0w1kgba5APPqVifSklsg3j1rQKI1yoerBbpBldhp
 ucxcNBYDjhJGj+AzCnKqnTbe5aWtG4y1FlJ2nAXjUSBZERPvZoe7IPtm/UHEGDXamv4jdsOOkSD
 E6R2dtjY5EKNEJXe69n2eSO7i3tDCLEbCyldPpWY4kVSd2225skdW0FOXPDIdam3XtecjfNkVoS
 jLUNgPNUPZi/ptxbEq7kuPrkAdlkJa4dI8v69mNu6QXWXu1CBd2TAXl0df8PtZGr5s2ZfVhWJwc
 hmi7We6MlsGj9wsmyWG8nvQmdB+5xfgDwhb3DOsyX3WMCXsRUrzOLEttmGv81q11pZgUlsWehwU
 KV6+VeheugztOznCaRQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

on transmit, skb->decrypted means the device must encrypt the skb.
if it can't do that, then the packet should be dropped, not transmitted
in the clear.

ip_do_fragment() and ip6_fragment() on a decrypted skb produce
fragments which have skb->decrypted unset, and can be sent out
unencrypted.

tx of individually encrypted fragments would not work anyway, because
encrypting needs the L4 header, which non-initial fragments do not have.

ktls could encrypt in sw before fragmenting. that would not work for psp
offload which does not have a software fallback path.

tcp sizes segments to the mtu, so psp and ktls socket packets normally
won't reach this path. an ipv4 tcp socket can be made to send fragments
by setting a route mtu above the device mtu and disabling pmtud on the
socket (IP_PMTUDISC_OMIT). the selftest later in the series does this.

emitting fragments from an ipv6 tcp socket requires more steps, but is
also possible. the test setup here uses ipvs, which sets ignore_df on
forwarded packets. in ip6_fragment(), check skb->decrypted after the
too-big checks, so that a local socket still gets PKT_TOOBIG for path
mtu discovery.

tested with tls tx offload on mlx5 (connectx-7), over ipv4. without
this patch some fragments after the first go out in cleartext, with it
they're dropped (IpFragFails) and the connection stalls.

tested over ipv6, with tls tx offload and psp on mlx5 (connectx-7),
through an ipvs dr service with a local client. without this patch,
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

