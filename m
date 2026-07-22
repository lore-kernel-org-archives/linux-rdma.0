Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2870C3C5523
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702242; cv=none; b=FLOGCJ+LS2l7MFTU+usmlVdrChwzv68SQ7SJcw+NCxSgZvSUrCWOwfRi5hSyuWkkjcT2BoVLFYE3m18xdx7hUQlc+XMC8lhv/XUBpfrGv0mtPgTGxyy5d15SvCk8WgXlmdNsl/5z960nIIH+9YNLkqeGJScdzee/Hw/R+YxyTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702242; c=relaxed/simple;
	bh=aNyEJGw5ly2F1/EiLTz4EKOTteqx75iS2Qb27KcK3oM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rF43g4Qr1hZ3MT+hINxBQMsB32JAl7E5f1+QQ59f/40eUkOA4eALyV6GaGORD/8Zvpc+LEhzcNuweBASUXLiCeu2XuQpqn8Jf/c+Dnama02OAY671W3iNd6wOK9iMF3HKt4FQI0/tCZD3g0TnpDwqA85ToNqvixAKiTwTjJaGms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=R9ESlBKG; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="R9ESlBKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784702241; x=1816238241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AZZ62/FmxBRY6L7thh9IFGRf/hOQYR1WZhNGBPTYIrg=;
  b=R9ESlBKGdJsg+ETC2gCJXvYfzMrqXOq04NjSSFqXEzUOTdxgNroLq4+B
   SLK2lVurcdWCvQ23E23/GoBoDcC4kg9QAv9z82uu2JUbNrpBL6Uq8dqIr
   tUaEvJ8HqryL4ptTUjVCz8od0X02a0qG4woLhtvFqgzaCF7k25DEuJzUd
   7hdAEXdLRRQ4FUIgslvlK02TIoYne9vEZVBjU0JAsHeYeTGt/olmoZ5IR
   zU3GnZP0QPHJ6vTFBQHkzLR5dRTkrlYk/MoWV89NVwZ+wTtfSx6mt6HeM
   SVUFXM9i/vFsHic9v2P1S4v8FuMoKx8QsUu2pOpkJsp21axewgvEWEUwd
   g==;
X-CSE-ConnectionGUID: pl0oHSffT+e4KeItYTK34A==
X-CSE-MsgGUID: Krij3F7STP2LFt8YCXp2Uw==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="24156725"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 06:37:18 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:13692]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.177:2525] with esmtp (Farcaster)
 id a431003e-9b03-4bd5-9138-e040ebfef60c; Wed, 22 Jul 2026 06:37:17 +0000 (UTC)
X-Farcaster-Flow-ID: a431003e-9b03-4bd5-9138-e040ebfef60c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 06:37:17 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 06:37:16 +0000
Date: Wed, 22 Jul 2026 06:37:02 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Gal Pressman <gal.pressman@linux.dev>
CC: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: Re: [PATCH for-next 2/2] RDMA/efa: Expose 64-bit send WR ID support
 to userspace
Message-ID: <20260722063702.GA17001@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260721070026.1635441-1-ynachum@amazon.com>
 <20260721070026.1635441-3-ynachum@amazon.com>
 <047c1566-905f-4d22-97fa-66945278a6dc@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <047c1566-905f-4d22-97fa-66945278a6dc@linux.dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

> > diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
> > index fc4b2eb903c9..1e371bfef6d8 100644
> > --- a/include/uapi/rdma/efa-abi.h
> > +++ b/include/uapi/rdma/efa-abi.h
> > @@ -135,6 +135,7 @@ enum {
> >  	EFA_QUERY_DEVICE_CAPS_RDMA_WRITE = 1 << 5,
> >  	EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV = 1 << 6,
> >  	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
> > +	EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID = 1 << 9,
> What happened to 8?

Its reserved for completion counters:
https://lore.kernel.org/all/20260720132221.2551-1-mrgolin@amazon.com

Thanks

