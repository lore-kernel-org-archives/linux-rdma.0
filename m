Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD133993
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 00:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022919; cv=none; b=pXBWUkMdiQaIwLV38UFvA08KFzIS6WGmJCwTjaCFCtiByeOXXKbUn8sd2PgztAl3RfAz91W5Rh+PZsluTjWZEnRi36mQnPO8heP+qcbDgN0fLyX5z9xyKHfZ7XYsfzT0ML7hQI5OI72ieRj+2E86nXHR7IKvxGoYDkjgIVQOPKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022919; c=relaxed/simple;
	bh=Bg7ZBOkQIeQJSNYfNEEpbP6T9971obaeKV+XLBR6l5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DvXQCBh8Oar4KrQ5noVaXNOo2exUjdf5AJendTZibbWvN/cza0Cuwtu4p3ZxQ/0OE8L+UQkwHEekDpoAcunn4IB4NqP8IUiYQCx8Twb8skGpqHPN6yg06vhajBrUG90C8GH6OOSVtjogb5+NqHUd3a7q92j0KIC2DRIhj91dHgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Kph0ITkQ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Kph0ITkQ"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93ece7a73b9so598041785a.3
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 17:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792022917; x=1792627717; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CA4rp8RFpYNcOmSAoFI7kJdmm3Y0joL+tnZEeEzIbIw=;
        b=Kph0ITkQfkgu4A0VCfFnxBujuBzSOhUcBlKn6oFkviNpAtjSz4FUhOTGjXCUb29W3S
         lqBbfMZ1Dd89rqSecUgASobuNhk/FnM+4xjY+1WYKT+HmdBg5o6ZHz9j/V15EDTGBuv8
         lkRbgJoMe2Lbt2KJFB5bp0AmhyvFtGoh91udl6KGVOwAR5VxrTqC0fUJiCvBCLEY73MI
         nYowGfex4UIUSCpNvUz+cwLAEu3lp3t9IsMO0dQgnHS+iJJ8bPd8rCa/NGjMl0CJlR3T
         epnT+9xur0G8k2MGK02iiXRjUjC82guMG+bG9nLDSfgCdrohiWVhgiwCddXQRmmFJGoj
         Pffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792022917; x=1792627717;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CA4rp8RFpYNcOmSAoFI7kJdmm3Y0joL+tnZEeEzIbIw=;
        b=jCwo8a0nAk3SuZNb1KtB1qnimKc26NBZitu3sybp3qGbGB8/i3aaEmUIObOTTomBwb
         Paui7lVVKX3gTrHUnZW56MQbyKrl2HrSgpUNT0TST3tSUh+T38fGf/DmKPbbqG85/baF
         csGUJMsK0smXkOE5j+h4UqWBDksmwdpzap6rw2I9VXLDQOVam5iWXuFFrOr3pOD3kHUQ
         L4bIo04yX4Dxni0BnW13VKdphBEflOFozlAOZFZ7Xflz0dS2gBwDwLPB72qVHTzamyLY
         Wx+81O1ProS0Zmu1aHdKg3QtdGxsHtzEZC6wyDlS9g7iklPm1TiqGbpMy7cVnzB5CJv+
         jE6A==
X-Forwarded-Encrypted: i=1; AKwUvBwYi65yqZ1K576t/VnvKvLc3hAB6cuYtMpK0iNnCyv3R3xhrpssCvQUEGvkOxpU8uxjRn1L/YRrbhO2@vger.kernel.org
X-Gm-Message-State: AFq9FYK6KtexjlkRuRPh1GSbDidOBuj9HG/noiHtftRFkhHAAME8dLTG
	yuM5NbqV8vSbKmSCpJxFr07+VIfe3xdmQMFLcWA562Nb/lzpLnazXMur1m1VFtfXagg=
X-Gm-Gg: AYBFou3Gpf3nAdme8MIvLi13oP08QdNA87CytBCrSSk3mXxRu0P9Pw5MmLQNgoc7eFQ
	GrHKYfUpmwdn6isxNA3/zACJFKi6HyajbT1zqKpMSN/yi0QYEH2TCDdDoO8VYSGFiuhvkZKDTtH
	suckKQc/5/ZNWwRaYjbQAqnfU7Eg3c5xq/q1YW691y7PZasZLqkFGcMsJ9O8NaOWm9eCvNZva40
	eRETVIXWH3DTrfGGb0LDQOtEWiOkwaQsJ04TtY4XJfxCjf9FrlG0l3Bc2JupIhvIYMBgn4Zq8Jf
	KJiRgvWrU3MAeCR9FdwzaRwwu2RUqNZ69SvGLhucF8Q0cVFVK33tkbHWvtcaU85Q4d3bgPTkOIJ
	+TScnzhOOgIllWqsgdqr7w/V/sH0yRnuDCvxbSq3jlG/CElaAs2S/AtQNSfbnwAvI4TxgAvkJH3
	PPh1ukD4KHJ7iUdU6pK/OU9GzkV9JW/4c6RdpIXbIyTFw1iYe7wg6b9IzriApXSx7oS/YetKskU
	4NplKsuCN1jdoUUC/qjQkLYQnWXPCwXlhVURqPhntij5ShsZM7TB2Uz
X-Received: by 2002:a05:620a:2993:b0:93e:61ee:fb14 with SMTP id af79cd13be357-93ebd248395mr2691455185a.36.1792022916743;
        Wed, 14 Oct 2026 17:08:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef502497bsm630577485a.17.2026.10.14.17.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 17:08:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xH91O-0000000Ezh5-0yPd;
	Wed, 14 Oct 2026 21:08:34 -0300
Date: Wed, 14 Oct 2026 21:08:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Doug Ledford <doug.ledford@hpe.com>
Cc: eric.davis@broadcom.com, Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
Message-ID: <20261015000834.GQ14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>

On Wed, Oct 14, 2026 at 04:57:16PM -0700, Doug Ledford wrote:
> On 10/14/26 3:21 PM, Eric Davis via B4 Relay wrote:
> > Ultra Ethernet defines a reliable unconnected transport. A queue pair
> > sends to any peer in its job without a connection, incoming traffic is
> > demultiplexed on a JobID rather than on a connection, and what a device
> > orders is far weaker than IB or RoCE and varies between devices. None of
> > that has a home in the current uverbs ABI.
> > 
> > This series adds the generic half. The objects, methods, and attributes
> > any UET device implements. No driver is part of it, though two already
> > exist against this ABI. A reference device model that implements all of
> > it, and HPE's Slingshot driver implementing a large subset. That is the
> > argument for ib_core carrying this. What is device specific should come
> > from private interfaces per vendor.
> 
> I'm doing some cleanups and then will be sending our Slingshot driver
> for initial review as a dependent item on this patchset.  Look for that
> by the end of this week.

You each will give reviewd-by's for each others?

You are running sashiko locally and fixing the bugs it finds?

There are several other new drivers right now, do we need to do
another full driver review trading scheme?

> Note: I dropped linux-kernel.  Unless things have changed, they usually
> don't care too much about the rdma stuff until it's time for the merge
> window and that list is already way overloaded as it stands.

Nobody reads that list I'm sure?

Jason
