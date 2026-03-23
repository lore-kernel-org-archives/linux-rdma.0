Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD3D27FD5B;
	Mon, 23 Mar 2026 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284995; cv=none; b=l9sXu1DXE0iZ4S9gyqjBfIBedkL0RzIzl1GtZK9fEkR3Kv1WfUXTaWELhvuPlqfC7uhEy7MBkAh+QmAJFibtw0kVp85wFxPrCpNbjXhu6/LCbTrBE9GfoDfY690/DKRdLypzSiQeiil4hrYI/OBxvoDldU6I53FFM2q1hQ0G0wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284995; c=relaxed/simple;
	bh=3LRr6Oc3HbunR39jA4Wco85rPF1hz2A9p50eN6FrOGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfwTybQrXSg4ObprSU+K05BkbOlypJpOYSXYQ7mn0Mrl++GwK0ZKHPlNj9JELAGHjUFyQlzH6BnVt5mzJtoaX3+zUF2W5EKVTVvOdVQbx3Myodpd0N5/5sDIkLRFaNGyAi99oMCdpmR9bWVCNT1bEABvaRDP9wB5mkPwH7aOjCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKhPgevW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKhPgevW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02119C4CEF7;
	Mon, 23 Mar 2026 16:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774284995;
	bh=3LRr6Oc3HbunR39jA4Wco85rPF1hz2A9p50eN6FrOGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKhPgevWJwYDUpAHx3SmxswXbZYutp9wdwpVIrC3PJZVIE4LEXS8dzZ4R1zL+YKBV
	 gRmyxjUsi7Xq+blRYMgJ9lE9BRSIO3jm4L94OXus9AuBCEPlFimeVsy6diaaygnPHd
	 kZBPLol6vlTgnYaZJsMYVEWNWh92t36nxnZ7vdo5QAv9jqvEGi3QjGcc5pFTnmkD+v
	 5HSz+sy4eBky9GW6THBx4AWCF1B/7xPwbR/Ckv0capkGC7yI6Zu2uhDHMBnT57qD9A
	 J++F56HcOzYVvrah/0iHAnnpM0iYsb0kBI5dEFHxzWz5gs21b2MLTsQNu3ybDPNJoS
	 Uz9rBLudsa6pw==
Date: Mon, 23 Mar 2026 18:56:27 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx5: bound raw flow rule match parameter copies
Message-ID: <20260323165627.GI814676@unreal>
References: <20260322031922.57975-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322031922.57975-1-pengpeng@iscas.ac.cn>

On Sun, Mar 22, 2026 at 11:19:22AM +0800, Pengpeng Hou wrote:
> `_create_raw_flow_rule()` copies user-supplied match data and matcher
> mask bytes directly into the fixed `mlx5_flow_spec` arrays. The UAPI
> allows up to `MLX5_IB_DW_MATCH_PARAM` bytes for the input attributes,
> but the kernel object only allocates
> `MLX5_ST_SZ_DW(fte_match_param)` bytes for each buffer.
> 
> Validate the sizes before copying so oversized verbs requests cannot
> corrupt the spec object.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/mlx5/fs.c | 6 ++++++
>  1 file changed, 6 insertions(+)

I suggest you to simply change MLX5_IB_DW_MATCH_PARAM value from 0xA0 to
be 0x80.

Thanks
