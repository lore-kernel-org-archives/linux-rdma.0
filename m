Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B08468C30
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790697504; cv=none; b=MghL+3MNWSBSscPUZl3MAYGaGTOX8qEYMnh7A45BBTm4UJNADfcSFL/Z8IhqK4DZfiBof5vnYx2qp+mLytx9XUFO8J0gNUfBIwjHQJ9tIOheg3Q2Yl2iGIiZGhvxf9KQ2v97cipvh/PzY9zPMttk2ox8oJgh4zYgK7bTPOd28So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790697504; c=relaxed/simple;
	bh=nR4yrTOIgVgspvjCPgKKmvkm5cZCrViKQN79fpTorck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQGnW1gJloY1pbEPWzCYCd0FU/AXn30hWIkU7mJXnNjDOnIfcA0B8cBMBKsmnsA0dS0wiaxjk/V4uiX4gdR/XetFrnigL6rVsvZc8wrwhbTt1JyxcmMuE1VznSPzjDwtDB4l+Gc5ApwR/WIWGUEHYlszufXuCYfHfbBLFHXB6so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TGjFZgg5; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TGjFZgg5"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e721b5503so41089275e9.0
        for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 08:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790697499; x=1791302299; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gf4CL38l7K7zHB2Jr75kV3VIF1+DE+Av3C/FhqhlLqk=;
        b=TGjFZgg5lUHeZxukRtGDBpWWXiPuev8gp7o7FIX6qFXoKC2EajqRD+/ExUDCSfZjoC
         i4OrZjFiZGSOtA6mpUM4f/v/zeZAXWCL3g41cedVNWBPRLuxv+9Dd+SWUiKp5re4pZfU
         jJ7hvCUY3S01HlnQisdD/KK+9JhEQayTnTWsXyOQs91JsZXPSkOOZZ2+4l+vktxu61vb
         8w/OE2ayTWQXiV2FZWNafA6HdPrYCAqgm4k0PQXdk1/Vwauf44GR+0YcnVQSOaFVxjpB
         d+/mHzpjlC5QOs1jyDU2SN5c6YrW8WpQYyg2fsMt9DDG51eS4rnjRbgfKV2Dql7KmKt4
         ocqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790697499; x=1791302299;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gf4CL38l7K7zHB2Jr75kV3VIF1+DE+Av3C/FhqhlLqk=;
        b=MHITDLZ+pRJPXP8fPFxscKJpyFQ72yCkAzwaj05suJ2TxCfnpjM1njbDvCvP2SY1bB
         uLrhfdaqdLosUMwKr4QTWFHJIXjaqSJgtfyuIcOg/ODf0KHepuk5kgsuI7Pp7DBWfn3k
         qe1enPMzmT4v0N2AJnlWELolQLKg3pJWdOQ1nPXSeaO3FeCe6NXEWD6lwdh53f/6WKkm
         FOAh0K/5W27z0xmX9CbbpJxbuh41PSYoWfuEXXPNC/7OAsLLu5XnDcVUI1aJlDuimAlK
         TpO9oUTj7jDbH30WW8Mty8lI48zMK+f4ne4MPpRI55Z7D/gbvxWLRMBs0OJgRwnQA32H
         w2pw==
X-Forwarded-Encrypted: i=1; AKwUvBwV6rZYw8xNu8XLueIQ6ofgtwoLWz9DeQ2hh39DJRl70Or8lfI9J7ifKUNmHCXX9wf74oI6yQWTSA0U@vger.kernel.org
X-Gm-Message-State: AFuF++k0rLblX+m1MAEJwC1XzkPCJLZGV3CpP2GpV91ig/t3U6nL8AaF
	0rpulDK73x3zBzNHS1r6cIrvYO8f2cXMZhwomNepC6P5T3n94NX4phS3WtBsdW0R6z4=
X-Gm-Gg: AYBFou0/6HgM6nSjRHSMmlCoa0/f/OBm8bT3Fw2CRp6Bdmyebr4CWE3OKLGmw8SNACS
	5IzSasnw/u5SNAO54xXtGjdCqe1DWed6qzCQo1R6xXH0pea2t9sMhVU73emQXjRPYafW4FoY2LC
	arAcWON/uyut/1E26eN9vXZqaV0d6r0JznR0kKdiXcqkqxOJOiWYf87U55OG+RvcW3MjDzFOhtB
	Fpkl1aoZ0A1qFxMtsxKlyyVWZVaHQazhB2UMnBAy9VEWqMAbamd2OV7RVMeMwA3v9XgolwFzfmJ
	lUgULWDL5qvOnXlh/3GpvWoaMsz72fiOjLrIUToF/XYfJ4hUpy31CISxSwsibIWnnLRJ1xF2WAh
	u56DzB7YZXkn/SH+6pzbV/foTm7HdYMCjbCGq86efQoeOIWrgT8C0FaD/ui5EPWGc3ZPHPGRGFq
	xULBZRJmfmU4uMrMXPGV70xPIWi0ypaZgsBgOL7M/rOrKox80NYIGIi7IQ1RewA70iafUHG++ip
	FBm
X-Received: by 2002:a05:600c:1d1c:b0:49c:eb16:9fd with SMTP id 5b1f17b1804b1-49fe66c9ae3mr284330975e9.3.1790697499193;
        Tue, 29 Sep 2026 08:58:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::5:5c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cf9dfdbsm127631095e9.1.2026.09.29.08.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 08:58:18 -0700 (PDT)
Date: Tue, 29 Sep 2026 11:58:16 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Message-ID: <arvf-dEnIzsXhzkL@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:15PM +0100, Lorenzo Stoakes (ARM) wrote:
> There's no reason to export the symbols for these functions which are only
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
> 
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

