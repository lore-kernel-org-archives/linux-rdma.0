Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D17C36BCC3
	for <linux-rdma@vger.kernel.org>; Sun, 12 Jul 2026 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783847613; cv=none; b=rgaw/fB3WXYfZa1B6KUEGhOQDnuMmFmwcSzgpaVkJw4tAN7Iaf4b8Z2Hm0FP5aEVqdm/Uhl7xshvtRirQH3+T84GwnPG9SIB2Rm/pZIQj3IX756y8F/rHsr3Q1s5hiYr/hab0cOjImkEFqj6a/F6ZNT59ROU5KoyaI7R223IZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783847613; c=relaxed/simple;
	bh=tgzAKMNW8ZfPs1Ko4jHTWkUQw1aZcHGNA8q3uTnh/as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JR5kgT+Wg3bitF+WQfcgpoQJReIaxaAx3E9Df9jK/4bAHyB5Yhq1TaybOVntY24w9o0N7xND48WVBWZNkBrvD7Hi6LR9nbUMdRCyZcW8saP0ql6CAPIe8S4gUhEtEhhQV521UMsOIox6jewKBduypFLK4fNwtvQ/yyRudMRFtxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKs551H1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKs551H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FF01F000E9;
	Sun, 12 Jul 2026 09:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783847611;
	bh=7UuFVh2BQTPAK8HwjImBHNQZEQaRUbsDBQp419h+dY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gKs551H1kIphArJR+kbDoqm4fFstiqXLaqvtbJm7+ztkstlvL6zQS+6xYBLXlS4GO
	 hC7mrYl6v3njs3vve1FbNQ8OHxU8HJoMZ/m2pi5Fh3P4ZAPSOExhEGrf2sCUapv3mx
	 mDkAiSyPScv3jnydgVZRIn+cCFyamM/dE6cyWZ3gnvhrY2rz0+7TO17mOCyINBPLqx
	 xKDtUzNu9RMZE5axTvH1VlLJoOZ4rUL7NmMhfXPHUSbC7m04sL/ZRVUunXd3HOQ0Ns
	 tbXSRCjBWPTjKsW226550k4Ctau0AGZL7SzFvplgx5RFt48V9r/4EuwPBDf+zvU6Tn
	 zSGf8p4FjHF3w==
Date: Sun, 12 Jul 2026 12:13:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Kamal Heib <kheib@redhat.com>
Cc: linux-rdma@vger.kernel.org, Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-rc 0/2] RDMA/ionic: Fix NULL pointer dereferences
Message-ID: <20260712091326.GG33197@unreal>
References: <20260709220353.729951-1-kheib@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709220353.729951-1-kheib@redhat.com>

On Thu, Jul 09, 2026 at 06:03:51PM -0400, Kamal Heib wrote:
> Fix two potential NULL pointer dereferences in the ionic driver by
> adding the missing NULL checks before dereferencing netdev pointers.

How is it possible to have ionic IB driver without netdev?

Thanks

> 
> Kamal Heib (2):
>   RDMA/ionic: Fix potential NULL pointer dereference in
>     ionic_query_device
>   RDMA/ionic: Fix potential NULL pointer dereference in
>     ionic_create_ibdev
> 
>  drivers/infiniband/hw/ionic/ionic_ibdev.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> -- 
> 2.55.0
> 
> 
