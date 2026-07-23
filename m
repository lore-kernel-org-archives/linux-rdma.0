Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D741378B;
	Thu, 23 Jul 2026 13:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812371; cv=none; b=GynuF3Y1XvokEp2BTnHctS/pblBL8rOTBGvYJtcANaKehlAnf+pedrca/bpStdvPo2wnPBp54RKzo6Dl3Ceuly+8SFzToANM++gO6EBy6YYgBcjXevHlqQ8pZUUX9xfO4CgyImTVIe3faSjJLnH71l7J4nsU6dScvVY2y5Ol+r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812371; c=relaxed/simple;
	bh=nPLm5vbtxa/6skrbj1WW4P9zeJMT2l37VJ8jwNPRY7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EVyuaTS5eHtgncps77sqNpv+jb74FR3rLsPwl/sD8TEYWHHrCrnfczEl7I0C7EXHRoYmLOJk8FK8lFnQRt55SwMIhTZgvPq3o6jZLDRR5jK6I5ru1b9860EWgR7bfeJiHLVsCkTDo5BXSBXj2+1/b/DjrClxPtLE6uqxj4c04e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dSzISsx0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dSzISsx0"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NDBdSO3106079;
	Thu, 23 Jul 2026 13:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TPYGy/
	xnl/LHU5WZ+btVhr5U4MM0vu15yaHT1tSjzbY=; b=dSzISsx0YtcWDLwJTYcVqt
	U/JmKpQdSZ3l0JfPab/n0O81B2ShyuAvYlJvkjaGOngE61hf+/8YZihOnrj47PS5
	H86PDdCs2UWMXnih94EYv9MaMK8yN3X+Ec0GqC9CrehVbXUGyGvvZoLQ1FteBO3I
	mOP4BCzk2YvWgNEaXMO/D9EefTb8vFqwiavomBAFUWWAGG2qtJl3NaL9RT0eqiQ5
	XCtjdSJ+Gq7bhI3fr1VVS6dWP3a1mKdYmbYPoH0FipB1reLVeK6qdIWVYFt0ELhK
	TFuaGwxtr/FOyWtzjSmooMBEOFirbnP9HRDvaTp4DEhOLrTV1NjvfMOJikTsi4bg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7917na1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 13:12:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66ND54qS002423;
	Thu, 23 Jul 2026 13:12:28 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1gm2xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 13:12:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66NDCQug5768176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 13:12:26 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7006D58055;
	Thu, 23 Jul 2026 13:12:26 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00E1458054;
	Thu, 23 Jul 2026 13:12:19 +0000 (GMT)
Received: from [9.124.222.188] (unknown [9.124.222.188])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 13:12:18 +0000 (GMT)
Message-ID: <afe502a5-7c42-4dbe-812b-9b072c819d25@linux.ibm.com>
Date: Thu, 23 Jul 2026 18:42:16 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v1] net/smc: fix socket use-after-free during link
 group termination
To: xuanqiang.luo@linux.dev, netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, wenjia@linux.ibm.com, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
        stable@vger.kernel.org
References: <20260723105454.87016-1-xuanqiang.luo@linux.dev>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260723105454.87016-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: kCVMwniQao9_0EbLoLk5cxzWHwZUUhhP
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a62133e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=dY3EYeySmlwgit32IBUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEzMCBTYWx0ZWRfXx9LxDrli9SQh
 cik11bINIZpIBYumHSvVvj9NpfypiXm58yK5BxZRAdkvfnpg3zHDhBuCWmx5OiYSgDKoIbnBldN
 qSm8fyCFB83Vnotv92MchGdYd9L6/ZA=
X-Proofpoint-GUID: tzS-avqFSH9MMflmHcByKNWOwiI3Ryka
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEzMCBTYWx0ZWRfX3FAkIuMLJjf5
 YAS1/vniHp5Gd9gTTn5JGClzYLfTaFiaALuwLNyDKx5+kzoBLaOj3zTPhfbGMhR7llb7HJoxPnO
 8V7ldPmz+V5loc3BHuAHJ0KKgnclCrl4HkgWXalDfDUyzs+xoOYN2ePDX5SdzBoRvstGNp9+1zC
 x38JoFCPd2uEopoYVQuRp76Qc5gu5cXSK5YvpGmAtsQVQMwcESABpvqExk77kG85A9Rgi97Y6m+
 MC3WYckd6eYIElmEOJ41Kr0Kpr6g3DzSjjxdjeFoZC1u/josPoitT+Ym1Ak63rU/tXVGOZDqUTp
 VwWfMBwCozYOxLEUnKLcAdvDGZqgsU5EfKw+vH2/jcSX2qsvm4Wkes9+RTr3alt1RbZuBmBfsTl
 gB3H6pFeKfsVqT4ptYPcpCzyNc7uROAEAMuJS84nIWPpZ+u4kXUOnygEMmSevUMjSpZsnAlOfyk
 n46/xAreY0HJasvHDuQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230130



On 23/07/26 4:24 pm, xuanqiang.luo@linux.dev wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> __smc_lgr_terminate() drops conns_lock after finding a connection in
> lgr->conns_all, but before taking a reference on its socket. The connection
> is embedded in the socket, and its registration reference protects it only
> while the connection remains in the tree.
> 
> A concurrent close can unregister the connection and drop that reference,
> freeing the socket before the termination worker reaches sock_hold().
> 
> The race is reachable when close overlaps link group termination.
> Local stress testing reproduced the use-after-free and KASAN reported:
> 
>   BUG: KASAN: slab-use-after-free in __smc_lgr_terminate.part.0 [smc]
>   Write of size 4 by task kworker/3:3
>   Workqueue: events smc_lgr_terminate_work [smc]
>   __smc_lgr_terminate.part.0 [smc]
> 
> The socket was allocated by smc_create(), freed through
> slab_free_after_rcu_debug(), and was followed by:
> 
>   refcount_t: addition on 0; use-after-free.
>   __smc_lgr_terminate.part.0 [smc]
> 
> Take the socket reference while conns_lock still protects the tree entry.
> The unregister path then cannot drop the last reference until termination
> has finished using the socket.

The race description and fix look correct to me. Taking the socket
reference before dropping *conns_lock* closes the window where a
concurrent close can free the socket before sock_hold().

> 
> Fixes: 69318b5215f2 ("net/smc: improve abnormal termination locking")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

> ---
>  net/smc/smc_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index cf6b620fef05f..b4208cb186c5e 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1572,10 +1572,10 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
>  	read_lock_bh(&lgr->conns_lock);
>  	node = rb_first(&lgr->conns_all);
>  	while (node) {
> -		read_unlock_bh(&lgr->conns_lock);
>  		conn = rb_entry(node, struct smc_connection, alert_node);
>  		smc = container_of(conn, struct smc_sock, conn);
>  		sock_hold(&smc->sk); /* sock_put below */
> +		read_unlock_bh(&lgr->conns_lock);
>  		lock_sock(&smc->sk);
>  		smc_conn_kill(conn, soft);
>  		release_sock(&smc->sk);

