Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E7199FAB
	for <linux-rdma@vger.kernel.org>; Thu, 14 May 2026 20:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778791547; cv=none; b=ihVik9iy63VJH82yMD4rCW4rfYraly8kwioKl+58tiJ0C69H8wb982AbaBdJ9pV1ahsXQFQHahAILXI1SqpilD+tD8r4fFvFlD6JqzSjgiCllaA2mTqkqrC8MUaqfEJooCmsJpCXZjuXZFnkKVHjdmO344KZrCCj1yJKuyn71vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778791547; c=relaxed/simple;
	bh=J4/Twk1yPXW3K2TM2vmFU80z7Hv0XofYAy1oz+Rm9GE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hs/hhKCPE+mTw30ZE/0mCfFk00J7Y/d7Wwbo7WchFFCbv+lUeaxIoJle8mgQ1Z6PPNfihEjh8XgDQSKUpX0igPWrfspyBhHZJ7HW/4fqc83wMlgCorOViZo+VrAyCssk/I4Q2HrucmnOc6E2aoCuB29taTt0VzdVF67vrRDp9cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ily7szzc; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ily7szzc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1778791546; x=1810327546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uVyKJb8DUScuy7EDDxLuxMAvaOKQqyGI9i+rH4vuAL0=;
  b=ily7szzcpYpB126bvCu1F0Elhbs2A+/eFwbBwdx6iOSWPNV0Bi/TCpD1
   MY492YnS5vaWyXfJjTUSeuX0OUlwtwiiwItVIDpfG4cf0LGSrZ0Gl7Hfg
   0toAdjMJuioQ5AmL8QvO4cCyyYNFJQsWRU3ThMgJZ9JH4g3kAKJAtwEOr
   Qipdq8O96SpdUrquAnZaxbG9SHlTw5SqN52OYxPV0zN+6FvwrZMMN8Xp4
   GXUVv9xkm+uE8cbC802Gsmplg1dbxuBeSUdkoWWSiUQqcuRCyIv/Lqvq/
   6WDB54cqfIl/ida9+Uk7xIslktqj4RPOy3qkWYjJEFl4mC31j2PTHv0LC
   A==;
X-CSE-ConnectionGUID: mgbLEGumTAyfpi111eZNOA==
X-CSE-MsgGUID: 08P65ToUSUuMRlchCyhJkw==
X-IronPort-AV: E=Sophos;i="6.23,235,1770595200"; 
   d="scan'208";a="19680066"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 20:45:43 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:19536]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.30:2525] with esmtp (Farcaster)
 id 7c81a1b1-13e1-4446-b0a3-62c69540f1fc; Thu, 14 May 2026 20:45:43 +0000 (UTC)
X-Farcaster-Flow-ID: 7c81a1b1-13e1-4446-b0a3-62c69540f1fc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 14 May 2026 20:45:41 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Thu, 14 May 2026
 20:45:40 +0000
Date: Thu, 14 May 2026 20:45:21 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>, <mrgolin@amazon.com>,
	<sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Daniel
 Kranzdorf" <dkkranzd@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Validate SQ depth based on WQE size
Message-ID: <20260514204521.GA14420@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260507112110.869212-1-ynachum@amazon.com>
 <20260513173812.GH15586@unreal>
 <20260513192451.GA15167@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <20260514162812.GS15586@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514162812.GS15586@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, May 14, 2026 at 07:28:12PM +0300, Leon Romanovsky wrote:
> On Wed, May 13, 2026 at 07:24:51PM +0000, Yonatan Nachum wrote:
> > On Wed, May 13, 2026 at 08:38:12PM +0300, Leon Romanovsky wrote:
> > > On Thu, May 07, 2026 at 11:21:10AM +0000, Yonatan Nachum wrote:
> > > > From: Michael Margolin <mrgolin@amazon.com>
> > > > 
> > > > Change the SQ depth validation to take into account the SQ WQE size.
> > > > This is needed since when using 128-byte WQE the max SQ depth is cut in
> > > > half. On create QP command, userspace provides SQ ring size which is SQ
> > > > depth X WQE size so we can calculate the requested WQE size in the
> > > > kernel.
> > > > 
> > > > Reviewed-by: Daniel Kranzdorf <dkkranzd@amazon.com>
> > > > Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> > > > Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
> > > > ---
> > > >  drivers/infiniband/hw/efa/efa_verbs.c | 39 ++++++++++++++++++---------
> > > >  1 file changed, 27 insertions(+), 12 deletions(-)
> > > 
> > > Please add Fixes line.
> > > 
> > > Thanks
> > 
> > There is no Fixes tag as this is not a bug fix. The existing validation
> > works but is overly permissive — it doesn't account for WQE size when
> > checking max SQ depth. Without it, the device would reject the request
> > downstream. This patch tightens the validation to fail early in the
> > kernel.
> 
> So why do we need kernel patch after all?
> 
> Thanks

The driver already validates max_send_wr against max_sq_depth — this
patch just makes that check accurate for the 128-byte WQE case. This
also gives better error reporting as opposed to device failure.
