Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CAB34DB4A;
	Tue, 21 Jul 2026 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784624483; cv=none; b=cUPeqK5v2/bvgbnRYEfijuvikDjESvJpPHGNyh17B5+iEvZ8sMMaviTpUF/0zSfBnCNK0nnMEA+wWadeFt1VyzgSxdjs6BqYGqedMbux7y2IszgrErF9SIbsQf3+4BjcwaJnKEVy608IaFnluit8Haf3U4QXzUmBlbAH0jz0rWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784624483; c=relaxed/simple;
	bh=t52EYSK/Jyg2Z76Mc7G84A36GSpF9FyJTAELdkalo2Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=G3efZ93nelrcUUHWc3qQ5A1WKIcy3tisUiiyWg/oqr1EYPYTcLkrW9wEKjMl9eLqerbD+MJEoFPPVEgbv3vN3/fd+5btxZ+kXKmdIgcr4Qgd418rxlNNEpXymJ1cT5D8f6v1+p7tOv3HfbOJ75DJnWnuf+oibOVFlgAd9Ihi9Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=i9OPRB7A; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="i9OPRB7A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784624469; h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type;
	bh=3HrP8gYYdMrVQRC35NFohQ8BQHeehqOgU6F5aIQtfzs=;
	b=i9OPRB7AW2NKPiBLXakErGX5daeo7a8tPNT+0Jd9+yNUFljETpxolDQF6BwjWOfeMdmFaFhDcQx9JKbWM7ZjSM8f/5h1SF4AbJTbJMErCz1dJdmlcnEy95x3QjI7M/NviX9i5WOsmhg/1s2yJljwoIQKUX/DTd/n1Dbjm6FndZ0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7ZKjwB_1784624467;
Received: from 30.221.109.92(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X7ZKjwB_1784624467 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 17:01:08 +0800
Message-ID: <5dda3040-67c9-7916-436e-47125daeb310@linux.alibaba.com>
Date: Tue, 21 Jul 2026 17:01:07 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
From: Cheng Xu <chengyou@linux.alibaba.com>
Subject: Re: [PATCH] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
To: Myeonghun Pak <mhun512@gmail.com>, Kai Shen <kaishen@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ijae Kim <ae878000@gmail.com>
References: <20260721082545.47395-1-mhun512@gmail.com>
Content-Language: en-US
In-Reply-To: <20260721082545.47395-1-mhun512@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/21/26 4:25 PM, Myeonghun Pak wrote:
> Each CEQ interrupt handler only schedules eqc->tasklet. The tasklet calls
> erdma_ceq_completion_handler(), which reads the DMA-coherent EQ ring
> through get_next_valid_eqe() and updates eq->dbrec through notify_eq().
> 
> erdma_ceqs_uninit() frees each CEQ IRQ and then destroys its EQ.
> free_irq() prevents another hard IRQ and waits for an in-flight handler,
> but it does not drain a tasklet that the handler already scheduled. The
> tasklet can therefore access eq->qbuf or eq->dbrec after
> erdma_eq_destroy() frees them.
> 
> Clearing ceq_cb->ready does not synchronize with a tasklet that already
> passed the check at the start of erdma_ceq_completion_handler().
> 
> Kill the tasklet after free_irq(), when no handler can schedule it again,
> and before erdma_ceq_uninit_one() releases the EQ buffers.
> 
> Fixes: f2a0a630b953 ("RDMA/erdma: Add event queue implementation")
> Cc: stable@vger.kernel.org
> Co-developed-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
> ---
> Found by static analysis only; not tested on ERDMA hardware. Testing on
> hardware, particularly device removal while CEQ interrupts are active,
> would be appreciated.
> 
>  drivers/infiniband/hw/erdma/erdma_eq.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Cheng Xu <chengyou@linux.alibaba.com>

Thanks.

While this is unlikely to happen in practice, since the ibdev has already
been removed and no CQs should remain to generate CEQ events, this patch
makes the CEQ teardown ordering explicit and robust.

Cheng Xu


> diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
> index d5b9d19882b2..a8784e07acd6 100644
> --- a/drivers/infiniband/hw/erdma/erdma_eq.c
> +++ b/drivers/infiniband/hw/erdma/erdma_eq.c
> @@ -220,6 +220,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)
>  
>  	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
>  	free_irq(eqc->irq.msix_vector, eqc);
> +	tasklet_kill(&eqc->tasklet);
>  }
>  
>  static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
