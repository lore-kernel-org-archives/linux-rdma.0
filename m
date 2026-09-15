Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9A64C755C;
	Tue, 15 Sep 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789497983; cv=none; b=GZavVN1LOz+znhT2YbL6n5/TOIqImt7e8bPD02h/42ccsN4cz5oiRnhqsLW4tEWrmwk+yuhWTCGPLEquudF/DaVQ/OIYNHWZ6iYeCIyMjwNqO9Je/VUYZEFI987+tkTvAWpyIVFgXiORVTk+l7CywZ45aRBJxSKfse1tQ1rWxFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789497983; c=relaxed/simple;
	bh=WYnwKy8TQ01u3ufFgIsYqd9azJHlmNqBeQBf1pnnd2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ReX2U2TiWnfbN84CMnncmGMOZxrwKyZ0ssKfkuvmK733xDBjEr0LPyP/yw6LkJnchCE/nUnx+asoTmnHXmgTvcce7PT5HDCvZC0M3bMZlNtec0UyZlkVLEaCukhghRLDNfVSe3WC3fgFEJEGYEOLTP97m25NXz/m342Z6WtiQ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ie9rfy0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ie9rfy0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEA31F000FF;
	Tue, 15 Sep 2026 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789497980;
	bh=cYXpv6LWkWjV+MmloXyCd3ld4EzsR5thztDMGkRmxsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ie9rfy0vUiiaKxLfpy0MIFlB5XFrzPHPRqwbe49Hwy2V885trRKTCoYxmBEeOX/cL
	 V+GNwr3aGvbHkAuZm7m0fx9sN2MpOD6iiPJby2KPChwNJhiow6gax2X27wE0gBUMEc
	 6k6sUWoqO84mbgC53ZvP8jVu95U5Z+8MUDcPEXWtCpn7L+tjLsWx3Y11E+2arC8ldY
	 VVqE2Huw6gJd34Aynd8Zwnoh3CsGctQBtbOWdnNTGDl6q9vJmpJ8wP4o/nTi9yaiw1
	 RSWICSXv0qOe0qLrAHnKI5vcPaL9E8jtFhWXQpvuv2eSOUPUyV2PkvwcDE4tRlz36E
	 LZwsAG9wLL4gQ==
Date: Tue, 15 Sep 2026 21:46:15 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Limit SRQ depth to the firmware
 command field
Message-ID: <20260915184615.GQ13683@unreal>
References: <20260915-silent-16-bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com>
 <20260915132428.2C67B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260915132428.2C67B1F0089B@smtp.kernel.org>

On Tue, Sep 15, 2026 at 01:24:27PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RDMA/bnxt_re: silent SRQ desync for legacy userspace due to non-power-of-two cap
> --
> 
> commit a0fff360dfd527e4f635aa0d8696bce687733ce9
> Author: Leon Romanovsky <leon@kernel.org>
> 
> RDMA/bnxt_re: Limit SRQ depth to the firmware command field
> 
> Firmware can report an SRQ depth above 16 bits, but CREATE_SRQ carries the
> allocated depth in a 16-bit field. Requests near the advertised limit can
> therefore truncate the command value and make firmware use a different
> depth than the allocated queue.
> 
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > index ef08d42f377e6..43ff3e7a459fa 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -2229,8 +2229,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
> >  	dev_attr = rdev->dev_attr;
> >  	srq = container_of(ib_srq, struct bnxt_re_srq, ib_srq);
> >  
> > -	if (srq_init_attr->attr.max_wr >= dev_attr->max_srq_wqes) {
> > -		ibdev_err(&rdev->ibdev, "Create CQ failed - max exceeded");
> > +	if (srq_init_attr->attr.max_wr > dev_attr->max_srq_wqes) {
> > +		ibdev_err(&rdev->ibdev, "Create SRQ failed - max exceeded");
> >  		rc = -EINVAL;
> >  		goto exit;
> >  	}
> > diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> > index ec9eb52a8ebf7..63dcbb9d80f4b 100644
> > --- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> > +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> > @@ -159,7 +159,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
> >  	attr->max_ah = le32_to_cpu(sb->max_ah);
> >  
> >  	attr->max_srq = le16_to_cpu(sb->max_srq);
> > -	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
> > +	attr->max_srq_wqes = min_t(u32, le32_to_cpu(sb->max_srq_wr),
> > +				   U16_MAX) - 1;
> 
> [Severity: High]
> Does capping max_srq_wqes to 65534 break legacy userspace applications that
> rely on power-of-two queue sizes?

Sashiko has a point, the power-of-two is negotiated with
BNXT_RE_UCNTX_CMASK_POW2_DISABLED bit.

Thanks

> 
> If a legacy application requests an SRQ size that rounds up to 65536
> (e.g. 32768), bnxt_re_create_srq() will pass dev_attr->max_srq_wqes + 1
> (65535) as the maximum to bnxt_re_init_depth():
> 
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:bnxt_re_create_srq() {
>     ...
> 	srq->qplib_srq.max_wqe =
> 		bnxt_re_init_depth(srq_init_attr->attr.max_wr + 1,
> 				   dev_attr->max_srq_wqes + 1, uctx);
>     ...
> }
> 
> In bnxt_re_init_depth(), this results in min(65536, 65535) and returns 65535:
> 
> drivers/infiniband/hw/bnxt_re/ib_verbs.h:bnxt_re_init_depth() {
>     ...
> 	if (uctx && !(uctx->cmask & BNXT_RE_UCNTX_CAP_POW2_DISABLED))
> 		return min(roundup_pow_of_two(ent), max);
>     ...
> }
> 
> Because 65535 is not a power of two, legacy userspace masking (e.g., idx &
> 0xFFFE) becomes mathematically incorrect, immediately corrupting ring state
> and causing producer/consumer desynchronization without throwing an error.
> 
> >  	attr->max_srq_sges = sb->max_srq_sge;
> >  	attr->max_pkey = 1;
> >  	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260915-silent-16-bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com?part=1
