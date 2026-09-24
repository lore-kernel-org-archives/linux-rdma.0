Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E73F4A4856
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263768; cv=none; b=WzFg9sAwkXWzdcN8Ky06YBDMV0Hd+lvLtJPAvElL7Ca0xwz9goqAlJAvdf3op8aCYxLNguFif3WAygsHEug1p0ObpJ9ElNvI3N8JED5/yNg6yachiNxSTejAHbqnT1fxhSLdTGU6QoCuRP3Z+fJjgq0WcBqnH0sbgdH6sxy2A94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263768; c=relaxed/simple;
	bh=WCbwUGRT4jIyRRfkSnjLW0bY1VRUZNcqa++ISNzLj88=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+mZuOl7Q3vTzFxd7nnwtBoe9kXS8kacC9VTowUXGvlC9xsEgol8E26MVu12G32nbbZrrU0m77Gp4ni2GRnylWxLQcdI+8ICwAh9LzTIfL7J+WOUuIiWykSCFHqnldKKS95cRrpVORLczzlRZmA7N2Y8UBTHfz+CuGFWVPNDGJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZmiNSxg0; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZmiNSxg0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790263767; x=1821799767;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=in6y1cH9etCjLswljwMzu5DlTbxvV6eHyKTLKkXJoOo=;
  b=ZmiNSxg0Ah+n4Yesy+dCI7rdlI9XaeTZ0/qDe4AjpyJpCuu5ffbSR0ab
   x6LOSq23xYmvw+kdQwJC7iIE21zqVpxePlEosZwa4q/4lE2oht3WUBzlp
   QukyKgvjjCxR8AO2FtkonPS2U20QikzJlcpouZh9ejuqnzK/A1HzoHcks
   BTDPA2wz9ar19kOdjGf7+7AJq5V/vja5RNVr4+IV9gx5Jle/8yo/ZCnSw
   SFOcJICCP+6PLTT0o5eG95VfUedvzzoqUvgddNlUsRTzYR72fU7CbNmiu
   YOwvITk2dxCaW3Zkbbrs6Vdf6rEVDHpNp8LkH+tgDNRJtoFM5Y0N8xmmT
   w==;
X-CSE-ConnectionGUID: L1tRYuiwRD6/yb6rHTLONQ==
X-CSE-MsgGUID: l+3JjflCSD2+80pwta6xAg==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29055998"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 15:29:22 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:17487]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.237:2525] with esmtp (Farcaster)
 id a6cd39aa-2ecb-44c1-9029-023b22905013; Thu, 24 Sep 2026 15:29:22 +0000 (UTC)
X-Farcaster-Flow-ID: a6cd39aa-2ecb-44c1-9029-023b22905013
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 15:29:22 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Thu, 24 Sep 2026
 15:29:20 +0000
Date: Thu, 24 Sep 2026 15:29:13 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yonatan Nachum <ynachum@amazon.com>, <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260923171741.GH2545495@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Wed, Sep 23, 2026 at 02:17:41PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 04:38:30PM +0000, Michael Margolin wrote:
> 
> > I'm reviving this conversation since it is becoming an
> > increasing need to reduce the long startup times. The major
> > part of this time is related to CUDA device initialization
> > needed only to allocate GPU memory, export a dmabuf, and
> > test accessibility via MR registration. Since obtaining a
> > dmabuf fd requires CUDA initialization, which is exactly
> > the cost we are trying to avoid, we are looking for a
> > solution that doesn't require dmabuf.
> 
> You have to use dmabuf. Go complain to the cuda people their stuff is
> too slow if that is the actual problem.
> 
> Precompute it and put it in a topology file like everyone else does :\
> 
> > I have two options in mind:
> > 
> > 1. Introduce a new (common or EFA-specific) verb that takes
> >    a peer device BDF and queries the p2p subsystem,
> >    returning something like:
> 
> No way. No BDFs in uapis.
> 
> > 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
> >    directly to userspace. As you already stated, this is a
> >    bit awkward as a device isn't expected to be aware of
> >    system topology, but since EFA lives in the cloud it is
> >    partially aware of the platform configuration and in
> >    particular the ability to access peer devices over PCIe.
> 
> If you already know your VMs are always safe what is even the issue?
> What are you probing for?
> 
> Lets please not hack around bad userspace with even worse kernel uAPI.

The EFA device already knows this attribute. The problem is that this
information is not exposed to userspace today.

So if I go back to our original proposal - exposing the
EFA_DEV_CAP(dev, P2P_DMA) bit through query device - this is a firmware
attribute that says "this device does not block PCIe peer access on its
end." It's not a topology claim, it's a device property, similar to how
we already expose RDMA read/write support.

The actual reachability is still a combination of multiple factors.

Why is this a bad uAPI?

Michael
