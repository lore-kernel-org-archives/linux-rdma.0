Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4E83B05A9;
	Thu, 13 Aug 2026 06:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786602336; cv=none; b=MX/AZssF8EY0xOsaIg7bW2f03K2yGqRc3UWclb978o2XXol9bYz3JZKPJ5lrAe6P87R44Y4WoRcDTwQpVLqdvOAX6CExxhO1ycBQZvOMgBSfBA0HoZvVh+pG7RLrVpEhBeROzaPU5zma01N2hw2SccDcdGEdgWS37UQy3jUlrps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786602336; c=relaxed/simple;
	bh=svxibkFDugFYlu9QZQNXaO7VDzJlKkHSVEUzwQo4D9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LqZQ44m7NnP0LAPvgbO0Dfd01n/caVygIc2/kYMP5+h8tkfQz+WJW6vTGAdV0ytmh4FfNyj3TXf5DXOFCPSgxu3wnOTriQX+iL2g5xRCoWmJ1VNzjtyVKpFoWxTuSC1TxjHjC3oeEk1hhfEI50UxLM+UW5mMK4Y5vczm4OHieAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gjn+ZrNz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gjn+ZrNz"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D61aWB1476562;
	Thu, 13 Aug 2026 06:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2bJFtk
	7IHCxsJ0zcnv89FCN+lwd2doS7mdHj/JpuX8U=; b=gjn+ZrNzBVthdGKCFwvBoQ
	66BDr2tO71ZfZww20yQyJJxjqQU8XFGf0KmU/dbTVoxp9JRsSlGS9f1r8KGs+bD0
	gQSByg6P0H4NdUFaLJeLbvkgJlBxGleEAtk+XJPBO5+k/StlWQYFcuJcPAlRppeK
	uR2fTLU5w4KShjFMPsTEU9DWfE0RnVdvJO0fGpGVkrvXXhdPycEs/lW6+atvjW1M
	B30g505PyFlu8uSbMvcifnAgwJ/GIU/F8d8cxbRk2nQ+w2+BVULmcebDtwGZvRJG
	fVQWzUwr9kAfQUr5Az7gBiPdjX0SR7Z6dkr14yjPoT2zthwz9XjOuEok67k2GjTQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvq9pgsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 06:25:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67D6BIF7030873;
	Thu, 13 Aug 2026 06:25:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxhfy9mk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 06:25:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67D6PVFM44040568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 06:25:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61F4220043;
	Thu, 13 Aug 2026 06:25:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB89D20040;
	Thu, 13 Aug 2026 06:25:29 +0000 (GMT)
Received: from [9.123.7.41] (unknown [9.123.7.41])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Aug 2026 06:25:29 +0000 (GMT)
Message-ID: <def186fb-0eb9-4751-9e39-64eaa4828759@linux.ibm.com>
Date: Thu, 13 Aug 2026 11:55:28 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] net/smc: release the internal TCP sock on IPPROTO_SMC
 socket creation failure
To: Chuyf26 <Chuyf26@linux.alibaba.com>, alibuda@linux.alibaba.com
Cc: dust.li@linux.alibaba.com, mjambigi@linux.ibm.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20260812071538.o7mdtMhZ1eOzDgQnKZduQfWlq0FhL7OCAPLjt9AA11w@z>
 <5c80dd63-80bb-424b-894e-2f4ca3a5568b@linux.ibm.com>
 <202608130604.67D5j4VU1508130@pps.reinject>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <202608130604.67D5j4VU1508130@pps.reinject>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: SBYSLgurU5WTwC2xFrb2mxNAsoVTR5JY
X-Authority-Analysis: v=2.4 cv=PbDPQChd c=1 sm=1 tr=0 ts=6a7d635e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=j67ANBCWoueUEsnO-3cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDA0MCBTYWx0ZWRfX+ycxAa8jrfqW
 Sp2tffj7jiuZg/rSyhQQ9AfsnahFpIE8fguky9vpjztGPw98FXUsJp0LQijeWMJPleRR2QCJ01s
 VmR1I97B4BnzOe2QyIMTajpd8SBLS//hJqJ8CuMiaRoDxpvPz9T9mb/wscX/W0criVCQyfhskYN
 X5rLv8loCBPbxbwhavCTw5ZmbL6SJN+QUOR/GzvUVu/BFlwpta1bGHykE5eq91j0eMA49Aefa88
 Woh2HuPphwFIwJCU7l4NVqzKVZRppnYANJxQ9alviXt5FSdkqZTVX+un/I6VTzzJbS9Ywv0yP1E
 a9lhVGzaeQ8foyw8tu/20lrNofdPQwLGYDglGs8e0FmcHYq9oqXq6oJZp44wz3mGjw6smQ1GIeU
 llRzJXwG/yWNJHGHuJJVNHXfwiwKvGqdsS3/8M3/vHW2vrypT8SLGiKVagBtrob/umtZYpQLfn7
 tMHMlNmE0r8J8TU5Vdg==
X-Proofpoint-ORIG-GUID: tooYW2aGgfQgEkQHhGN7pcdCTP5tWg6X
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDA0MCBTYWx0ZWRfX7RaF8vC1CwVw
 moXmqWBWcwzgYxV2oR5XcKwrLSJ7/Mns/M0L7xXN41Mq3KFCFlJQWgahbTPySCeur9Fkys1wQdG
 Wbk8c10C9PzPyiB3ELAYlMU3W9sJwT4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608130040



On 13/08/26 11:34 am, Chuyf26 wrote:
> IPPROTO_SMC sockets create an internal TCP sock ("clcsock") from the
> proto->init hook. When socket creation fails after proto->init has
> run - e.g. a cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE
> denies the socket - sk_common_release() only invokes sk_prot->destroy
> if it is set, but neither smc_inet_prot nor smc_inet6_prot defines it,
> and smc_destruct() returns early unless sk_state is SMC_CLOSED. As a
> result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC) call
> leaks one tcp_sock, so an unprivileged task able to attach a deny-all
> BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup can grow kernel
> memory unboundedly.
> 
> Add a .destroy hook to both protos that releases the clcsock via
> smc_clcsock_release(), which is safe here because it skips a NULL
> clcsock under clcsock_release_lock. Also initialize clcsock to NULL
> when setting the sock up: the smc_sock slab is SLAB_TYPESAFE_BY_RCU,
> so recycled objects are not zeroed.
> 
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

Thank you for fixing this.
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
