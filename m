Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7695138E5EF
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152290; cv=none; b=ePVy/DkzIvU1A1KxFyW0I6g8PI6nH7TLV/14yAzqiLDoF0/8PYG4bWYM4DItvg/ds5a+CfKXvnOaf4Ch+XJ5og888h95l5Eb3VOpCxSf0HwOYa9d/cGlOQGC62haAS05CWRZFhyrEECXKHbLjxTVkwAR5Qguvvg3V8UeiGkzZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152290; c=relaxed/simple;
	bh=XiXrGWu0FIPsQfk7J1Vats34jRcQ9n+08r5ordfwqV8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A6kfDYFy2CH96iqzIbQf3Ubl/8AHjq2i0QqFB38W0cp2xk9Rl4pBOSqpfj+T0KNg3Mf3SJczq7K3nUmns1MJCTY6VWdWdwnPx5t6IJExVlmt0wFZo21nqcm5z8S4SfG1+Fzsw4QSZtQ/GrwoHIHRaj/iPH513zqznB6bN4CNU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtAokamy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtAokamy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDED1F00893;
	Wed, 23 Sep 2026 08:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152289;
	bh=46ioZNzpu0zaA00/9iSw1HKBFaCBbO/A+XcCOhDZG1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UtAokamyY+gTnNBLMrBRj5ujIB4MuTQ5rAi4goKprSV5KfeRQLafW1uZ52BjFa0Uv
	 FmRP95Uil06CRtJU9soTsl7SAVt8V1jQsyHss+9KWCAT/KF7w/9+33YVGUp5jge0+9
	 FVzO8O6AcBH5rrAnPug2Yxc/bFLfiQAXUjqNfzBYdLKpNL5cHiXEJwfWMBE0e8tHcF
	 nhWWOH+IU372eDod4SfKR8Z+/smb/8OcevWT+GjTRzexUTgQH/EjiqpxPNfy5JGJ2Y
	 kHvLscN6pc2itcfVrCyHY8rACXJYMX6a2y7UjhPkXh0fm9coXvrzxbXhKfMl50VaX4
	 PyhTt1dQZvP3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Unbind data direct device on IB device
 unregister
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923081442.2520-1-lirongqing@baidu.com>
References: <20260923081442.2520-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:31:28 +0000
Message-Id: <20260923083129.3CDED1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mlx5: Use-After-Free in mlx5r_umr_post_send due to teardown p=
hase inversion
--

commit a526f3c890d0ead88aa1cec9b7e04bfef90a8d6b
Author: Li RongQing <lirongqing@baidu.com>

RDMA/mlx5: Unbind data direct device on IB device unregister

This commit adds a call to mlx5_ib_data_direct_unbind() during IB device
unregister to revoke data-direct MRs and clear the data_direct_dev pointer.

> diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniban=
d/hw/mlx5/data_direct.c
> index 93a56ee2c4ef4..66852e83c38d0 100644
> --- a/drivers/infiniband/hw/mlx5/data_direct.c
> +++ b/drivers/infiniband/hw/mlx5/data_direct.c
[ ... ]
> @@ -109,6 +109,7 @@ void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ib=
dev)
>  	mutex_lock(&mlx5_data_direct_mutex);
>  	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
>  		if (reg->ibdev =3D=3D ibdev) {
> +			mlx5_ib_data_direct_unbind(reg->ibdev);

[Severity: High]
Does this introduce a use-after-free during device teardown?

Looking at the teardown sequence in __mlx5_ib_remove(), device stages are
cleaned up in reverse order. The MLX5_IB_STAGE_PRE_IB_REG_UMR stage is torn
down before MLX5_IB_STAGE_INIT.

During MLX5_IB_STAGE_PRE_IB_REG_UMR cleanup, mlx5r_umr_resource_cleanup()
frees the UMR queue pair:

mlx5r_umr_resource_cleanup() {
    ...
    ib_destroy_qp(dev->umrc.qp);
    ...
}

Later, during MLX5_IB_STAGE_INIT cleanup, mlx5_ib_stage_init_cleanup() calls
mlx5_data_direct_ib_unreg(), which now triggers mlx5_ib_data_direct_unbind(=
).
If there are remaining MRs to revoke, the call chain is:

mlx5_ib_data_direct_unbind()
    mlx5_ib_revoke_data_direct_mrs()
        mlx5r_umr_revoke_mr()
            mlx5r_umr_post_send_wait()

At this point, mlx5r_umr_post_send_wait() will attempt to post a work reque=
st
using the already-freed dev->umrc.qp, causing a use-after-free if any
data-direct MRs failed to deregister cleanly.

>  			list_del(&reg->list);
>  			kfree(reg);
>  			goto end;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923081442.2520=
-1-lirongqing@baidu.com?part=3D1
