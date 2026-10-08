Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C181472F78;
	Thu,  8 Oct 2026 08:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449626; cv=none; b=ErK3sFJMMxrVvXy9kT3wE2ONCtU3VUFza/GRf5vEY7M0y+f1jhIPglxgwummMyQMHroEMKUn4CXagZ9KK2TdpgYVdLZLUwIORFwiljcpr11DSwYdE1m/guxl4990uPF7p+8KsZGRP3FKIr9g3ZMirvi3A1BR/wQJlJW+ZZJpEd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449626; c=relaxed/simple;
	bh=O3YnTtbd10Xw9sLF9/frn1oBli2TWFOYF+69kuWOGAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VZJ30OgKgpaZ2uxdywZ4Bpd88opcz0mz22MQowdfXbK+FWcN97LJCgw7pwuPz22Vr/kmcoz9UCULTSRdpNyxKXSYHrRh8HMvRzD29iDsYDIcUdK+ERq/rWtmonwmEYaa0ne3kVI/DajkzjEzoSyzVENgm7ILgF2KwucomeamYK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U13CQPwD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U13CQPwD"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987Zbav731290;
	Thu, 8 Oct 2026 08:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yCaVqR
	c9yjueH1hFzVHbm+BxIaJ3wN3cQfVAJe78FX0=; b=U13CQPwDK8MQKGtwN1EIBt
	VpZ2M5+3kmu+1U9A1ehMofwC2NySsm3QwhBMeZl54kFRmyVNTXkBpgBQrFgvuhb0
	OKD/kcWTr6yv0iXjZmZpnIXCR7vLMdzTsXqLaFlbaaHQKv6/vWb2TM4gkVK65vbg
	Cj4DYX/TBiEC+B8BjvV9CF8tHjWNvJg4GAYq9JSzmJnrzy1wnFVTFsGY6t7YFVSJ
	W2IIaZkuQzu814T2sQ8eTrs3GMQiolm19+f7dyTD5D+F79RopHwU5KY1X/NEm3le
	OrUk7N60t/uDXPWnkFlJq7SOO5tZ0HASy5wpzlRXh8WnTkJRbB3vdAAkm6S/trCg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjvj9jg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 08:53:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6987XMQo3111519;
	Thu, 8 Oct 2026 08:53:38 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h5s34u5fp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 08:53:38 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6988rbFQ49348886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 08:53:37 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C9E158090;
	Thu,  8 Oct 2026 08:53:37 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B6B45807C;
	Thu,  8 Oct 2026 08:53:31 +0000 (GMT)
Received: from [9.124.217.43] (unknown [9.124.217.43])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Oct 2026 08:53:31 +0000 (GMT)
Message-ID: <b70659c4-c1c1-4e73-b67b-0b1ad3dc61ef@linux.ibm.com>
Date: Thu, 8 Oct 2026 14:23:29 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] net/smc: protect clcsock lifetime in smc_getname
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
        "D . Wythe" <alibuda@linux.alibaba.com>,
        Dust Li
 <dust.li@linux.alibaba.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20261008084444.787449-1-nicoyip.dev@gmail.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20261008084444.787449-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: agaMw4ZeHjn_ip_txaBPouXLAjfGHefl
X-Proofpoint-ORIG-GUID: f9Z4xotu3fH-_uc5RIHv87pvYPVXRxqn
X-Authority-Analysis: v=2.4 cv=FoOQbGrq c=1 sm=1 tr=0 ts=6ac75a12 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=slhZEP1NsPBYwTPRAy0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzNCBTYWx0ZWRfXzFN9isecd6OQ
 mt9jAmc/pDedw9fwnVBTLcAakBF/tSqxahfg1zL2h6og6qWSpYyvh9H4R3fmMxBkX71LDwN33tR
 jyMdjydcqlTHrMCNvmNyk6qHeMaGHzw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzNCBTYWx0ZWRfX7KCiUly/dDUz
 3DtblOTSwHiwrUDAe7xgYQNiiesIbd0Bx7Eaakscf9DZK+zZpcAwnxGPc4YX0sIS4f//e7JRG7Y
 TN42s1DIP+d1uwz/jb4i2qCV3KqpIgD0LlJlMk1cLsnUFVvAMbrJx3wBU1n5Kv2EI5T4zzI7eec
 NkX4AdspB2ZKZhN/na1jJspOmXLzAQ3k1tzaYdXlvxZNryxlZiYVHXBIGxMWZ2SuQMy1priaiGJ
 7/a3gvs6Tjg0XeNiTMb081IBkBbOy6RKJoP87H7s2oC263gMsp2Htmg55VJaZx2el/2Ua+xPpos
 Em9sloNcw86brVzr82RBPhTafjQ3kDiw7TO0SBRssb2vYSiNYTwvDLlX8TkXIuexQIfVFqB4T3/
 QtvHMs30gyt3NfJ1HyRxb8hRQGcB7cvtgySNUFtRPWPlsvoXUCvypIUBoE6lfpG+x0aUyQ9kTfG
 VrRJ2wE4o7Osj9ACpzA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080034



On 08/10/26 2:14 pm, Chengfeng Ye wrote:
> smc_getname() dereferences smc->clcsock without holding
> clcsock_release_lock. Link-group termination can release the CLC socket
> through smc_close_active_abort() while the SMC socket is still open,
> for example after shutdown(SHUT_WR).
> 
> A getsockname() caller can load smc->clcsock, then the termination worker
> can clear the pointer and call sock_release() before the caller accesses
> clcsock->ops or invokes getname(). This causes a use-after-free; if the
> worker clears the pointer before the load, it causes a NULL dereference.
> The syscall's file reference keeps the SMC socket alive but does not
> prevent asynchronous release of its CLC socket.
> 
> KASAN reported the following with test-only timing instrumentation:
> 
>   BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
>   Read of size 8 at addr ffff888109abb4e0 by task poc/103
>   Call Trace:
>    smc_getname+0x19e/0x1b0
>    do_getsockname+0xe5/0x170
>    __sys_getsockname+0x8c/0x100
> 
>   Allocated by task 95:
>    sock_alloc_inode+0x1e/0x280
>    sock_alloc+0x3d/0x240
>    __sock_create+0x7e/0x430
>    smc_create+0x121/0x240
> 
>   Freed by task 0:
>    kmem_cache_free+0xcc/0x340
>    rcu_core+0x50a/0x1850
> 
>   Last potentially related work creation:
>    evict+0x446/0x6c0
>    smc_clcsock_release+0xa8/0xd0
>    smc_close_active_abort+0x26a/0x3a0
>    __smc_lgr_terminate.part.0+0x137/0x2e0
> 
> Hold clcsock_release_lock across the pointer check and the getname()
> callback to serialize with smc_clcsock_release(). Return -EBADF if the
> CLC socket has already been released, preserving the existing peer
> state check and the callback's return value otherwise.
> 
> Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> ---
> Changes in v3:
> - Limit the fix to smc_getname(), as requested by Mahanta. The code
>   change is identical to v1 and uses the existing release mutex.
> - Drop the new clcsock_lock and the other v2 changes. Mahanta will
>   address the other readers through the broader CLC lifetime changes
>   discussed with Dust Li.
> - Rebase onto current net/main; keep the stable Cc.
> 
> Review:
> https://lore.kernel.org/r/4bb7f15e-2cd8-4598-9bab-1ea5f5d2bb59@linux.ibm.com/
> v2:
> https://lore.kernel.org/r/20261003183325.2289707-1-nicoyip.dev@gmail.com/
> v1:
> https://lore.kernel.org/r/20260926180404.2721010-1-nicoyip.dev@gmail.com/
> 
> Validation: W=1 builds of net/smc/ passed with IPv6 enabled and disabled.
> The KASAN excerpt is the original report; no runtime test was run for v3.
> 
>  net/smc/af_smc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e9f93b3ab435b..8b3ee70f8433f 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2784,6 +2784,7 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
>  		int peer)
>  {
>  	struct smc_sock *smc;
> +	int rc = -EBADF;
>  
>  	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
>  	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
> @@ -2791,7 +2792,11 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
>  
>  	smc = smc_sk(sock->sk);
>  
> -	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
> +	mutex_lock(&smc->clcsock_release_lock);
> +	if (smc->clcsock)
> +		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
> +	mutex_unlock(&smc->clcsock_release_lock);
> +	return rc;
>  }
>  
>  int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> 
> base-commit: 6d25ffca055a77787c21a36b66c253f76239411b

Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

