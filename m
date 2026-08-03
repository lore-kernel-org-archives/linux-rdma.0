Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0DD2F49F6;
	Mon,  3 Aug 2026 06:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785738517; cv=none; b=nsiKgb/pl+MQyKEnX7mYgho5R3fvmM0fNhyrDqKmL/fyvr4Wv918/mqEDeWSMA4J7N+jW4DXoResBdN45NPTw+KC25P3prTvIauaOcg/qGiXHABh2vC9fMfrQTbmyavIyPundXmpeAXJWuDgEEsQ2Bop7UkejdX+JOG6NI2MAdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785738517; c=relaxed/simple;
	bh=j6wNZYALu5Rd2HxZ6z42jCXmMubMzwNM/+fU64vBMp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXpkXFk0NIT7G9O+KNLHQVp3g6x25bM8jY79s3K5BcSRWrsyWPMaa6p//CCLMT2DsLvIsX6mrPNBzs/SWpXd8Dku3NmsAwiOadVWfVEwccO/v9fuq+VKsKDACcP0hfig+E8R3VfwfyYd477lZAL/iDFitgSvprrfmpdfXnWeqe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=q3NXIigV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="q3NXIigV"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672NgEK8380027;
	Mon, 3 Aug 2026 06:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=grwUhx
	kUCrNPHqyBF0X6Wki2lSXMtyrWH9yMkxLVMT0=; b=q3NXIigV3epglhyIfrY6IQ
	ToZ3rD67cRjQqwd5I/Y5f+bJdIBlu/PRmiJceFswbwdpYk/B4AHAG/Yu2EuhNnDv
	3LMTVerktSy8q9JVGHuMEXNJju+9vd7f0NcXtV09m8jhtI12U971l/vKHHfr94bz
	65JjBpC5YGl/iz4gNb/yuCIBUaG0J1OWH7elWKxcELJvTfxz8+0zMKN0NwgtMkNw
	qarDEgSmIdz9ca2XQUs0oPlEPLZl3PSADltB0QjO+ej/NKv2rdAwGKz15jjv91ID
	N2hSI/ZmOqSMUOPI0DQ09XVwazB26Uc7XsQFA+SRjXrfbtz7E2UURdsA0GOuLfMw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67hf6ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:28:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6736QHms031713;
	Mon, 3 Aug 2026 06:28:23 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmh40ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:28:23 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6736SMt713304400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 06:28:22 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F1A558054;
	Mon,  3 Aug 2026 06:28:22 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61A325803F;
	Mon,  3 Aug 2026 06:28:16 +0000 (GMT)
Received: from [9.123.0.155] (unknown [9.123.0.155])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Aug 2026 06:28:16 +0000 (GMT)
Message-ID: <d861388f-0a03-4994-9470-534f4cf4f14c@linux.ibm.com>
Date: Mon, 3 Aug 2026 11:58:14 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: validate peer CDC cursor against RMBE size
 before accepting it
To: Bryam Vargas <hexlabsecurity@proton.me>,
        Ibrahim Hashimov <security@auditcode.ai>,
        Dust Li
 <dust.li@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Tony Lu
 <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <amA9XGOWH3z4Z1fu@linux.alibaba.com>
 <20260722102929.38218-1-security@auditcode.ai>
 <20260723230647.138311-1-hexlabsecurity@proton.me>
Content-Language: en-GB
From: Hidayathulla Khan I <hidayath@linux.ibm.com>
In-Reply-To: <20260723230647.138311-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA1NCBTYWx0ZWRfX8sfwO3ScL3DW
 LXSYZPMSHPYYfKHRaFyQyqupUeGrU30Ai93VevAopFXkTjIw4eAn30+m+gHAP0ctK+HObY6Rx1O
 ic3oY74jAuy4f4orJowxSmIlqvuNo38=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a703509 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=yQ0VBZUCRUxF-LYgn2kA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA1NCBTYWx0ZWRfX5P+mslCepaAa
 F/Xj5JlIuCRlKMPnRR0xnpmt+9HO3GxMyShK4eQjZ7jJv+Gl5lWYK6Rt74uZL4VvsKlDeEqdtyu
 wO5F0hzZ9X2jsc8exuQjDwbpEpkDbibIc3vGVhPBrLUy/rMW4YzyfRUTtl4C9luytf/15iSpHUz
 /ijK3W9QRonEmkNO3LPrOtNUjjIHMp7Oh6kF449WJCXE59v4f9fXNkUH70WmxrIG940860YRGXT
 ancMCxZCAO3H4UrRgps3jfaSU9gqfvsqnwi0pS2pDPO4W2ZbsZQeuzmus+6npd76x2k7UbmyxLW
 0vt2WfYCDYiwooSWjF3MV/xYFW9XSINVmP1/wAoIKhSv0JsnVKG158c5qSxn6+FRSJ03sWm/Nyt
 ULfjbLMlAGd3deh6UcnfuBTevtzQKWNZ8LPo7IIiv2NAyek9VYACndEWkXrd5LI9Iy/qwSPcmX7
 ynt3yJ/52Pya/odR//g==
X-Proofpoint-ORIG-GUID: 4xOFp8dqCfk60xbB6IW_V_BQlhgSNg5k
X-Proofpoint-GUID: cysbySCLSsFRZy8_v0LnwTuq0UFsZcft
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030054

Hi Bryam,

I have a standalone net-next patch that aborts the connection when
bytes_to_rcv + diff_prod exceeds rmb_desc->len.  The check sits before
the atomic_add(), so the accumulator is never written with an out-of-range
value:

     if (atomic_read(&conn->bytes_to_rcv) + diff_prod >
         conn->rmb_desc->len) {
         smc_cdc_abort_conn(smc, NULL);
         return;
     }
     smp_mb__before_atomic();
     atomic_add(diff_prod, &conn->bytes_to_rcv);

The patch also moves the open-coded abort sequence in
smc_cdc_msg_validate() into a new smc_cdc_abort_conn() helper, which
the overflow check above then reuses.

It is currently in internal review. I will post it to netdev shortly.

Thanks,
Hidayath

On 24/07/26 4:36 am, Bryam Vargas wrote:
> Agreed, and thanks for dropping the competing one.
>
> Patch 1/3 bounds only the cursor count, not the advance: smc_curs_diff()'s
> differing-wrap branch returns (len - old.count) + new.count, so prod(W,0) then
> prod(W+1,len) is diff_prod == 2*len with both counts in range, and
> smc_cdc_msg_recv_action() adds that to bytes_to_rcv unclamped. wrap++/count==0 does the
> same over several CDCs, so a per-cursor bound can't catch it.
>
> The out-of-bounds copy you point at is closed by patch 2/3, though. It bounds the
> derived readable length at the consumer:
>
> 	if (readable < 0 || readable > conn->rmb_desc->len)
> 		readable = conn->rmb_desc->len;
>
> so copylen <= rmb_desc->len and smc_rx_recvmsg()'s second chunk (copylen - first,
> offset 0) stays within the ring no matter how large bytes_to_rcv grew. I ran your
> wrap++/count=0 vector end to end on the real SMC-D path under KASAN: with 1/3 alone it
> trips slab-out-of-bounds in smc_rx_recvmsg (bytes_to_rcv reaches 6*len, read of size
> 5*len); with 2/3 applied recv() is bounded to rmb_desc->len and it is clean.
>
> What 2/3 does not fix is the accounting: bytes_to_rcv is left > rmb_desc->len (and can
> sign-overflow negative over many messages), so the documented
> 0 <= bytes_to_rcv <= rmb_desc->len invariant is still violated at the producer even
> though the copy is now bounded. I have a net-next follow-up that records and aborts on
> that. Your
>
> 	if (smc_curs_diff(size, &old, &temp) > size)
> 		return;
>
> catches the single-CDC 2*len advance cleanly; the wrap++/count==0 form slips it, since
> each CDC advances exactly len (diff == len, not > len) and it is the accumulated
> bytes_to_rcv that overruns. So I'll pair your advance-bound as an early catch with a
> check on bytes_to_rcv after the atomic_add and abort+record there, which covers both.
> The insight is yours either way -- may I add your Suggested-by (or Co-developed-by)?
>
> The v4 series otherwise stands as reviewed; I'll repost it for the netdev queue and
> keep the accounting bound as the net-next follow-up.
>
> Thanks,
> Bryam
>
>
