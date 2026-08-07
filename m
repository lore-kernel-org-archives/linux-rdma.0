Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DF8373BE8
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 23:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786144440; cv=none; b=rn/tybTp1c9h34nRLSnSZD28bqmhmzH/n9LJ0PDCKFlqT0+xbu4rSexSWfvf/xCjUlnPiyB8mN+lvE4CVZSwSk1+5xnj1QPLlP1FHc8/GU5pq7oRxYtr9u7QwvteNwlcrJ4jVFYXcpz9q+T8pkakdc7MQlfPqkdpmEuAB0hKscQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786144440; c=relaxed/simple;
	bh=tqUjXiHomX+VrKleMFQsfMOb8MiW4dZzgPZl+5IWgtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c926vAVxdKKIc/hRi7M39wxNTvNpmpBTimlRmjPdB0+UJxLb+2u3e2rkMibrTvA0ie5vjME74hIp0nao1jQaJa4QZBwkZ2+3wQqoPvX8QyW+K6BFIX4/a+49R//0qYOp9ROCsTBjg8PjP7rfotm30GxjEFK668wbhg+etoxlp8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XM9syh0g; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XM9syh0g"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c05dcdf49so1052231cf.0
        for <linux-rdma@vger.kernel.org>; Fri, 07 Aug 2026 16:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786144438; x=1786749238; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tqUjXiHomX+VrKleMFQsfMOb8MiW4dZzgPZl+5IWgtk=;
        b=XM9syh0g7YijndTABQ0Uj7uoscky6+Y1s3Oh5oNH7LHDnmSkfMTJMDPqstPd23mhwR
         cdSfvBontzP074JnhY3vrp5mpyDrT5a1vDH5DnRVYw7pVwvowAIQndBTStKo35nXmjwe
         4GHNfSYW/TKuDUTR78TollixPB06XXR+ugEDtYnROYmH00XMTQAr+8ZCRxAloIMSlC7v
         eq2vRaltp3UyNVNIQrA1NcZmpE4SrqSJXhpv9sj4tfVmDIU5VFs1YP58tlI150NTqleY
         obukpD5sADci/gjtbwYBHZ/hFUYXS52xb7qjnclcTizgSJoiD+tcxzCvyqqPCA+E39OC
         R4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786144438; x=1786749238;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tqUjXiHomX+VrKleMFQsfMOb8MiW4dZzgPZl+5IWgtk=;
        b=C+HhKmMcWXUB9qUkx+pslRUGVBek9JxCdPD13ige7I8xyFMgCqYjSiFFfgajkN7P/e
         16p/ptqN1pvE6w8zocovIu3H5/CcnYUoxDm0rh8iAPyQ1tvFApgkVgrtLPSsBX2LhUig
         o+jtvuvl3T0QX4S8qpruVK2Q9gI8dVwTBk8s1vFRo7BgIEWRDmT9ssQMCZOzVXM+qfEd
         peIAqnynFUj0g4JvU5SrQQPgll4ZNUkdzlfRlCMgQO7gZzhHD1NNSgEIsweQdPJpmdPu
         rJ3RaBNlwseZr8qIYKxJ8I94hfmM0ftR9hXWrPV5IAZaExivo54d18ouklgLUDjy31Am
         RNyQ==
X-Forwarded-Encrypted: i=1; AHgh+RowEYkTJkzyIyQv1FR0hA9b5cBz66BepgC5ZQHQj58qeYRyQmietfZejaQB8X2ZNALyinLBX+Ic445L@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ajmakHIuAdHZg5E+Tb2mEpXMgvs8JebMC+TMMNilpcSX+BD8
	TdZrV+n5VRESBiCwdn8+rV1NmawKoV+yOdIOFBLTJ34DCgiZwy9D6gykncNM7UbiBf4=
X-Gm-Gg: AR+sD13UkQYreVPj7nvLzzok/UAPI7cul0VeLbW3AHY9HAv8nfCMHYVb68mVDPQF4rj
	32/FB4ve8EdPxe8/tK117AaQrGibmWIq1X14XcW9Ffk7OIoYVvEIUDKHEFxtfVwpfwJS6h2zd8X
	t6q5MxUdpXP3QfgDRCZmqyNzqrq25YCmC6DlWX3Xe+eQqrEwqH77Zt9r9gwOJAOpIhUOVsNN1IQ
	SlUJXgqYnVuja2BNEDaowpB9OXcEzSfYM0AclRBakAQnZ3vp1fneXHCmviD9GGwtBZwVZL+qmZY
	R8KaL3ydIFvGwqvhJuBAj8AHHYJD6s8dxRTjLKA31sxnoFzJ+BuwRYtLHXL+NHleVQZKKXMgJdr
	j+ccdAr0sWY0rlO+5x8BPMxcwffIk0m7FG0a5qOPTEsTsrxaezWlfmlQIw+nSmswfHJW0YsDvoi
	sDEFiKPpd6SBfzOKpMckecY1YPH9ImpQlyUF5BatA=
X-Received: by 2002:a05:622a:4c9:b0:51a:1651:b796 with SMTP id d75a77b69052e-52ce6188478mr291017851cf.29.1786144437788;
        Fri, 07 Aug 2026 16:13:57 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a918db45sm19297086d6.4.2026.08.07.16.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 16:13:57 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wsTlE-00000001Hhl-2cyu;
	Fri, 07 Aug 2026 20:13:56 -0300
Date: Fri, 7 Aug 2026 20:13:56 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"leon@kernel.org" <leon@kernel.org>, Long Li <longli@microsoft.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Message-ID: <20260807231356.GM200537@ziepe.ca>
References: <20260731091041.2250897-1-jiri@resnulli.us>
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
 <anCBtLSxn8TtFcSz@FV6GYCPJ69>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anCBtLSxn8TtFcSz@FV6GYCPJ69>

On Mon, Aug 03, 2026 at 01:59:07PM +0200, Jiri Pirko wrote:

> That is not doable in UAPI. Some userspace app, like rdma-core in
> this case, might use it and rename breaks the compilation. Some other
> app you don't know about may use it.

Linus actualy had some comments on this once (which I will never be
able to find I guess), but we broadly follow what he outlined. The
userspace has copies of the kernel headers embedded in it. When the
kernel headers change the user space updates it's copy and fixes any
build breaks.

So long as the build breaks are fixable, and don't change the ABI, it
is fine.

Many parts of the kernel work like this because userspace is not
supposed to directly use the kernel headers themselves, they are
supposed to be sanitized by glibc or some other helper library.

There are a few places that don't work like this of course..

Jason
