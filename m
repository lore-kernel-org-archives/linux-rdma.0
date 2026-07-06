Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7953FC5C4
	for <linux-rdma@vger.kernel.org>; Mon,  6 Jul 2026 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783340417; cv=none; b=tawRA2DUF25x1/M8xcY+fGEYQ1dDra3+75vue1cm0/MAOGuKToq4w28u4lY386/2dIFSihlhyYcpoLYEqbwHzrEg2W9xs0M7tEgAdfxtujyuM4LJYTgsZkCqoqYYqPiVabk4bfCLkDl0dtNkg/drSk+k0IBsQ9cMN/2N7yvEjug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783340417; c=relaxed/simple;
	bh=v1y9xUzt2mpMi3qfgQdySREVh9zb1UGKphDVW37KSvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ly7vwLH4RfFY1QLeo5etGKXhOoFkOjPphL4WoHyQB9qWVpDDief+47i9k32Sa9Jom1PY9EWy9tHjWITAx9VADUsi95RQ1uWnFxhUO9kGmH9mzLP0hYqp9lhGqkd3msWgveU5WwO8FiY6Ee0C9vH/18PQTt0w2MwDm89V66BhqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZaMXukP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZaMXukP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33B01F00A3A;
	Mon,  6 Jul 2026 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783340415;
	bh=4d/3sSVF+jQjMjo/fWukunxfxgvt6BxOCBG0Q7x7ryE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GZaMXukPGZEIDLMx+2FKFeFcu8SN7lcDmDFx3K+BwCBLEFbqDkzrPHcKfdbjXN7GE
	 5PConpKC7TADi2rwUUMg5bgpXwJMVuhv8PM8QnrYsp0CdoOfbY/n326Ao2ocue+ZdH
	 23SakHJVcETYeGj8el0ZTAU7PQiLAb2ql12WjCxRKoqdh6QZ7bbrgLLnCSwE3tAjOp
	 YG+7diydsmzF+ATPZEaMPp8VlTNkAv4EuZ7pQ6SkwATwL7orRGIOaniz9XQCtLKPa8
	 kzIyBuceAU8wzs9R199uM8tBL1VgorqG2uzAW2ARnmDx2anq1ejj1v//x3Ju5VhT16
	 SI+/LgONoxvZQ==
Date: Mon, 6 Jul 2026 15:20:07 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	Firas Jahjah <firasj@amazon.com>
Subject: Re: [PATCH for-next v5 2/2] RDMA/efa: Add AH cache handling on
 create and destroy AH
Message-ID: <20260706122007.GL15188@unreal>
References: <20260628133422.523230-1-ynachum@amazon.com>
 <20260628133422.523230-3-ynachum@amazon.com>
 <20260705133506.GF15188@unreal>
 <20260705140852.GA25788@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705140852.GA25788@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>

On Sun, Jul 05, 2026 at 02:08:52PM +0000, Yonatan Nachum wrote:
> On Sun, Jul 05, 2026 at 04:35:06PM +0300, Leon Romanovsky wrote:
> > > +/**
> > > + * efa_ah_cache_put - Put a refcount of an AH cache entry
> > > + * @ah_cache: AH cache
> > > + * @entry: AH cache entry
> > > + *
> > > + * Drop the refcount. If it reaches zero, remove the entry from the hashtable
> > > + * and free it.
> > > + */
> > > +void efa_ah_cache_put(struct efa_ah_cache *ah_cache, struct efa_ah_cache_entry *entry)
> > > +{
> > > +	if (!refcount_dec_and_mutex_lock(&entry->refcount, &ah_cache->lock))
> > > +		return;
> > > +
> > > +	/* AH cache lock is held here */
> > > +	rhashtable_remove_fast(&ah_cache->hashtable, &entry->linkage, ah_cache_params);
> > > +	mutex_unlock(&ah_cache->lock);
> > > +
> > > +	mutex_destroy(&entry->lock);
> > > +	kfree_rcu(entry, rcu_head);
> > 
> > Where do you use RCU locking in this series? Why do you call
> > kfree_rcu() instead of kfree()?
> > 
> > Thanks
> 
> Originally I used kfree directly, but changed to kfree_rcu in v3
> following this Sashiko review and Jason's comment:
> https://sashiko.dev/#/patchset/20260512061121.2177521-1-ynachum%40amazon.com
> 
> If you think its not needed I can delete it.

I'm not sure you're using the right data structure for this task.

An RCU grace period is required to ensure that rhash has been unlinked
from ah_cache->hashtable, since a concurrent lookup may still succeed in
finding the deleted entry. The problem is that the refcount has already
been decremented to 0, and any attempt to increment it will trigger a
dmesg splat.

Thanks

> 
> Thanks
