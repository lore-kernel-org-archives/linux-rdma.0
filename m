Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A371E98E3;
	Sun,  7 Jun 2026 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827063; cv=none; b=n8BZ/lTVPQFUkSMVfFK00cCk0d7f0XgIxYZygVHN4zkxz2SRjM/NCvuESx8flX5I2RIhNaix5WhfDxUpboe5KHD79mm39S4qgZi01vZiR5IZRa6QstLGzW76g/6JWxfCGCnvLGC8L5PnXAnEo0SA9Opv1dElUARba5YH5J9McU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827063; c=relaxed/simple;
	bh=CopSiw+NcfqVh9zee2U6gLhA98twW+OmwOpd2fZVvUs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ouD2RR3sFputN5QXlqymn8MRfQe+C2uClPgFmQSveqeR4g7ZaqBPV4C7fKBV6Ei9Dgr8JdOTKVibCRPGZLO6Y9aRUF+Bty8rSUwJYTfWy4P5dsJJsrUDaXCTTiBymSjBx8Hbq0sh7We/ViCEiM3aQ4bNfElzAQvnun0mMf6fmAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsdWPgdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsdWPgdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E351F00898;
	Sun,  7 Jun 2026 10:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780827062;
	bh=XPB3nQ7jNSWdej/jsORQVH8vmBpgTh5XHeuu5DcxTWI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=fsdWPgdMRXLNC0RV4QqPFH1XDYDA1QVoPBSNAJsTO8BKd7jkwlxcKJle/ONRcpMv6
	 5PYzT3L3U9fjPz1PfqZ44lWH5JFYvJG3bqV7yBEEZfan/76hkdLuqPjBMxz4gXqqDA
	 BgIVxiLj+uBz2yh5RFX2AFCnXEXoijmZiQEYX3DFUiZbE/g4xBKLIWzCx5QWdfED7M
	 efrt0kMYG9e0pIB68kQlwyICuLOAHCdBBWeqPFWByzlhZ82Buc5rizJyhhYJa/xm4V
	 xn4Tl+VbpG5g2mJGtDT07pFdeu8WWZUF/CqU5uAR6IfYBVz3JC6Y8BWGip2EUAP2GA
	 7qPP15qNhIE1w==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20260529052359.389413-1-tariqt@nvidia.com>
References: <20260529052359.389413-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-05-29
Message-Id: <178082705966.3033804.9374462993799593597.b4-ty@kernel.org>
Date: Sun, 07 Jun 2026 06:10:59 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 29 May 2026 08:23:57 +0300, Tariq Toukan wrote:
> This series contains mlx5 shared updates.
> 
> Regards,
> Tariq
> 
> Dragos Tatulea (1):
>   net/mlx5: Update IFC allowed_list_size field bits
> 
> [...]

Applied, thanks!

[1/2] net/mlx5: Update IFC allowed_list_size field bits
      https://git.kernel.org/rdma/rdma/c/cc71b7f32f0ba8
[2/2] net/mlx5: Add sd_group_size bits for SD management
      https://git.kernel.org/rdma/rdma/c/ddbddbf8aee54b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

