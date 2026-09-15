Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466684BFE63
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789497357; cv=none; b=C35d9Zu0w6a5crM4D90+HoG3m2ivuu1qy96hH6N5zi7rSupGi5DmB9R2tsVDyEJB7GW1y7ZQNSGMOUR4/An9BbRae4LeCtGlYutV0OUb+JHnY/LHxh5R8a4JsMqBoTSALWL8909NH5eJOXmh9kbT9TTBevgEz4ja2KrABP547rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789497357; c=relaxed/simple;
	bh=qaGwhFaoahzWL1MDk0rb/dLks4yZ6ReWXMusnXgJcIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XO68qZB/Kx9BEb3sv4tJA9owfXTl2cu0g72TV6jvtmM+PXn0nANkMNKUX74rkaiSacTywddlndwkpW5BH8YOBRGIOgpsM9W5GCPROMay+vk+cXuxtQFWmfsLIVaO/x8ju6RVV24nAiwfU810muJ4RjweGQbVCC4G7GE/SxPb4IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEfnuKAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEfnuKAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2071F00893;
	Tue, 15 Sep 2026 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789497353;
	bh=GIOW2qAOFW60XhsE1IeRBREiAg1KTTSefibJznirfmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JEfnuKAvvnv4f0Nhlj3Yu1tzwG9AevU5pAJcLlN5+2SJD7/dJhliqyX8v3a0b6+MK
	 s65lXptM2F7wHXbISxHThf1GGR0T4J8u4enNT6TMzdeBqTEZ157ilFc0eluIt/r95O
	 1/12uN0RGKChvXy9uCDsNgES9YUkG2Zw832PHsAVfL7djo7EAHQtsuserkpx1HR5XB
	 r00UbLK3bPOex5WQugaclNJGywkj76Itq57+kLupnEFADT9JvmJThfGtBO+IuFheec
	 MM4GJkjIDZn/V0IC4wImXL0Ma22db8/CI/Cw3qJ3SufnH4OA7JY1Klr8rRJbLM/74R
	 tq+sM51+VBJnQ==
Date: Tue, 15 Sep 2026 21:35:48 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Ruslan Vagner <rusya92266@gmail.com>
Cc: linux-rdma@vger.kernel.org, jgg@nvidia.com
Subject: Re: [PATCH] RDMA/qedr: fix comment typo in verbs.c
Message-ID: <20260915183548.GP13683@unreal>
References: <CAF9RqJ66ApKFeMwr59AYXHpDO2FOL=NCuvG=q3NaTxR4yEg1NQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF9RqJ66ApKFeMwr59AYXHpDO2FOL=NCuvG=q3NaTxR4yEg1NQ@mail.gmail.com>

On Tue, Sep 15, 2026 at 07:55:56AM -0500, Ruslan Vagner wrote:
> Fix the spelling in comments. No functional change.
> 
> Signed-off-by: Ruslan Vagner <rusya92266@gmail.com>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It was already fixed in commit ea42dc093681 ("RDMA: fix typos in comments")
https://lore.kernel.org/all/20260907065047.26773-2-hemanth.selam@gmail.com/

Thanks

> 
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index 012a0ab98d6b..973d0fa7cdce 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -1075,7 +1075,7 @@ int qedr_destroy_cq(struct ib_cq *ibcq, struct
> ib_udata *udata)
>  	/* We don't want the IRQ handler to handle a non-existing CQ so we
>  	 * wait until all CNQ interrupts, if any, are received. This will always
>  	 * happen and will always happen very fast. If not, then a serious error
> -	 * has occured. That is why we can use a long delay.
> +	 * has occurred. That is why we can use a long delay.
>  	 * We spin for a short time so we don’t lose time on context switching
>  	 * in case all the completions are handled in that span. Otherwise
>  	 * we sleep for a while and check again. Since the CNQ may be
> -- 
> 2.54.0.windows.1
> 
