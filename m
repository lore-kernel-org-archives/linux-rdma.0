Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA43C246762;
	Tue, 16 Jun 2026 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781572716; cv=none; b=ivn3nE4KuPuptFpLQo7QDxfGZajHaw//UW9ieeaKX7/hGzoNlQbmf+h69b/+9+K5/F8lDVq+wSAJXhFfJHPliC41vLPV0RnXn5LIDmcE6bQ8/mRM/2wc7i7HUmVOLRspD/4szTkMkPQDzWa5GU62DMtH0CvAJGyhTvv6GqkgLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781572716; c=relaxed/simple;
	bh=z3Bi8ixE7Fg35E79/serkDEQjKt+sNDRES5kU+jWHpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wvv6+p8Y6QKLfSH3HXNXWDAUX49TI4k7uacW5porJsJAfCXBkZHgfX1DWkgDDRPpSbS+qsI5MSCOB0QRd3ezzE7rO8JhIxtMl/Z4SopwFygPDI5+x6Z65LSsQeHv0e/zwHiGbgPDwpGqTd9XxbKpl7b3xCk75ZvOaXtm6BRT6wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hust.edu.cn; spf=pass smtp.mailfrom=hust.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hust.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hust.edu.cn
Received: from hust.edu.cn (unknown [172.16.0.50])
	by app1 (Coremail) with SMTP id HgEQrAD3_SlVpDBqeHimAA--.44228S2;
	Tue, 16 Jun 2026 09:18:13 +0800 (CST)
Received: from [10.12.169.118] (unknown [10.12.169.118])
	by gateway (Coremail) with SMTP id _____wD30BFTpDBqCpcmAA--.24027S2;
	Tue, 16 Jun 2026 09:18:12 +0800 (CST)
Message-ID: <bcf4351e-771d-4c60-8d0e-9ccd893b8a94@hust.edu.cn>
Date: Tue, 16 Jun 2026 09:18:11 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: infiniband: correct name of option to enable the
 ib_uverbs module
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Alex Shi <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>
References: <20260616002027.67925-1-enelsonmoore@gmail.com>
From: Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <20260616002027.67925-1-enelsonmoore@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:HgEQrAD3_SlVpDBqeHimAA--.44228S2
Authentication-Results: app1; spf=neutral smtp.mail=dzm91@hust.edu.cn;
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr43ZF1xKFyDCF17JFWkWFg_yoW8tFW8p3
	WDG34IkFs2yay3C3y8Cr129F4xWa4xCa15W3WkWwn8XF1DAws3ZrnIyw1YgFykXrW8ZFWY
	qr48KFnYgr4jyaDanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQFb7Iv0xC_Cr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
	v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK
	6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4kS14v26r
	1Y6r17M2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI
	12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxV
	W8Jr0_Cr1UMcIj6x8ErcxFaVAv8VW8uFyUJr1UMcIj6xkF7I0En7xvr7AKxVW8Jr0_Cr1U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04
	k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fZr1UJr1l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j6a0QUUUUU=
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/


On 6/16/26 8:20 AM, Ethan Nelson-Moore wrote:
> The Infiniband documentation states that CONFIG_INFINIBAND_USER_VERBS
> should be used to enable the ib_uverbs module. However, this option was
> renamed to CONFIG_INFINIBAND_USER_ACCESS in commit 17781cd6186c
> ("[PATCH] IB: clean up user access config options"). Update the
> documentation to reflect this.

Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>

For patch that mixes English and translation update, should it directly 
be merged into Jon's kernel tree?

>
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>   Documentation/infiniband/user_verbs.rst                    | 2 +-
>   Documentation/translations/zh_CN/infiniband/user_verbs.rst | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/infiniband/user_verbs.rst b/Documentation/infiniband/user_verbs.rst
> index 8ddc4b1cfef2..96bcd1bd37ad 100644
> --- a/Documentation/infiniband/user_verbs.rst
> +++ b/Documentation/infiniband/user_verbs.rst
> @@ -2,7 +2,7 @@
>   Userspace verbs access
>   ======================
>   
> -  The ib_uverbs module, built by enabling CONFIG_INFINIBAND_USER_VERBS,
> +  The ib_uverbs module, built by enabling CONFIG_INFINIBAND_USER_ACCESS,
>     enables direct userspace access to IB hardware via "verbs," as
>     described in chapter 11 of the InfiniBand Architecture Specification.
>   
> diff --git a/Documentation/translations/zh_CN/infiniband/user_verbs.rst b/Documentation/translations/zh_CN/infiniband/user_verbs.rst
> index 970bc1a4e396..31534681654b 100644
> --- a/Documentation/translations/zh_CN/infiniband/user_verbs.rst
> +++ b/Documentation/translations/zh_CN/infiniband/user_verbs.rst
> @@ -17,7 +17,7 @@
>   用户空间verbs访问
>   =================
>   
> -  ib_uverbs模块，通过启用CONFIG_INFINIBAND_USER_VERBS构建，使用户空间
> +  ib_uverbs模块，通过启用CONFIG_INFINIBAND_USER_ACCESS构建，使用户空间
>     通过“verbs”直接访问IB硬件，如InfiniBand架构规范第11章所述。
>   
>     要使用verbs，需要libibverbs库，可从https://github.com/linux-rdma/rdma-core。

