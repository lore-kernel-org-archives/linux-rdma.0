Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56993ACA58;
	Tue,  4 Aug 2026 01:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785805593; cv=none; b=hIUXLZPsmWS2KEIp9pfr+uOzr49cGp5GpHU2P9ASMTOtA4gXwseZvpnXre5v/69A9KhQR7/h63WGwSqt4DYwR8pWM3t7eQbbjVmhY+RlDV283cQFhtFmR8M+Mk80ODUcmybF6nAG0Iuv7q/g5pauRmtyD2YHHtWn6lOUkpmWurk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785805593; c=relaxed/simple;
	bh=IuyBCeH1qGLR61B+rXPybdwA5+ZgwrWXMAFRgR8iZYE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATFUWMdMDEBNwnGXYkcKy3rkH7trFKBw0aCMZzub/w72dttF28CFBakyYzUCqZMT1tlBuhQgix9/OsMbbB+MmDcho78u+NXKEomge2C7ZVNE+t/Z/D86+cfiWQzbBd1aZtIm/c6+CzC3yH8ADKBNVjQCVz1HttTSSQwq9C8ko3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JU4hyO5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JU4hyO5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189121F00A3D;
	Tue,  4 Aug 2026 01:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785805592;
	bh=4ggcyklPNP/Ka92ERqUUXKmfaNifZ6wrBDocR5GKTJo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JU4hyO5ryF1FFS44LOl1SW5BbijGrwpsGGy/UYK7qzqXLIyCtZNFmg5WcAOjjWSBN
	 WBvHU1XDykWk1WfL8JsccccL0dJI7AECoi0PB4TVS3ET4Xq8rdboNBI933+r+7sox+
	 ep/E6rb09L5HcP0PZOL888exqMUTQOyJb5BE1zWNpgeMkdimOpOVWS0BcN0UkJqJ+7
	 Wy127/Q8sFDf7hDeyr/Ykeelt3EUs11XA4UKynDZFeWdXN4sLju24es8d+ieATjL4d
	 C4JrG1oTZU1nRw811PkI9EcWkIo1bydnI6R7YOUYkJoHlYdemCC9/y8TN8bXso6tEt
	 HSmiak0KmV0fg==
Date: Mon, 3 Aug 2026 18:06:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Boris Pismenny
 <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Dragos Tatulea
 <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Kees Cook"
 <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
 <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Add mutual exclusion between PSP and PTP
 TX port timestamping
Message-ID: <20260803180631.5813f758@kernel.org>
In-Reply-To: <20260729065137.2420679-1-tariqt@nvidia.com>
References: <20260729065137.2420679-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jul 2026 09:51:37 +0300 Tariq Toukan wrote:
> The WQE flow_table_metadata field is shared by multiple TX offloads:
> IPsec, MACsec, PTP timestamping and PSP each write to it.
> 
> Commit [1] resolved the conflicts between IPsec/MACsec and PTP
> by shifting their markers to bits [8+], leaving PTP's 8-bit metadata
> index in bits [7:0] without overlap.
> But then PSP support was added in commit [2], which writes a 32-bit
> keyid across all bits of flow_table_metadata. Unlike IPsec and MACsec,
> PTP timestamping applies independently of encryption -- a PSP-encrypted
> packet can also require a HW timestamp. When both write to the same
> WQE, the values corrupt each other, leading to wrong PTP timestamp
> tracking and potentially wrong PSP encryption keys.

Is the concern about Tx? (please clarify)
If so, Tx HW timestamps are never guaranteed, why can't we just
skip timestamping for PSP packets? Only TCP supports PSP, and
upstream TCP and HW timestamps are pretty much mutually exclusive.

> Prevent the conflict at configuration time by blocking:
> - Enabling TX-port-TS when PSP has active TX keys.
> - Adding PSP TX keys when TX-port-TS is already enabled.

Why catch PSP at the Tx key programming? PSP docs very explicitly
require drivers to _not_ enable the feature by default. And tx
keys can't be added if it's disabled. So it would make much more
sense to catch the enable / config callback of PSP?
-- 
pw-bot: cr
