Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618576;
	b=1izkMfiWtBr+2OzauF+3nPZhL1NRUlOf70gEar5aM+NNINqQV9Pv3QoJkzHxocxt1JRK
	 tJcLKT0I1kah74+kIGs08ff7hZL1MX9MACxjsPW7zTiZC2opsvAnQPPVDGAXe2pZY+aDA
	 trTdReBR6mzBNdSIfDHZ62B6wm7FDADdgelQgSwbkTEWht7YcoP3FBla6WCvKOQ1zk4W7
	 g+qqYsHWev09HWCJ0hyRADLi48lhWTVnCjl/zVOYwlWLaLM2Ey0XA8owE/JjXHAjSYMR+
	 YzwEA6P1hkKvqsrpJ2Y59pz67gxxQC8aWdGzLi/kjaZSQ4t6Nft5I5gctsacLPmDgUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618576;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=H2v9m8o2ZyN6mJNXof8J2YJUJ0qz0MjiMku6/OumPR8=;
	b=uUsyXrdROQ/D/DSS821XaZXXxs6BWjYpXVCjuC8by3mG1kVJ8xcFXMYQPXAELcqy1AO3
	 57FIvrpw+ZydKSD3IopzD59akohav1X7VL54z69Khea1sgPQ4HzuPUy/Q/jixBJbStRX+
	 Rzoeqg+pmPeUxMCT0pTyv/trW+C8eAiCtf4sLu9VKZeivNCpIOFGKMrDNN3foSecCZqIK
	 TbOa6dDJyXQ8NqYgI9PCs9aw1IORTrWu54AcR8Mt/ir9DOYIcXA+C76PrmLdhhC8d30T3
	 fDZFWg+5/dUvmubXAV9S879O+3iHsGPaeT4bO7fkwy8CTlecJdaPNvt+ACgpLmg99Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=OYNxKfNH;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6785606A332
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 14:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6785606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=OYNxKfNH
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-943e8d35f74so582387785a.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 06:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795618575; x=1796223375; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H2v9m8o2ZyN6mJNXof8J2YJUJ0qz0MjiMku6/OumPR8=;
        b=OYNxKfNHfP6AwkYsERu63zDzJAQPUGhYsCT43HZkjStcluGygKe12LuAexit9a5c6I
         2xHd+rFeUUWgQz3UD4v6ixaaQHjS+rxO6ULdO3fhPiUPK01Xq8/mBmvNXb1FFx0+5h+y
         txmt8Qu7dTrHwsvfmdLvBZVh1tYGu5ws2UTAxhQ4QQZ6wJ9BJZ0AHoMR77wCIUE8irGw
         yOJVXSOfdvyNe/kwEsFYcbGWMENmzqdQGwGisbGOpmrz0P+cscixGw43F3nRwhBp4hXK
         oAi1vBIDqzDf2RFEYLAzJgTZsaAnHnNnhRfu705bDSb63uQLNQ3FjPvM/ZEIm9FBbf+L
         49WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795618575; x=1796223375;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H2v9m8o2ZyN6mJNXof8J2YJUJ0qz0MjiMku6/OumPR8=;
        b=QAYRiuUwxaUXUU9iWdkEfp0HVUOxzDdnc///4IphEh402ms1JGTJsLTCBLmO9/fZp9
         WPTY2Uqd8NZNsmK82yqJtmy3D3nxe/lOg4ZeNl7ZbLmJMO6bCVHUIdC/366wmsB2LI3L
         io8JBAwO9FJIW51AS9erZmonApnqUX4nVFvpsPYu8wAaDO61KAOCZ0orMqTemfEiE9nH
         R7uEMbD7kS7ugjXcjydteg3KEbsJNxOa47L8yLWCrFvxdeWTAhkHAAfyzy+RteeDVIFq
         m64nkwqjWG/6QL8up7iVIQAWavb5knGQCYWDEe7+23YpKR/6Da4thTTvkSzPEumCI3f3
         JN6g==
X-Forwarded-Encrypted: i=1; AL+hErEtRA1A08psEXd4Tm61DKIHrw2MbKRJJ2Qntw9tgD11KbuNwD5ebC/Bp+GT923gHnyWP2G5oX3i0yPY@vger.kernel.org
X-Gm-Message-State: APuU4Z+HFSEWxc5XaJGWZFcSx664ft1qjpYy0xC2UjTe2HQKpBL5CFRp
	4x7qV8Z7Na40nTN94/Z7voF5EgCYIMf5ifWpEXRlE/KOHfRTF/v/qRyNz39/cryXAJk=
X-Gm-Gg: AZFdTZeIe5ryS/klr/4G/ow1Fht59vqmAnUKo4az2R7Jc3Qp4E14k26SrbHHYYV+kZW
	tIzphwX3ZWzq68Rz2hhFQHEjIn0DNjB4IEpVIcEzxE5A9SawVHLz8xn5ayIW8RBz6cOTPnjlPhZ
	F+rFxMyD10Ag7LiW67+GK3kHqA8IMHI55BOJ19/cvaFJnaUImxaks9i//PDCM7uaaJ7jnwCtG6m
	rqnxCYuw3hqjwTKhfrX1kjZDDL4AjQ8uCM3Q2X2na67bslWQG0GRDBZYvQKGX+NFVgHkUpK92dl
	Ox1f2yURpVFXJM5d//suOvYGYG9FexXSPKZmd0sxxuBMYu+Dla5fJwNc9CYcIJXtJs0TrqKt5jz
	iaihmpN6I85403MSA2U4A+08h3RYtHS86EQ1acvjzgzYs4MjiRDJA964b0ulP8q1azf9P5HAxPV
	WCJW3D+UqKVAztCV3QyVdpwU1iM12JEfLJIqG60WYt5RSz5XV1MmrabN0WNRnY4skmax1IJyXXL
	ChzZKFtxKeLXHzKgmf6OLa50lUHhy6k/MCGVMA5BnEd4c30ovHLtZmAAIqzi+loqxXVlwT9VU90
	2+JGbw==
X-Received: by 2002:a05:620a:2956:b0:949:9cf0:badd with SMTP id af79cd13be357-949bab2f511mr3135941485a.73.1795618574856;
        Wed, 25 Nov 2026 06:56:14 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb38c903sm1327013585a.19.2026.11.25.06.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:56:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWEPt-00000001o1M-2tKn;
	Wed, 25 Nov 2026 10:56:13 -0400
Date: Wed, 25 Nov 2026 10:56:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jaeyeong Lee <lee@jaeyeong.cc>, Artemy Kovalyov <artemyko@mellanox.com>,
	Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Preserve DEVX objects after failed output
 copy
Message-ID: <20261125145613.GJ246011@ziepe.ca>
References: <20261111105346.3220427-1-lee@jaeyeong.cc>
 <20261115135123.GD42525@unreal>
 <20261122103715.51731-1-lee@jaeyeong.cc>
 <20261122103855.51859-1-lee@jaeyeong.cc>
 <20261125131244.GB14811@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125131244.GB14811@unreal>

On Wed, Nov 25, 2026 at 03:12:44PM +0200, Leon Romanovsky wrote:
> On Sun, Nov 22, 2026 at 10:39:01AM +0000, Jaeyeong Lee wrote:
> > As requested, below is the full dmesg from the reproducer run.
> 
> <...>
> 
> > [   13.847526] mlx5_dct_repro: loading out-of-tree module taints kernel.
>
> What value does this change provide if it is based on an AI-generated sequence?

More importantly you are not allowed to call
uobj_finalize_uobj_create() from new style methods, it is only for the
old write interface. I guess it is in the wrong header.

It should be uverbs_finalize_uobj_create() if you want to use this
sequence.

And it should probably cover devx_handle_mkey_indirect() as well.

The idea itself seems reasonable, once we have done the actual create
command to FW it should use the normal destroy sequence. That is
exactly why we have the finalize helper in the first place.

But to do that right the entire obj_destroy should be removed.

IDK about the claim that DRAIN_DCT can fail, but I suppose it is
possible for a hostile userspace to immediately refcount any kind of
object and cause its destruction to fail and that does seem like a
legitimate problem to me, so this is worth adjusting.

Please send a v3.

Jason
