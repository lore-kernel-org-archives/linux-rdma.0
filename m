Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.162.73.231
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794842825;
	b=V5YMATIE2p1UpXPM5dw/ScFL/NxIjU6Aq6ATtdGr2ougCWsETW2yYwlohaZegJFFGcL0
	 qaKjnapF92szszIgMojPes1KMEL1DA77pVJgzpz1EhgI80RAlfVNgz8bSAyPy75pqDfGz
	 ITvzRhBnOWqyh4LWYBqgt+/+oHkCf8+7knweMG2QjbacBhUCLqyzqZb/pS7TZs278zFLo
	 C+ixxuvejGjkVweRTkt1T4bDMiqvi4u6pQRbUc9Xiieds+18EF60jWq8U6WI0fa0kZwzu
	 zNU98J0yOAzC1YPBfGV1llOlmzbDYCVGjEibdp5aGJ7AJ0IOrlUSThiqika7HGwvg9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794842825;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=jQ5moJAwspIDmVnleLy8zTs3Qhh1IMj9licNWg4LnQQ=;
	b=lVsa0olsNJKRhFUGyr3Kb1Xgr3vK4QHer2vT41VSArKIxkY0Mk2sekEwlNDZ/oMzgxVo
	 rDsDRsvAGhQ5ToVr7nF7Uw7WV+UbOzr/SVt2K00oNpztCb6QJUDVEQp2NSBDp6tM8X8c/
	 dCfZBUACqCi/W+j/AZ4oZfAeLBWSTn0ji296U2zedUVpApSfumjBe2G/mZ5ZBWsASSS8A
	 WvdS/8U2Vpn1OSeA1iDAFxIdRfl8WlExH149HzVtygiWeh8iArXO00eMiiX97wFIpyMUf
	 HrBhq5tz7hV6p6B92Qc63R5HclNKqyviqsA3hicpBCe4l6Hf14wNLrQDgDC6glg+Ivg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=RoYn+LGw;
	arc=none smtp.remote-ip=35.162.73.231
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28893606A88A;
	Mon, 16 Nov 2026 15:27:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28893606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=RoYn+LGw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794842825; x=1826378825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jQ5moJAwspIDmVnleLy8zTs3Qhh1IMj9licNWg4LnQQ=;
  b=RoYn+LGwI8x7VDQWBqE/GNlCFbbC6JXTyMd872rVhR7U1cPmSlHVZoLN
   /2wbrnc54+22BxA2/7D+GUQ2lFw5cw30rD2uCQkGpzeJr2wJbJQGFU7J6
   CgNC4Il8QRApkLaNFHZ5vXoCvMkqqSoBUtfzC8iR1p4Z+R6md1pr3VbEk
   exQNZhjQMEfSvtd4XA/IpbXbC087UD8FHrSZRQWPGvmNwyZHEf2lSCvZr
   mDJ4GkPIlZYDr2gVD89SQZvP1q2H1o71s3hSJ7iY51Hay/1aeuZVs4dNu
   xefRC2/8jD9uFwdppl9M2BKPqnfxD8miDLI+lv437e+H0K1foY1Bkp+HN
   Q==;
X-CSE-ConnectionGUID: h+nwA85wQxOElU/OXk1dqA==
X-CSE-MsgGUID: upn+/RpeR+uulnF/EqUqLA==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34092392"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 15:27:02 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:7890]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 86de6ce6-fd91-408d-b03e-71a42f531eb3; Mon, 16 Nov 2026 15:27:01 +0000 (UTC)
X-Farcaster-Flow-ID: 86de6ce6-fd91-408d-b03e-71a42f531eb3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 15:27:01 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 15:27:00 +0000
Date: Mon, 16 Nov 2026 15:26:52 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Eric Davis <eric.davis@broadcom.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 00/13] RDMA/core: Ultra Ethernet transport
 verbs
Message-ID: <20261116152652.GA8275@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261116143656.GA34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261116144830.GN2532299@ziepe.ca>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20261116144830.GN2532299@ziepe.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 16, 2026 at 10:48:30AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 16, 2026 at 02:36:56PM +0000, Michael Margolin wrote:
> > On Mon, Nov 09, 2026 at 08:00:33PM -0800, Eric Davis wrote:
> > > Ultra Ethernet defines a reliable unconnected transport. A queue pair
> > > sends to any peer in its job without a connection, incoming traffic is
> > > demultiplexed on a JobID rather than on a connection, and what a device
> > > orders is far weaker than IB or RoCE and varies between devices. None of
> > > that has a home in the current uverbs ABI.
> > > 
> > > This series adds the generic half. The objects, methods, and attributes
> > > any UET device implements. No driver is part of it, though two already
> > > exist against this ABI. A reference device model that implements all of
> > > it, and HPE's Slingshot driver implementing a large subset. That is the
> > > argument for ib_core carrying this. What is device specific should come
> > > from private interfaces per vendor.
> > 
> > Hey Eric,
> > 
> > Thanks for posting this. EFA's SRD is also a reliable unconnected
> > transport (one QP reaches any peer, delivery isn't ordered), so we
> > looked at the series as a possible second implementor of IB_QPT_RU
> > that isn't a UET device. Other vendors might also want to support
> > this interface in the future.
> 
> I'm not sure about this. If you have exactly UET programming
> semantics, including the job, then sure.
> 
> But squeezing some EFA specific thing that doesn't follow the spec
> isn't a good way to build the APIs.. Persumably EFA has its own
> job-like mechanism for security that is different?
> 

I see your point about trying to fit an API to a different use case it's
not meant for, but I don't think this is the case here. EFA doesn't have
a job-like mechanism, isolation is handled by the network, so jobs just
don't apply there.

As I see it, RU can be (and this series gets quite close to this) just
another QP type multiple vendors can support, with UET specifics like
jobs being optional on top. I think that treating it this way during
interface definition improves it.

Michael

> Jason


