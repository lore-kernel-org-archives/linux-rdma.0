Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F5C3EBF00;
	Fri, 13 Feb 2026 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997163; cv=none; b=oDHl0wx2QoBFOTan2PxTH3l9ct9J+yfHOAVAOLLIdb7d4xkrlIWM2Ap6ML+b4OUMpHmfppLFf5sqhp2zIVTD7cyWpHwe+Vsu2qY2+ot2LWe+FhE09WYnvKuJYDwBy5fMBqYf1f12lpl80Ng+ZDS/z4TXJ64ApGqdGqF+okBt63E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997163; c=relaxed/simple;
	bh=Km0c3hu2mTYwG06bgOREloMPxjOhW5HIfVFrAjnK60E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJkYn2wDFeYJ9Wrmlm97CDExOAnXvUwqEymsE218GTLhCjOFTc0/GPPK2aZPoN83H9NOnKmU5g6lxfLQUDENpM5zxKKqaFr9phJcfLDN5svdhUfcZmyDtht0G0mkWEkhfk4lRZqVModgtI5wx+XffJM/vSJCilrAG0+YWB+iKtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFuuY30T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFuuY30T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0621C116C6;
	Fri, 13 Feb 2026 15:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997163;
	bh=Km0c3hu2mTYwG06bgOREloMPxjOhW5HIfVFrAjnK60E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFuuY30TVRrfxr3c5CEcUPHQcSsiMqDei6vrcDNOF9LR9xOa1xzHXXxmFwT7YOD1S
	 dvULhKBdahoOhBdkN+kMNRq7ZSa9n2LqTv3wWad9ce3QNa43eQr+aLyEz0KkDlOGEc
	 kGNVGtHnTvCNyOqLFWZnBDV8mEK0hmeXpHdJ84Y0T1yKk1UQ3KRZjpoPtSntBZjmF4
	 qhf95qfulUCl/090TaZsPpSJUpT1xxEDzzvps8KdcWsxja/FOht/M3VfRMKJATGfal
	 l1wKncqMIgBdVc/r5+xyXJT490u4jmlo9IdbTQOheR4b2BVOumppT1ijCmZjwLE4Ig
	 Y/+c0e49qwYMQ==
Date: Fri, 13 Feb 2026 17:39:19 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 09/10] RDMA/bnxt_re: Use ib_respond_udata()
Message-ID: <20260213153919.GS12887@unreal>
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <9-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <20260213104024.GN12887@unreal>
 <20260213124232.GC1218606@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213124232.GC1218606@nvidia.com>

On Fri, Feb 13, 2026 at 08:42:32AM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 13, 2026 at 12:40:24PM +0200, Leon Romanovsky wrote:
> 
> > > -	rc = ib_copy_to_udata(udata, &resp, min(udata->outlen, sizeof(resp)));
> > > +	rc = ib_respond_udata(udata, resp);
> > >  	if (rc) {
> > >  		ibdev_err(ibdev, "Failed to copy user context");
> > 
> > Should we move the error message into ib_respond_udata() and remove all
> > the corresponding prints from the drivers?
> 
> There shouldn't be an error message at all. I didn't try to remove
> that stuff.

Please clean this up. People will copy and paste this code, and it is better
to ensure it is properly prepared for future use.

Thanks

> 
> Jason
