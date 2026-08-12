Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897004570DA;
	Wed, 12 Aug 2026 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545875; cv=none; b=hp761l9WA92qqKMhhrf6HGQwE4Qq0YpXSht0m8Ipt3uMrHl9ll/qpEauAcqZFqhla3n/3KEgVtGFyVezlD3tVSmFyZavKOX55qGlD4fIdlmVKdxlRiyVdtaGnqQIK7hJ2PiwV1fvXxeTyuKu6HQPJZQ484x4OusF0Vtix1CFZjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545875; c=relaxed/simple;
	bh=KOxnVU4XsTxjrHiTBzYsMrKq0Z0mba5pmmuMt/CJCVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R0Y7bn99rM/l9jicXSvBskX6p6YjLcVoTVLosqa4zwngk7H3WeJRQfiNcF4wYB/XUElD0ezEdEms4JoHz+pEojIS29BLrccdyNMHZKOxIdfeWArhlTXF0zDFSNox7DA0LxXDMR+bPYiXNcjpp1CUzNwY5hFwwNU7xn2BdkNlAuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ov7oNDEP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ov7oNDEP"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CE1RgS3686384;
	Wed, 12 Aug 2026 14:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Nga4Iz
	GXPEla/M65LkxkY2vFyiFXLjbUZl5bMU5LDYI=; b=Ov7oNDEP6hsN4R5bHdDEhO
	g3IPijtjNtT+jGXRwKiNWcgr3H3gFiaLqYheKxFggwlwxpVL9DfgxeRNXb2ytpZS
	yXxqZH1El1Y5tEgL352lYtZmHf2tf1x2PRyGOwD7JCtOT5koMVSC0c9Dh87jvveL
	0apZKFeMS1IbJXMH9tBF6AX4ILLNbHhp8HQ+0vEXi2CfLpVVzVoyEUUFEjTb2tm9
	OGAl5ww4l8C5DkKQKL4gTvQICkJF3bFM5ClU0BBHI/6ttY0BRB/LFRjys086aZ/A
	HJuyKH93yaPage8sRRJyZ07RIWETXPdBkJtogeDgYaBxnpQd0jKPgO7O/CWvDuwg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvm9u15n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Aug 2026 14:44:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67CEfHbW032081;
	Wed, 12 Aug 2026 14:44:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxh0gebdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Aug 2026 14:44:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67CEiTdO44368220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Aug 2026 14:44:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42DB920043;
	Wed, 12 Aug 2026 14:44:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F14B420040;
	Wed, 12 Aug 2026 14:44:26 +0000 (GMT)
Received: from [9.39.26.209] (unknown [9.39.26.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Aug 2026 14:44:26 +0000 (GMT)
Message-ID: <5c80dd63-80bb-424b-894e-2f4ca3a5568b@linux.ibm.com>
Date: Wed, 12 Aug 2026 20:14:25 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/smc: release the internal TCP sock on IPPROTO_SMC
 socket creation failure
To: Chuyf26 <Chuyf26@linux.alibaba.com>, alibuda@linux.alibaba.com
Cc: dust.li@linux.alibaba.com, mjambigi@linux.ibm.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260812071543.C94FD349CD8@smtp.subspace.kernel.org>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260812071543.C94FD349CD8@smtp.subspace.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDExOSBTYWx0ZWRfXyp/3PN77Kjr7
 wR856fW4jJsM1evQCyZwKLpKWoE95arDekrKEyjk3pWQeG59dpDohSBaqm32eI/M1+GAWZ3EMo9
 iiX27hTXo/ME/q3QnPBJQF8Z1HoUrEx/Yww+nkOsa2I4uPSjieW3/ZlKfsgUuUs5rSXeN9oCHF2
 LxN1hKm0fwGgfdrZfbJp3Tw2na77jylm0NzEP/Hbymmhm+SeZat3F77BdTqPTC2iSzzbE/gdP90
 F5AvMqXR7d2nrg5pAncFQ90NM58VHJTAfFjNkvcABhl85POPgymZp9GnPMiNtkJ1SpSg7mtDASo
 csP56/rCa9pvb76wL7FKZ5lufrEcLrXwUzTNfaPFMRTrtqAHNoUOOu14x5ilt2QFnL6ynQp20qy
 yL9Rt/VilZha8GwCs6iFDwfUdQxkuMhXZPRWsvGD/713TU/IWj31L9e1zNmhvpGiD1Y/CX6Wcuc
 4qZlxxaML9O525sGicA==
X-Proofpoint-ORIG-GUID: u5JVFy_OFIhT4s3zXHMt0z5hH-H_608H
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDExOSBTYWx0ZWRfX+BrTQ0imPvgd
 nVDzOnJzx850iz3KbmwSBRFiwX1nTdd6NhReemWzRx18TW/K9AO3RPI2GGQTx0nToHLoPFDUG1L
 3svJcEJM0ZSSpWKWffRkFgx7t42nBLY=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7c86d0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=SRrdq9N9AAAA:8
 a=I6kgrEg1N8Mqh0EC74gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mlO8cGyNYYQjoNHCmfPvgqPvkIaWsQQe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120119



On 12/08/26 12:45 pm, Chuyf26 wrote:
> IPPROTO_SMC sockets wrap an internal TCP sock ("clcsock"), which is
> created by smc_inet_init_sock() via smc_create_clcsk() from the
> proto->init hook of inet_create()/inet6_create(). When socket
> creation fails after proto->init has succeeded - for example when a
> cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE denies the
> socket - inet_create() calls sk_common_release(), which only invokes
> sk_prot->destroy if it is set. Neither smc_inet_prot nor
> smc_inet6_prot defines .destroy, and the sock destructor smc_destruct()
> returns early unless sk_state is SMC_CLOSED (it is SMC_INIT here), so
> the internal TCP sock is never released.
> 
> As a result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC)
> call leaks one tcp_sock. Any unprivileged task able to attach a
> deny-all BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup (or a
> task confined by an LSM policy) can grow kernel memory unboundedly.
> 
> Reproduced on v7.2-rc7: with a deny-all BPF_CGROUP_INET_SOCK_CREATE
> program attached, a loop of socket(AF_INET, SOCK_STREAM, IPPROTO_SMC)
> calls fails with EPERM and kmemleak reports one unreferenced tcp_sock
> object per call.
> 
> Add a .destroy hook to both IPPROTO_SMC protos that releases the
> clcsock via smc_clcsock_release(). That helper is safe here: it takes
> the clcsock_release_lock initialized by smc_sk_init() and skips a NULL
> clcsock, which is what smc_create_clcsk() leaves behind when creating
> the TCP sock fails. Also initialize clcsock to NULL at the start of
> smc_inet_init_sock(): the smc_sock slab is SLAB_TYPESAFE_BY_RCU, so
> recycled objects are not zeroed and stale memory must not be handed to
> sock_release().
> 
> The same behaviour is visible without any debugging option: on a
> plain kernel the slabinfo "TCP" active_objs count grows by one per
> failing socket() call and never shrinks.
> 
> With the fix, the same reproducer leaves no unreferenced objects in
> kmemleak and the "TCP" slabinfo count stays flat, and regular
> IPPROTO_SMC socket create/close cycles are unaffected
> (sk_common_release() from inet_release() also routes through the new
> .destroy, where the already-NULL clcsock is a no-op).
> 

The fix looks good, but I think the commit message is longer than needed
and spends too much space on reproducer details and internal call path
narration.
I would trim the detailed reproducer/results text and most of the
internal call path explanation, and keep it focused on the leak, the
failure path, and why adding .destroy plus clcsock = NULL fixes the issue.
If you want to keep the reproducer and validation details, please move
those below `...` instead of keeping them in the main commit message body.

Thank you,
Sidraya
> Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Assisted-by: abaci:qwen3.8-max
> Signed-off-by: Chuyf26 <Chuyf26@linux.alibaba.com>
> ---
>  net/smc/smc_inet.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
> index a94084b..b94a194 100644
> --- a/net/smc/smc_inet.c
> +++ b/net/smc/smc_inet.c
> @@ -15,13 +15,16 @@
>  
>  #include "smc_inet.h"
>  #include "smc.h"
> +#include "smc_close.h"
>  
>  static int smc_inet_init_sock(struct sock *sk);
> +static void smc_inet_destroy_sock(struct sock *sk);
>  
>  static struct proto smc_inet_prot = {
>  	.name		= "INET_SMC",
>  	.owner		= THIS_MODULE,
>  	.init		= smc_inet_init_sock,
> +	.destroy	= smc_inet_destroy_sock,
>  	.hash		= smc_hash_sk,
>  	.unhash		= smc_unhash_sk,
>  	.release_cb	= smc_release_cb,
> @@ -68,6 +71,7 @@ static struct proto smc_inet6_prot = {
>  	.name		= "INET6_SMC",
>  	.owner		= THIS_MODULE,
>  	.init		= smc_inet_init_sock,
> +	.destroy	= smc_inet_destroy_sock,
>  	.hash		= smc_hash_sk,
>  	.unhash		= smc_unhash_sk,
>  	.release_cb	= smc_release_cb,
> @@ -109,6 +113,14 @@ static struct inet_protosw smc_inet6_protosw = {
>  static int smc_inet_init_sock(struct sock *sk)
>  {
>  	struct net *net = sock_net(sk);
> +	struct smc_sock *smc = smc_sk(sk);
> +
> +	/*
> +	 * The smc_sock slab is SLAB_TYPESAFE_BY_RCU and recycled objects
> +	 * are not zeroed. .destroy may run even if .init never completed,
> +	 * so make sure smc_clcsock_release() sees a valid clcsock.
> +	 */
> +	smc->clcsock = NULL;
>  
>  	/* init common smc sock */
>  	smc_sk_init(net, sk, IPPROTO_SMC);
> @@ -116,6 +128,17 @@ static int smc_inet_init_sock(struct sock *sk)
>  	return smc_create_clcsk(net, sk, sk->sk_family);
>  }
>  
> +static void smc_inet_destroy_sock(struct sock *sk)
> +{
> +	/*
> +	 * If inet_create()/inet6_create() fail after .init has created the
> +	 * internal TCP sock (e.g. rejected by a cgroup BPF program),
> +	 * sk_common_release() ends up here. Release the TCP sock, otherwise
> +	 * it leaks on every failed IPPROTO_SMC socket() call.
> +	 */
> +	smc_clcsock_release(smc_sk(sk));
> +}
> +
>  int __init smc_inet_init(void)
>  {
>  	int rc;

