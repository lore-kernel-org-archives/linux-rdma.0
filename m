Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8D539D3D3;
	Wed, 26 Aug 2026 07:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730178; cv=none; b=acmGf53Pm47GZitzdzbKjriubjNb9B1VWnwPK5h2PJr+leZPowFKoPQkcxotriU0Ai2O/SB7Y83ane5Tu08UGlPZStq724x2DM+hnUruA5uDpmRKHb0cZYEtrR+ZjJKd3r2L5Fno+XDbQeFYj35gU2qN45/2Iye4tdYPRRQIcw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730178; c=relaxed/simple;
	bh=ceupSl+HG+4+99koEvi/7l9ZGEHV5mrxj1j8iGg8UbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fO6P6Udlf2CJjWdRJOL4YZKEPyks21rrBaK8lgSG1Wu8Ul/Fn6vNA0Mg22pjlvHzHcse5Cnh3TrNxJv8e4CrhZOn4KwMAMyaYhwltiBbLS0i38IWTcAAWQAt/hHmil0ae3cvwDvBxoiWfM5zocBpT+Rx1OzV0lXL7QEOcI4d6tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FlS5K0ns; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FlS5K0ns"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787730166; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ceupSl+HG+4+99koEvi/7l9ZGEHV5mrxj1j8iGg8UbQ=;
	b=FlS5K0nsS2plQEiyGYi6vVxOdEdZ9VPDayetjz5QtQrcTE1sjDT0N5RU9CjVXWr1d1CmIG4vsyWcrJurP4W9A4JtgCV0hZg+8O8xMZBMoH9onby1Cdj9HVpXdewX4CW2ZlYDxQbK/echXJQtSbBeAYsjRA06FlWiT1Bu9kpDXy4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X9gH55O_1787730164;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X9gH55O_1787730164 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Aug 2026 15:42:45 +0800
Date: Wed, 26 Aug 2026 15:42:44 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Yifei Chu <Chuyf26@linux.alibaba.com>, alibuda@linux.alibaba.com
Cc: sidraya@linux.ibm.com, mjambigi@linux.ibm.com, kuba@kernel.org,
	pabeni@redhat.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4] net/smc: release the internal TCP sock on IPPROTO_SMC
 socket creation failure
Message-ID: <ao6Y9P24-tnV3VVo@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <178753843966.342810.566471390946765094@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178753843966.342810.566471390946765094@linux.alibaba.com>

On 2026-08-24 10:27:19, Yifei Chu wrote:
>IPPROTO_SMC sockets create an internal TCP sock ("clcsock") from the
>proto->init hook. When socket creation fails after proto->init has
>run - e.g. a cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE
>denies the socket - sk_common_release() only invokes sk_prot->destroy
>if it is set, but neither smc_inet_prot nor smc_inet6_prot defines it,
>and smc_destruct() returns early unless sk_state is SMC_CLOSED. As a
>result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC) call
>leaks one tcp_sock, so an unprivileged task able to attach a deny-all
>BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup can grow kernel
>memory unboundedly.
>
>Add a .destroy hook to both protos that releases the clcsock via
>smc_clcsock_release(). smc_sk_init() hashes the sock into the smc
>hashinfo before the clcsock is created, and smc_diag dumps walk that
>hash dereferencing smc->clcsock without taking clcsock_release_lock,
>while sk_common_release() calls .destroy before .unhash. Unhash the
>sock before releasing the clcsock, as __smc_release() does, so a
>concurrent dump cannot observe the release; the second unhash in
>sk_common_release() is a no-op.
>
>Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
>Reported-by: Abaci <abaci@linux.alibaba.com>
>Assisted-by: abaci:qwen3.8-max
>Signed-off-by: Yifei Chu <Chuyf26@linux.alibaba.com>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

