Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B393F5BF5
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 21:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483377; cv=none; b=BMP91+Zb96NvsCeCM4h1IHCenNs6OYM3K8iyNnXpteNS4ugh2j0nxShjzXN++gQeGXdMWxDC1m2DfF1e4uTZ2Lju0ohfstp54CeSXCc/7IVJ8a299dHZSq6va0Noxjj509P4t7bYAQHufRyOyH4E3utwAEfWkWO8hiwjT3eplDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483377; c=relaxed/simple;
	bh=XN/rifqNvJQDtxhcJX1CkOjTxm/idHUoaQKoCIcr3J0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMEhdf7EhfOxiRpyY3YpeYXKsXDxDXxAV965HI7ivlx9CAw2Sy12xEFQ9bV+sdkitxyz1iQOdMDbE3Txa6ggA8B571XjB12g3nhnxG3IwehW8kQDacDi0yfVrGtyCJwGMoy9Yeq5DcqcmnANDVblI6qYTaIMtgmLIJTuutEwgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHLshkuD; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHLshkuD"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8484f229529so292707b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 14:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786483376; x=1787088176; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=duzXNp2G2UESyfsX/Nv+I5To/x8QlNagRZc9TfujvZ8=;
        b=iHLshkuD8hBFuauu4Di391vGvcjQPTjaGzzEbn5A5oegjFPuo2toVazuiHN6PYmxAb
         /HpeaZ7L7FPd2yTnQjuluPzw2qiaz26lrtn3pQu1kZ4cVTxgo5BKjGilTiLxUTwV4eT6
         em6hDsWoiS+ZCtPV54S7Wg1VaWBad7TAFpQWvmLxaNR9V1eBftl8BqCFF6hraUieoE84
         BM/SD5uATWeSfQY/znDz3wI7Go4cW22PGFkMHMFP3eDnMDiuxegNYylALhxUhHMkIcHZ
         Bf7aMENNcRKgAG7GIoc3J9AIIgV16iuBudza6Y2fGq5QIb8b0/ewFob6ACmvz/5WZYnS
         QJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483376; x=1787088176;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=duzXNp2G2UESyfsX/Nv+I5To/x8QlNagRZc9TfujvZ8=;
        b=dtD8I0ystP33CE6g0FjaK1/YLZH334kQ6jOS1vVTjcUUJYYrIUQzWz9ceZEQAWIq08
         UXsbXwT7u060drupLk79Ku0OSpib5RsFs8AEcWf9KJupG/qqe6/KwArVFzo9MY2co940
         u9Z+8p2xsPHpQYf2xplxoz8BiRYQ1Mt+KvHl5IVi/AxprMR+40+ToLolm9cV4UZGAQ8u
         bIbNGBub+LLQC7nal4oT2DklvMyQzMzZ/A/Q5MPxIm1qGO9y+dQUZG6ee2UxVjnj7YCa
         0vhMQ+T2AdU1OIJYhP8ZaeqL3fuLrwrOhX6ha9tOpUB0I8pWuLqtt612NzeMXcq8j5Lz
         UDPA==
X-Forwarded-Encrypted: i=1; AHgh+RoCknLt0mQNu51hkOBQzsO00+g3lHpGidzwt+2KRIi+4evS9ypEdYKPsYA5TFKD4CitED1NtokmrOHg@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1j+X7jlQUtYwkNSHZfnUe27ksghwpWLW0ofHhkxSZDnveWMyQ
	uce3MkpLjD100pCvQbistwSD1/YxNv8il4ZRVhAv88qRfzvKRYmLjRDP5gQwydVKCQ==
X-Gm-Gg: AR+sD13GoU5OSeyQLEMGDOs8vermzyKo2RH7Hl5iAxoRGptd4Z+lkbhkKibgjc7wkPT
	z7hFnyn8NpJUqb4SXQkSdN1SSvPlj92v8Rq9fio1g4REPKm608KbnZULtugkThZXMJ3bXAjaa/M
	aEokOdJfpBmoGaH1iLP4XJ2ggWG0UdteejFX83aYjzT0lDIPyMuTKle07haALV7FxBDNawMeaCn
	LBEoR3qwmKM4vApjP6EzhN3XYIbrrBIW+8H9sPRhijrzZ2Oactt45w8XeWwd37hQN/GGj4gxp3F
	0/iz1WIwPT7qcId45d2Aukl9eRBgdq5tPDjiqimodiNMwjBnKnDgrzfKOEQjWxIRg8MaGacceyF
	+j2OJ9CrYAgoeXuf2eh3u1T6En8J5QosSNnO6679KlMWlj+Ze3f8waBdIm78yGtLrTS/lFAgqrP
	G2fb6FX15XQSrupqCoZLR81CdUn95IPUoLY7rVd/mVoWEz3NXCDzIXKQSnu8VjQh29bTqI9TtNn
	G/FUXuWFdMMI7P81pKyMiQzapnOqg==
X-Received: by 2002:a05:6a20:a105:b0:3c3:a168:edc3 with SMTP id adf61e73a8af0-3cc2bcbf252mr7676629637.38.1786483374995;
        Tue, 11 Aug 2026 14:22:54 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed8bdaeb5sm1461553a12.11.2026.08.11.14.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:22:53 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:22:50 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 11/11] vfio: selftests: mlx5 driver - add send_msi
 support
Message-ID: <anuSqnU7WPy-9enn@google.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <11-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
> Wire an MSI-X vector to a dedicated EQ so the mlx5 driver supports
> send_msi().
> 
> Each EQ can be linked to an MSI-X vector, and the CQ can be set up
> to deliver an event to the EQ. Thus, when everything is armed, an
> RDMA WRITE posted to the QP generates a CQE, which generates an
> EQE, which generates an MSI-X.
> 
> To keep things simple this just re-uses all the existing QPs and
> CQs, so they generate single MSIs during memcpy.
> 
> send_msi() drains any accumulated MSI EQ events from prior memcpy
> completions, posts a small signaled RDMA Write, then polls the CQ to
> consume the resulting CQE (avoiding stale completions on subsequent
> test cycles).
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: David Matlack <dmatlack@google.com>
