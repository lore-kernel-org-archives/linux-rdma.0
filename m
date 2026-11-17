Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903542;
	b=zxdLuBlrVPfxptueMf9GjFjdcdMDg/XjtRnVQnGj8lWf8I+JVeIyI8eMU3yckqor5PJz
	 MA56cqPnvf2zMkWs374K+/r4gFVK4+aoTUo9wXoinII6hySrbKC4ks5YtgjN+31mzT8Ae
	 8StglbRJT9EJhilJGtzIKKJ04zyaLdABEEv4+09Y3eromRkEbwWm+ceXtTte3Por0CO8j
	 IMIPP/gdIA5kq4/8oobyV3W5Gdsn9t/XeF2fCuVojSXtkVdLZ0y3ErJn7JnGFRaCPVIkl
	 7XvFZHJQWLeVMPWVbOUIuHkOwZvSxS5ofvZTHBHBJ4fgCYoN+Qdl8ULzH+VMgFXl4sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903542;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=norB5AKxycQW+VS7PKyACMKpVSxMYCyQnsB+tsyz12o=;
	b=SUq13krza2ELK7ABHjrchzrWVIO7xquJ95/B3eFIV9MdJ9dLXQCU7U4UM7bsJcBZsGj8
	 o1sEkVP0+W8D7fifm+r4fYao1CSWYTH4qmmooWjA+ZMIApNyMxtqLxGtm3SigC/nPV8QD
	 z8g3pJaMffN66lxbOjvDAjLFdqL3ZkCsSAEmxD3DQVGdslFQ/vpodJl8F3Nm3Ff6sAL2U
	 ueoLHsEcjVtDwaFpqlXoF1JaNUashv7+vkAqfdygS5Q6jDcu231yiA0K+Olf8YTCBHDAy
	 7fV7duXD3vOUX53emWytR+2Mrll1wn03wv+okgK8gSPp76wKNGIwcYteNriOFiD6sFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b="VB+/FqqN";
	arc=none smtp.remote-ip=35.83.148.184
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F08606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 08:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41F08606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=VB+/FqqN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794903542; x=1826439542;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=norB5AKxycQW+VS7PKyACMKpVSxMYCyQnsB+tsyz12o=;
  b=VB+/FqqNuwQyAMhcuQ/Slga6DprKxELFzWJz/FivBtmR/cOiUg062qId
   +QZMNirV20odfy9NDv/fYjHCAxkFjgCcu8e8DWRkqiz4QrLlvB1ZIqJUP
   YRj19OsL1PBxtKQPcjEQYEiSow5WxV6P/7TckVgbylFiuPpnicVLaYnZc
   oTjTODT1eDBpfj8G9r4FVgMwrWk7LOoGXpqK6CbT8GekXsqYtbqU16K/X
   o9nIxcFPidiK9TV/ibgQiF5maZY72em1SSh1ETLGIpL+fBMVA3rk9lrxW
   5VKOYqvU3Lhh/dSCXbA/diGeNbYU5DVtNCAfDHzWifh2d7LQMFp3hzDWD
   Q==;
X-CSE-ConnectionGUID: x2u2bFa2TFmR5p+F3sFGwQ==
X-CSE-MsgGUID: PxJwvZ4PQ8uwKbeUdVigEg==
X-IronPort-AV: E=Sophos;i="6.27,218,1787011200"; 
   d="scan'208";a="34128285"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:18:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:22758]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id b625ee90-d0a3-4e01-b3f4-7b00d806b566; Tue, 17 Nov 2026 08:18:59 +0000 (UTC)
X-Farcaster-Flow-ID: b625ee90-d0a3-4e01-b3f4-7b00d806b566
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 17 Nov 2026 08:18:59 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 17 Nov 2026
 08:18:57 +0000
Date: Tue, 17 Nov 2026 08:18:50 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Ilia Kolominsky <ikolomin@amazon.com>, <jgg@nvidia.com>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Message-ID: <20261117081850.GA18565@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261116112913.GI11319@unreal>
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
In-Reply-To: <20261116112913.GI11319@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 16, 2026 at 01:29:13PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 09, 2026 at 08:13:46AM +0000, Ilia Kolominsky wrote:
> > EFA Completion actions let an application observe work request
> > completions without polling a completion queue: when a work request
> > completes, locally or at the remote side, the device performs an action
> > that the work request names, such as writing a value to a user buffer.
> 
> Why are these verbs EFA-specific? This looks like extension of already
> generic UVERBS_METHOD_COMP_CNTR_* code and probably should be general too.

It is indeed an extension of Completion Counters, and later we plan to
connect the two by allowing a Completion Counter to be used as a
Completion Action, but unlike counters, actions mostly matter for
unordered transports where a completion count alone doesn't tell the
application which requests have completed, so it needs an efficient way
to track completion of specific requests.

Do you think these semantics can be useful for other providers at this
stage, or can we start with an EFA-specific interface and add a common
ABI later if required?

Michael
