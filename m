Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C297935DA65
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783261345; cv=none; b=aTbjhHjVIrMc79l1qpHH+7jX2lIE12INdD9aqjPjDLTExlMp7txA5InyBJvVrC0kQCWSSVJwf4htwqaT8Pu9frg30nTpi/XqUa48g2uS9Y/8yamrLxynpGVQqM1F3vFoL8t2LLgC+IPA1owyvJKcqLhVMelLjCSFWujni1aMKa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783261345; c=relaxed/simple;
	bh=izifLaOe6z/pULRR5p6ldPhds2KICYVvvIMXeCl9WV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSYvADSK0NQ4vhuld8qzY3If0qDtVndVH5EKLV/lwd6UhdUKW2b2o7Sd9PKHA/L0g3gJIU68m+Kq8nyUR+pQSq6Y80iKxp9hbc6rBbv+3E4EjfSWYHJzFJBGUZjV6KEpWa76VOZtUlCTygH5AnSXWC6qXK0OxRgU3cv+e57G6SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NohfcOOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NohfcOOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F31F000E9;
	Sun,  5 Jul 2026 14:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783261344;
	bh=dJjqrSCLcW4Pz2/jWlY7nahnp/XOzIvX2frnpgjeP74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NohfcOOQf17jcN85hORYXXtgA5UK97HrSvK+pLTxkBPk4vtxC+okcGUBEwfk9bLHC
	 yW+CnNKE3YfBWJ5OhR9yb34c8j1Tv2I/hJeHSxuUrxqzVa1f4FUJxaeDEcjd4zU9IU
	 B87qff3JmN3nDxPBgiuEF/XbmQBuV8P9Oj3gG769dFT3TihDSvsTppGIu2puoDv4yC
	 i8yyKFwqEpLh5EBoIDL8J2eG/H5Vh9ZMenBidp3GATfh2CZ+Tg0KGUqwOrgMAEA1bl
	 ykKPSCksx7lM3QiQddz2Z9NAOtwdlxPbeMazS3Zo/3zjtUW1gUCSyNESNhHg7pOulL
	 4Xi+eBJ8acSrg==
Date: Sun, 5 Jul 2026 17:22:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/irdma: Check for null udata during reg_user_mr
Message-ID: <20260705142218.GJ15188@unreal>
References: <20260630154720.1647530-1-jmoroni@google.com>
 <20260705140940.GG15188@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705140940.GG15188@unreal>

On Sun, Jul 05, 2026 at 05:09:40PM +0300, Leon Romanovsky wrote:
> On Tue, Jun 30, 2026 at 03:47:19PM +0000, Jacob Moroni wrote:
> > The irdma driver requires udata for reg_user_mr. Previously,
> > it was assuming that it was always non-null, but it can actually
> > be null if the user intentionally triggers the UVERBS_METHOD_REG_MR
> > ioctl.
> > 
> > Signed-off-by: Jacob Moroni <jmoroni@google.com>
> > ---
> >  drivers/infiniband/hw/irdma/verbs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> > index cb54c7c8fcd..3bcac68a612 100644
> > --- a/drivers/infiniband/hw/irdma/verbs.c
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > @@ -3519,6 +3519,9 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
> >  	if (dmah)
> >  		return ERR_PTR(-EOPNOTSUPP);
> >  
> > +	if (!udata)
> > +		return ERR_PTR(-EINVAL);
> 
> Is this check specific to iRDMA?

Ohh, I see that it is fixed in  011199f46f44 ("RDMA/uverbs: Add
UVERBS_ATTR_UHW to UVERBS_METHOD_REG_MR").

Thanks
