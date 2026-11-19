Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051887;
	b=R5theIT2v2joMpPGw2YzVpdUTKF1M8f07dX1R//wKN1ZqG2q1p0zTIieRsH6dhRKZ+Xo
	 O2XyGnpUDgKUKox5QlTTuxmHbyQWlMOAsSsyyDd9UhtEnQOOkoCDsBAehEGlPtvp/9s5b
	 v5yJs1sq/Un2BGfMigN5SyYemxOsWXH+bXAz0xvNluXmO397avpvQIRLBVZ0IYE0dligc
	 3Br14/jeaLe+g7n6RIxKZsyBeY5a4C5eA85HV3epjQBWGgdX1fs1NIuHfi3VP0zsY4BzJ
	 54rPKN5okAEay5P6dCrvuKHcoxfUIzbb+D1wra584ac9pJsG597aElUfCHYhdVfMlKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051887;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=P2Uj5eJQ/pImJaX7y2hlXtH60Ket8Hk1wY9Gm9bo7Qs=;
	b=HfzpafCOf+tdYCidkruACG5PtXIx08eBwdHxJG/fQCpWihJ9jzfLKDsEB4TgiVd+HdVc
	 jaykLygxSWciiHgJXE1jlunkJr1qsYAGlTo/xk0FMKJS+hvhmHIZ8J2cxOCW3e8mpupiH
	 PbtHSbk5J8etkpxce4pcwn3BNgfI46M9fUtorRyYQNvtPqmKCz42/u0FyMe4pWqhFC9Qj
	 rbvhS4HVc05pGlKfmeNi4oegV8pA6XZTu4PlKdT3PlBFNrKsqrWVnvea16zZ5IHCB3PLo
	 aScwHpXsP4mMhRfYzuEE5V2XGsHHxb0ifHw8Af9D08a0rbr+8IejVuP5mdRd3ge5lTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=fh6l6A+J;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942E2606A330;
	Thu, 19 Nov 2026 01:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 942E2606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=fh6l6A+J
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ19S0D1375386;
	Wed, 18 Nov 2026 17:31:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=P2Uj5eJQ/pImJaX7y2hlXtH60Ket8Hk1wY9Gm
	9bo7Qs=; b=fh6l6A+J3D/DeSDReFswL6gr+hBhtlYaPvsxOHbjJVNROQBfHxrwQ
	TQN1xwimAAEbhZ6ZXQbf0e4kil79lTWPoZCeFxp+1WlwFapX4u1fOMk+TJA6P973
	PYCclInj77h4L+MLYtmdrfvfOUB65aXhDUnSIkaBeIlSqtL6rRWZ7Vkwwqi0XLdw
	i998tBkIAMhXHGBrlClBxHGOtHglwlj6BtTm2ZnwUnrOFQahzvmidak5HFArwNn4
	ZqukbJ6VfkkljX43bNTUprOLURJP/vluMQv1DFH56EoIpbXfD9A+somcwPpCUMID
	5JSMqcjCoX4fejCCLj5EKAlkkvCCxZ0Xg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu6b8r4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:16 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:14 +0000
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
        Donald Hunter
	<donald.hunter@gmail.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim
	<jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
        Tariq Toukan
	<tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 03/12] psp: declare psp_assoc_set_tx() in psp.h
Date: Wed, 18 Nov 2026 17:30:54 -0800
Message-ID: <20261119013103.1092559-4-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261119013103.1092559-1-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Proofpoint-GUID: yVV_1QUW5K0tGURDzbKPcBa7SpKrFcbk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX8LkTAZS8L5wt
 uU6lSqSyZB2RP+C0kSd7pDzvolBLAtp5tGZr6ee236lS3ROGpyrlfiwQ3fzAnOTWvLzVo9UcBqf
 ++YziysC5Z5TogmWScEPNoDafZBqS/ge3Obw3dwxKwO/kNVyQPHYQ78ffnVkgtwaobqSc7+cpSq
 9StQcbYVrmQ4JNDQ2r7ZyBnmX34MQsqYrbu/6DbyszJAHlHiM/pP7yUvU+C45J9TQM4dKkWmFCN
 aOVoLrFSfBJC3QvE8OLJDb5cmRTRSrkYCUW/CLXqa+jr1IP9oQwI1npaQSFTjroDO60iU75V1Z/
 5vcl8p4icp8yo81r6dDaHG9TRpVqIXXIsU3qoe/uGned78z1ObLFGiddr6MwcPkC9MVuqwnvaTW
 maieXxmCgNamE+Nt/M2WkzKtRVFf+xBiTc2ZCdxpIB7so+j6QHEDR1wAmTuR7dMTIRFc4zKru6z
 J/1bGz50qKvJRUT0z9Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX5S2WrSb6Dgso
 bOoFSZU2z3ffmnpAz4zilQCoNAwLlRhTUMsu5hnzZ1ExIdwRJAjvu1maYpm0kpfMc3CvrT+m1hf
 I0QJ3nja8psG6igAVYdWp89bkzxIxeY=
X-Proofpoint-ORIG-GUID: yVV_1QUW5K0tGURDzbKPcBa7SpKrFcbk
X-Authority-Analysis: v=2.4 cv=Mfz5KJ/f c=1 sm=1 tr=0 ts=6afe5164 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=FmbL48aYcJvIc3pBxYIA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

Socket-less PSP associations will need to install a Tx key the same way
sockets do.

Make psp_assoc_set_tx() non-static, and declare it in net/psp/psp.h.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp.h      |  3 +++
 net/psp/psp_sock.c | 15 ++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/psp/psp.h b/net/psp/psp.h
index b123c2427905..de4be3320009 100644
--- a/net/psp/psp.h
+++ b/net/psp/psp.h
@@ -24,6 +24,9 @@ void psp_nl_notify_disassoc(struct psp_dev *psd, struct net *net);
 struct psp_assoc *psp_assoc_create(struct psp_dev *psd);
 struct psp_dev *psp_dev_get_for_sock(struct sock *sk);
 void psp_dev_tx_key_del(struct psp_dev *psd, struct psp_assoc *pas);
+int psp_assoc_set_tx(struct psp_dev *psd, struct psp_assoc *pas,
+		     struct psp_key_parsed *key,
+		     struct netlink_ext_ack *extack);
 int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
 			  struct psp_key_parsed *key,
 			  struct netlink_ext_ack *extack);
diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
index f2cba3fa3a23..d04146273bf2 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -185,9 +185,18 @@ int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
 	return err;
 }
 
-static int psp_assoc_set_tx(struct psp_dev *psd, struct psp_assoc *pas,
-			    struct psp_key_parsed *key,
-			    struct netlink_ext_ack *extack)
+/**
+ * psp_assoc_set_tx() - install a Tx key for an association
+ * @psd:	PSP device, must be locked
+ * @pas:	association, must belong to @psd and not have a Tx key yet
+ * @key:	Tx SPI and key
+ * @extack:	netlink extended ack
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int psp_assoc_set_tx(struct psp_dev *psd, struct psp_assoc *pas,
+		     struct psp_key_parsed *key,
+		     struct netlink_ext_ack *extack)
 {
 	int err;
 
-- 
2.53.1-Meta

