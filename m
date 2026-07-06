Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA8F41A76E
	for <linux-rdma@vger.kernel.org>; Mon,  6 Jul 2026 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783344559; cv=none; b=UwlA1JBySdRhdPIgeLBvuSygml+XQiWjY2Dc8Ik/AhGLPGQ96MjWfz9QGmXYdLTbKT8uLZ6Rn82aneJUwHjlAnBhkAudq9mgb44QVTJbDf1s3cqKDkKsmUPDnTivDk0/VJsbP8Z1xTfWOvC7njQFnLKbWgFEmCYuLjcNNptiuS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783344559; c=relaxed/simple;
	bh=5vq4JO2XZaKTOcp/lEfWleiqCCX/Lq2iFfTSw0BX+rE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukfoS2cO3mFSMGEz3BIcyqyLt2G2WCD11vQaPnz8hi4JYJAeOVn6Jm6/1Col9Z6TkuMGERcTUZPK1Dooh9nostZgMB2cqxYY/Nj+eCwe4oxQjrG5wTdGyFqMsxtL8zuRnYWDjhRzso5J5/8dFpsROBgC/1kd7hC0ZaGJR7SpBuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=PkYzvjwG; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="PkYzvjwG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1783344556; x=1814880556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VM//OanOto1OrqMYd+zm80JbONodlf9qTrvZ0ZfOWxc=;
  b=PkYzvjwGk0Rw3Qsd1PyLPo8V5LlvZ+zWLqQOpoU7Ji3pQdz2EELXiCDi
   XelsutKuoDSfoV2gaxmdCzEAQhbh51vnWJj9SOHkkp2emrXPXSKbZ9u/W
   WjhcNBiW0twdi/Z1kJvwvgBc8EkAtFTPpKczE/k7Kl6510bug5BMj4leD
   WhkQk3PbujMYlKEj8/gvGc/R9kyKaAutZsuDju6bhKmqT9RT7vbB8wu6C
   xspEiPo0bz9KVgc+8B/+57XFn8+ZL4W+k84R/sHQlrutS9FhlmwTf1Jaz
   rmm3LgwnBIroPqyn/GqrsPWwh0xioksuU3eVeCPmv4s3mEhUVrOHiFEiW
   Q==;
X-CSE-ConnectionGUID: 9JAF9KZNSSegxyPYV/4yLA==
X-CSE-MsgGUID: H6FyORwYSSG8Rkxpb42Rmg==
X-IronPort-AV: E=Sophos;i="6.25,149,1779148800"; 
   d="scan'208";a="22934386"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 13:29:11 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:22915]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.225:2525] with esmtp (Farcaster)
 id 73adffbe-c29d-4bee-bbf1-f68a8809cf4b; Mon, 6 Jul 2026 13:29:11 +0000 (UTC)
X-Farcaster-Flow-ID: 73adffbe-c29d-4bee-bbf1-f68a8809cf4b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 6 Jul 2026 13:29:11 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Mon, 6 Jul 2026
 13:29:09 +0000
Date: Mon, 6 Jul 2026 13:28:52 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Firas Jahjah <firasj@amazon.com>
Subject: Re: [PATCH for-next v5 2/2] RDMA/efa: Add AH cache handling on
 create and destroy AH
Message-ID: <20260706132808.GA28508@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260628133422.523230-1-ynachum@amazon.com>
 <20260628133422.523230-3-ynachum@amazon.com>
 <20260705133506.GF15188@unreal>
 <20260705140852.GA25788@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <20260706122007.GL15188@unreal>
 <20260706122314.GB71454@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260706122314.GB71454@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jul 06, 2026 at 09:23:14AM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 06, 2026 at 03:20:07PM +0300, Leon Romanovsky wrote:
> > On Sun, Jul 05, 2026 at 02:08:52PM +0000, Yonatan Nachum wrote:
> > > On Sun, Jul 05, 2026 at 04:35:06PM +0300, Leon Romanovsky wrote:
> > > > > +/**
> > > > > + * efa_ah_cache_put - Put a refcount of an AH cache entry
> > > > > + * @ah_cache: AH cache
> > > > > + * @entry: AH cache entry
> > > > > + *
> > > > > + * Drop the refcount. If it reaches zero, remove the entry from the hashtable
> > > > > + * and free it.
> > > > > + */
> > > > > +void efa_ah_cache_put(struct efa_ah_cache *ah_cache, struct efa_ah_cache_entry *entry)
> > > > > +{
> > > > > +	if (!refcount_dec_and_mutex_lock(&entry->refcount, &ah_cache->lock))
> > > > > +		return;
> > > > > +
> > > > > +	/* AH cache lock is held here */
> > > > > +	rhashtable_remove_fast(&ah_cache->hashtable, &entry->linkage, ah_cache_params);
> > > > > +	mutex_unlock(&ah_cache->lock);
> > > > > +
> > > > > +	mutex_destroy(&entry->lock);
> > > > > +	kfree_rcu(entry, rcu_head);
> > > > 
> > > > Where do you use RCU locking in this series? Why do you call
> > > > kfree_rcu() instead of kfree()?
> > > > 
> > > > Thanks
> > > 
> > > Originally I used kfree directly, but changed to kfree_rcu in v3
> > > following this Sashiko review and Jason's comment:
> > > https://sashiko.dev/#/patchset/20260512061121.2177521-1-ynachum%40amazon.com
> > > 
> > > If you think its not needed I can delete it.
> > 
> > I'm not sure you're using the right data structure for this task.
> > 
> > An RCU grace period is required to ensure that rhash has been unlinked
> > from ah_cache->hashtable, since a concurrent lookup may still succeed in
> > finding the deleted entry. 
> 
> It doesn't look like this uses RCU for lookup
> 
> > The problem is that the refcount has already been decremented to 0,
> > and any attempt to increment it will trigger a dmesg splat.
> 
> Sashiko claimed this was for some worker thread internal to rhashtable
> 
> Jason

After researching and checking couple of examples in the kernel,
kfree_rcu is not needed here. All lookups and removals are serialized by
the AH cache lock, so no concurrent reader can see the entry after
rhashtable_remove_fast returns. Will change to kfree in v6.

Thanks
