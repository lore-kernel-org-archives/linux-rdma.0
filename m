Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D7E481FA1
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 11:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470555; cv=none; b=JSxmQRZKWcQlwT9sS7zlNGki4eGWg+kmT7bsxlcbDo9CqeeUQSgiI+FuF791ELTq2THoNDsaLHRhLjf7H0GqHILtfdNUmmlW9ac2rU/Lan4o5p+F6ypO7/3GXjwuWZylWJTU5/269OS2H1ME71bKCGTdNUFTnJIoV+A/htkIL+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470555; c=relaxed/simple;
	bh=MUUFNXHg7881K3DZ1+BmfOMu3bHF/5od5gmdDdyIjng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UT+ld2NsNrY3kwxkiZtukuqZ3vY7jfj4221WC6jqkc6Mc8suGnDLb8cfvCRp6uCMorRsZnjB81P/p+/a6zwvEzvVVev/mSi6TR5xXA3QG4kMUZpbNclP/kSEnS9+sM6XUaTEkFqz52SQDuRi6Xyr/FP9iNG2V0Ss9dfQJaeAEP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHRVzGIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHRVzGIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165A11F00899;
	Tue, 15 Sep 2026 11:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470553;
	bh=TfkhWobNfd16H2o2zqJNM/vzWB1t9PTMI6rB/ZAN1FA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LHRVzGIi81gaLeQ1OEwNJdRWa8rjKYPaaOkAKbiTkILWzls1Cet+rN7N2TJfFwQB/
	 j3AZZHZUD6iMZyyVHkGuEU5Wbsn7vOb8pQ0R4RRTn0IdJj8ng+1uVo6mX6olBBiO70
	 Afll6xxn3WcHAZUCOEMA6OCk2kPhx3lMzt3ZyKQIR60tjbTbhum20n2AupM2soMlaJ
	 oLDBwrAmPqADXdT/kNXkE5Nup7OlPeqg3RplY+fK0YZKxu0X4bz4s10xa86OLKLDBB
	 nt7E9vLoCE7wS+3YRIuTDvpbKnpHYtnHeQQf/PM3hCofSbxhJTF3hJb2EgBEkoG5MP
	 WoNj4OHyT5QaQ==
Date: Tue, 15 Sep 2026 14:09:09 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	danamala@amazon.com
Subject: Re: [PATCH for-next v2 0/2] RDMA/efa: Add support for MR relaxed
 ordering
Message-ID: <20260915110909.GI13683@unreal>
References: <20260824073057.1046630-1-ynachum@amazon.com>
 <20260914065601.GA21454@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914065601.GA21454@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>

On Mon, Sep 14, 2026 at 06:56:01AM +0000, Yonatan Nachum wrote:
> On Mon, Aug 24, 2026 at 07:30:55AM +0000, Yonatan Nachum wrote:
> > Changelog:
> > v2:
> >  * Remove the relaxed ordering device capability.
> > v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/
> > 
> > -------------------------------------------------------------------------
> > Add support for MR relaxed ordering access flag, allowing userspace to
> > create PCIe relaxed ordering MRs.
> > 
> > Dana Malachi (2):
> >   RDMA/efa: Use device ABI MR permissions instead of verbs flags
> >   RDMA/efa: Pass relaxed ordering flag to device
> > 
> >  drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
> >  drivers/infiniband/hw/efa/efa_com_cmd.c         | 9 ++++++++-
> >  drivers/infiniband/hw/efa/efa_com_cmd.h         | 8 ++++++--
> >  drivers/infiniband/hw/efa/efa_verbs.c           | 5 ++++-
> >  4 files changed, 21 insertions(+), 6 deletions(-)
> > 
> > -- 
> > 2.50.1
> >
> 
> Hi, kind reminder for this series.
> I reviewed the Sashiko comments and no changes are needed.

It is always good to know, even three weeks after the review was
performed by Sashiko.

Please refrain from sending new features during the merge window, as we
mostly ignore submissions during that period.

Thanks

> 
> Thanks.
