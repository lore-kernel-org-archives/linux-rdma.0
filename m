Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872225;
	b=AImUQAGBpheUkZuiBjmIOzIo4bbHwqLEWRnGxSMPXK1G8JHgrBpweJLK0UUR3G4EMW5T
	 0nB1gH76QiOeh0Wl7ydAT++OZspcBNUadFwlpVr/VeeTD8kA1NjzcpV4QWnEQrb5wJFDT
	 LJZPMofUH0f1sejRRKMUBeViovhL3Q/3eSKAQTC+NVr2TZ7/6ANQ3cFiY5/Qx8yUaRxbo
	 rHslhHSa/L7XVci4BkRMp1c65e+ulZaP29dJ17tmYPS1yWLDGCOi15QX8VXfYKeNSIcWE
	 eLz8sPGaf1Gx6X9xExlxkuftXl+0YI03C3QCVM67mCquPS2swbDX6e9KDFH+6KXYDwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872225;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:Cc:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=RXxdcpf1mi+lXR6AHit85Uc8DdIXrFeiJ/EvXtI9+wA=;
	b=etwVTdasZQSk7OqwewH8c/ekkUrR4L0l/5UCdUQlya0pLhdqnIqmcvUQBnUCvi2ktotv
	 D3kqED2LEZvYVWSdWccSh0VuAsb0bu202X8SNuJF8P9FmqXE+OSr68QI/7Y6Ejny4DyT4
	 bj2lEnrPK1IkiOc6k1woV4JnXJnn/24KT4MWySGl1JVNCAgAoG4q3CagybGw9/Y/0obIF
	 qlfxPimxIx3nbHvXEe62GD6rm+QdauDqXiSdCNMWdoFH0rR2WAq85TOCePbFaOdQKtmVS
	 hCuNqixjSaaUkX85q87MXo/e7YV6wwxJop6mD0ykg7JefdHeN8cumTYR0rEcRb4Pp2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=K+3VdS09;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E06D606A33B;
	Thu,  5 Nov 2026 09:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E06D606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=K+3VdS09
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A56i55R3019705;
	Thu, 5 Nov 2026 09:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RXxdcp
	f1mi+lXR6AHit85Uc8DdIXrFeiJ/EvXtI9+wA=; b=K+3VdS09/qvpRfbTh9TCyG
	zD/hcJi0UJa4P2QlG6lbehNK4fGl0r/CSPMrcOTF7sE5cqRE+A7Ka7kdLjzLM2j9
	YQIEzALUozhg91LRh0smbFcvaAgAd5VHEoSS8ysEAGbXE5+XsGmwzxSXkHKO12Cm
	UnsESCvGhWY1Qo9xwvxFYoR+fWfixYxf5aAc1EoJ6V/BvG14bxxcqfy4Tts5nSbr
	M6CCvAZTGC12SLbLtuvQ9TM9SJNdXBUFwHZ4vBFg93XEuPwFcaFoVMAbrSLe2Y8d
	YVubOvnIA2FApoQnmxz+w5Izh0w3a+TDUVeTgTo6W9yuF3nXmWKAp8GWeyOZUenw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn7u3set5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 09:50:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A56YwhT025909;
	Thu, 5 Nov 2026 09:50:16 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hqsf5fr8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 09:50:16 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A59oGpL11665990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Nov 2026 09:50:16 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D3CA58055;
	Thu,  5 Nov 2026 09:50:16 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7418A5804B;
	Thu,  5 Nov 2026 09:50:11 +0000 (GMT)
Received: from [9.123.14.188] (unknown [9.123.14.188])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Nov 2026 09:50:11 +0000 (GMT)
Message-ID: <78beaf8e-6357-4856-8464-717bb47d74a4@linux.ibm.com>
Date: Thu, 5 Nov 2026 15:20:09 +0530
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
Subject: Re: [PATCH] net/smc: deregister the MR when SG mapping fails
To: Wentao Liang <vulab@iscas.ac.cn>, "D. Wythe" <alibuda@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Sidraya Jayagond
 <sidraya@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20261104022812.1484233-1-vulab@iscas.ac.cn>
Content-Language: en-US
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20261104022812.1484233-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Zsp4uN7G c=1 sm=1 tr=0 ts=6aec515a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Ruwe0kKRUAsyMHfTDyMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: llxEXSJ92mwsL0YGbs24MbVE2Tb2cnFU
X-Proofpoint-GUID: QBXzzbW26_VqFZhZxFxkn4K-9NLxyoG8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDAzOCBTYWx0ZWRfX/F+/mquu0ObP
 pKNJT3e5LACx4XtI7jMvXajAhTEx4ySfAo+jtLcZr5iwP8TRL1DJhp0fztiOog0S1SxsgnH69kC
 X2d0L9eBscWYfB2bsjaarZEB31NZCQ3NqBdlOLeVEp7GTlvbdzQrVKP4IcvrFiLYRLsQi6AAJ21
 WfzRawXtHxFgJxTuPW7ylY5RS2gwqOKNeOSnMutjpbPFZ63P2Btam/mtHZ3jkKhP1he0/NphzHO
 xzu/qTsqKi0f+8Afz5i6e1/CKQTsnmswUNDUDt73I/12+MEVqjvSDULULPoIbJ+eUO/Vybm4mV1
 uvhvajow0fq8zxM2AAW5AW+LrOMXBR3+Y9AwwEaz2yBfx+jYkC4ZbXHzRJ4eHn6u8UD903hsLqW
 FOY2DpggWBXa+GIpiW4XhR0Mbu1qj6dZnq3AYQxO0pajR0vZGNbXRtX605Mkoh6cDwWKgHAZ0JU
 trX85tXuS5VxK0N4crw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDAzOCBTYWx0ZWRfX7+W4sB5iOJlQ
 ShhOO2/FPzSAzw4FmKs/kLtWwYZ/LacEHuJNFwhZB3yN+dBZCW8U08YvPpjE045x8GLooD+1sK+
 5+6lS5fecKpJ3Ip/LBJJ/yEj+0Tj7pg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050038

Going forward Subject should mentioned PATCH net.

On 04/11/26 7:58 am, Wentao Liang wrote:
> When smc_ib_map_mr_sg() maps fewer entries than the SG table holds,
> smc_ib_get_memory_region() returns -EINVAL with the memory region
> still allocated and its pointer left in buf_slot->mr[link_idx].
> The caller only undoes the DMA mapping and frees the SG table, and
> because buf_desc->is_map_ib[] is set only after this function
> succeeds, smcr_buf_unmap_link() later skips the buffer.  Both the
> MR and the pd->usecnt reference taken by ib_alloc_mr() are lost.
> 
> The stale pointer is also harmful: a retry takes the "already done"
> shortcut and treats a memory region that was never mapped as valid.
> 
> Deregister the memory region and clear the slot before returning.
> 
> Fixes: 897e1c245773 ("net/smc: use separate memory regions for RMBs")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex

This is not required.

> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

> ---
>  net/smc/smc_ib.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index daaa8a72da90..fa21d269196e 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -735,8 +735,11 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
>  	}
>  
>  	if (smc_ib_map_mr_sg(buf_slot, link_idx) !=
> -			     buf_slot->sgt[link_idx].orig_nents)
> +			     buf_slot->sgt[link_idx].orig_nents) {
> +		smc_ib_put_memory_region(buf_slot->mr[link_idx]);
> +		buf_slot->mr[link_idx] = NULL;
>  		return -EINVAL;
> +	}
>  
>  	return 0;
>  }

