Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48830D411;
	Wed,  5 Aug 2026 06:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911188; cv=none; b=DkrDbNxEBw+1WGmDBjlKec9Yc2wAIjtwU23Mtz/vT2RTCAOTTTjNG5hcvJHIT7pkmfC5xmDc1UXhBEuBzQC89zUd5QKik8Y/0t5fVC/8a5yl/UbWmThUTqGcKUf/sEHqhQCG9TtemvJnsNii3w/b5n1H9zH7maWbsxPHz+MSj0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911188; c=relaxed/simple;
	bh=PNsMA9R42MmvA5cRDbfTSqilYpttCRmEzXJmYfqGKxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mdz61BWWrDekyvmB7jap9FMZOLWQZMEFI3I4XhKBZ2GEJnD3MVxoU80kqWGLJC6KLlxhpfzLT/aNj50PRpJfYEghTzWK3yic4P8R2bxgS6ph+HWjrfXUH2PD/swwhX6P+nKHjX119k6F0bG1E8kCt6zVolBhvSif15tQxXokGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OEOn6US7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OEOn6US7"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755m4aw3005713;
	Wed, 5 Aug 2026 06:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=j6PbpK
	L3xhLCleMb6lUTk/vq9RjH1F8YA16D3eRYEA0=; b=OEOn6US77Wyb5iDxXDte1G
	2pmq3FCspueNnZg7k/+/DWcuqvmhaxGzE8ZoWCnBC6m5tUsmYA1rALytd6K3oIMT
	F/p4oCAujcBt0jpWt4OA2+TiE/3HEXDby8YylaSPuIdI6LaDZRxBUHDRFllLtfiW
	GYFUym7mRk8eOOA3GL/GxgIUvvRbCQjkqrEjGLanAXIdNZnCvQVMxxrnEiOxrTZn
	kPfeRomtvn+V/rc2iPIs0baQ0Uld/CHy47WMTmkahNwznth9OvdEe9cpSAN31kgT
	a1HvrWD41ZScppfOgbDnaY1nybYYw9x2YF4j+q+qwppEivT86kf7+Z3EYCl25YKA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51mr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:26:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QPkH010728;
	Wed, 5 Aug 2026 06:26:25 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw5e54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:26:25 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756QMW564946574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:26:23 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92FA25805A;
	Wed,  5 Aug 2026 06:26:22 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEC9058051;
	Wed,  5 Aug 2026 06:26:17 +0000 (GMT)
Received: from [9.123.4.72] (unknown [9.123.4.72])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:26:17 +0000 (GMT)
Message-ID: <905fe2d9-a8c9-4047-82af-6f530d024ba2@linux.ibm.com>
Date: Wed, 5 Aug 2026 11:56:16 +0530
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
 <sidraya@linux.ibm.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260804213917.3413525-1-gyf161023@gmail.com>
Content-Language: en-GB
From: Hidayathulla Khan I <hidayath@linux.ibm.com>
In-Reply-To: <20260804213917.3413525-1-gyf161023@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXw40AjIgpsswE
 DKZ9jxK2i/2S1mWl9Pytm1dAADrpJGRN9UXejrGEqoocKkjs69QChBSKDPU8Il7oTKQ7mn03TEW
 OToKKrT7tqOLHoub1maSn2z4QNJUqq4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX1SlNoHYxe1ok
 ckeAY6LdsH60nZuku9U3GLiNp6hcpqLqq/UVxq50Q+uTJu1U3Psmhi8chap2ypKXLCBlCkqmrvW
 C/d+88kxkssGPcg210HHFBaJPvhV9rRrqxtLkAUwT948fiVqs09Xgb5oixtN9AvX/oAdTxww+2D
 UPxNdGkUnXx/tM+/gTe9aDAisQV9kTd2LhMIpWiMjIWpFed7xMpnNv2h2WgoNo8gIkxv+VCPN0T
 5KBLF3l7ulMwdAlYaH+n4xyvl/Ta1Oa0A0Sw2yN0ZgWO3Zawks8JXZ34VzAwvw+ktI9otcxwq0r
 YDKGR4mE87i+DfXEg+AUSFYVhaRm4ZL8HSfielg5DHFeer4SyUOUki3BX8eBxjKPmI5J/i7hg0U
 oHDHnzZrUK/t/DG41JdJlEWEqVvUxUzhABn45ulKPaBW1muYFV83sf5GCtoh5KQsvfqiJIHSRPY
 FqUUGbqK5Cr8dtl5IvA==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d792 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=h0Cf4ckhx-fnnXdm7CAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: hm7exjQLvOy1koeT6yIdPd4NvjDhjvs3
X-Proofpoint-GUID: LP8eRiaH7bek0YrRrjxMggDB2oLXQIqi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047

Hi Yifei,

Thanks for looking into this.

Yes I have submitted a patch for the same issue.
https://lore.kernel.org/netdev/20260804082800.498672-1-hidayath@linux.ibm.com/

Hidayath

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
>   net/smc/smc_core.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index cf6b620fef05..04c6ce608ec7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1148,8 +1148,10 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
>   		read_unlock_bh(&lgr->conns_lock);
>   		/* pre-fetch buffer outside of send_lock, might sleep */
>   		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
> -		if (rc)
> +		if (rc) {
> +			sock_put(&smc->sk);
>   			goto err_out;
> +		}
>   		/* avoid race with smcr_tx_sndbuf_nonempty() */
>   		spin_lock_bh(&conn->send_lock);
>   		smc_switch_link_and_count(conn, to_lnk);
