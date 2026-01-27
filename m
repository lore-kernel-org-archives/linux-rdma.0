Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0394B35D5FF
	for <linux-rdma@vger.kernel.org>; Tue, 27 Jan 2026 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526470; cv=none; b=DIbBL0Y7/H3ygMua5SvmzrWWM/ZKqx9nUZxdHm8jw6iZZ//rkqUo+7iax2lu6G/QrU6lG5LfTFyMdQEkvrUFv018LbOyqOhffqS8WVRUM5NR68v0CPOZANT1SkCUa+Ca13w5Ukj+elA6s1rTtdts0PSiTeJmOXw3SFIPFsDROCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526470; c=relaxed/simple;
	bh=9MUb/IUOGgh7l5Cq38H+B1mWEKMu3kQEB9Iu4hTiHRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHJKExRw+gLWU8GDuOfND4NxYHAx50m8Mfng6a84dlH8O51hvXY4LhAVXV91A4vMBiJ+kQHVS/2Qv73aYx9StS6exwBuQungb4M4Oc+NiKkmiG48mITiKvvyvGwgcvSNjd8nPzBUg8T3cMvUPMA9X0B2HHfbTVIECkSG4wD/E9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=ypVX9t44; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="ypVX9t44"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47ee0291921so49938035e9.3
        for <linux-rdma@vger.kernel.org>; Tue, 27 Jan 2026 07:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1769526464; x=1770131264; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cGpjAjDLkOSIuJiQ1JALNASUDAQaSYFEf1deSG9mrpc=;
        b=ypVX9t44m5QKHEOumjgi2UCW+XFzis4UROx+gC/8E6f5nVLzLG7V2rGQkdNd88WmFu
         5xaScbkNXN3j4AO0m0pKLWTAAAWQyQcWyGnUs2S3xmTzFtRWtY72QinRSH1YTw253thg
         jd59gCnUfknK9UD24p6+9Jw7+wxSy3omDYBqkeXKWs5oCDV34iIsLyub2VADFbyF5FNm
         F9/dPA8V8b5Zd5GH+Y2JV9pV+j2zrEwU6oragzgXw6/yo49MCB40Darz9GcdYsVcJUnm
         JL9zHe+vcKqzohSXXAp5zMdQ1wg9sBbKozqjtFVy4kEckopj6IsQU0nUHgk1gTZfrqYx
         M7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769526464; x=1770131264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cGpjAjDLkOSIuJiQ1JALNASUDAQaSYFEf1deSG9mrpc=;
        b=MbHsvab50xLVP52EOflM3I7H3OyLi8egJQfe/AMv9o3G7eXUe8yAuJFatsNT6BvfiG
         yN2Fm4Y5EKqagv3Ugunjy4yKGODZW6YhqMEPILDEqtg5BUU1bFH1Au1XPx9CjgJ16YIX
         BzUdWw4Kp2O3UQ3tebx9J1dUuegiWRnEJvmziL+SYRdHXWJL0kgMOTwtkR8yP5WJI+Hc
         ifNqNpdEEU4zggaxp+sXceAm8lRIU3bm6w70SAFWT+ZePa/szNEOvyPkFItehkq0qj/e
         Jutv7/VtWpsur72utA4Dn7CzQKUSnGr+XkVP1bzvXarz8sCpyLDgwtLpH+btM5sJvFCX
         V+RA==
X-Forwarded-Encrypted: i=1; AJvYcCX1HBgbi+CKmiqeI7v+y+X0oGGOYtvxSsUu70d4uHljTbQNqdnXi4Pno/uwsIfM05UAz6uEI/aldbHM@vger.kernel.org
X-Gm-Message-State: AOJu0YzzE6ZRpB0FcMZug3Sa3VSgMIKTrTefRpozJl/abWucGFb/Bv1A
	S3//WaJKXJcos/RAeUvHwRdeSiiX92EPn1UK40zHzdPZ2LVmfvi8HW7acoxq170ugQM=
X-Gm-Gg: AZuq6aLxVlqBGduJVpSBDOIuMcGOiauA74l9/5s1q4JmiFpPGxxhohvHw7uNkOYPCO7
	KthFl5erUK+PTnpl0s18JkWCXE67oKvgj4mDJ1JVSBHcABg+DDjhGu1mwXPVcXihKz+Co1bcZeY
	YuNA1IRvG7U7R604tmE8nWhKbE2gdQDCYKiAsn3H+kVIc1zANBt4bSYlRebZgxRaJRwa6nmUsx6
	ijsbpB9eLEbUbL5IRQNIVk8p2/fP/182aLWKBz5RLPn7ylQrTM/7a5O7xWcu8vqzLE3+i1/VxhZ
	Oi0zSLvH7rnGgJJiuhpUZRVXbcYgYAb4lJ7xl9EUQUQGrQlYZ2uqgMhUo2mrYgcJUN4TZXi1oA+
	u4RZJHTGPvStwHlLyZVwqTR3Efhuk4KXHt5bPQKwU0Eobc8xCmIEohf3GbFpiO4g8sEoFEaO0j2
	BHb0ffX8g+vEAg4DSfHz+PQHs=
X-Received: by 2002:a05:600c:1e0d:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-48069c8c0ebmr27284095e9.17.1769526463910;
        Tue, 27 Jan 2026 07:07:43 -0800 (PST)
Received: from FV6GYCPJ69 ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066c10ce0sm110981815e9.14.2026.01.27.07.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 07:07:43 -0800 (PST)
Date: Tue, 27 Jan 2026 16:07:41 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, 
	leon@kernel.org, linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
	selvin.xavier@broadcom.com, kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v9 4/5] RDMA/bnxt_re: Direct Verbs: Support DBR
 verbs
Message-ID: <qkqqa6grjmfbkxalfk25w2gliscr3e4erdwae4zvl2oqncwgyn@brkp7gu3ppy6>
References: <20260127103109.32163-1-sriharsha.basavapatna@broadcom.com>
 <20260127103109.32163-5-sriharsha.basavapatna@broadcom.com>
 <pynbf5lh5azbblvoygivvzxjcmnvffrtdz5zbjzsg4rccbpvud@277svcow3ra4>
 <20260127141545.GE1641016@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127141545.GE1641016@ziepe.ca>

Tue, Jan 27, 2026 at 03:15:45PM +0100, jgg@ziepe.ca wrote:
>On Tue, Jan 27, 2026 at 01:30:03PM +0100, Jiri Pirko wrote:
>> Tue, Jan 27, 2026 at 11:31:08AM +0100, sriharsha.basavapatna@broadcom.com wrote:
>> >From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>> >
>> >The following Direct Verbs (DV) methods have been implemented in
>> >this patch.
>> >
>> >Doorbell Region Direct Verbs:
>> >-----------------------------
>> >- BNXT_RE_METHOD_DBR_ALLOC:
>> >  This will allow the appliation to create extra doorbell regions
>> >  and use the associated doorbell page index in DV_CREATE_QP and
>> >  use the associated DB address while ringing the doorbell.
>> >
>> >- BNXT_RE_METHOD_DBR_FREE:
>> >  Free the allocated doorbell region.
>> >
>> >- BNXT_RE_METHOD_GET_DEFAULT_DBR:
>> >  Return the default doorbell page index and doorbell page address
>> >  associated with the ucontext.
>> >
>> 
>> Similar to CQ/QP, why this is bnxt specific? I know a little about rdma,
>> but I believe we use it in mlx5 too, no?
>
>mlx5 has a specific thing too, the doorbell has enough fairly hw
>specific properties and never leaks outside the userspace provider.
>
>We consolidated the internal code to manage the mmaps, beyond that
>there hasn't been a big push to consolidate more.

I'm a bit lost about what this patchset tries to do. The cover letter
does not mention dmabuf at all. Not sure why. I understand that create
cq/qp is enabled to work with user-passed dma-buf info. So that makes me
assume the same for DBR. I guess I'm wrong.
