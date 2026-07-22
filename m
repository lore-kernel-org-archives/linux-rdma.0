Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E122EBDFA
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 06:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702087; cv=none; b=bFjGLNaxdO3pS+S4MhRmmRmpHjtoNhHXvGHPft6OYxkzJP+W+owx6XFIiaZ9DVRmwl1yeRF27O15j9tIyOJzIWZcgCJs0aDUXFQrTT/aHjAzcGoBAuOnGGi7wvFPxDBRwHO0UnR2Dn3qfuK8OoiAsxE6EahaM1Epfjnzc6FGUfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702087; c=relaxed/simple;
	bh=MfJfoMzKmfk+AUGJ+gp4xl07nlwOq0gvrrtxbBe9IzY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jp2ZecwnkufXAQAN0JTzOOPw6T2n9xC+neRZ9ptTG4hNDwDspP8eElwdLo3T07zl70Gz12sQpffezcZgZgVuSrELW5QdeKRkQ+FrHbrX7eNqgb7u2ScloLzqYPZ5VZMlz2b/t9cRmno44xsz3DIh74Xil0QPjbpVPtxFw9LMmHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=aFsJb3ed; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="aFsJb3ed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784702086; x=1816238086;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XhOvvpj+4OgxDkDrmJCMUyJJ0XQUfgdvzk0pX5N2V1k=;
  b=aFsJb3edlekVv2HaTH635sz6KpVXDi0DS40m/IvRBzTnX6zhKUgL7Mbh
   72jLJLwgO+ZADt8laH4EI0uvksM+VV2NkW6Pi72+FQWxPR9Hgegzw2e7Y
   nH6L2q3Oovtq53lhVJKL+zmCB4HKbUKnGsZAEPTUufl1Q4dhF+hE8RJe6
   pB+bRzydPRosVVZ6TbBpocRNQmXeR9V5F4NidnYvXYRVJwPL5raw0drBh
   xRvkj3nI52aRxAa2iPkQqq7UJZ/Djk2edmq0dA9Ery6GM0Pnt95rQRuO5
   g0hRNZbmGKCpYfHMEYxafK+Z42IixhL/SpT5kKUCVPQMJskAjXZ5rQT9u
   w==;
X-CSE-ConnectionGUID: ubYosXLVSoqP/VvsT/aJSQ==
X-CSE-MsgGUID: Muz3TenfRpmtj4kBdUnm0A==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="23903766"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 06:34:42 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:21142]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.17:2525] with esmtp (Farcaster)
 id d4d3f602-2340-453a-ac29-309f6a326a3c; Wed, 22 Jul 2026 06:34:42 +0000 (UTC)
X-Farcaster-Flow-ID: d4d3f602-2340-453a-ac29-309f6a326a3c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 06:34:42 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 06:34:40 +0000
Date: Wed, 22 Jul 2026 06:34:18 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Gal Pressman <gal.pressman@linux.dev>
CC: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: Re: [PATCH for-next 2/2] RDMA/efa: Expose 64-bit send WR ID support
 to userspace
Message-ID: <20260722063418.GA13288@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
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
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Wed, Jul 22, 2026 at 09:04:36AM +0300, Gal Pressman wrote:
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
