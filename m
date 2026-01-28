Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F6137419D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Jan 2026 19:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769629268; cv=none; b=m0kiJ+MroGXKzyMvadJZs3bzr0xgf3yLqt2Z4SRbEE1hJqQxF1koBoALfWTExUJYxftu8CV9SO5ArOIGIGHnk7XFCgtMs83Qr6vFpJ3OoeAVL3glC3KQ4xBEORjg/1MEiz8aNikWHJN1vjqnu6mQoicDf+ScSs1RroO53hdAflQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769629268; c=relaxed/simple;
	bh=sB07+08BgMPzYlAD8MNqV1BaPYYisB58/FHC5ZnY0Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oetzCN5KmWpGxHKgLFMaAy9NEA9C4WvcmPogjNu9VjIfVXzeYic7P2KmgvCL+DZT+iW79egkJfxWRHZwPnsnl0S12/silhSo9bRqXuT/5ylAev17qQAl8HUW6I8HzbA1Mf74EkHDxB3GHGXdZV4S8J9dhcwvqtmoP43gOfKjtbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ch4hWkwW; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ch4hWkwW"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50145d27b4cso1738851cf.2
        for <linux-rdma@vger.kernel.org>; Wed, 28 Jan 2026 11:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769629265; x=1770234065; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sB07+08BgMPzYlAD8MNqV1BaPYYisB58/FHC5ZnY0Is=;
        b=Ch4hWkwWdSiaB0QrAogh0RxwPFA5BYVNOq9IWtyJu/Cx4txhMDiqd/1ul4d6IeuYNn
         eFK/aGvW5xozRLdN2K4xfB69fJIYSBsLg2WYO2SenNz2mQmtes+oqdStt9gZS9i3RxqJ
         KDwxdouXvlyFzBmm+MDjWKp8FQq/TVpEB725BA6FIgAnSdPMmg2GU9fmIzSIYD6dfdBn
         VtOAnd1inp331B3K71i7qXDWtW7Vf1bY0uJoXf7CTsm/L9YegbGypMQykCHqJEPZ2J5N
         tvIlCluab8hjKsvuRAbFJZhHvMtoAeJMtQZOmbmSaJFMqmV9VLGYbQtiHT7zGT2ipvAz
         Lmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769629265; x=1770234065;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sB07+08BgMPzYlAD8MNqV1BaPYYisB58/FHC5ZnY0Is=;
        b=eQrLqXzlU6FtUaq60XvCFeBd6/FjEbeZIozNAzXfw8RoYKS+XGguBiE7Q806tpyRSD
         uG7UGwdMU2lvZvoRpLV9o/bG51LsYJ06CSIhjZ18IhBED+fv7rKc7jiwzCcE67ZWaKyx
         Efti4t6g/fJj5Dp8YerI6T44B4xzHTobz8nqYKvsajzLWedzbj4qbiDtYx6q3TrtNGAq
         oMTxnRLAAXlS1/hsUEk8Ha2jxiWmDF/wdG9Ks5N9hS8A7iSDA2IgVaMNdfX4O5gR+JUk
         2MkAPnBM+xI8LvNbcqZqOooG/YgcgkMcRayMPd+YWORdyv92uORfaE6xDIGewhOf2iaE
         lmJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX381ICH1OLaPzyThAb7yBhVovnVU7Htg9w+Y57dZOprpgeOPkpi5NYiSqsEtoFZjid+DZ+AyHJsi4@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9LMRu4B1JmREAoO3p20T2LHvEng8PcSySuPhr+9a6sh9K2LRM
	cjP3VnDhPeMpt8tvEAozk+xAeZAV6oOfbB635BXjnMJOqCRBdwxBeJi6r1rVyZQoG8U=
X-Gm-Gg: AZuq6aKFcmux27hGB5PrTm7OXp/gvu4HE16XrRpV0Phulm/CBfWc43MVzK/uDy+n5Ty
	a3d4DjpvFjS9K0xIbInZBGopg85WTCXDyBGy1qLsVTpBpqjX1PJ5AhmaMjKJxpqokAYHhRf66YA
	IOSsLRM39cmoQiH51CVQqf59QmkUuHJ+BWhUehAhCT0OuRH024UjQvlIii0TKUOWivakA+Hc8rv
	YK7plvNW4NAO8pfBP+wZOavB9Am68FN4/JwwT0m5Ab8HvBk6TmHEobtxgjWbJOb0115HBIozlHw
	P2FimXnMlQgB7d2EqgXovx7CLIKizONl/vcajGgX/+b2aXzon26pJ8pa1FqlDVl41a7pC+9M8xl
	limuEB7KYFcj9ms82pAy8aM9mBJwWmsKGwT63XVomLrOG3y2rccbpZNQY7PfGqLL75DCJkkSfy0
	eSaaODwRaLEmFrqibRO8oIr69Tho5KeFGy1bOscUhkc07qBomrIgwPZ/241bsdy9K56DY=
X-Received: by 2002:a05:622a:1496:b0:502:a063:c439 with SMTP id d75a77b69052e-5032fa20c34mr84779801cf.80.1769629264891;
        Wed, 28 Jan 2026 11:41:04 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d376e6f7sm22896076d6.52.2026.01.28.11.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 11:41:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlBPT-00000009ayy-37Xn;
	Wed, 28 Jan 2026 15:41:03 -0400
Date: Wed, 28 Jan 2026 15:41:03 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v9 5/5] RDMA/bnxt_re: Direct Verbs: Support CQ
 and QP verbs
Message-ID: <20260128194103.GW1641016@ziepe.ca>
References: <20260127103109.32163-1-sriharsha.basavapatna@broadcom.com>
 <20260127103109.32163-6-sriharsha.basavapatna@broadcom.com>
 <20260128153248.GK1641016@ziepe.ca>
 <20260128155101.GN1641016@ziepe.ca>
 <CAHHeUGU6drR==eT5tdHADYdLeGuhHkPZB97JvAKqMiug5OQd=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHHeUGU6drR==eT5tdHADYdLeGuhHkPZB97JvAKqMiug5OQd=Q@mail.gmail.com>

On Wed, Jan 28, 2026 at 11:33:18PM +0530, Sriharsha Basavapatna wrote:

> VAR_WQE_MODE was initially planned to be controlled per-QP level, so
> we added the mask definition. But the current implementation uses
> per-device variable WQE mode and it uses the ucontext level flag
> BNXT_RE_UCNTX_CAP_VAR_WQE_ENABLED. So
> BNXT_RE_QP_REQ_MASK_VAR_WQE_SQ_SLOTS comp mask can be ignored until we
> support a per QP variable wqe setting.

You should have checked the comp_mask when it was added to the struct,
not checking it makes it useless going forward.

Jason
