Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791490;
	b=VVNj5z6Hclhkziap9DlYFxOxO6TX5hYQemQnRZpHcdhLw+hwLn/eaywxgDz8oQa3zril
	 2GX3c+YTH/iiqV0QY/qohwJN2HMW1DLWZHtUR7+ggBJ3WZBuRfvN5ABodAYPtjjKmRK1k
	 gD1q178pOLg2xo3FYHZbdQV3oJdffNxQDes646z6kYtCL3SVcsAmOD9dIxeyvuHUNP7Cc
	 B58j0l5+GCNEZHVQ8vCFwB8PdeJRV35ZznsyxRD7BZOKjedB/LYZGcwPQfy9vXQ5F0tca
	 t5yYc6l13170EIAtrVkrN/G/kvJ44R0R3TUInIOsY+3PHuW+hQ9rVAHMAzmFfqwNaeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791490;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MZgRSZ9SSrFyPkS4hrPNY7kSbZNnfDOIVWhMxVOjBhU=;
	b=Aarf5MNub3bMLW4NlzGnZcczKnb0KO3Mz2a9Pgr+7ur13wPP3oS82u0RACAGzvLCBzKa
	 jQybFo52/zJrnhnrdmLmuJ3qdOEIlby99Bpn+bfQgCd4lyT3GA+17iFVOqAWpMeez+LE/
	 +SyBDd2tckx9IH2gnlcCqzXBFWWBosuUm/m8VD7bQFQeO95xyxsh9fz1aRcOlF9c8Fb7G
	 +7aUf4Ec/jKoQeW6m4Wyg4mQ2io/yU606DdPDYCvfoWWistDN8d2UBmhvlfkUs8w3/4Ch
	 VIkKA8XWWFBHdkpZIya06TUnbxHnLBmMdq9WcVQblgbooVY3217HUOMrIrCz5CN+lTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m/MqdBbj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF99606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m/MqdBbj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EACD1F0089A;
	Fri, 27 Nov 2026 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791489;
	bh=MZgRSZ9SSrFyPkS4hrPNY7kSbZNnfDOIVWhMxVOjBhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m/MqdBbjkY16sB7t5ROTR0K03wPFe7zpCzgLh37AfXYBy8u5n440XyhlItz+O8Rzi
	 Fg2lAK36nBNRGqEE1dtNYUSIsMEuKzA81dTZscIcLadzeK2A927SyDRGm0seg2o8kY
	 iZzqFPD3ewa8inMD4jYjLLd8WPlCC+hv+nQ9QBURu5FN1kdY20/McOTHGHEBSFuGdh
	 yNhWfmwMTJF2HnBP20qsZrXjlog01UGiQoJcpsz2zcXy74ze8bhYAQe6yTCeGEZDFM
	 C0Z63ADvnJkUTlnLA4/A1hI12YuJvIbGBeo+dkeSzLR4Mafpu3enNgGQHSmLc+ciUf
	 zlZnw9A/LlNoA==
Message-ID: <sashiko-outbox-237639@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/11] net/xsc: add CQ and QP helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145727.70868-7-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145727.70868-7-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/xsc: xsc_core_eth_destroy_cq() skips waiting on xcq->free
  on error
--

commit e696a8de856ac33999eafa7adfe7de1ccd665f4e
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add CQ and QP helpers

This commit adds CQ and QP radix-tree tables, helpers to create, modify,
and destroy ethernet CQs and QPs, and EQ dispatching for completion and
error events.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/cq.c
> new file mode 100644
> index 0000000000000..a4f9b488d659d
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
[ ... ]
> +int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
> +			    struct xsc_core_cq *xcq)
> +{
> +	struct xsc_cq_table *table =3D &xdev->cq_table;
> +	struct xsc_core_cq *tmp;
> +	int err;
> +
> +	spin_lock_irq(&table->lock);
> +	tmp =3D radix_tree_delete(&table->tree, xcq->cqn);
> +	spin_unlock_irq(&table->lock);
> +	if (!tmp) {
> +		err =3D -ENOENT;
> +		goto err_delete_cq;
> +	}
> +
> +	if (tmp !=3D xcq) {
> +		err =3D -EINVAL;
> +		goto err_delete_cq;
> +	}
> +
> +	/* the completion reader looks the cq up under rcu_read_lock and
> +	 * takes its reference afterwards; wait for it before dropping
> +	 * the tree reference so it never touches a freed cq
> +	 */
> +	synchronize_rcu();
> +
> +	err =3D xsc_destroy_cq(xdev, xcq->cqn);
> +	if (err)
> +		goto err_destroy_cq;
> +
> +	if (atomic_dec_and_test(&xcq->refcount))
> +		complete(&xcq->free);
> +	wait_for_completion(&xcq->free);
> +	return 0;

[Severity: Medium]
If xsc_destroy_cq() fails, can xsc_core_eth_destroy_cq() return while an
in-flight xsc_cq_completion() or xsc_eq_cq_event() callback is still using
xcq?

Both xsc_cq_completion() and xsc_eq_cq_event() drop rcu_read_unlock() or
table->lock after incrementing cq->refcount and before calling cq->comp()
or cq->event(), so synchronize_rcu() does not wait for those callbacks to
finish.  Jumping to err_destroy_cq after xcq has already been deleted from
table->tree skips waiting on xcq->free, allowing the caller to zero or
free the enclosing structure while a callback is still running:

CPU0                                  CPU1
xsc_core_eth_destroy_cq()
  radix_tree_delete(..., xcq->cqn)
                                      xsc_cq_completion()
                                        rcu_read_lock()
                                        /* looked up before delete */
                                        atomic_inc(&cq->refcount)
                                        rcu_read_unlock()
  synchronize_rcu()
  xsc_destroy_cq() -> fails
  goto err_destroy_cq
/* caller zeroes or frees xcq */
                                        cq->comp(cq)  <-- use-after-free

Dropping the initial refcount and waiting on xcq->free right after
synchronize_rcu(), before xsc_destroy_cq(), would ensure all in-flight
callbacks have finished even if the firmware command fails.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D6
