Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B02438E8BB;
	Fri, 16 Oct 2026 06:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133985; cv=none; b=J9k7vgxVMb4Qw7+CdYLAxIn8Kn9b+2Mhq4X+d/R/r81uab4+/BbasEt6yVHSuu/v0poT3sec2xKKEWiem1pcnF5MwGUTy4TjCKVbG8z89IijFuAPoa51BTZ0Xr+6i4Xe3JolX4KMfWRSozRaLALEDwODJTNyTz+YeLAut3TnhuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133985; c=relaxed/simple;
	bh=oiKeBWTIwWhSBuTaKT2Q4n7DD1q3cThWeYYSAxkcU1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SRbjyWXPAO36POgIpYMU61tnqmddFth2pJ2zLXQpL6WH7kpCo58Uc11I1sWB+8BFXQOFHAAFAdZTlVlMNTh7caafs4coG4D+QugaNVSSZb5hkKq1hxwrARfO75v3+hCr9VrIj8jAetkuKCh540i94mEwca4a7hHcG2oyHEeHMpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4j5b8f1Z0Vz1T4Fq;
	Fri, 16 Oct 2026 14:47:14 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 5266B40579;
	Fri, 16 Oct 2026 14:59:38 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 16 Oct 2026 14:59:36 +0800
Message-ID: <1ce84c99-7f55-a146-7333-4ad791434097@hisilicon.com>
Date: Fri, 16 Oct 2026 14:59:35 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH net-next v1 0/4] net/mlx5: Don't free CQs whose destroy
 failed
Content-Language: en-US
To: Yuho Choi <oss.patchbox@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Ariel Levkovich
	<lariel@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Alex Vesker
	<valex@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>, Itamar Gozlan
	<igozlan@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20261016045849.813696-6-oss.patchbox@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100018.china.huawei.com (7.202.181.17)

Hi Yuho,

On 2026/10/16 12:57, Yuho Choi wrote:
> mlx5_core_destroy_cq() can fail, and when it does the CQ may still
> exist in firmware with access to its buffer and doorbell record. It
> also returns early in that case, without waiting for EQ handlers that
> may already hold a reference to the CQ. The four helpers in this series
> ignore that error and free the CQ buffer anyway, while their teardown
> paths also free the object that embeds the struct mlx5_core_cq.
> 
> Keep the buffer and the object that embeds the CQ when DESTROY_CQ

Are the buffer and object freed somewhere else later? Or are they
leaked forever?

Thanks,
Junxian

> fails, as the regular mlx5_ib CQ destroy path does. The HWS send ring
> CQs are polled and never armed, so the HWS patch keeps only their
> buffer rather than passing the error up through the queue open and
> close paths.
> 
> The issues were found with a static analysis tool from ongoing, not yet
> published research, and confirmed by code inspection. None of them was
> reproduced, so this targets net-next; I can resend for net if you
> prefer.
> 
> Compile-tested only (x86_64 defconfig with MLX5_CORE_EN, MLX5_ESWITCH,
> MLX5_SW_STEERING and MLX5_HW_STEERING, W=1).
> 
> Yuho Choi (4):
>   net/mlx5: Don't free the ASO CQ if destroying it fails
>   net/mlx5: Don't free the WC test CQ if destroying it fails
>   net/mlx5: DR, Don't free the send ring CQ if destroying it fails
>   net/mlx5: HWS, Don't free the send ring CQ buffer if destroying the CQ
>     fails
> 
>  .../net/ethernet/mellanox/mlx5/core/lib/aso.c  | 18 +++++++++++++-----
>  .../mellanox/mlx5/core/steering/hws/send.c     |  4 +++-
>  .../mellanox/mlx5/core/steering/sws/dr_send.c  |  4 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/wc.c   | 17 ++++++++++++-----
>  4 files changed, 31 insertions(+), 12 deletions(-)
> 
> 
> base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
