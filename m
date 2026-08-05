Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68B830C156;
	Wed,  5 Aug 2026 04:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785904830; cv=none; b=SP3NrRfwpdmcuj5lYMlsP1xDeg+NAgA2iwXu2dQFxowU0dyzbLAH5XrtktCCrl5Y+vrMSOovHlBXa2kOLl+7ab0PQW/goz5/JFbWj3iiqM/ut3aIYvkB/ZAZUSwL/mRS8yPnrIaovBdzvTmb0G7cy+/BVvDFAagWkisaAGjlpsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785904830; c=relaxed/simple;
	bh=lyaMiC19LEzfHPgL7ONL7ZX38Ccs/J7rehs3k4Y4iWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qq1Zq7tnuo8TPDN7BykG69ThLtkpWMu4sG+B+sBrhdp7xKD6XTODhfhBepqPc75sDthWqNC5hvMUQF5Gtu09WOkaLr2UpqtuNOxGQ9rTpEGcUKuzcyEmCf7GxihXuJ7JXCmqnUP43e+c+K9Fn39YPlELCGMoFHP/EZEDiy5XKTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i6t/d5xI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i6t/d5xI"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6752nGQW2696052;
	Wed, 5 Aug 2026 04:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aaKdFf
	RdiERcYuAMtC4GLLsQx8Zz14qxCDmQ0r5ywxM=; b=i6t/d5xI2XSOa4BNZhd6Q3
	lFCrvWUPQDNppmvCheJjzyXJfLIsSlfCe1+PW6XvBslhTcUdO5kUCa+yaRNuoEke
	m1Zht2XTvOOMoj51lsydnls4amWZcO++p068iQaqmPqAVAMyJvEN2Z7TrezHOGBz
	0XtKUlqi7gwDtSTpSn+2JsAmd1JyX8n9X1RawSDicDTfGmNaqikVhJKA2lcZAZbP
	4Nki5cHAhtJKA3rgfzf9kKFf9xtbPWNuwOC6OYKsmo1/RnloFTFymqIBIfuY7YvY
	j5d2sQp6eiOOgJhnh1aijVTFq5YfxA0OIwDqJ/A9U4KTbsGQzF4UoChuOfYUzqYg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8eurr98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 04:40:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6754QHcR023634;
	Wed, 5 Aug 2026 04:40:26 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtymrdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 04:40:26 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6754dkA416122580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 04:39:46 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77F9958142;
	Wed,  5 Aug 2026 04:40:23 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A49AF5813E;
	Wed,  5 Aug 2026 04:40:18 +0000 (GMT)
Received: from [9.123.5.171] (unknown [9.123.5.171])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 04:40:18 +0000 (GMT)
Message-ID: <66d3bcd7-1c2e-4bc9-b7af-4ecfd85ae6cb@linux.ibm.com>
Date: Wed, 5 Aug 2026 10:10:17 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/smc: fix sock refcount leak in smc_switch_conns()
 error path
To: Yifei Gao <gyf161023@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Sidraya Jayagond
 <sidraya@linux.ibm.com>, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Hidayath Khan <hidayath@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260804213917.3413525-1-gyf161023@gmail.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260804213917.3413525-1-gyf161023@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: hEvd8y6GQlMGWQpJiluf4kHXyluvx-TO
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDAyOSBTYWx0ZWRfX6PGfOPukj13q
 /B2F/Q85Zc6m85DXyY9jdw/BHAqKHAlc01Ke6wYq512J8YyAsYhWd/Xm/aSWg3puweKcH46W/FQ
 606dt33NIF/+alR/5LK6Ze8Pcnxsbu0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDAyOSBTYWx0ZWRfXxuQHVdo2Ohax
 pTFkJlExq/ugni50Q6sftxbjxxi6YVcDaAksfKsKIJ8JEMIZuJ27NF2IzFtcOdMTTF5GiSLHij7
 Sg/5Xj20i1E0S6EBNcVtqOBOcc8Etbt4/8kJA1J3WW4TP2oyQnIbGNXRQlLgWpjdTs4GMKSrIZN
 OPMwHgcCdoIuxSHOZAjFW/5nazGpOqQCvp1NU4GqDKZ2ho6OlQT1JdDaQhKF0z/m9jK0S3VXaqR
 C1HxD59WgdTuNqQMsbOu/ceoqS8JrAUBIgXvBWRaQYnR1l26nFomBehUY9joV18CVaf5573jdE0
 JOIn1HgBvMGS6E370p8Y9ZwoURXCVMfqz5H2W8e3w/eSvH+MwUpfkOdIVuE4XM8bJ8tdgnvdHFp
 drmy3p9mraOnQtsqqncvKAVJgDHMv8KjWbiODtS92YuxD5loeAqgivKuZnL7ocff8KBt5WmV9xW
 UbbZ6BVurAaSUyhSSiw==
X-Proofpoint-GUID: O4mkEsRhdSi5M01UnBaULCLKy-NPBF-I
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a72bebb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=h0Cf4ckhx-fnnXdm7CAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_01,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050029



On 05/08/26 3:09 am, Yifei Gao wrote:
> smc_switch_conns() takes a reference on the socket with sock_hold() before
> dropping conns_lock to prefetch a tx slot. On success the reference is
> released by the sock_put() after smc_switch_cursor(). When
> smc_cdc_get_free_slot() fails, however, the function jumps straight to
> err_out without a sock_put(), leaking the reference and leaving the socket
> unreclaimable. During SMC-R link failover with an exhausted backup link
> this leaks one reference per failing connection switch.
> 
> Release the reference before jumping to err_out. The err_out label is also
> reached from the smc_switch_cursor() failure path, which has already done
> its own sock_put(), so the put must stay at the get_free_slot failure site
> rather than at the label.
> 
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Yifei Gao <gyf161023@gmail.com>
> ---
>  net/smc/smc_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index cf6b620fef05..04c6ce608ec7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1148,8 +1148,10 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
>  		read_unlock_bh(&lgr->conns_lock);
>  		/* pre-fetch buffer outside of send_lock, might sleep */
>  		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
> -		if (rc)
> +		if (rc) {
> +			sock_put(&smc->sk);
>  			goto err_out;
> +		}

This patch has already been posted by Hidayath:

https://lore.kernel.org/netdev/20260804082800.498672-1-hidayath@linux.ibm.com/

Adding Hidayath to confirm, but this appears to be a duplicate submission.
