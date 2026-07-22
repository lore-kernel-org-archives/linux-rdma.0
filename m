Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD73364045;
	Wed, 22 Jul 2026 07:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704376; cv=none; b=V1k6OLeMTVdpSduLb5ROeVrUDydoSHphVKf9iUlTy4+SBng8+4CzoKtOXt7yZpzTZ/9JQ4p1FR7YLiJBw41i7N76XR73juA9i1D2PmTQmBMFrvRFWEJAu8aNVbaJpYN5BVOnHjZBgV6ggBmWKs4Xb7WSNgO9m/O2Dw8tE96R1Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704376; c=relaxed/simple;
	bh=SJI+vbgPnERpXrvCI1fnpDrMdVImICtdc0/IuK/UXr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=detLbh2GPen2rGg8epYFVh+hBqyMvCl44xnHBYy+o2h5evRDd2qhg9rnaf1qZJqp6sbRyE/ENS0DZXu+RwNUL2NWS0QXC4OPb7e2Ek6u85d0huKdlQebAppXK4EXwlPIVDX9kYMyFtA1hvZHCyMWV6oKCvlpgg3MG09qr3VPo94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bflEpSSr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bflEpSSr"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M5CDt43158297;
	Wed, 22 Jul 2026 07:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YuiZTF
	BCKb9cyZsgHxv7oo45ztJyu4OIMWaZ5M1x1E4=; b=bflEpSSrxH4L1Ws/p23kfD
	WZFIaFsTRwT9Lhi0q9y6Jg/3CcOo6OjmbJJVYQe/mDaVAcG9WkM2y1DnFnGPVF62
	uU9ZIgQSk/0Tmzx4CuJ+Q7600/pa8qeQ6PMA3AC3tNDJy9vRh7frZyu+IOs0ccyE
	Eh2/VR1294kHiHLsLnmm8oB8N1XfmP87BcJ/4TJUbTffdU/7lZYoUBPcZgzeNpmN
	nxCIs2AY7gSHPf1Vu3WfGDetndP7ZmZuiXWgb2rjj9k1T1XFadI7hX8OWx+x34Gu
	ZMxV4zXbDwCDgym0NgiFyEuMxlh2PqqmqF8Xwq2RCaWM39vSG3yvGumIjWq9TkBg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7910rnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:12:49 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M74esI014258;
	Wed, 22 Jul 2026 07:12:48 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnah6381-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:12:48 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M7Ckss15729274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 07:12:47 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9798358063;
	Wed, 22 Jul 2026 07:12:46 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 476FA5804B;
	Wed, 22 Jul 2026 07:12:36 +0000 (GMT)
Received: from [9.123.4.151] (unknown [9.123.4.151])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 07:12:35 +0000 (GMT)
Message-ID: <c2284b5b-47ac-44ad-bdf7-1ed2df715ae0@linux.ibm.com>
Date: Wed, 22 Jul 2026 12:42:33 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 1/3] net/smc: clear the correct v2 slot and
 buffer in smc_wr_tx_put_slot()
To: "D. Wythe" <alibuda@linux.alibaba.com>, wenjia@linux.ibm.com,
        wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-2-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260716113745.65234-2-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: q_f7TrMV8Ad81lxg7oLI9p0YfDM9E7Yv
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a606d71 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=Qe67-9xVIEsA-X6ZM-YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA2NiBTYWx0ZWRfX09kJLylOforb
 rhnPaPQYm9FwcyaOLcLzQeP3Nx/VhivMqaPgtSquL+PFZd6gki+SofiL5sFjmiLXAxszs7IRufl
 YmwEy1Hp6QG888jUKNJJ2NCY3Mmmb7E=
X-Proofpoint-GUID: OzcO3seV1kk119JLSb8TEQIsacxg9lno
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA2NiBTYWx0ZWRfXzoGnjD1xT9B6
 OJUFNDGyxMGg4lt5GlZ9T/EwmZ5vtGHqUiR2TbEB6oLmoBv8ce9he7OPuhfAAnWZNnkSkTAHGca
 e1cWekbwCQkC8cQvY7lfheC+W1To02fEeC+FPrPfu1rbksc3supOzZLwZhSLsBRILyCmUsdAL1i
 MzM4k7+/IFeBpQBOxTntMJUF8I7+Cj7hIb5p8V0hv2hZhrFNrlYBMP4rvZrtWoyoHVr+ddwZ/WV
 3tkcWhJtDk3msoB7uI45QjTilnBZt5YD22+VUxbC33D8GBCbNVtVofBPiihkiAYDFvI+d/A9V9k
 13fx8oW7lW0Sv+UIGe/yOyEo6oMkW/RhYYk4kA5qqgvc7o1KdS9xbHey04diZsrIUJEd+mMvQsF
 mOwFeHBsudR3jcn97I9AO48o3FBgJbk4hkEKL6ZiZ8uEeExVbYcqPCMF0Tlzr+K0s44w1HvKCre
 qUjN2/U/oAoQF9571eg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220066



On 16/07/26 5:07 pm, D. Wythe wrote:
> smc_wr_tx_put_slot() tries to reset the v2 pending slot and buffer with
> memset(&link->wr_tx_v2_pend, 0, sizeof(link->wr_tx_v2_pend)) and the
> equivalent for wr_tx_buf_v2. Both are pointers, so this zeroes the 8-byte
> pointer variable instead of the structure it points to. The pending slot
> and buffer are therefore never actually cleared, and the pointers get
> overwritten with NULL.
> 
> Pass the pointers directly and use sizeof(*pointer) so the intended
> structures are cleared.
> 
> Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_wr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 59c92b46945c..6b5add922993 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -288,10 +288,10 @@ int smc_wr_tx_put_slot(struct smc_link *link,
>  	} else if (link->lgr->smc_version == SMC_V2 &&
>  		   pend->idx == link->wr_tx_cnt) {
>  		/* Large v2 buffer */
> -		memset(&link->wr_tx_v2_pend, 0,
> -		       sizeof(link->wr_tx_v2_pend));
> -		memset(&link->lgr->wr_tx_buf_v2, 0,
> -		       sizeof(link->lgr->wr_tx_buf_v2));
> +		memset(link->wr_tx_v2_pend, 0,
> +		       sizeof(*link->wr_tx_v2_pend));
> +		memset(link->lgr->wr_tx_buf_v2, 0,
> +		       sizeof(*link->lgr->wr_tx_buf_v2));
>  		return 1;
>  	}
>  

Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
