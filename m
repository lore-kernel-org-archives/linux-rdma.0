Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E235380F
	for <linux-rdma@vger.kernel.org>; Mon, 24 Jun 2024 09:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719222670; cv=none; b=oGxKEtB4auobMx6sYGFjasAl4o8qZT6ZYxZKR1GnUC17vplqGejREPZ0Zvs9X3sRezlrPACmoHlCSgdxDM75/ZEgO/h0kX76bIlJHURMde6kMmARIO1SXLBdsM9kNpnmjlEMYRqcl5IBhp3tO53LKitv5QSbuaq2BMPd5DY9GWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719222670; c=relaxed/simple;
	bh=kRRyjXH+LxwsUEkL/Vyp2Js/1+92uzx3TGqzRBSh/2g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TgoFZLDhWp0Kq0V7zzPWkcXLkskr7h6R2bf+/7FnhcHqBqdRAWYCTlvEApf36rJ/0aoyRTePiSGjVb+3nQOWWYkDGRF0fOaM4t6rmvY5SkWHbEMo8GNa7YyKZfshDqJMA3+tXBr+9VXIebKz3jR4/VkqhJT0pGKYYac1f2XBKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1p8fdye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1p8fdye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE65BC32781;
	Mon, 24 Jun 2024 09:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719222669;
	bh=kRRyjXH+LxwsUEkL/Vyp2Js/1+92uzx3TGqzRBSh/2g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=E1p8fdye2CpdorUkrB9WmgpJlX/EzKNriwlEHZr2OYEiOub/6yjZlej5FNbLXlfs4
	 zopDlOY3aU3960GVJedEO4iLuOIsAmaSsupErI71ivNvn3mOSK2p3PNndv4m9HS3Nc
	 8qPZzGXzaSQmLHABa4NPpJDnfjcUgnUXWyqE3Sq6Pw4HyoiCeC6HLRwWoWRNrjP/uK
	 ZY8iRKVI21HO0x/3FhkJkn7jdMyJccvoMJKu57TrQohTHqcDvFH5ik7LbnzSL/Uglt
	 xB6QdpdJURPBMAF+S6tPd9m51kiHSu9pBi+ffGJfQMvvPf3fOGh4b12U8jkOmNHiMC
	 Jd86VPRB51E9A==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, 
 Roland Dreier <roland@purestorage.com>, Yishai Hadas <yishaih@nvidia.com>, 
 Leon Romanovsky <leon@kernel.org>
In-Reply-To: <1951c9500109ca7e36dcd523f8a5f2d0d2a608d1.1718554641.git.leon@kernel.org>
References: <1951c9500109ca7e36dcd523f8a5f2d0d2a608d1.1718554641.git.leon@kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mlx4: Fix truncated output warning in
 alias_GUID.c
Message-Id: <171922266576.231623.12633512568003458119.b4-ty@kernel.org>
Date: Mon, 24 Jun 2024 12:51:05 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-13183


On Sun, 16 Jun 2024 19:17:30 +0300, Leon Romanovsky wrote:
> drivers/infiniband/hw/mlx4/alias_GUID.c: In function ‘mlx4_ib_init_alias_guid_service’:
> drivers/infiniband/hw/mlx4/alias_GUID.c:878:74: error: ‘%d’ directive
> output may be truncated writing between 1 and 11 bytes into a region of
> size 5 [-Werror=format-truncation=]
>   878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
>       |                                                                          ^~
> drivers/infiniband/hw/mlx4/alias_GUID.c:878:63: note: directive argument in the range [-2147483641, 2147483646]
>   878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
>       |                                                               ^~~~~~~~~~~~~~
> drivers/infiniband/hw/mlx4/alias_GUID.c:878:17: note: ‘snprintf’ output
> between 12 and 22 bytes into a destination of size 15
>   878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx4: Fix truncated output warning in alias_GUID.c
      https://git.kernel.org/rdma/rdma/c/bc80b39bffebae

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

