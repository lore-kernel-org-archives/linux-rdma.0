Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AADB416134
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784749267; cv=none; b=tornlXIWinfJy85+ut0hoN0ZzMPh0QE5IkuetwtvcMLpzQSZ4Qgpiy//D8+Z/4q8Oawh17cYDNxk1E2D3qxBBEVcvSKAxWMIIt+rV8GeRyRU7pm9yYS1vIvF2pNFxYllpbf/d9AkPK/z3tdsTaZWN6L7BavmA7bKmYHUpH+1kEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784749267; c=relaxed/simple;
	bh=NTiPeEdiwRbPZRVlCr10UXxaWrRrq2c1DGICPJYYt8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIFIuHRJ5QiRO3OYCv3RT0tk2XOc9TcFVcHAWHwlcXb4Ebmp/i/P0xZzIvkAfQeKu+m7ZixGTedYAhmR5TMqiOaatN2JfSTWLxQ9EOZTid7igSZojy0BZXH1g5BcFS+GgRfW09yV8WOGMIbHo/NA0u9LdNpG+lvro4DYScrFWcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gs5NxQ9+; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gs5NxQ9+"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so10647368a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 12:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1784749265; x=1785354065; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BaLMMlEPQVEJVp7yi53Jaq4bw1CnmBvZViSV37yCXkc=;
        b=gs5NxQ9+w2wwoUQz2kNQQk5m4oTFj0N+HnFRJQwDtws0vZDP98CBO0BMA9ZcFck/dK
         dXw538NdzS7g08EE6RPk+KzOgZLbC8Y/R2HaB7Ghuaf2TRfUQ/4wq30vQFGAYA94zbk5
         e0P8DMZjD+rXPNTZkG8kMW4HpK38anl7vbk6pkHLNw0+9BlpHAcPcjWUfBpc38ujuUt6
         Cx9ubgiT4e6njqTpPyBqbx1FVhnjNGDgDb0k4q8lAR1oNjmtxtxgR95Z99Oq45pknKVy
         V3fHBhhucrjOQikYmhYFDaRZGPeb3y89aPWZPQXNvsxXsx6vrNqoiIxAeJcJ2bgIiP6T
         GXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784749265; x=1785354065;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BaLMMlEPQVEJVp7yi53Jaq4bw1CnmBvZViSV37yCXkc=;
        b=sLdUsRTpuYW2arC0osNC4L8IV6d/QzwTTf7ExrjWYQv8lTDTWYRVFBZK8HdBge7DVD
         5/tMXMkyh81FX+ERjE+F1h0OA1rNpEJ+fp9M1Rv7p8ivBs+BNMiT9LmAMjuoHOpMKNIf
         51xAE7oClBi1gVzrjYugkgz5E0ptZlRtSkFJfH6nRnmZhmdgwuxHV5L2wIZnvb8vXC2E
         xVMsRBkbl/p8tW8YJUi+Ygo2qn+FsHPVvgk+yA5aVmGBwj5z5Jh2b63fGXPFoyRX4qk7
         j5HwGJ5vHYaKYjjQa6NxyZEzuXCZRkSfXNwSx4U1EFOyIfM2IP468K4hiTA1AgfVnJbv
         p+eA==
X-Forwarded-Encrypted: i=1; AHgh+Ro1llwIXHadOJS2l2mmtDcclBtkhmlZnK0G+cGdwmvuO0ZhmyB/xYJ6jPsAzVZrYyd8M9ci9sbWqU4e@vger.kernel.org
X-Gm-Message-State: AOJu0YwtpglB4Nce95QadVY0Ky1hZPRLD5z+f4ocpIzvl/4H29tsDTTd
	FLaadQYNc4H3h60fUNMoqIIPqRlee8h+1et5CFtVi/lUkf1+JFMHvCjw/9okpDeR+Hs=
X-Gm-Gg: AR+sD1217RAx/WevfD8rGrcIHnjhiUmFvKCSI96BYqEjkUNelrFzpQJ4wRVvvpqcDq2
	n4zyK2KNfHsXr25W6Euq2kOMX3xx2TNBeiJaol8ctxjO7AANa2gqZ20ZtTo+JDAEpzGvvCVHsLq
	P6imXRIehxWrNz7TkSn9X5Abtyi4lXplj7kjx6o+02uQ7R3kQ5I7oBYSVZpCueJ5L6JDnW1wsXa
	s3/Ka5aNMhXRLtal9100u+20GeUB/dHZpPWoY0m6PeAz52Nm3oX1OnB70XY6NINZK7s47k9xcK5
	6nou0DZwo6NAqIFF1aUTwpD3DBtD3bFJllNLym95bEuY11nHGH/wU0Pf6Z0aTyR2YLFU78kT/2Y
	XDAn5ZstC5dsJOyHfD2lZ6wiWtCOQ3JZDmepQhew44xQgCPMRf8AoPHstBx6fo9o=
X-Received: by 2002:a05:6a21:7a96:b0:3c3:7cfe:b337 with SMTP id adf61e73a8af0-3c3ad7ad9e3mr22452234637.30.1784749264707;
        Wed, 22 Jul 2026 12:41:04 -0700 (PDT)
Received: from ziepe.ca ([216.228.115.8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1c9289sm12094784eec.29.2026.07.22.12.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 12:41:04 -0700 (PDT)
Received: from jgg by NV-9X0Z6D3.localdomain with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wmcoR-000000001AM-2I6K;
	Wed, 22 Jul 2026 16:41:03 -0300
Date: Wed, 22 Jul 2026 16:41:03 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Make sure that UMR page is aligned
 to PAGE_SIZE
Message-ID: <amEczxLd_WnHzj5M@ziepe.ca>
References: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>

On Wed, Jul 22, 2026 at 02:41:13PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The UMR XLT buffer needs to be aligned to PAGE_SIZE.

Why? It goes into a sgl? The device certainly does not work on
PAGE_SIZE, so if there is some alignment here it should be the MLX5
adaptor alignment

Jason
