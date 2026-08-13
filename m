Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EB229A31C;
	Thu, 13 Aug 2026 05:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600042; cv=none; b=bJOIdPEhZDCn1rXi716aFxxj0mUFk1uXitUqIkMvrKokYEoY9pYlY97M8NfZDhWnjTH3sDldSVn42szccrYJ8AyhpdvtLOIBfI9EqF8iHHXXoe0WlXxh37FQnyoZNv2WZVvVWEWP3qCkCjiXltsaWBxed5Aqloo/hfu83Iw+LiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600042; c=relaxed/simple;
	bh=sELuXYaxCJ9UncWL/nmLViigSAbUu/vCfzBBi1l2PPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzlRl5pysSoLfrgcI+KDaMFoYypN5aYsFWJyoKnJtPmq18FSgpKvMtF0QZ8CqQaIlbcnPM8+MYr+2nrF+1SU27wqd2sZ/emDC6B20Cm4meY6LeW5r5MwOnLjfAZFuT+f6J6fqz5INrSfNTMAeJAVpZbo2NbheV5IzBv5mR+Krqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pZOXEQX6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pZOXEQX6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D2W10b001322;
	Thu, 13 Aug 2026 05:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vT0JJ5
	rBk5ojb+OTQCI6SMh2iRsrUKRetqSkzOvdcP8=; b=pZOXEQX6zF3p7fXh1ETrud
	DK9Lp0DYxUnR/LUk1tFdiwSbRn8F/rWgmNnIH0n87AxfNk/2teK2J2Uo3taeerZm
	67kSf3DpFmxbojCvSdjACSYnrAeUl2G1rCwhCwIsE/tTP6732yRr/IRFO7zmN3oO
	retC9rx5gLWdMvzWTEYOnCkxMMQRFcgvNwwKK2mT51W1GKJCUlu9o34nedUbllIE
	pPGzVbiNkr9siBIETobPB+rILZKa8DkQcCk6L7xAgxYRBY32FhENcXuc7zw4wpCf
	WPY/fYjHDNxcztrbGtyrYWGAa1gv5H+zky/A2XuObrU8OjLlAYdXlLU0Ugq+z4Xw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb23xu81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 05:47:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67D5fv9Q029253;
	Thu, 13 Aug 2026 05:47:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxhfy9h0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 05:47:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67D5l6GE38601024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 05:47:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAEAE20043;
	Thu, 13 Aug 2026 05:47:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1391520040;
	Thu, 13 Aug 2026 05:47:03 +0000 (GMT)
Received: from [9.123.7.41] (unknown [9.123.7.41])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Aug 2026 05:47:02 +0000 (GMT)
Message-ID: <891f8b0d-ec14-4614-8f61-87d9158ebadb@linux.ibm.com>
Date: Thu, 13 Aug 2026 11:17:02 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 1/2] net/smc: unregister the connection before
 draining the rx tasklet
To: hexlabsecurity@proton.me, Dust Li <dust.li@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Tony Lu
 <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
        linux-s390@vger.kernel.org
References: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
 <20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7d5a5f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=-M-Itl4GYaBKzoAUkUEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDAzNiBTYWx0ZWRfX99IknMgLPgfe
 Pw7Zx35Zg7mYui97i4B67Hs00ECEkrRJubZ53S+86H/xpPzoY6LN/DL3BLpvmaIinmW8H3RuLFu
 yJeCOtcks3yhoSRfPybHNYAJ3/UyjtPeDPkOjJyGJoPz6yKf1Bma40qyHh6J/BoWazJNnSenBte
 iwX4laaOLdu7tUAlMsf40Nb/nuYNQb+lxZyDybRmY7+RQha2kQnAF/QjPhXokn7GWo7j1AJvM5J
 SbsFNUWp8dVOyXNFahW/ueS6RmEShxyXhPxJQE6vNwbdVSWx6aS2x8io15Av9one+ER449bbUIa
 mArMNX3J/xTAmXAashwQEQWTAlE/vfiKu09dgdaP90I61sB96mwKsuYA7Qm47ZAxqEb810P8IlI
 7IX7N1dOEtN4MYZ1aeuDSRRTnr/myJXNIdJupp5NikNj2hbncM0+p+C4bHuM/Ouxp0cCjElASL4
 jl7/BEltICCdN90lPcw==
X-Proofpoint-ORIG-GUID: fc-So2Dpc2fbfODQr8LDeXMgc9hPM5hF
X-Proofpoint-GUID: nT97tu86nSdz4X0cAVzwVODl7I-uDxrK
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDAzNiBTYWx0ZWRfXxuMJSQZMr+bX
 QL0FNnsQKwSZxKSnzi5Dph9/WjZI9PHynO7Cr2q3//f29e7oT5L55mTh1An+Spc9ZAPqKax4jVY
 bwkcfUZ9J6r8fIViHvsIvmKn/YaRly4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130036



On 08/08/26 12:51 pm, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smc_conn_free() calls smc_ism_unset_conn() only while the link group is
> still on its device list, and never sets conn->killed.
> smc_lgr_terminate_sched() unlinks the group immediately and defers killing
> its connections to a work item, so a connection freed in that window keeps
> its smcd->conn[] slot with both gates in smcd_handle_irq() open, and the
> device can re-arm the receive tasklet after tasklet_kill() has returned. On
> the DMB-nocopy path the ghost send buffer is freed right after that drain,
> so the re-armed tasklet dereferences it.
> 
> Unregister unconditionally and drain before the detach at both teardown
> sites, mirroring rmb_desc, which smc_buf_unuse() releases after the drain.
> Clear conn->sndbuf_desc before freeing it as well, so a reader that samples
> the pointer cannot get one that is already freed.
> 
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  net/smc/smc_core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index b4208cb186c5..181647982490 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1209,14 +1209,16 @@ static void smcd_buf_detach(struct smc_connection *conn)
>  {
>  	struct smcd_dev *smcd = conn->lgr->smcd;
>  	u64 peer_token = conn->peer_token;
> +	struct smc_buf_desc *buf_desc;
>  
>  	if (!conn->sndbuf_desc)
>  		return;
>  
>  	smc_ism_detach_dmb(smcd, peer_token);
>  
> -	kfree(conn->sndbuf_desc);
> +	buf_desc = conn->sndbuf_desc;
>  	conn->sndbuf_desc = NULL;
> +	kfree(buf_desc);
>  }
>  
>  static void smc_buf_unuse(struct smc_connection *conn,
> @@ -1268,11 +1270,10 @@ void smc_conn_free(struct smc_connection *conn)
>  		goto lgr_put;
>  
>  	if (lgr->is_smcd) {
> -		if (!list_empty(&lgr->list))
> -			smc_ism_unset_conn(conn);
> +		smc_ism_unset_conn(conn);
> +		tasklet_kill(&conn->rx_tsklet);
>  		if (smc_ism_support_dmb_nocopy(lgr->smcd))
>  			smcd_buf_detach(conn);
> -		tasklet_kill(&conn->rx_tsklet);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
>  		if (current_work() != &conn->abort_work)
> @@ -1525,12 +1526,12 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  	smc_sk_wake_ups(smc);
>  	if (conn->lgr->is_smcd) {
>  		smc_ism_unset_conn(conn);
> -		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
> -			smcd_buf_detach(conn);
>  		if (soft)
>  			tasklet_kill(&conn->rx_tsklet);
>  		else
>  			tasklet_unlock_wait(&conn->rx_tsklet);
> +		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
> +			smcd_buf_detach(conn);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
>  	}
> 

Looks good to me.
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
