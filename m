Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5ED3D5668;
	Thu, 13 Aug 2026 05:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600061; cv=none; b=G9+ByPNVzpveis749to5Juq6ICA1S4um5RAKFkIuFkNgU5T33vdBq0ya6cywZctd54lWe+3MsNsyiP/ZCWJ8GfbwcMGgH7Nrn1WTtap3jsuVXg7Z4JbvWTv62rTRmF3huJLHjGH028iVVtavuCfZAk8eBgCr3UmSe/9sBnMsz/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600061; c=relaxed/simple;
	bh=HztUxp3cIY+LpIRNnKQK8Z3z9lqKE/Xm4f7f1K4oms4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nHMZeYnehLOv5Swr1pRIyoOBmByjb9u0ejjm1KkIY1a+qiO8df6Xr/LcRM8PdmhbQp4rMIUmKJcYPGPlW5+DN2pWd/Gg54R/sZ3scbxDf8APJMjMTXRYoNJpjttGpOBdIBOPq2KGREX6GSak/Mc0VbwBtIxSnJvvSXbon18Z5oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HwRQg9F2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HwRQg9F2"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D2Vpfb1137963;
	Thu, 13 Aug 2026 05:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WTUZof
	A5fhhsZLorPZqOKmWdsxRjs/jqPR4QojA7Uyk=; b=HwRQg9F2xQv20FlRxXnn20
	bMi/pbMIipcgBo10tbRyI1m/jL8Ihyh9ZY5Fwv3H/7lUCcPSCxX4FwDmxZinvg1g
	tCheO68yBRTurJuwWP8dEhxbWIxkX+IeeUs1iAwSpars4slizJngG/wE7E8Xbq2X
	XwfIolvCYqQ4vrnb9XPGJ4Ijdwy++BpwQZmXKyqaZAAdPUfTDWFaWINSD4JO+8oz
	4LGfVA3AI9SvJycrjIqiiMHAsuUF09UtUAl4UHtOasJHUIXOgrf/3oKkbS631vvT
	/OqofGLb5xWAA0+Tr44Ec81ovJwu+a9gA4qqe7FAvZNmyW8xX4IAb+e6ncz/UNMA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvnwdfk8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 05:47:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67D5g1jg029658;
	Thu, 13 Aug 2026 05:47:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesq9v79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 05:47:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67D5lR1D39911808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 05:47:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2B1320043;
	Thu, 13 Aug 2026 05:47:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C913620040;
	Thu, 13 Aug 2026 05:47:24 +0000 (GMT)
Received: from [9.123.7.41] (unknown [9.123.7.41])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Aug 2026 05:47:24 +0000 (GMT)
Message-ID: <d5a0c244-5dae-4cab-a583-554916f3a827@linux.ibm.com>
Date: Thu, 13 Aug 2026 11:17:23 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 2/2] net/smc: do not dereference an unset send
 buffer on the SMC-D teardown path
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
 <20260808-b4-disp-22f119e6-v2-2-61647601a6f3@proton.me>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260808-b4-disp-22f119e6-v2-2-61647601a6f3@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=RsP16imK c=1 sm=1 tr=0 ts=6a7d5a74 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=gtJVlIiFC0nkM8rK_MsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: JyJy2-MNmNE5AK77qfuxE_C8m-eN9rTL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDAzNiBTYWx0ZWRfXxKIRWwFGxtb9
 vowUq0V2DwrVN4P3N/LReb++avlKQYoeNDI/fs/2VIYTv51w0+2Yw9xVMI9cI942IDnxKQOmdwB
 G/tCRqQA3ykTuowPh1+ysJCJE3D7elW5glEHCM/RjjXlSLoXf9ZXRYdajuYSY7W+QCwIqk6bEZo
 CMhP13z3lUk6iCYd05wG+6q60oOi7uo+QrCCRNFKjuzQv/9YhmutI6X3xLpCRLCM1zDsaRoJWq3
 ed5xVY0zlsiSceJ9VzoD2Vc4j2F6XnV1MEUAbmP7T0aGB26qLN2pFJSVlAILD+VRLOk11D7oqDJ
 CJI1paOrLQBZoffCxZQmaRgXu/Qqmxcz9AHugFFIhFklxVLALJxX/+VHyb8BbyFW/u6YftbDhVw
 J6crKWt0hcxPjrRZs99MDPuOFwcXQeibq4NoJPZGn9cmMD4305OLcKA+h39MFyyqbbprokbu7/1
 T+5GkhIMknxZCvD8U6w==
X-Proofpoint-ORIG-GUID: zq2tARgAA9sCWM6IEnURL76Va5V9Nk1v
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDAzNiBTYWx0ZWRfXwqW4UgQnevbK
 GO5XSBK+dSDpHFlUHNu9/y3XzRJuvVkBksfj5q3ZBjPKKfGHU8fvjCeqb9V+QwXOupJHhH7sdhy
 mFL+rIWppEnu+BvgbpZkBSsULMNIDKU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130036



On 08/08/26 12:51 pm, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smc_close_stream_wait() calls smc_tx_prepared_sends() from inside its
> sk_wait_event() condition, and sk_wait_event() evaluates that condition
> once with the socket lock released. smcd_buf_detach() clears
> conn->sndbuf_desc from smc_conn_kill() under lock_sock(), so a link group
> terminating while a socket waits there leaves the helper dereferencing
> NULL, faulting out of close(). SIOCOUTQ reads the field by hand, and
> smc_close_cancel_work() drops the lock across two cancel_*_sync() calls.
> 
> Sample the pointer once in the helper, report nothing prepared while it is
> unset, and bound the ioctl the same way. The receive tasklet dereferences
> the field directly in smc_cdc_msg_recv_action(), not through this helper;
> 1/2 is what keeps it from running that late.
> 
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  net/smc/af_smc.c | 3 ++-
>  net/smc/smc_tx.h | 6 +++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 00403175b740..cff910cedbfc 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -3233,7 +3233,8 @@ int smc_ioctl(struct socket *sock, unsigned int cmd,
>  			return -EINVAL;
>  		}
>  		if (smc->sk.sk_state == SMC_INIT ||
> -		    smc->sk.sk_state == SMC_CLOSED)
> +		    smc->sk.sk_state == SMC_CLOSED ||
> +		    !READ_ONCE(smc->conn.sndbuf_desc))
>  			answ = 0;
>  		else
>  			answ = smc->conn.sndbuf_desc->len -
> diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
> index a59f370b8b43..610a945aefd6 100644
> --- a/net/smc/smc_tx.h
> +++ b/net/smc/smc_tx.h
> @@ -20,11 +20,15 @@
>  
>  static inline int smc_tx_prepared_sends(struct smc_connection *conn)
>  {
> +	struct smc_buf_desc *sndbuf_desc = READ_ONCE(conn->sndbuf_desc);
>  	union smc_host_cursor sent, prep;
>  
> +	if (!sndbuf_desc)
> +		return 0;
> +
>  	smc_curs_copy(&sent, &conn->tx_curs_sent, conn);
>  	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
> -	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
> +	return smc_curs_diff(sndbuf_desc->len, &sent, &prep);
>  }
>  
>  void smc_tx_pending(struct smc_connection *conn);
> 

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
