Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1567B31B100
	for <linux-rdma@vger.kernel.org>; Wed, 20 May 2026 07:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260630; cv=none; b=Mo9kp9582lodS5ntI4O3Y4FZuus3AGZ10hearzxeWsMt5PAFO1CSU7RnCIhTtRTRsGBSd8uhKLeioVZ95A7S41Dw4A3Evj2T8O2IuSgzf65/l1xHcCZxHRIO23wTmmmkyse4rflGEroxgGSeg2O5ubcjVqQqVmBhUqQI33O1CS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260630; c=relaxed/simple;
	bh=eeiP7R6Kk2f0gA7KDCtvQQ/NMNbb+298dA6VLcyDOy8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJaifHdSn/A4/5AGHF0Mkk8bJ75GTQfhgWa3mHLryUBMErPBIjtBzbDswHXr95QIIVWx+l1DYPR4mupjwsnU7Cudn3jPqUFtl9Hm5xocQVXFky0fy5xJhN0sLkOb5x5qrSrG42sRm3/CgGntepYIRznaCZPve9WskZafp4ZPZJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=iK+3aWEO; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="iK+3aWEO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779260629; x=1810796629;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HekCaluQbRlt+RK53GG/Fy1JhnFCPCAWiBWnzbwtP5M=;
  b=iK+3aWEOgROsxYT94lH65+mOKWvYZ4J0GjqO4YSSSWGT25jo65tE+3mM
   SMXiRd+MKUFq777XGNNWlfXzuvUvapBjUZDYIelBmDxGE/hivsClY+2Q6
   iiLuPGelX8JwWrAomHvIEUGZGEMD0kjqBZWgfxm4FJ82EaP0skCFa8gj0
   euvJ0c4c9L6rkZVJtJ6wOMa6vEmRwrs5gf4vOsbA1LHYZYYQYf7HXGF9z
   Gg5Shb+3EZdU+fAwqYJXnwTDWr+MNmahaZ7qNFwPkTwjV5wtgr5vDv1fp
   uiWf4BOJ/JDKn+DSTF+Ei7Il1BWERg2qPu9KVnTHLH3HsJ6DjzXCMdAXD
   w==;
X-CSE-ConnectionGUID: 8TnteW83RfGQpnebT4gOEg==
X-CSE-MsgGUID: nOD/HEEsTzqj+HgnmB29EQ==
X-IronPort-AV: E=Sophos;i="6.23,243,1770595200"; 
   d="scan'208";a="20089013"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 07:03:44 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:24179]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.132:2525] with esmtp (Farcaster)
 id fb325ea9-5d58-47ad-8f64-955f541fef84; Wed, 20 May 2026 07:03:44 +0000 (UTC)
X-Farcaster-Flow-ID: fb325ea9-5d58-47ad-8f64-955f541fef84
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 20 May 2026 07:03:44 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 20 May 2026
 07:03:42 +0000
Date: Wed, 20 May 2026 07:03:33 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>, <mrgolin@amazon.com>,
	<sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Firas
 Jahjah" <firasj@amazon.com>
Subject: Re: [PATCH for-next v2 2/2] RDMA/efa: Add AH cache handling on
 create and destroy AH
Message-ID: <20260520070333.GB1721@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260512061121.2177521-1-ynachum@amazon.com>
 <20260512061121.2177521-3-ynachum@amazon.com>
 <20260519133857.GW33515@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519133857.GW33515@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D045UWC002.ant.amazon.com (10.13.139.230) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, May 19, 2026 at 04:38:57PM +0300, Leon Romanovsky wrote:
> On Tue, May 12, 2026 at 06:11:21AM +0000, Yonatan Nachum wrote:
> > On create AH, first check if the AH cache entry already exists and if
> > so, returns the already stored AH number. If the entry doesn't exist,
> > the driver creates it and calls the device to create the AH. A per-entry
> > mutex serializes concurrent device commands on the same AH cache entry,
> > ensuring only one thread issues the device create while others wait and
> > reuse the result. If the device create fails, the entry remains
> > uninitialized so subsequent threads calls can create the AH.
> > 
> > On destroy AH, the refcount is checked and if it's the last reference,
> > the driver issues the device destroy command while holding the entry
> > mutex. The entry remains in the hashtable during destroy to allow
> > concurrent create threads to find it and wait on the entry mutex,
> > preventing create-before-destroy races on the device. After the device
> > destroy completes, the entry is either recycled if new users arrived or
> > removed and freed.
> > 
> > Reviewed-by: Firas Jahjah <firasj@amazon.com>
> > Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> > Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
> > ---
> >  drivers/infiniband/hw/efa/efa_ah_cache.c | 124 +++++++++++++++++++++++
> >  drivers/infiniband/hw/efa/efa_ah_cache.h |   5 +
> >  drivers/infiniband/hw/efa/efa_com_cmd.c  |  27 +++++
> >  drivers/infiniband/hw/efa/efa_com_cmd.h  |   1 +
> >  drivers/infiniband/hw/efa/efa_verbs.c    |   9 +-
> >  5 files changed, 162 insertions(+), 4 deletions(-)
> 
> <...>
> 
> > +
> > +/**
> > + * efa_ah_cache_put - Release the final reference to an AH cache entry
> > + * @ah_cache: AH cache
> > + * @entry: AH cache entry
> > + *
> > + * Decrement the refcount. If it reaches zero, the entry is removed from the
> > + * hashtable and freed. Otherwise, the entry is kept for reuse.
> > + *
> > + * Called after the device destroy completes or on a failed create to release
> > + * the caller's reference.
> > + */
> > +void efa_ah_cache_put(struct efa_ah_cache *ah_cache, struct efa_ah_cache_entry *entry)
> > +{
> > +	mutex_lock(&ah_cache->lock);
> > +	if (!refcount_dec_and_test(&entry->refcount)) {
> > +		mutex_unlock(&ah_cache->lock);
> > +		return;
> > +	}
> > +
> > +	rhashtable_remove_fast(&ah_cache->hashtable, &entry->linkage, ah_cache_params);
> > +	mutex_unlock(&ah_cache->lock);
> > +
> > +	mutex_destroy(&entry->lock);
> > +	kvfree(entry);
> > +}
> 
> This pattern looks very similar to kref_put_mutex().
> 
> Thanks

We don't follow the kref put semantics here. On last AH put, we don't
decrement the refcount and delete the entry. Instead we keep the entry
in the hash and only do the last decrement after device destroy
completes. This solves races where AH create starts while a device
destroy is in progress — by keeping the entry, concurrent create threads
find it and block on the per-entry mutex until the destroy completes,
ensuring a device create is initiated only after.

Thanks
