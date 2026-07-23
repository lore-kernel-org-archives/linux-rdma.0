Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C426D46D563
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 12:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810095; cv=none; b=UgCFbfUj8xzqUCR3f4L2Cd4lF10Hi6OToPHcj33WNFPZY8mjir2lXe0ZKZ33hrCqo9Jy1ytzbKgk8MRB+ytma8kMNRwTlqD8dwkPgJM5uRx/gyTyIJ3heSHN0knqzm3172vWetUODNAc2pxUdStPNL3tjX/5FdOfxD9+S2AlA3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810095; c=relaxed/simple;
	bh=9vXsW6c9n5QaFWJNV0zxUuUugKYaTQbYumhDHuUm1UM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D7a/GTuvPHBSHXBekQOO6NBMqDqInQv0Q4qKhBVge7b2Lhu5ByaQTX3eGHLZDpv3kyCkyS+K5OA6UF8B9w50ZTUnTte8vFbg9S5qNEZCE+/InuNNbntGgNWk/aBBup+/GirZVK7o+HnxBJJLmJ1aUNuANF2l9qgRDM2DgTdrqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEPiYHwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEPiYHwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF58F1F000E9;
	Thu, 23 Jul 2026 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784810094;
	bh=KCsxg8SO3rXqLuCEjtlBH7A1l9Erq6+441LNFFV1WnQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WEPiYHwiSm7MsuGp6B4nLMGQut6d1dLw33oHZQb+SClE8Zj9sUKW5P/ekm3sJ5Zr0
	 /YoQJsEi7NpDFWOj6m3X0duTmm3QdyInVg947rMbAhX1+UeRdQeldRCSSfP8Amc8Id
	 QI+hYu0cf8u4Fm3coubVj/wwyD6RiXi1KiLAERAMRyTIkVCxBcVqbrI8jgxHHijgRe
	 Q/PIUElhaj4qr2DmlQDkYh6WwyKgMbDteomvMrteqfVUjurNynhU0EKHGnEXqtL9KL
	 wXYkC9eUy9Yec7TLEuh5OotnBrX1uSKZGOrRVV660t1z6y+ORx1mDbGnwldJr8+l1I
	 zZmb1ujvBvQCg==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Cc: jgg@ziepe.ca, mrgolin@amazon.com
In-Reply-To: <20260701124015.64350-1-jiri@resnulli.us>
References: <20260701124015.64350-1-jiri@resnulli.us>
Subject: Re: [PATCH rdma-next v3 0/3] RDMA: add per-attribute UMEM for SRQ
 create
Message-Id: <178481009157.3480189.16148817701964697005.b4-ty@kernel.org>
Date: Thu, 23 Jul 2026 08:34:51 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 01 Jul 2026 14:40:12 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This series continues extending the per-attribute UMEM model to the
> SRQ create uverb flow, so that userspace can back related buffers
> using previously introduce descriptor infrastructure.
> 
> The underlying infrastructure - ib_umem_get_attr_or_va() and the
> per-command UMEM attributes - is already in place and used by the CQ and
> QP create uverbs. This series applies the same model to the SRQ create
> flow (the WQE buffer and the mlx5 doorbell record) and wire this up
> in mlx5 driver.
> 
> [...]

Applied, thanks!

[1/3] RDMA/uverbs: Add SRQ buffer UMEM attribute
      https://git.kernel.org/rdma/rdma/c/fe34dc1fa08224
[2/3] RDMA/mlx5: Use UMEM attribute for SRQ buffer in create_srq
      https://git.kernel.org/rdma/rdma/c/023349192e79cf
[3/3] RDMA/mlx5: Use UMEM attribute for SRQ doorbell record
      https://git.kernel.org/rdma/rdma/c/aac287f4f1ebeb

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

