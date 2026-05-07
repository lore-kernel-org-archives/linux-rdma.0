Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291291F09AD;
	Thu,  7 May 2026 02:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778121264; cv=none; b=kxEXuHtQWBBZqx7X93t8MkUTE8dD5DiWa93kHEypb3HlcwWw7T3fY2pXALzq+xCPmb+inYlcJEiwP6cIKH8oFV/sU9MYsC9D/3Z7xcTRQyWWtM3+Yrg4ECcCENkMDE1qxAlZjzKoS8wtKYzv7wOymLO8fGYJBVom9WrnIrQ8lvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778121264; c=relaxed/simple;
	bh=vjgPoeXfSi+YgnWA1u+rAs1TE4c2HHNyQfEdIDXFtQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3F/FEn6N5dJ2yCw+ne1sAU9oxO+/rRm8+df5Mr+ocdmKCAT+wk/+cfetO8VFFM20SfVJk/ZVHJoEnAUxhF5ddxE3mRxTLMBZ7LCPzVxGUD9hE4a7awX8I1FrgEgHYEen2ksgqSbEoXkxqYglLfnsK+VEy20U38R50xHMPNzRp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaCW80Yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaCW80Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B356EC2BCB0;
	Thu,  7 May 2026 02:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778121263;
	bh=vjgPoeXfSi+YgnWA1u+rAs1TE4c2HHNyQfEdIDXFtQQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iaCW80Yg8m0KtPSNXOr35aRsKOAAPbPuiiHLNaA1Mqmn0sIcbyqqcJ2PbeadnBLHn
	 CYbXLpghPdriX44ALoln9cco58y8329MRzHT+KT4ZQeOVOdyKHWRXZr3I0JdHTV2V/
	 lC0By9QLMUBvP/srEFDcFCgR/TGRTHwWOsQ5LKSn3PYDF9lkRNl6uZQKqTo+VqHxKc
	 XtthISAjndyVhkug+PwA5whej9Ump1KAY+JdZIpa2TCseTpNVQ2RnzJTp4bSgPqV5S
	 nw/1Ok7yE9KAGcncBEbQu9WDBmjsU3ZWTUTZGeoBxLL1phMDxI+mgoYvZYwpwtmH/1
	 QRhs/Ifvnonig==
Date: Wed, 6 May 2026 19:34:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Alex Shi
 <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu
 <dzm91@hust.edu.cn>, Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi
 <pavan.chebbi@broadcom.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Alexander Duyck
 <alexanderduyck@fb.com>, kernel-team@meta.com, Daniel Borkmann
 <daniel@iogearbox.net>, Nikolay Aleksandrov <razor@blackwall.org>, Shuah
 Khan <shuah@kernel.org>, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org, Stanislav Fomichev
 <sdf@fomichev.me>, Mina Almasry <almasrymina@google.com>, Bobby Eshleman
 <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v2 2/6] net: devmem: support TX over
 NETMEM_TX_NO_DMA devices
Message-ID: <20260506193420.575e1806@kernel.org>
In-Reply-To: <20260504-tcp-dm-netkit-v2-2-56d52ac72fd4@meta.com>
References: <20260504-tcp-dm-netkit-v2-0-56d52ac72fd4@meta.com>
	<20260504-tcp-dm-netkit-v2-2-56d52ac72fd4@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 04 May 2026 17:27:49 -0700 Bobby Eshleman wrote:
> +	if (bind_dev != netdev)
> +		netdev_lock(bind_dev);
> +	dma_dev = netdev_queue_get_dma_dev(bind_dev, 0, NETDEV_QUEUE_TYPE_TX);
> +	if (bind_dev != netdev)
> +		netdev_unlock(bind_dev);
> +	binding = net_devmem_bind_dmabuf(bind_dev,
> +					 bind_dev != netdev ? netdev : NULL,
> +					 dma_dev, DMA_TO_DEVICE, dmabuf_fd,
> +					 priv, info->extack);

Not sure if it matters but are we intentionally releasing the bind_dev
lock before calling net_devmem_bind_dmabuf() ? Previously more code here
was covered by the physical netdev's lock.
