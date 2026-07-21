Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CA9415F17
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656268; cv=pass; b=pDA4SZPrUidZpBtSeXKrnqjvl/t3d5mbCLDqdV/3NIc7uFdE/v+aEPb893/k3OfI2fa0rJPdF/StTEfYo6OpxkPqFHtC9z6kPyJ2JgB+87W+lHa1GEAGNMYYPIv4xf7+dHvWWPAIoJXm3j0xfmVNrxVzU0LtFFkvrShbpEkWFKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656268; c=relaxed/simple;
	bh=fk82OUiWTbfj+Bj8rJw44IZWjsVv95l8951dHoMMtw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FU8HGdxbHFipaR7DSz4+0I1OHl+LLL9h+b6crfLUsgb83iFMQDndu47RDUw1lEiZPSiDpIbCjbLiBORYD6OZx0t5MNANkPw1Yy9tUypKvNKUncO4GNS8zvh6+Y05zQlXmgGuY3ZM2YhHc7lTm5dg1wGKMYaWe1z2YIoujXCvZMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=B2YpB9l1; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="B2YpB9l1"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-383cb94f742so10816218a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:51:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784656266; cv=none;
        d=google.com; s=arc-20260327;
        b=Vsy5GtG+hi/hauWKepGPAJV99u1Il7AZJ5JhIJwBYVeyn4G8LrDN3oZ8yWvS40xsw5
         oLLHetcfqLm+QUUL9sH/n/Vz1OdBQpil0fKNnHl9mGgHoebqZxLkp9bwnfc4VT/tAOxf
         qbpYHNAl+nQPfblNPE3c4IHmgWYfxBEJ3VKYtQdrs7OPGmUI73yT/wlVYhQVXNjBZiQb
         xBybGAi14CMmCZPCQwWduLCxWgugWP7kBU+b8RlRJerZpOT886Tm1H+tdZy+R/1PMNwO
         Uzj9HZMvUpU5C9qTt+6uCqNhu2PUF2u5ldAsLN4dpjRBMoF15/2641F+aViIA9y57Xcc
         BaaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bqJhHZxbGEvXYhualzcQpDQcrx6Nf+L7xXv1g9Mul7I=;
        fh=y/yf5N2ozcrf/e5Zl39RR2MolHw3t85I+EVm2vX3dFg=;
        b=bEww0mUFKm9rGGP3GNKbLLum7+/xcfsFNnmfhpWBPK9J1daTTNsXrmGfa30RFGK9iB
         knJ3cVT00VM/VdVMLRjLIfEf47RCHZMW3HNKuz7Ey3LjHw3lBr2QBpSuxXaNBhBfgify
         lgmRll7iQjQyUy+jNh7i9UFY6/oX+gv6hm3dvNizwH8QqSJgVTq5v7Cl/qVyNTViNmH6
         x6tH3DRIS31IdzoRnskvC/+DZpXYMsratXCkwuCvUs95QqpUu05A/2ol+vyFOn0/3LkV
         XNWPNOoVWj/+NopckBA0tGKSLN2MDuRGuFIcqiIMHV5JgAtCvj3GjJHL9K3IOzD8yaoD
         CcwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784656266; x=1785261066; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqJhHZxbGEvXYhualzcQpDQcrx6Nf+L7xXv1g9Mul7I=;
        b=B2YpB9l1/TObhAYO5TnNeLkPfQxNXrt4FLbJyfF4b6YsB+3mtpbrLC451fbUEPr63Q
         NGNBLAOy40rqXGxxjmU5vU/QmC+jmwpBDFL6ttXHav+6+8uSI1bxu2+SDcUQKocYcmeU
         76hn3dxT5HBpSSNFeebJZejdZ4Of6NVZvekz3E/0JEmzyUg1uVZOoqWE3ozRZIz7Yw/g
         aV4g00IZWHMy1bMsdWmPSGpXeuw4SbTJR+fwdbgnVoKtSm6mjyNQNMkQF2BdW73TrjIE
         HHlteqCJSX2KsaZYaghGCnm4F7hyNlV4rp1cwqBvLgVdBAGiQxXY+zV1e3E7rOuSt15t
         wBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656266; x=1785261066;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bqJhHZxbGEvXYhualzcQpDQcrx6Nf+L7xXv1g9Mul7I=;
        b=C3AKV2qwWbMvTT5UgN3bzP1A1DWd8S+vWXsTAUSRdH0rVGWEGL0Ukf3y+1Tb+QmQYF
         +3WbA6ijmhAque8vWKK13neqKPf/jL8smSXQKGI/HpPoM/w9FUEoYo92jo4Q9u9oA/jv
         9x+EimjV2f2drtKxiKdM74ncIAveCj0EuNurX45sh4hN4/3F3KUa9TxOYDHIIJ0oBa2n
         fjyqqqbSUUieKGQA8+x3VYgHTMi7ZdmXfYV26v8jVjIPjpVd7mGnOZa5Lh0dmUwj2Q6p
         FvGaHYgjr5LBvPpiEVG+X+Qze0dvncFrjt+QMsgL4vGb39/kMYNB/qmMngQ3Zy+kxKV8
         jxjw==
X-Forwarded-Encrypted: i=1; AHgh+Rqc1idvM3hskXm2idHNEjcS2oojzshhckylgWfAHAUhNgpRisYyG4qeHWKi959d4cATcDe3mHnQYwzK@vger.kernel.org
X-Gm-Message-State: AOJu0YxelNK8g+ocI39PeOnwRUsv5wX80uDrfKJ/qbeODmU9Os4p+WkJ
	AMCMJ9gHUW8ShBpmbwzxLAg2CbRsoA7+BG+1r9dCaYA6xddh7pZ0/TMK1qn1xMwiabN+GpV8Rj+
	pn8wgSZ0uxbf3gfzYBxWjKcGOmIRd7h5KBltT2BH7
X-Gm-Gg: AR+sD11uoE4yj+cBuVp4P2E7pJ+npc/MCZMuyEwoyBP73bA4T8zPu8CgbAbSNyg2xTc
	QDBR+i+JPcf2bnbyqk0sFrnBxH0za31q96ISpcvftfygqv4JWBD0IAOEu5/yF8I77a50cZR0hQt
	B7668Yk/bLJRJQDU+aXR8gnnbCWPPCsucBvgimDzJewd6Jxj21F84wTydBfFXPeQZcL52pD6aTI
	qi4qUc99IAIBoByUwUKVgMD1lXqUV1dO5jzlhszPIF1HzxekQBpW9hvfRd8eJmKyw5Mo2pXzSuG
	h0+uLdEfPsHRtD06MQzp0vIYuOQJrsY7UgXJ1/K8/PQ=
X-Received: by 2002:a17:90b:2e90:b0:368:ed26:15b2 with SMTP id
 98e67ed59e1d1-38e4b43c408mr19724564a91.8.1784656266239; Tue, 21 Jul 2026
 10:51:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
In-Reply-To: <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Tue, 21 Jul 2026 19:50:54 +0200
X-Gm-Features: AUfX_mys0lIoq4Q-xmicA-5OIV7AmcAZv6tYBswRu-bPoovrkHLh5N1N3P5Onu0
Message-ID: <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks you!

On 2026-07-20 10:49, Logan Gunthorpe wrote:
> My eyes glazed over a bit. But one point is that maybe this could be
> split into multiple patches: one patch introduces R1BIO_P2PDMA, one
> patch for raid1 and another patch for raid10? That might make it a bit
> more manageable.

I have split it in v3 into a raid1 patch and a raid10 patch.
I am not sure about separate "introduce the bit" patches.
R1BIO_P2PDMA and R10BIO_P2PDMA are entries in the two personalities'
with own r*bio state enums.
The commit messages are shorter now.

> Also, I'm not sure if it's possible without digging deeper but, instead
> of adding a !p2pdma_unmappable check to every if() statement in the
> raid*_end_write_request() functions, might it be possible to factor out
> a helper function and return early from it?

An early return doesn't work here: on a mapping failure the
function must still fall through to set R1BIO_WriteError, so the
completion path runs the (single, whole-range) retry and records
the bad range -- only WantReplacement and the FailFast md_error()
are skipped.  v3 folds the two tests into one branch now,
which reads better and keeps the fall-through. Please check v3.

> Maybe the helper could be
> shared between raid10 and raid1 as they look very similar. The
> differences between the two are minimal -- there might be a bug fix that
> was applied to one that should be applied to both?

I compared the two sides after splitting: the P2PDMA handling is
symmetric, and the remaining differences are pre-existing
personality differences rather than missed fixes.
A shared helper would be heavier than the two open-coded branches,
so I kept it per-personality.

Mykola
