Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1BF3D88E0
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 04:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213175; cv=none; b=ZVhyafj4TOa+KX95kAPWy7TcGJm439W7S81fis+HkfH1sCBJjTy3v5h0+W5QThrLkD5FPyUdK2JU4aI/QZVCWC7T3FEIshmrGVoxB8OLJLnvzcm6UIMy5hW7j0igaHBr43H2rTNUQIK//uMcvA6mdGEOA4LnX99TynkEFBHSw+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213175; c=relaxed/simple;
	bh=Wvw/2bHf1KgDxnfoU5OV5pNLLYg8ys38gccHOAl2Lus=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kn9ko4T2CmzDDvRoBKo0azde6r0q0FteT/fM6bqkdoaQoikZ1tFtn/xQ27bJGK1fPRMUDEg9BPab53EgN+qHnUdm65KVLiy+9W69lsPSHMdThS08urLdZxInZGLwJm5mvOaxybM5rjnuUCa7k15dSNPmXW7tVXv9+oqJXRpYnls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnM9bRgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnM9bRgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA601F000C4;
	Sat, 17 Oct 2026 04:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792213174;
	bh=9SvfKss7xso6D0DoTWZESuozchWYCISkTUwk61xs46M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OnM9bRgrmwYJLiWmZ+FhftyLbRoN4q5bxivsWxW3bGiSlN5ady7+aW3IEZwu4YD4V
	 pF6hC+22DUfrlmzevyNMrlJHcnLpUyH9Ob1CiNHVzdlFbxm9s7yCDKh2MtdUbgWYdO
	 /DBzvgNp2JbW2Uhj61LOUm32q5e8U1f8K8nUwxq/2IUiBLaig867WyRkHN60XL1eqK
	 6Y35zmA1pkrF+SjjK7WoP6zBM6rASLBzYNXLEZBIm4HKzDWDNhEVSoEtMFvBr6uBJN
	 0ffUJoZWG0Xz1bbytOdvDdvpx8zOpYeo9nzHLQjvn4FYPbP9Sfa2ClFmga9BbpUtjP
	 F5Dn12o6PqQjw==
Message-ID: <sashiko-outbox-175297@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 4/4] net/mlx5: HWS, Don't free the send ring
 CQ buffer if destroying the CQ fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016045849.813696-10-oss.patchbox@gmail.com>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
 <20261016045849.813696-10-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 04:59:33 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mlx5: software UAF of embedded CQ struct when firmware destroy com=
mand fails
--

commit 46458ea83b82e1a1672d9e95c03b0f4bac750b05
Author: Yuho Choi <oss.patchbox@gmail.com>

net/mlx5: HWS, Don't free the send ring CQ buffer if destroying the CQ fails

hws_send_ring_close_cq() ignores the result of mlx5_core_destroy_cq()
and frees the CQ buffer and doorbell record with mlx5_wq_destroy()
anyway. If DESTROY_CQ fails, the CQ may still exist in firmware and
retain access to that memory after it has been returned to the
allocator.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index df3b93499eebb..21e2d0a26e88a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> @@ -1005,7 +1005,9 @@ static int hws_send_ring_open_cq(struct mlx5_core_d=
ev *mdev,
> =20
>  static void hws_send_ring_close_cq(struct mlx5hws_send_ring_cq *cq)
>  {
> -	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
> +	/* A CQ that was not destroyed can still access its buffer, leak it */
> +	if (mlx5_core_destroy_cq(cq->mdev, &cq->mcq))
> +		return;

[Severity: High]
Does returning early here expose the software CQ structure to a use-after-f=
ree?

When mlx5_core_destroy_cq() fails, it skips synchronization and completion
wait for concurrent users of the software CQ:

drivers/net/ethernet/mellanox/mlx5/core/cq.c:mlx5_core_destroy_cq() {
	...
	err =3D mlx5_cmd_exec_in(dev, destroy_cq, in);
	if (err)
		return err;

	synchronize_irq(cq->irqn);
	mlx5_cq_put(cq);
	wait_for_completion(&cq->free);
	...
}

Because hws_send_ring_close_cq() now returns without any indication of fail=
ure,
its caller (mlx5hws_send_queues_close()) will proceed to unconditionally fr=
ee
the array embedding the CQ structure:

drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c:mlx5hws_send_qu=
eues_close() {
	...
	kfree(ctx->send_queue);
	...
}

Since wait_for_completion() and synchronize_irq() were skipped, could an
executing concurrent EQ interrupt handler or async event handler still hold
a reference to mcq and access it after the send_queue array has been freed?

>  	mlx5_wq_destroy(&cq->wq_ctrl);
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016045849.8136=
96-6-oss.patchbox@gmail.com?part=3D4
