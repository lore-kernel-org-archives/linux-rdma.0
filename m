Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875083F23D0;
	Mon, 12 Oct 2026 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830425; cv=none; b=dbWgBaijD7m2H1gzo5qyQyHfnpoUatJ9+jzwoSWGbZkMEbV7UJM16ejnsA8ojmx9QKqVYwKir97eH63Ga6ZlNXEQON7+N11p5C5MsjsEwysYFKS3dpp5mM0lTUaSc1v1MJOUfU+I3CQzSIoRMw5zQnyW6mBcsaV1kHH2OfmcPuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830425; c=relaxed/simple;
	bh=Y5WiD0nLj8+Bfh17drMQqQqgdDnkLsCE4wiqvxdRXas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQdfJqkzv7JkXOVd25DX37zJAI+Sz5Fg4d63SjeF3NSWfKwFU2Wmw6nf6xvB9pyylyFzGxBvy0JuDqJlZU2w++ZCPsX6pEJbDii3G4Nu2jB9k/h+qsazzekPJ9S+5P1QolXiQcAosdwlcTBx3lB1GlZKK8ZKa+dT/FhSODqF+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nd/jIKBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nd/jIKBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0671F0089B;
	Mon, 12 Oct 2026 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830424;
	bh=72S7hBFcXN3w+nzaQM5xVnbXCT1pkqZQ/s5TrKdSWRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nd/jIKBIrNe+jWdwqLXsZ6U5C8wfRryaymjpG37eE25SYIcrk0Sy0eGMX+uxREr/t
	 lL1dZEOvhDKKo8h6TleP5QBjXZ3KTopzMENZyruTOx48Yfc39tTqSqyC3XIROCs+9c
	 BJ0ri6TLMO/zPoeAjkyyIjaavRH+y95nWGhLPPpPhyLxB3Ks0atkqAAcsAMWTGlfOv
	 OAIokolG9DcGn0RXt5RmcCHsAHgR682g9CHO0n7Rh4IVPmjEjvdhtdCeeCTwhYckIZ
	 xZyHt3zZmWbRPgiXY8Yc3vrRW0Y8oG5clBiuu9DmCJNDbASvvMJZ5+YY9FJM/fNv/N
	 +I8cGbtra5ePw==
Date: Mon, 12 Oct 2026 21:40:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Haitam Lazaar <haitam@lazaarsec.com>
Cc: Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for
 read responses
Message-ID: <20261012184019.GK219304@unreal>
References: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
 <ecf307a2-e814-480d-8da8-1a7b76537d3f@linux.dev>
 <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>

On Mon, Oct 05, 2026 at 03:18:25PM +0000, Haitam Lazaar wrote:
> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> mask:
> 
>     /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
>     rv = siw_check_sgl_tx(qp->pd, wqe, 0);
> 
> Because perms is 0, siw_check_mem()'s authorization test:
>     if ((mem->perms & perms) < perms)
> evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
> an untrusted remote peer can issue an RDMA Read targeting any valid
> STag in the Protection Domain, even if the memory was registered strictly
> as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.
> 
> Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
> when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
> perms = 0 for standard local sends.
> 
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>
> ---
> v1 -> v2:
>  - Compact READ_RESPONSE handling by combining num_sge and perms assignment
>    as suggested by Bernard Metzler.

Please don't send patches as Reply-to previous version.

Thanks
