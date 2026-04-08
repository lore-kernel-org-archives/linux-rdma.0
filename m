Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4FD175A63;
	Wed,  8 Apr 2026 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775661965; cv=none; b=ebktojbVsMZmI75N/zDzEA1nz7hgh0bgNP0AH7EJpJRWTjC47viHWB9BsM9DKpmWa361CUL4RbuSPEyK25zQ5WcqB7klenJejdgtpFjk2s16E4up7BhsXiTvP3S/ZXAbHdG9XmZQgnXVS0Y4tnnOAllBBJUX4PPI5y0rpULULjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775661965; c=relaxed/simple;
	bh=KsQyl1ZyVyK9D9CF592JArgWi3cqdGNTKg78GwavARM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YapTMduzPRK3pakXhxpCLGJjuTLpYmx9S1Of0kjZRFJ+r9y5WeNYWkS5FPUU7rdaP8czEtVVaUGxA4Xe2trM8Uy2IBocuWt5as1U6Rktsm/SoptMU1A1HIEyzBARbCFr1JafHvkJCg0gwi5KqqfSI+G5yUD9bkgYWo7zawFx06Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+QOerFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+QOerFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FC0C19421;
	Wed,  8 Apr 2026 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775661965;
	bh=KsQyl1ZyVyK9D9CF592JArgWi3cqdGNTKg78GwavARM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+QOerFDDmaD0SRl/5jE1iYESDvgxtv5U297dpdh1N6IATREv8/kpDqPushIedki/
	 9dJyZUJqlA3ElUm3zNPsOrkladtTJfZBqaFOhedKbQjzQAWwrEnAA1Cpyjzl2ax8y3
	 +GWE4VEMhFWLeb1esluazmGuxi+BKyucvwd5kFRo+bnrUwA+pr224EoBY07GiKMp4X
	 rP1RDImHxSrUYaDl9Xk4TJ+NjFx0SX3rqXyBS+ULSxh9fYg6jUWGoEKFqbrb05IG/d
	 96/g5zOtwboFvhAEhJt1STafthSpXOXEYa18QShT9ISZxVV3/hQYy6OG/AR2htP2Ii
	 FrHkGciRtwFUA==
Date: Wed, 8 Apr 2026 09:26:03 -0600
From: Keith Busch <kbusch@kernel.org>
To: Shivaji Kant <shivajikant@google.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	henrique.carvalho@suse.com, linux-nvme@lists.infradead.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pranjal Shrivastava <praan@google.com>
Subject: Re: [PATCH v3] nvme: enable PCI P2PDMA support for RDMA transport
Message-ID: <adZziy_r_5BFMx8U@kbusch-mbp>
References: <20260406092132.1333458-1-shivajikant@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406092132.1333458-1-shivajikant@google.com>

On Mon, Apr 06, 2026 at 09:21:32AM +0000, Shivaji Kant wrote:
> Enable BLK_FEAT_PCI_P2PDMA on the NVMe when the underlying
> RDMA controller supports it.

Thanks, applied to nvme-7.1.
