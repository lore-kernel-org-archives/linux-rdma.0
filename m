Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010658;
	b=o0vL2d3X0aHGDRBOVOzTq8g3tWDFOu9gU6eAP5a+r+1C3muDe+nqf/DipSt3W7Uk/qWf
	 HT3jTR14QXFqEPuCYHgPfsjd87RY52xMuqHDVpBVcONcSSmV+2FQvp+6+CgWl3fff/31q
	 juz50dyQ+mVcRPoWopobn8Z+Q5GGmmQAhv7702499L61BInnH6DlSorThu31UGQJUQo3q
	 9ihBqtgZs0mR2zZsnXCKiUSzgSruG9My9C2lvmPKABslszFl6yZjxsc+Jy1tKcFSg4c6r
	 aPWsh4C3ItDz++9y6FGpvqdv8fvFl4VWkyLOae9XZjrhKbVN4MEB1X8wfdMw0UO4+xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010658;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EeQyz2mYY5toUiEDRmwERA2gZdwxOVr0NH74i92r4J4=;
	b=HzWVr7KEv46SiGbNZYKcZMfA8McqyD4OpiTRnO4Prl/De7X+EprSBw1C4Yk8DrP1AbQM
	 qF3ySeSfAVLC94eH0H3UlpaCJLPBG3mZgk6ns8coGcDJqzCECfEbNWDMcSzw901pvhAX+
	 BF4m/NSuEf+xqGG4Jb1Tw2zk6SJzbT8sEK3RWwdpsrzfpDGYcpXdIsXXqm85/zhmv3ijy
	 DYY1EhaxpVWvy4c+EruCF3cScQA87i965/g9xipFidrxYhuaf7IlE8eceErrfstP7fxJG
	 aEs9BVrDyH1aPgeGcnD+YSycgBJms90HhxHJj0KhKZ/21XQkXKqCnLcl6zIhPVz0tdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mk5Hs3et;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3972606A33E
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mk5Hs3et
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B251F000C5;
	Wed, 18 Nov 2026 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010658;
	bh=EeQyz2mYY5toUiEDRmwERA2gZdwxOVr0NH74i92r4J4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mk5Hs3etPe6yuWf2Wzwhym1IAVUN6eZaTrn+320ifwUskp1rHkNWyw4fkp0I899Nu
	 N9dYrPUSz6nh0SExvlXdg8p+iBmAn9wUztr1+X5h6sBi+tlrIywRpES+a563z9wdxG
	 PvNfi22Pa7C8KoH+bEiXBX6VDW09DM/3RfQwI8xd0qLfkj6hoFMi6kaFWOwG5Yxw2E
	 stz777ygwkjCyQ54omKHcPVav0gj8tiY1sDNLSpdLDOkMQxB2dVfmFjrzpQH7L/bAE
	 kF7iDHdbzN1oR5sSlN/9d0StKbp23vapMJlRwwJDAS4EvqeBxsquqZ8iRgyBnPxJ9p
	 ILz6+KFNu7PsQ==
Message-ID: <sashiko-outbox-221136@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 07/11] RDMA/mlx5: Select the QP core device
 through its PD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-7-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-7-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] RDMA/mlx5: invalid qp_type check for DCI in
  configure_requester_scat_cqe() [1]
--

commit fd0bed19b1450b572f53f3dc5f8db9cab84d4594
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Select the QP core device through its PD

This commit resolves the mlx5_core_dev from the QP or its PD across the QP
create, modify, query, and work request posting paths instead of accessing
dev->mdev.

> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5=
/qp.c
> index 2709e5465d331..1135e710e3398 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
[ ... ]
> @@ -1957,11 +1970,11 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_d=
ev *dev, struct ib_pd *pd,
>  	return err;
>  }
> =20
> -static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
> -					 struct mlx5_ib_qp *qp,
> +static void configure_requester_scat_cqe(struct mlx5_ib_qp *qp,
>  					 struct ib_qp_init_attr *init_attr,
>  					 void *qpc)
>  {
> +	struct mlx5_core_dev *mdev =3D qp_to_mdev(qp);
>  	int scqe_sz;
>  	bool allow_scat_cqe =3D false;
> =20
> @@ -1977,7 +1990,7 @@ static void configure_requester_scat_cqe(struct mlx=
5_ib_dev *dev,
>  	}
> =20
>  	if (init_attr->qp_type !=3D MLX5_IB_QPT_DCI ||
> -	    MLX5_CAP_GEN(dev->mdev, dc_req_scat_data_cqe))
> +	    MLX5_CAP_GEN(mdev, dc_req_scat_data_cqe))
>  		MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
>  }

[Severity: Medium]
This problem wasn't introduced by this patch, but should this check
qp->type !=3D MLX5_IB_QPT_DCI instead of init_attr->qp_type [1]?

Since 2fdddbd5c966 ("RDMA/mlx5: Move DRIVER QP flags check into separate
function"), process_vendor_flags() sets qp->type to MLX5_IB_QPT_DCI while
leaving init_attr->qp_type as IB_QPT_DRIVER.  The condition
init_attr->qp_type !=3D MLX5_IB_QPT_DCI is always true, so creating a DCI QP
with scatter CQE enabled and a 64-byte send CQE on hardware without
dc_req_scat_data_cqe support sets cs_req to MLX5_REQ_SCAT_DATA32_CQE and
causes the firmware CREATE_QP command to fail.

[1] https://sashiko.dev/#/bug/linux-c5534546-da56-41f8-bc32-0fc827b3c22e

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D7
