Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112A93370EA;
	Wed, 22 Jul 2026 02:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784685759; cv=none; b=Mv1b0xuP4JB60XfOf9+QvFeariFKyoXVQldVHm1TlTaaM7qp8Gk22KkZHL74soN772N2LFQLth04EwaR9V3FKtcSAwVS3HF6RlBfG/v7SpUDbfBFt4c+203Z4wc3m6qdSKsDZbVW3dZmrOPiRQnXq3ExHRlwqrzyVD/5Afdgvtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784685759; c=relaxed/simple;
	bh=Ms+3hk7hbeWOt4MjdwrrXhO2v/6wikmjnkbxooQcK5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D6dA32+qo//zNv4BOIhKDsZXrzhbWbF/4fjY565IRgVZ+uCsfMAsDXwGKgNOQg/IdyPYpURjs1rMXZb5XmUQh+bB+6V42nBSLm1TeaJQEO7rB23yfC/dnw5X2xw1UbGMFXMZm1R5aqXNSxlS40MCTDZ3yhUSqRdOmPtkiJ74140=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FCM/OhwP; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FCM/OhwP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784685753; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HSaIX6hIosJ/jHt+6+F5JlQMZyVUp21ckgOQoM3Lki4=;
	b=FCM/OhwPi+KicqDqEul8eNn5BS+02AVP1FPZdIbXC1BJlatnRGKQVPvPyhGeaFUAhDh/HMG9lULRV5WLnUYrK+++1t3lURNiArDciHV+OrQ3TnSCc8v2TKFifvPGr+uC029LMEi6y0xmPrk5Lojs20w8v83Tz+222fhja1bFbSk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7bpXMI_1784685752;
Received: from 30.221.106.174(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X7bpXMI_1784685752 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 10:02:32 +0800
Message-ID: <68b9b418-b672-ee31-1c66-9806b8a2eb60@linux.alibaba.com>
Date: Wed, 22 Jul 2026 10:02:30 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] RDMA/erdma: fix use-after-free in CEQ tasklet teardown
Content-Language: en-US
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: kaishen@linux.alibaba.com, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260721133745.3197015-1-fanwu01@zju.edu.cn>
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260721133745.3197015-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/21/26 9:37 PM, Fan Wu wrote:
> The CEQ interrupt handler schedules a tasklet that accesses the CEQ
> buffers. During teardown, erdma_free_ceq_irq() removes the interrupt
> handler and waits for any in-flight handler invocation, but does not
> wait for a tasklet that was already scheduled by that handler.
> 
> erdma_ceq_uninit_one() can then free the EQ qbuf and dbrec while the
> tasklet is still accessing them.
> 
> Call tasklet_kill() after free_irq(). This prevents new tasklet
> scheduling and waits for any already scheduled tasklet before the EQ
> buffers are freed.
> 
> This issue was found by an in-house static analysis tool.
> 
> Fixes: f2a0a630b953 ("RDMA/erdma: Add event queue implementation")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6
> Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
> ---
>  drivers/infiniband/hw/erdma/erdma_eq.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Hi, Fan Wu,

Thanks your work! But there is another patch fixes this issue already:

https://lore.kernel.org/linux-rdma/CAHYDg1QDaWPxD7pb-A1ZmqxaX6YACWTsinzEG4_EZDKbAX38kQ@mail.gmail.com/T/#t

Thanks,
Cheng Xu

> diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
> index 6486234a2360..78ebec6d48a3 100644
> --- a/drivers/infiniband/hw/erdma/erdma_eq.c
> +++ b/drivers/infiniband/hw/erdma/erdma_eq.c
> @@ -219,6 +219,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)
> 
>  	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
>  	free_irq(eqc->irq.msix_vector, eqc);
> +	tasklet_kill(&dev->ceqs[ceqn].tasklet);
>  }
> 
>  static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
> --
> 2.34.1
