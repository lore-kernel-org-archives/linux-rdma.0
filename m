Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073055;
	b=hp81aAMCGDs97snZpcy6b01UX1PsFRl7wnR5WqnOay6qzkP54K0iqcClULEBR/TJokOj
	 Zt2ty22C3kJiog4mLfw0464v6NV0mPq4GBE1BDtk1pOtiyS1DbUaDtGa9wZqBj6/AT8lb
	 YSckspek8u0Q5AO0occsPPZsaxaQboXJAidPcG38J5q8iHWS7cXkBfceaZdgovrQ+qjze
	 ptZRoZEyh411yqaJ9olpI3CO/jAq8U5VXj+cllMtGpRuhrzwIFQejngc55YWADo9CSdX+
	 TqLiEDI4//dN1Wy0riuEf3PjKM9qA9l8LK2ypGzeWaDMTe2Ud8pfK1Vrd0b06qzxfPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073055;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=PpA7Huyl4HsN6y6lBWysCvDrGPcB8h4nS9rilJdNIn8=;
	b=wkAXAhqngY6pMu7PDZU2QaIzEYe7Gx2G5UvNNNLs/QcUYB35/3SUfEYqJVhnyi1mokWH
	 MauSGvj7mrz4qy2Z2575ZQ/6lVw0vIBDS2f8YtMSMuzbBL48FFVzBfn3fGJryCdJCnvkq
	 paNvYQ5is141xMiCf/+8IRvHVbYH+bBjgvtu/x4E0WHdPdYFVQTQIu1MrwogBN+MV00i5
	 2ASPV0qpsc4KcuLIgizTO80Bn996I2m3Fw2eBcblCTBRAfg+z5VL5iz7d55PXlDA2TENt
	 ydV8FMUmFC4xX/I3GM9PNU6VDPiZP1iMNb5avt2uB+ifJzmfqdkjE4PNlvZQm0cuJMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=K46uLKNl;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7531960A260C;
	Thu, 19 Nov 2026 07:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7531960A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=K46uLKNl
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ6uVlO1805523;
	Thu, 19 Nov 2026 07:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PpA7Hu
	yl4HsN6y6lBWysCvDrGPcB8h4nS9rilJdNIn8=; b=K46uLKNlSBGrqZcTNdrHjH
	ZSsTM9MmKU/1EuSA09S8auoe7ewdgrakfhKF92BOIxBvzf9Asekp5CdgCMNQ+mLa
	QrPXi82CT6Y/OyH8Nmr+r9xRI3GRXupvcLsBrBtbtf3+QKGploW8MIoY6wqrpNIA
	oTai/Rlgcti7PA3I+ye+Q+Eyu7FaYRtQRg5Vq5gmMEsQ7+O3Y3ignraeaipQv/Fa
	BpDTDZ3VACxcJh001yWYoKIlrTkvMczLdnDjsnSDnKqNj3xIjhHHSJlrh9jcG4qs
	+5IdMNSOda+HTswmQArlYDURAjoX8ON5U+89FQP1aR9gfvhn5sfKHq/lXi5AfdtA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105rq8m9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 07:23:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ75C433327282;
	Thu, 19 Nov 2026 07:23:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j1bb5c7au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 07:23:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AJ7NtXk42074492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Nov 2026 07:23:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 611332004D;
	Thu, 19 Nov 2026 07:23:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 556C720040;
	Thu, 19 Nov 2026 07:23:51 +0000 (GMT)
Received: from [9.123.13.84] (unknown [9.123.13.84])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Nov 2026 07:23:51 +0000 (GMT)
Message-ID: <e9389120-778a-46f2-93e3-aad966bd148c@linux.ibm.com>
Date: Thu, 19 Nov 2026 12:53:50 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 5/5] net/smc: annotate data-races around smc
 sysctls
To: Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org
Cc: Dust Li <dust.li@linux.alibaba.com>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Matthieu Baerts <matttbe@kernel.org>,
        Mat Martineau <martineau@kernel.org>,
        Geliang Tang <geliang@kernel.org>,
        Allison Henderson <achender@kernel.org>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Tony Lu
 <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, mptcp@lists.linux.dev,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-s390@vger.kernel.org
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
 <20261118045137.174026-6-jiayuan.chen@linux.dev>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20261118045137.174026-6-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: d_pMhtpwwfHRBcOOG4J3TNdurOevL0_9
X-Authority-Analysis: v=2.4 cv=e8uT2qp/ c=1 sm=1 tr=0 ts=6afea40e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=3S7D6mjnOIgGY85eZR4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAyNyBTYWx0ZWRfX2eVJ+/+IxlE7
 W+BE+rUAtrGYMJflvUMIkc0soy6L0enk48XAQSEVygx2VVnZZvnFX2aPyViyQbzjQ1577O4Rkvo
 HZK9RL0k+M/Qa579S+rWoPsOB1I1+Zc=
X-Proofpoint-ORIG-GUID: C6HuRQ26zw5MJH3TAq5joplAzXr2-CMF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAyNyBTYWx0ZWRfX3cNfb6jiVM8D
 mfpJaV/VkGJobFNS7IXa9q6OVxa6ACnLSmgQ99qI1gL4DfWZS6aCQ3ElldLIrRyUjdnDzZFE4UE
 oRZNhCYOnJXrVWT+HqHH718BrfppYVflPBNAJq/JOg/PqCewSgO/VurZ/xIhNHaD5zB+j+CYi/A
 VxaCAXf5E7oDm8AQqbU4KLI8UO+uvjwF954uOoolfc+fz9eM+yte1w6x2FwdfOwCjJmkxDLZ5yQ
 PJb+4uCfTkQrnLN1XUgUH+jAdEK0saKP1Kj1Kzz9RFUOk/2btj+0blmhxV7kLfnxENdLJAOLIDC
 ZfN1OKNsOWA2SwTEFwhbjgpOURJzLkIKoIntQKfR7JkCthxT5qO2hawMhtuPv/iLE+ZPhs9H1lS
 23YWitNnp4X4GX9/ved77zUb7Qp9yXNi8fbiARvo84vbfDHBEunSvH7+CYea+4Q25HWz80qfIT4
 HZKDb3f1SLoVbLCychg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_02,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611190027



On 18/11/26 10:21 am, Jiayuan Chen wrote:
> autocorking_size, smcr_buf_type, smcr_max_links_per_lgr,
> smcr_max_conns_per_lgr and limit_smc_hs are read without any lock while
> their sysctl handlers update them with WRITE_ONCE(), and the SMC netlink
> handlers toggle limit_smc_hs with plain writes. Add READ_ONCE() to the
> readers and WRITE_ONCE() to those handlers.
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Acked-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/af_smc.c   | 8 ++++----
>  net/smc/smc_clc.c  | 8 ++++----
>  net/smc/smc_core.c | 2 +-
>  net/smc/smc_tx.c   | 2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index bfc0c7e71a12b..1d3eae064fe0d 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -88,7 +88,7 @@ int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
>  		return -ENOMEM;
>  
>  	if (nla_put_u8(skb, SMC_NLA_HS_LIMITATION_ENABLED,
> -		       sock_net(skb->sk)->smc.limit_smc_hs))
> +		       READ_ONCE(sock_net(skb->sk)->smc.limit_smc_hs)))
>  		goto err;
>  
>  	genlmsg_end(skb, hdr);
> @@ -102,13 +102,13 @@ int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  int smc_nl_enable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
>  {
> -	sock_net(skb->sk)->smc.limit_smc_hs = true;
> +	WRITE_ONCE(sock_net(skb->sk)->smc.limit_smc_hs, true);
>  	return 0;
>  }
>  
>  int smc_nl_disable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
>  {
> -	sock_net(skb->sk)->smc.limit_smc_hs = false;
> +	WRITE_ONCE(sock_net(skb->sk)->smc.limit_smc_hs, false);
>  	return 0;
>  }
>  
> @@ -411,7 +411,7 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
>  	spin_lock_init(&smc->conn.send_lock);
>  	mutex_init(&smc->clcsock_release_lock);
>  	smc_init_saved_callbacks(smc);
> -	smc->limit_smc_hs = net->smc.limit_smc_hs;
> +	smc->limit_smc_hs = READ_ONCE(net->smc.limit_smc_hs);
>  	smc->use_fallback = false; /* assume rdma capability first */
>  	smc->fallback_rsn = 0;
>  	smc_close_init(smc);
> diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
> index 014d527d5462d..df0afeef67cbd 100644
> --- a/net/smc/smc_clc.c
> +++ b/net/smc/smc_clc.c
> @@ -990,8 +990,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
>  	}
>  	if (smcr_indicated(ini->smc_type_v2)) {
>  		memcpy(v2_ext->roce, ini->smcrv2.ib_gid_v2, SMC_GID_SIZE);
> -		v2_ext->max_conns = net->smc.sysctl_max_conns_per_lgr;
> -		v2_ext->max_links = net->smc.sysctl_max_links_per_lgr;
> +		v2_ext->max_conns = READ_ONCE(net->smc.sysctl_max_conns_per_lgr);
> +		v2_ext->max_links = READ_ONCE(net->smc.sysctl_max_links_per_lgr);
>  	}
>  
>  	pclc_base->hdr.length = htons(plen);
> @@ -1272,12 +1272,12 @@ int smc_clc_srv_v2x_features_validate(struct smc_sock *smc,
>  
>  	if (ini->smcr_version & SMC_V2) {
>  		ini->max_conns = min_t(u8, pclc_v2_ext->max_conns,
> -				       net->smc.sysctl_max_conns_per_lgr);
> +				       READ_ONCE(net->smc.sysctl_max_conns_per_lgr));
>  		if (ini->max_conns < SMC_CONN_PER_LGR_MIN)
>  			return SMC_CLC_DECL_MAXCONNERR;
>  
>  		ini->max_links = min_t(u8, pclc_v2_ext->max_links,
> -				       net->smc.sysctl_max_links_per_lgr);
> +				       READ_ONCE(net->smc.sysctl_max_links_per_lgr));
>  		if (ini->max_links < SMC_LINKS_ADD_LNK_MIN)
>  			return SMC_CLC_DECL_MAXLINKERR;
>  	}
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c1420..2db3a87054835 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1010,7 +1010,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
>  		lgr->net = smc_ib_net(lnk->smcibdev);
>  		lgr_list = &smc_lgr_list.list;
>  		lgr_lock = &smc_lgr_list.lock;
> -		lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
> +		lgr->buf_type = READ_ONCE(lgr->net->smc.sysctl_smcr_buf_type);
>  		atomic_inc(&lgr_cnt);
>  	}
>  	smc->conn.lgr = lgr;
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 0f0c6df3bf2ce..30bffe79d06a3 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -148,7 +148,7 @@ static bool smc_should_autocork(struct smc_sock *smc)
>  	int corking_size;
>  
>  	corking_size = min_t(unsigned int, conn->sndbuf_desc->len >> 1,
> -			     sock_net(&smc->sk)->smc.sysctl_autocorking_size);
> +			     READ_ONCE(sock_net(&smc->sk)->smc.sysctl_autocorking_size));
>  
>  	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
>  	    smc_tx_prepared_sends(conn) > corking_size)

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>

Regards,
Sidraya
