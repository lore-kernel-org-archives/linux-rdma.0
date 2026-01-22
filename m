Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C353EBF3D
	for <linux-rdma@vger.kernel.org>; Thu, 22 Jan 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101810; cv=none; b=G7LRQG1XOVBJKuIvKoj8vd+RO6EGVaXbjaY7/2n9LDPoaQz6O/NcX6AAY/8WA9GIi80C1dkcn0L3Zs1ASA5a0+b8h+CIY5mVcei9d/H4122PR0M4WKTx6zN9OhF/ykCMydBKzzs1HE1Z/hQKym6Hnau1nTbVrhy3ID3KBsQLvs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101810; c=relaxed/simple;
	bh=InjV94M9hZGmudvwWkiMkg4m+x4BjkmMac/RvNBa7mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvGmYYczT40MXGMO8OPZulkOsdEbE96dlbMFpKgf7XBS/XkIbHpbX++zPVhKXlVWqS+0x/PHTHB84EDTmHq9ywcCvdosh31t025ygInWx2uB2E/wGzccYRm7j6Tb4lp9+dUDk7aJriauKtzCueOHKlRgYi8s7X2DzNrB3CdcwfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyzpgD4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyzpgD4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AC2C116C6;
	Thu, 22 Jan 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769101809;
	bh=InjV94M9hZGmudvwWkiMkg4m+x4BjkmMac/RvNBa7mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GyzpgD4PPVZJ5vWI6gC52eC+dgWT2KFHGS7M5KcyRsoHuHRhsRJRRnO78h16TiLNr
	 ODxNnsTTR6diE2mOGnTWdIFq1K7WauxwcFxvXv7KZy36EMrWk7sMNHxqtpwXCjzG65
	 3ATjhLPyOza9eaS2T1LnDw3Nei0e3W1/g5mRDPWY=
Date: Thu, 22 Jan 2026 18:10:06 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yi Liu <liuy22@mails.tsinghua.edu.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
	security@kernel.org
Subject: Re: [PATCH 0/1] RDMA/uverbs: Fix missing wqe_size validation in
 ib_uverbs_post_send
Message-ID: <2026012249-huddling-scorn-d194@gregkh>
References: <20260122142900.2356276-1-liuy22@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122142900.2356276-1-liuy22@mails.tsinghua.edu.cn>

On Thu, Jan 22, 2026 at 10:28:59PM +0800, Yi Liu wrote:
> Given the potential for kernel heap information disclosure, I believe
> the first issue may warrant a CVE assignment. I would appreciate it if
> the security team could evaluate this.

The kernel security team has nothing to do with CVEs, sorry.  Please see
the in-kernel documentation at:
	https://www.kernel.org/doc/html/latest/process/cve.html
for how that works.

And as this is a public issue, the kernel security team doesn't need to
be involved at all :)

thanks,

greg k-h
