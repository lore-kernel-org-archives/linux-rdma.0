Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C773CB8F1
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785955026; cv=none; b=k1Zx/ZHNwVVtltY7Qqco7TVRmpP3OCOEDWcpbcN1fIDpnAzQJNq1OkS26UgbmjHfzN1LkiBo4MZ6iR5hJ40pyt52ZSIX3cH5XESYn4p3woNLpvR3UfookWgbXP57fDK4iX9rLTIIArFDhMzYOVL5nWVURrIyCIqu6cB0ixWOtdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785955026; c=relaxed/simple;
	bh=Tf9syscAZW5PE8qDFT2Yh4y+Oi/xeH7ih1X/P3PhvsY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKRCLFE6XuUTTm+PiXg568zfTHwTFC643IvEANCAocWE5YDFKXtjxry2SpGIWdC+pj+9W3YGx5yKr4yXRdPfRPWNvMhEuICA/Ww3yYBZMOq/BSb4gjUP/Jsj0rGsZYPiDmMLZ5Pltfs8cKKdWvBrG05jvla1evjgjkEkXuzpfpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jhNQd57d; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jhNQd57d"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-9061a795d76so13475986d6.3
        for <linux-rdma@vger.kernel.org>; Wed, 05 Aug 2026 11:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1785955024; x=1786559824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tf9syscAZW5PE8qDFT2Yh4y+Oi/xeH7ih1X/P3PhvsY=;
        b=jhNQd57d/5RFTMm/Uy5rP7pgx/NBI9hYroqjEZoK19E6AEzW57ciTbO5EiR78dzu4+
         lz8r/LlG+IIoVcIPiFPRu9jRl8lK31e7EAMs4nqrvkdFxP/26x3ST8kEldHGuYzAzLpN
         ZHuQgq633y3Y/NICC5s3XWYQwQEfuwGE44+76X9OXwU1Eljwg3wi1/nwV1rAmovQNjtz
         Pyj/CxyD5gUAgactg9sXYlMDe3G6+zo9YjDxUr2sCMHTObxDpNQkGx7+5R3WDuwWlRAc
         4ter0qS6r+znnJuy0ethP9gUPinBfq5fBYxddMvFwuSosm0jSbPOuYR2vkDOevPaqz5j
         0YJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785955024; x=1786559824;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tf9syscAZW5PE8qDFT2Yh4y+Oi/xeH7ih1X/P3PhvsY=;
        b=opw4sg7QYv9kjfNDVEYYVeoH+/61irajdO5m/2cF8rZyq+yf9007TZojU94UN/73qY
         50UoFh7N42QPYJDcLgFVQ5/60zADCHVwc2rLyEDXiJPXsaTSTIuj7EdswMDvm7Jidypt
         zmah/aEFp+6z/wTPc1j2Eqqickd8fYjfYbtDXICZ97xFzOjDAcHBBEOFH1kZnsqwYnYI
         jcobOkNB7PcqkN3DT3a0JfYAyglSiS1gEefY4S6JkiAvyY3la1SmzBW4fh8LjGy5WZ7r
         bfS1UgMKwAi1IYWDPqCHDORKCm5lklZ64T67gOx5GwExYnwKyv/HU0HB4xkOytjygLkl
         CGdw==
X-Forwarded-Encrypted: i=1; AHgh+RpC+MAN2KBL6+TloYrvx+OyI4Ko+vhKMH0Zrm7vpYrHSUBh0kKEaQLC2mgqIcOGUne9KEGFKLuKczxZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzLjzEV9futKB7/Ewkt4DO728ZJM+jeQcgjVNX0afNE4cvdZGd/
	ooahkr8im4Onl+FPAjFoHO+USCUXYHbWGJwq0X/eN0sfyswYim96+TIm9S2KOGjxUcY=
X-Gm-Gg: AR+sD113R9UJJgdq/rQQNytJero86WBeDaPkowtDn+e9GF2DvezlEx5nirUaqfpbcTd
	3JsYBVK9Eop9XHld9xuS63gph+9AnUB3jcdGmyDDRuNqU0bUZgFQajxj/HhNPhFXbncpELLy1FM
	xX4e+CwmfAFqU0oJ/srxK6HKQtcwnhBiJn5q5l/beWJ062wZqkEdGz/zEi/epZWt2FqW96HvQJa
	e8U8Kik311rYSd9K2Vq7zY3Uq9BzOGiE7LoTc39H9xvJLe7hygM6NSUScIfWjsDFJ3naND7VxEp
	dzr3hOMMZXyO5rlYzX010/2XA9zm4l4IAjmtXusg5//OP7UnCBFtbDEi8fQMhbLO4rTnl7ZpRu+
	fIh+LCNQF8deiKg6pw3rkmEZ6xZkJ1a2QieWQeXK3gsT9cwXQiN2HWMwqfBd9jDX1VW/y5kurJ0
	xW+OUOLJAdOqghCmf3I/b+cRqAwtPH+51El6suHA==
X-Received: by 2002:a05:6214:f08:b0:8f0:a849:f392 with SMTP id 6a1803df08f44-90881203d0cmr103220766d6.14.1785955024046;
        Wed, 05 Aug 2026 11:37:04 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d807sm31895686d6.2.2026.08.05.11.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 11:37:03 -0700 (PDT)
From: jgg@ziepe.ca
X-Google-Original-From: Jason Gunthorpe <jgg@nvidia.com>, David Matlack <dmatlack@google.com>
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wrgUA-00000000Iyd-2zvD;
	Wed, 05 Aug 2026 15:37:02 -0300
Date: Wed, 5 Aug 2026 15:37:02 -0300
To: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH v3 00/11] mlx5 support for VFIO self test
Message-ID: <20260805183702.GA72896@nvidia.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On Thu, Jul 16, 2026 at 02:03:16PM -0300, Jason Gunthorpe wrote:
> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.

David I was going to respin this to fix the minor nits, do you have
any more feedback or are we good to merge it ?

Thanks,
Jason
