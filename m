Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.12.53.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839828;
	b=Ewuoyc28ihXwtDPZBuN7hAVsw8/rf5k64dPb3BfC+/tjYd2SDiAIJzIijrShWOk6CMzY
	 AeXJ9/98K+ldpyP2uGy2iNHZ5PTv/4e8/hSV2p+zwa7aMLbwWP//z/bQS/l3id1nFUJu0
	 r2q2sM8+vjb+Wo2ThM+Iri+e2aNbHveTqnZNao0NJyQFLEh678VMEL+GA7/c5vOZUzJDF
	 dCVEj8fi2QsShgLrN3Cpd2FH71MZCrscLJBlwaSpgE3GqHtyIi+8gooudvmJp/MeD+nAR
	 0duZ12a68yQ+rW30/MKxOgg1sNVlWKJ1OVZC2Gu1nQOR0GwEZAfYSsDbGNNJAWy1igw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839828;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=TwDh7NeOYs3w2+iAF4rVo1S2VRjLVslAqjALBVQe9H8=;
	b=mzzFnoAbJ1tR1O9mf9T0JNf0rV2ZDGj5airGOUrz30u5gHo0vMgQAyokbqzKuZMDUSHX
	 toNNUxy6DDM8zhfKnD03Dod+ZrCLNn+c3BCy/b5KSJ5rcD4mB9xBLCkbt0F8AN2jfU+dc
	 DYbPVzzve06jnItLPy33AuyRIP43VOgdbvDl7bUd9KXUD7rKWCzJFA97T4Gun6xWD/sZ5
	 /jqR7On9rvT+ZCf0MCBovFnKn8OfmgVMnrnqTF0SYuZZsteqKMVEdMR9gl2ujWDe8ArZe
	 J9QhL2CnQqLGtkgWpNlTTaztrwWiCeDnOvT81SNzk/OmS4GchmICLpRrc8z7WoYGJWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Tr0JprIs;
	arc=none smtp.remote-ip=52.12.53.23
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BFE606A32A;
	Mon, 16 Nov 2026 14:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35BFE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Tr0JprIs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794839828; x=1826375828;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TwDh7NeOYs3w2+iAF4rVo1S2VRjLVslAqjALBVQe9H8=;
  b=Tr0JprIsWiei7caaZmQzz9ddfmRxYMXJOrxyhslFXwvoqZAdwJRJNcmB
   g6qVfXyRPt4wCcCfOF0RgJh6Sd4y6nqRe4TPpWQHFafqmxeZe5eSiH9FH
   CSW587tDmqKMVYVzqdKzNeLlergi4BM0SyKbkL/M5TEEkvzIyTOF3C59u
   ggRtqUNvnRmJ2QFaJd+wUmc4dOO2YsqoveUi+4mX8be4cvhKxD5ctN0LG
   b5xMkQjiJglQ2N9uIRm8c1Ux90wi8jegM3BhzmhvTUxOKy0tan3pkXLXy
   vV63RNjVBGw6gVN+bZpxdrelEUC/A1qk6Fm8drhzE86WXBVfNQ/xkKG6x
   w==;
X-CSE-ConnectionGUID: +0ehwjPeSLybSoyx4iXngA==
X-CSE-MsgGUID: YjzyRVeuQASXU+g5xINcWQ==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34083560"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:37:05 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:31532]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id a65adacf-5011-44c5-9f5f-6fbd471b85af; Mon, 16 Nov 2026 14:37:05 +0000 (UTC)
X-Farcaster-Flow-ID: a65adacf-5011-44c5-9f5f-6fbd471b85af
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:37:05 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:37:03 +0000
Date: Mon, 16 Nov 2026 14:36:56 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 00/13] RDMA/core: Ultra Ethernet transport
 verbs
Message-ID: <20261116143656.GA34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
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
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:33PM -0800, Eric Davis wrote:
> Ultra Ethernet defines a reliable unconnected transport. A queue pair
> sends to any peer in its job without a connection, incoming traffic is
> demultiplexed on a JobID rather than on a connection, and what a device
> orders is far weaker than IB or RoCE and varies between devices. None of
> that has a home in the current uverbs ABI.
> 
> This series adds the generic half. The objects, methods, and attributes
> any UET device implements. No driver is part of it, though two already
> exist against this ABI. A reference device model that implements all of
> it, and HPE's Slingshot driver implementing a large subset. That is the
> argument for ib_core carrying this. What is device specific should come
> from private interfaces per vendor.

Hey Eric,

Thanks for posting this. EFA's SRD is also a reliable unconnected transport (one QP reaches any
peer, delivery isn't ordered), so we looked at the series as a possible second implementor of
IB_QPT_RU that isn't a UET device. Other vendors might also want to support this interface in the
future.

I prototyped it on EFA on top of v3 and the matching rdma-core PR. Send, send with immediate, RDMA
read and RDMA write all work over an RU QP without jobs.

There are a few places where RU and UET seem tied together, please see my comments in the patches.

Michael
