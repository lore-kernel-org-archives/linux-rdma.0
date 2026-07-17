Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635DF274B3C;
	Fri, 17 Jul 2026 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784250009; cv=none; b=XwoqBDuQeBMNLd/rRek0bYArWtjE9sqnCi9Yxv0IG2sajVCF/Ami748U35QXsJl8jawD4NO6eXWjgSmiMz+dsoSldFoV3BdjcILVkPOSxSy4NxUlrRozvc8G75UgNvYuKFL8FFSaRzryRTFof5wjEQQZd4GVDktGZJpxbEuIgKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784250009; c=relaxed/simple;
	bh=rF5NNlqdfSIzaV3JN5AZXZrtIVkCvCuqGmW+6Pw9XIo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bzC5jSf7rzY0bm1/y4DgmtDfLpxKUD+dZHb3dobYUvVGsCo+TlnWnpZpJZz+DHoWIYkvsvHvg4t++qVRShR0wlcFpqu9YLKcKAjKW5JXoGyEFcDNKs/zZboS1nK7PCxUaExKgZnHUREARM0b2MKSG92HoqyUdOhqG97DkYdAR60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWF6q4MT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWF6q4MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FE31F000E9;
	Fri, 17 Jul 2026 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784250008;
	bh=9eV+HhwTzn56N6JyUndCid0i54M08XVrElfAjn9eZoE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BWF6q4MTgZwppUnQzE7gV+/XZSCZ5l1Ux7bzlziwVtxwGmLSnkBW/Oe+EODhme+0W
	 mtiHOZswBmf54Wu8hRBM1opjeFPkmV1xqXQXIOVyttLVPgGdYD/D8MdsLPc8ocGlIh
	 7KtOXDYoqpEpeyIopKPaZLul1cBQOCeeke3IF6SmwsDHxfESiVGZYz0Poe8vJGrEkZ
	 NqBe7K/dKm3blmN8ZYo6FA6QRUFoRoHv5CGCOsfIGyVYA+6Wgr7lRY5b51CmktMUea
	 C1c96oycHhl8mQXYhTFtUwedFk18U29ZkF46P+li9BaLsP5akaJwoKQC8fJwLOUu1x
	 E4Oox9gse+mvQ==
Message-ID: <428d61ca599cdcb5f42818af5a9c7e80d4eef5dc.camel@kernel.org>
Subject: Re: [PATCH] rds: use krealloc_array() for iovector growth
From: Allison Henderson <achender@kernel.org>
To: Weimin Xiong <xiongwm2026@163.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>
Date: Thu, 16 Jul 2026 18:00:06 -0700
In-Reply-To: <20260716025101.118159-1-xiongwm2026@163.com>
References: <20260716025101.118159-1-xiongwm2026@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-07-16 at 10:51 +0800, Weimin Xiong wrote:
> Use krealloc_array() for growing the RDS iovector array. This makes the
> array allocation overflow-safe and derives the element size from the
> array pointer.
>=20
> Signed-off-by: Weimin Xiong <xiongwm2026@163.com>

Hi Weinmin,

Thanks for working on this.  This looks mostly good to me, the conversion
looks correct.  Just one nit, since this is a hardening fix
and not a bug fix, it should target the net-next branch in the subject
line like this:

[PATCH net-next v2] net/rds: use krealloc_array() for iovector growth

With that fixed, you can add my rvb:
Reviewed-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison

> ---
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 68be1bf0e..6a567c97a 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -971,11 +971,8 @@ static int rds_rm_size(struct msghdr *msg, int num_s=
gs,
>  				return -EINVAL;
>  			if (vct->indx >=3D vct->len) {
>  				vct->len +=3D vct->incr;
> -				tmp_iov =3D
> -					krealloc(vct->vec,
> -						 vct->len *
> -						 sizeof(struct rds_iov_vector),
> -						 GFP_KERNEL);
> +				tmp_iov =3D krealloc_array(vct->vec, vct->len,
> +							 sizeof(*vct->vec), GFP_KERNEL);
>  				if (!tmp_iov) {
>  					vct->len -=3D vct->incr;
>  					return -ENOMEM;
>=20

