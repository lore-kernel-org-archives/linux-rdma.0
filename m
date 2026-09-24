Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7508F4052B9
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 07:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233470; cv=none; b=RXHEOkLsfFDQOxBxVkAblDtpJIxlumwJa3fL1fZHk6Laj/JCKC0eumuqm+NWJH+FDV8ZX/jhgA2fXSwj7s/iI0dJzDq08pD15BiLcWBXbAQ1Ynu6g3sTrzwb/gnuCSEeB7X/1O0Ozqzs3EMxrqssK2tJH6pXJwFxryk2iSLIqr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233470; c=relaxed/simple;
	bh=kxjkraTxTGtbdNthsA/fH3s7E2cP6H5v2TPPFqq2C88=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=inWF7Qi8ryDiAqonRcWqZ0Zw2QskPDKxjh2x0ebxXtS2p7DNO+OitIEs26u74TY4GXlgKbKLydD9rZaxQ//VCOrIJLDmGYIRfwJdxDRJhoWQYsDnCbUi506trNX78QEjyHhcAnF2borlBrWKN6oJEkeFJ6TZxZzdQYcyowneMS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yn4gFpAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yn4gFpAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FB41F000FF;
	Thu, 24 Sep 2026 07:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790233460;
	bh=ffiCxwtoclp5rZyUMPz/tw7bqTKO+QkQTdr9kzi08Jc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yn4gFpACV7FYm9R7PMHrVS5LTqi4rK5PfhgfONH7XURJcXIfEBOBEZoVl9GV63mlz
	 tPTmgF1yBS8zueM1J/8QpFPqj9Y7rb7zt9fD9BlFHunao8ypVPLFGvtZVBdPikm15T
	 8A3MTMtrvOcXJE1fHHiCi/3fBeILVzhDLh1+gCG2G+AojqcvBV3GMUCB+LT/4DnyPg
	 FbM8mqVINd6ZsIN9+bKq/Al9CELW+wAT7FEpFIg2s2IQ3B7FJ/LNJsPr6U2n2V7zh2
	 UgOiHHQON6WCOq4wLnGYQRyPKY9+37EcqpKajF7Cb0biSfXH0XPHFLtjuPZaS4WpyS
	 T+FSFQYk662AQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Wait for in-flight page faults on
 implicit MR null_mkey dereg
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260924065017.2424-1-lirongqing@baidu.com>
References: <20260924065017.2424-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 07:04:19 +0000
Message-Id: <20260924070420.88FB41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mlx5: child MR leak in mlx5_ib_free_odp_mr due to late null_m=
mkey wait
--

commit f5fc9e80765babb54d4d8c2db70efadd75e2ccc8
Author: Li RongQing <lirongqing@baidu.com>

    RDMA/mlx5: Wait for in-flight page faults on implicit MR null_mkey dereg

This commit mirrors the main-mmkey handling for null_mmkey by dropping the
reference and waiting for any in-flight faults to finish before destroying
the mkey and freeing the imr. It also initializes the waitqueue for the
null_mmkey right after creation to avoid a NULL pointer dereference.

> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx=
5/odp.c
> index 8dcbb0e5ccd7c..c7367718e24f2 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c
[ ... ]
> @@ -683,6 +684,8 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
>  		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
>  			 mlx5_base_mkey(mr->null_mmkey.key));
> =20
> +		mlx5r_deref_wait_odp_mkey(&mr->null_mmkey);
> +

[Severity: High]
Does this code leak child MRs when an in-flight page fault races with MR
deregistration?

If a page fault on an implicit ODP MR uses the null_mmkey and is queued
concurrently with MR deregistration, __mlx5_ib_dereg_mr() will call
mlx5_ib_free_odp_mr() which iterates over and deletes existing child MRs.

Because the null_mmkey is erased and waited upon here, after the
mr->implicit_children xarray is already cleaned up, the in-flight page
fault handler can still look up the null_mmkey, take a reference, and
create a new child MR.

The new child is inserted into mr->implicit_children (which succeeds
because the slot was just emptied by the cleanup loop). Finally,
mlx5_ib_free_odp_mr() waits for the handlers to finish. The parent mr is
freed, but the newly created child MR is permanently leaked and retains a
dangling parent pointer.

>  		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
>  				       mr->null_mmkey.key);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924065017.2424=
-1-lirongqing@baidu.com?part=3D1
