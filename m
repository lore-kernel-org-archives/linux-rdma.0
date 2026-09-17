Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C7B4B1269
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789644329; cv=none; b=BdChMw3VsYq51DntE0jE3XAzXnrrdTTlFTPTGMa7LAdfQmFGc8jffgMjyfQXkiGeuOzh1kvhjlpZInI5JBS5uWpSjYVo393N2bjhtqDtWW+PXWlQEpvtn0jRBBvSexHW/cjrtuOmXfuXAqtjZVqOeLa5n1f0w+FD1ffXPEHxZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789644329; c=relaxed/simple;
	bh=WVXjNgzh9PIeeQRViIfzzW+ZjnYT87c7x7L5Jtqo/dA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e+7B9INI6hmQpOtY5oX5g2yjYhq7c48SUUSCy1W62Xt0saB/1TRGQIYtK2IvZLUGDe2n2FBC5Yp2GLZV0PZbJjjuI9GBCzuTU/YK/AJH9/fOJX2+wQDhQaIH8KPC+jgME2R88RNtKJ4GOpafuIZULtI6s+FkeT8+72DJ6Y+2yO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRd0jznk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRd0jznk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820AE1F000FF;
	Thu, 17 Sep 2026 11:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789644327;
	bh=ovr/XlHmpkAo3FSpaQco3DyiBm3ZtOt39XfyG3+6MM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IRd0jznkqXUSRuh2BM7qVH6CsSSKKdSLLXN9azJk8zHSlG4shbNyknGGAP8xJNELF
	 TMLHdngvM1DHE0DUfjOeNDXGepYEatNqPETiciSutsrZ8aXn6IUcdPLSPyyg20x0fZ
	 /pXsm97R6cdHEAljF03xlYQBVMF5pbwAcXZUaoemkGljZthbKG+MXlngGBFyA2IAUA
	 CL2AXCqhesZ/1gE+THPDC0nwgvThgumS+3QQPNmxCfAQ6LiveNUYZL1pHWlSvsihaY
	 LN4+oOWSU9DSbNw0WMW52ag/n1y8VN05tvKzQX+TgLU0BRyMJjNkYkpecHI29gLQ9l
	 rlgKT7WUwtQOA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Restore flow_attr-first layout in leftovers
 flow rules
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111722.1723-1-lirongqing@baidu.com>
References: <20260917111722.1723-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 11:25:27 +0000
Message-Id: <20260917112527.820AE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] rdma: embedding struct with flexible array member not at end
--

commit 8e283bb18af02522e075bf4c88abcbec6ff60c4a
Author: Li RongQing <lirongqing@baidu.com>
RDMA/mlx5: Restore flow_attr-first layout in leftovers flow rules

This commit restores the original ordering of members in the leftovers
flow rule structs to fix an out-of-bounds read during flow rule creation.
By moving flow_attr to the front, the layout matches the offset calculations
expected by the flow creation code.

> diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5=
/fs.c
> index b155baee0017c..e27826c3087bf 100644
> --- a/drivers/infiniband/hw/mlx5/fs.c
> +++ b/drivers/infiniband/hw/mlx5/fs.c
> @@ -1651,8 +1651,8 @@ static struct mlx5_ib_flow_handler *create_leftover=
s_rule(struct mlx5_ib_dev *de
>  	struct mlx5_ib_flow_handler *handler =3D NULL;
> =20
>  	static struct {
> -		struct ib_flow_spec_eth eth_flow;
>  		struct ib_flow_attr	flow_attr;
> +		struct ib_flow_spec_eth eth_flow;

[Severity: Low]
Does embedding struct ib_flow_attr at the beginning of this anonymous
structure violate the C standard for flexible array members?

Looking at struct ib_flow_attr, it contains a C99 flexible array member
union ib_flow_spec flows[] at the end. The C standard specifies that a
structure containing a flexible array member should not be embedded within
another structure, particularly as a non-last member.

While this ordering fixes the runtime offset calculation expected by
create_flow_rule(), does placing it before eth_flow trigger modern compiler
warnings like -Wflex-array-member-not-at-end?

>  	} leftovers_wc =3D { .flow_attr =3D { .num_of_specs =3D 1,
>  					  .size =3D sizeof(leftovers_wc) },
>  			   .eth_flow =3D {
> @@ -1662,8 +1662,8 @@ static struct mlx5_ib_flow_handler *create_leftover=
s_rule(struct mlx5_ib_dev *de
>  				   .val =3D { .dst_mac =3D { 0x1 } } } };
> =20
>  	static struct {
> -		struct ib_flow_spec_eth eth_flow;
>  		struct ib_flow_attr	flow_attr;
> +		struct ib_flow_spec_eth eth_flow;

[Severity: Low]
Similarly, does this second anonymous struct declaration also embed
struct ib_flow_attr and its flexible array member improperly?

>  	} leftovers_uc =3D { .flow_attr =3D { .num_of_specs =3D 1,
>  					  .size =3D sizeof(leftovers_uc) },
>  			   .eth_flow =3D {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111722.1723=
-1-lirongqing@baidu.com?part=3D1
