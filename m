Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB81A15B135
	for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782822714; cv=none; b=LLhFbjbK5ieUiOo76oduMh7xOpTgI8GRzvLw1EIBdO+o8FqZl3ZgXmEpI8QQ+my4XuaoLWOwbGEZcaHiA3KH9GNK/wthf7VNVEWoIbrlLlqos5bFouC6mebn/J3QFgoV2J2EkuEktyQl7mTL/SPsNt9UnpoX/nKpvTY9nEVzads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782822714; c=relaxed/simple;
	bh=K6zzVV0af8xAaoAtSqcQxD8uDRZmwf0GT2DpjrnXsAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DoDI+dbU9WwaYJ2PcXISvfvWESm7bQad8xthRm0iBaTlQHFNokfeA1UQgilAaVKQyN7ExViV6cdAOWFSbybx2iDN2e2wytK/Pxi3nfBQoyRBJGrSzkO2oprZ8fK2rS2hywwqSjbjVGFdvTjfp9uuJrCYGY5wDukOCRN2iWAKRQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=f5fSd7Tl; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="f5fSd7Tl"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ee6912d86dso22070946d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 05:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782822712; x=1783427512; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6zzVV0af8xAaoAtSqcQxD8uDRZmwf0GT2DpjrnXsAg=;
        b=f5fSd7TlbMNE8bbKuAbrv+VmvqOJfVyi0ivLv5jLhIFVA9QNYLhziCyexGcP3JAgSw
         uTPz6ByVtb8X1bj/ujD2XgsVit/zJWocV883Ep7Mr3/0eojX5dzHITd0pGPa1aqBX4YZ
         yOiSVGhmFeGT2siQhcEjHSHQE1pbaM7wTnvoI/R4LNeuSXPvimF7KvwTSzzSkxtskW98
         0I8j58N+I5f93ZCVcjkslK1pkYlyUzZW44fNgtsH0jIrMPAklvxr7P48DcdxUPAu7cKh
         BRGarnX2QG4fUTvevxyffU1tBspBPs+oPLsYgg+iszuZUVE3H/EmOxRpUevbKmJjfEEh
         bJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782822712; x=1783427512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6zzVV0af8xAaoAtSqcQxD8uDRZmwf0GT2DpjrnXsAg=;
        b=MZ9hZvRqqNHyuPPK19i3y5Cq0hLtEcrjkpPhviS0yLETrp8OvOinMwSqYAoviP+j/W
         TexBWacJZaO0XlXNLm7a0lTuGAjmS/78855CAgwMvPS0uC7Wio0wOrBmiilJpZf6NiKa
         OVV3PBZIOWijBu5cJ3MMFe/n1bglxTH67jyu9JoQ9Zvseoz+xcTw3oyZXTVgQWQV9if5
         lBF7qPwxOfZjntFX8ksUG/Lps0zeL+557v+gGwVVsrxaq6y5EkE6u8ATBxmo27lP00Ui
         pQLiH6zR3lghK6JooOOBPz8xeG9SjokRK6kATBgbu3x73bE5fxEGyNC+4i1T8sVquyrb
         Czww==
X-Forwarded-Encrypted: i=1; AHgh+RrThTjBlKlBK+yd2N0rwT4TKf1LhYUmwfEFytkSm6n/uEy8Oa+WEvKmjv2jSN4PLzRXMgUUE1++5UIX@vger.kernel.org
X-Gm-Message-State: AOJu0YwEkXxRzqQXummNOP22SAVKOBuktGDdA39TD0dK0MqWh9NyVHqk
	eoKl2GiacUBmtGKWJioKgzJG2/+/E20/so4uBwNsd72aS2UtB2+u/eZTGV3Xa7nguaE=
X-Gm-Gg: AfdE7cnqVB7MEdjHivSA76ZqQFEePXc4KrjsSthwuZa3wJ6iZZI2Gul4BdQacxtnUeE
	A10m6pbwnnVeVMQl2LMu60VFr11tHStwHiANDe4zDh+7lN/pHTAbFUjdfHynk6TtcqKoNOaOj/8
	+LcP6LAFRSUq1qs0EKLAr4E0fHo9+gsOwlczXloNbleiZcEimAeRgcpiKOy7TtNOwxOKb5j5kHu
	Q1zcISxenErKQsSY31fxSr244VhAY2DW9EaOokZ+c8xGNdF9J7RRsayIwqYOERK6uge2RVcbfP+
	8sK35pQae4AnVJpyjjg4dPY65BBwxt7Ug6KNmINnS5iprx9ma4fIN8UDfU1zRUAPT6ZhlJRNYFz
	TAYxSyNPtw5nCMMN1LQOLu+QfzkfK8allAyGmnSWaNCs/w5A53eafblEvkXXQajrzUU794Aa8N0
	/7YJtKcz54LLVxqLq/ge5K6BqHjOtfLaMemVRfY0ENIBYv0yl+2TCtKIPuQmI4zxcoanE=
X-Received: by 2002:a05:6214:31a0:b0:8f0:275e:8b3a with SMTP id 6a1803df08f44-8f1be38d9f0mr47693926d6.48.1782822711717;
        Tue, 30 Jun 2026 05:31:51 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a328fed8sm22758066d6.16.2026.06.30.05.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 05:31:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1weXd0-00000001ppa-1Uxh;
	Tue, 30 Jun 2026 09:31:50 -0300
Date: Tue, 30 Jun 2026 09:31:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <20260630123150.GB7525@ziepe.ca>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>

On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> ib_umem_get() allocates an array of pointers to struct page for
> pin_user_pages_fast() calls during memory registration.

A whole bunch of these use cases in rdma are really "give me some
temporary memory, I want it fast and as large as possible. In a
syscall context I will free it before returning back to userspace"

eg we'd be really happy to get any kind of high order page here.

So, how would you feel about a new API?

 void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);

I know of a few other cases like this in the kernel at least.

The implementation could try to find an available high order page and
immediately return it, otherwise do a small reclaim allocation?

Jason
