Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A0F223708
	for <linux-rdma@vger.kernel.org>; Thu, 29 Jan 2026 00:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769647242; cv=none; b=Fb9yNE2EIuxd2fFyFt3mHSJR+ONwQMFUJfpSLQ7xGHF9SQPbxzpRDbxFLK7PzyHljCTlA8lARez4SowAVwyY9p8igyoQT0OYvj66nSehXo7mjRQrnI/kgPdAWHebMEYV5mCFQq3l60f30ycR7iNlFkzRolGuyacFGi684UzZb8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769647242; c=relaxed/simple;
	bh=A1trNZeJCLML16muPMgSiDBa3zR4aUDIgjdgXxPENIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAUCW5KmCoOhSwUM2THvODIbzyVUxfD0TYJWKC/i8kUS4jKYYsB9yVLn44JXyYf4784xXqQSaMjLrZaueqCYMlofexgbSANC3wso3SbdHKUpAv9fPUcGgCdsSdt/yv+YHii8lUnO8+e7OO53WTW9OdDhqhW2r55s/KOMr5JgNA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=iR1/4DIK; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iR1/4DIK"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50331ac1fedso5184921cf.0
        for <linux-rdma@vger.kernel.org>; Wed, 28 Jan 2026 16:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769647240; x=1770252040; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A1trNZeJCLML16muPMgSiDBa3zR4aUDIgjdgXxPENIA=;
        b=iR1/4DIKRmMZk+T7JgmMPoTW9KiChFmmEX0Ir68yBE3jlyhWSYufhCApsxxi+Iy86u
         8EkETNknzzliHCjRg8A+JgONLdbsEideQfkvbTeS6kasd9MWczy8AePBrB3yJ1rFj3mr
         decbRV5e+69NhCYyPd6Q+IbG4D5FvLopeH3Fdijo5tjEmVrYJNhr76CZ1isNTgY4BmXh
         ct/A1B8RQlUszmgUhLxe2/C9MU3Eltcm2HudX8NqoPC/mZ04d9zu9H22hmarI0Vu40UF
         fLybiOKkjLYu4lNOAmYiTVFuRyRuMIAzGX+ZbU4rp3dSub1qO/bJS1OROZeqPtk3eNtk
         FQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769647240; x=1770252040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1trNZeJCLML16muPMgSiDBa3zR4aUDIgjdgXxPENIA=;
        b=sfXcQRK4MM4TNNXT3WbZhee0V5wL8IU15z9oohPW4Hh/qVS0jdXvvVUFaTmGHiSJ5+
         bBUeGJrT0HBz8cPrGsbDyFhrF2pVvq09jTaolIC3L9l7g5GdC0O/g3SPe8+HQ6lXlpuR
         quhq2835bXTHO36ayMeWOSunbGTsdpUYDDTZQvWhrM3RlLmKa5Gl6HDWxOWrBA1V2zH6
         8sCLc2DKGNXigiSLLvfTyh7K+rT1uLGBDrJOvB8DP/UygeMjg4zrvlTGVlREZwjsNoCn
         VbOGex1hjyGi638+HcrgqY5aj+hJ79DeaSC5u/TyHYZBa+9lsjKddwC+G16+90aslylI
         fxpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwDmPrN1aXjpdeRGj0Go9JIXdqp3zhsTT6uspHRW8ttUXP/VrJkhHCCG6wkWUcbRbT2LqDBV2Yx7uF@vger.kernel.org
X-Gm-Message-State: AOJu0YybIp6roH13Y6SjKoCs/beCo3XF+aByAs+lijsuDB59c4toz0s0
	sLACB9Xq2Zf5ShiluP26vMEdHKQCnTX8PS5I01ssJkfMpFut8Hfcnft9Bryx9ohGaf4=
X-Gm-Gg: AZuq6aIQugrpr0p1WR2TIrcaE9FzyebxrUEn/3i89HmC8i9RVYiWvhbpOS2bRMw3npm
	L8ZK5pr5WPcCwkdFbr7N6oYK+e45Pv7uW8mob0AtXjALJi1bWnwFUZ03DnTb3QFIgz2+aA4wSsk
	Zi/NvjVfDrqFTNEOd1EFk460k4XIuF3EHp0+2lD3RQcty5phlHs2+/wGH7ovcA3nvawsIGY7l34
	IToD+FAdrqXKvGdNzQODsmAWTPvSoUtmsapBvcqkmZgWo4lZvdnXxPRRXK/fMZRBps+d29Nxqi8
	QPrqGMR9j8zS1QCOaZ1ZkoEz21iPZrhkUEQhjPKdmMh2j8XXA3oexv0U6+qQzYtnI4v2zIiu7Dn
	UGKpzLV1Hm0E/H6SL44kSIXKZLyD9SExvCnxS/fFU7+D2Sl6paVLvAoMBZrKArxcYbwE9YiwZVP
	HZZXErb9VrPMmTNP7Wjz06w9Av1a2Uq1Dw+p+LuDpKTc4DwoWMBIEBorm7ALbaLj/4xhs=
X-Received: by 2002:ac8:7f4f:0:b0:4ee:4128:beb7 with SMTP id d75a77b69052e-5032fb1d67amr95194361cf.69.1769647240063;
        Wed, 28 Jan 2026 16:40:40 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5033ca9d5b9sm17040031cf.13.2026.01.28.16.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 16:40:39 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlG5O-00000009g7j-2tul;
	Wed, 28 Jan 2026 20:40:38 -0400
Date: Wed, 28 Jan 2026 20:40:38 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH rdma-rext 0/4] RDMA/bnxt_re: Add QP rate limit support
Message-ID: <20260129004038.GA1641016@ziepe.ca>
References: <20260116091808.2028633-1-kalesh-anakkur.purayil@broadcom.com>
 <CAH-L+nNFR8broz0i6ddQPrGL38AO1ZVaSRdXe9AcEafT3Sqeaw@mail.gmail.com>
 <20260126201857.GP13967@unreal>
 <CA+sbYW3dLsVqXcaG9xYdh-YRpdf6-ZjrMKRCBnapMY+gFzoA2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sbYW3dLsVqXcaG9xYdh-YRpdf6-ZjrMKRCBnapMY+gFzoA2w@mail.gmail.com>

On Wed, Jan 28, 2026 at 12:33:57PM +0530, Selvin Xavier wrote:

> We have another question. Existing implementation of IB_QP_RATE_LIMIT
> is applicable only for raw ethernet QP. With this change, we will
> start supporting for RC QPs also. So mlx driver can also get this
> request for RC QPs, but it will silently ignored as the QP type is not
> Raw ethernet QP. Should we fail the request instead?

Yes it should fail, I think that is an existing mlx5 bug

Jason
