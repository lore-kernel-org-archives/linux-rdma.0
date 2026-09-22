Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9470D5616C5
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094518; cv=none; b=usg9fDrm5ZAKwKp0GwNNSm45x0Enqqshzcu5Jr48kCp8JqSfyoGRc5OOHZwaIc9sYHpiCmIy1wgIGfZeyIa5tdd+oB5M1YYLYAEnGbgL1rFayMim4iAEZ9ZOvs6ndEK9AxQ/cqO+gjOCw0/mct3xsaPWiHirWIc9nQCKZwkiCvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094518; c=relaxed/simple;
	bh=f0m2eroJSURU1exL10gldlzl18nJ2NGdgvJAdL4mKqs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W51kDJSj8Mmj/U/QvpxvcQRZN2uK4aPmyfEnUlqcW/i4s7tYYCtN48BQJN7leQhF/fJjWdV0Z6o46dMcJkmXIlOdTel4HkDuI8qGsxFY8qm5aBp1jU/wDiHfSPXlDiXHESRO4DSh46xNglYKH+y/vyDDGHmE4jfrK13buZG8i/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=pTZvumWk; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="pTZvumWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790094517; x=1821630517;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=N6Hu/i1Ff99mkUBw5NDgey6XE7vt8L3Q+QeOM5C9N6o=;
  b=pTZvumWkqOPokZj/2uBQDZLRrF+CMGaglXQ4tpX+631q0rrnmocsp3QD
   BotqputHCIlM6wFCcJm/lMCtAgaRl6j2xT/lI0oMlI9TaAhmnAXlLEhZX
   Qgw6OAB4TInP14l/Z0tVcScqlA9sFL0NaKsZLQW7qnI1xopOwedWUMbm8
   LUsKhjawfp4sx6W0CGDdhaSk7YFNABWYHRVQB5fkNZ3EjIHqlPBIkzN+g
   zNXgAh9nzbw58rGahaouvMPsOGBdUGDJfG9gaJRY6X7MWZMw6Iug8ndgB
   z36k5xyVtO7+eUyjlnqkVExFOJElGmG/LWKyGvxNB8mhmN0dURsus8xmr
   w==;
X-CSE-ConnectionGUID: vS0FuxozQDe7HehY1Jnojw==
X-CSE-MsgGUID: JyumqYInSEyB3lBVAKkoLw==
X-IronPort-AV: E=Sophos;i="6.27,116,1787011200"; 
   d="scan'208";a="29267518"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:28:35 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:28862]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.232:2525] with esmtp (Farcaster)
 id 02965251-2f28-4f16-8798-241e306edae6; Tue, 22 Sep 2026 16:28:35 +0000 (UTC)
X-Farcaster-Flow-ID: 02965251-2f28-4f16-8798-241e306edae6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 22 Sep 2026 16:28:34 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Tue, 22 Sep 2026
 16:28:33 +0000
Date: Tue, 22 Sep 2026 16:28:26 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH for-next v3 2/2] RDMA/efa: Pass relaxed ordering flag to
 device
Message-ID: <20260922162826.GA20821@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260922160118.990-1-mrgolin@amazon.com>
 <20260922160118.990-3-mrgolin@amazon.com>
 <20260922161443.CB48B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922161443.CB48B1F000FF@smtp.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D039UWB004.ant.amazon.com (10.13.138.57) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, Sep 22, 2026 at 04:14:43PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] efa: missing firmware capability check for relaxed ordering
> --
> 
> commit 8cde16309300638ef5ed5570f8cb4ae347e5c6e6
> Author: Dana Malachi <danamala@amazon.com>
> 
> RDMA/efa: Pass relaxed ordering flag to device
> 
> This commit accepts the relaxed ordering access flag during memory region
> registration and forwards it to the device firmware via the admin command
> path.
> 
> > diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
> > index aac0e936601a1..07bfcb093df85 100644
> > --- a/drivers/infiniband/hw/efa/efa_com_cmd.c
> > +++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
> [ ... ]
> > @@ -236,6 +236,8 @@ int efa_com_register_mr(struct efa_com_dev *edev,
> >  	mr_cmd.mr_length = params->mr_length_in_bytes;
> >  	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
> >  		params->page_shift);
> > +	if (params->relaxed_ordering)
> > +		EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE, 1);
> 
> [Severity: Medium]
> Could setting this bit cause memory region registration to fail on older
> firmware versions?
> 
> If older firmware strictly enforces the MBZ (Must Be Zero) rule for bit 6,
> it might reject the command when userspace requests relaxed ordering. Since
> there doesn't appear to be a check against device attributes or firmware
> capabilities here, does the driver need to verify firmware support before
> passing this flag down in efa_com_register_mr()?
> 
> [ ... ]
> > diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> > index 6356872753507..9e4435401a4c7 100644
> > --- a/drivers/infiniband/hw/efa/efa_verbs.c
> > +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> [ ... ]
> > @@ -1679,6 +1679,7 @@ static int efa_register_mr(struct ib_pd *ibpd, struct efa_mr *mr, u64 start,
> >  	params.permissions.local_write = !!(access_flags & IB_ACCESS_LOCAL_WRITE);
> >  	params.permissions.remote_write = !!(access_flags & IB_ACCESS_REMOTE_WRITE);
> >  	params.permissions.remote_read = !!(access_flags & IB_ACCESS_REMOTE_READ);
> > +	params.relaxed_ordering = !!(access_flags & IB_ACCESS_RELAXED_ORDERING);
> 
> [Severity: Medium]
> This passes the userspace IB_ACCESS_RELAXED_ORDERING flag directly into
> the command parameters in efa_register_mr(). 
> 
> Should this be gated by a capability check so we don't inadvertently break
> MR registration for older devices if a userspace application unconditionally
> sets this access flag?
> 

For both comments (that are basically same), that's ok in this case -
devices ignore this bit when RO is not supported.

Michael

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922160118.990-1-mrgolin@amazon.com?part=2
