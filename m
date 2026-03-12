Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5AE1A9FA0
	for <linux-rdma@vger.kernel.org>; Thu, 12 Mar 2026 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773318142; cv=none; b=R1Le7mmjAk7CGz1xAMfaR1KZuRGHrWdm5fjwAlw3r7Haavfa+eTSAwUhRSZr3xj9+UEJqQlLHffhpPq2aIDpwEhQFXhfuiQJtuvtUKl5Ik1Z6OkWFtWhKCRUm4P9Mz/RsA6QwgvToEdDK4WRP04Cy7sV0OPFXFQOcHAxVGTHkd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773318142; c=relaxed/simple;
	bh=CIqUqdezJUt7fx005uAPCwnbutghZRMPmBs/ZUdJIEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLGuBU7DF/C3bkI9fch/nkVGwpjT+LStKxvYLRRQDxWYWElwa1RyHUd/cF7EXqYkSQJSllrH/If4JkHJhMvttYDgBqz4gJ1w6zXhZWpOTlqEIpH4Y9q2rVIoxtDUmLe4SvM3/K8LkNn5TBQjjDLbAJbTMxFNSjHFBgKz6QwjZwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=MwlYBpil; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MwlYBpil"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a9f445cbso12827666d6.0
        for <linux-rdma@vger.kernel.org>; Thu, 12 Mar 2026 05:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773318140; x=1773922940; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TimmS2+Pbosg7L15RHI5hJFu+i/J4kMKaqKEQ2F4CiA=;
        b=MwlYBpilCBpxEAvq6qqNanb0ptmdzz/WPEGMB0vpfqBd97XzKUsrUnv6AYlPg547Eo
         6wLkvsZx+gLApph423a9TXB/+qJj4L8RbgHwBsQ7ki3ySBoKisz+BfrSxlmyAhFxy1y7
         MkoD3Zwq6jRtuC2LgwELoHu20730d8eIGQPPZBGtpJ11c9qVOkOPeNFUQSbo7Vwjp8uF
         yCxSaiPoQH0VpSLcKwuYk4X3wC3c2l3S83qe1WRTb08h0Fcs4pkaV89NmNFgp5AeuIx2
         YWXNeeCZbTNZgccWYyu+7hsdZ+UuxucjYfmgOLItAUYNww4ITvwix94L4gHlXgX7eYMj
         bIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773318140; x=1773922940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TimmS2+Pbosg7L15RHI5hJFu+i/J4kMKaqKEQ2F4CiA=;
        b=jlNtbzVZoyUDhx8Kox4NSlunQOGyHmg6lmf30b0CCMx8npwKiCCPtkrQPpK3CJB/hd
         idOigAap2Zigk9pajKC7AtX3sTHL1Yyv+8+Hp++APTADVs3qg/at8Xi8L9HvlXwl0j7D
         XxoRFeT82eJtCkrVIgoxLEhAcKlM4rnuJmuytqFS5hUOBvqe9EPD7XowXyPcNg8rvOzw
         IQiyo6M/ZDNkzvxEdo8IQkPlpOfGx/enf7re/Him+RbHDP4JFJ6rjDfcycqSximEpg+T
         EmRgGBjv3bqgFyhwvKDHtNBRr90XHq8eGImCEs1pomKfR1AczoielrHPoD643+xK+cD7
         qf4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWEkn/IB/A1s/85KmdZ/uSFleUTQgq6mYKW5Wb+UvOIle4rInUH5GZFmqHcMx60/ocwaEZo0wsbRmO0@vger.kernel.org
X-Gm-Message-State: AOJu0Yze948dGi6droWRCKzuKuuQwa/IQ/CYLSZV96XWkaQRMO/pmTFo
	AIE2Xk2u1ZPUwFVeC91YcrL+s2hgbvbQxOZadOl40CAdVYHtLYfJ2IcLwlJ5jyB6Z9U=
X-Gm-Gg: ATEYQzzKXsB+dfSPGeBuxt36JzFi+CFH2ck4SWjIQujP9zTDaHE6hQ0zrrmXE9CRZ43
	1C+yN5tzekHqrrpiLTQ2JCU3Cx96K24NSCGp3xIyKHde3ATclE+swOFiWNtDXxAyZA9MuloCYtP
	s3m6JT1ykLbKGgAV2UjYY5vR5W5YTCm5/gHt9Kv5rOnrv8leEoxW6aaIbAiAgLM6NgMU1ZTzbPI
	qNKVC9IzIxa0vurz1LaAvilw0JsXydPL/rdfOoPUqgHwZs0ZBWWR3JIEcwV1fBw1ONXEL7k8h56
	ILj88Ls/7ydaHdK6QhGohOY1kTnO94/GMRWcQFPv/i8jKiw0cBNUJjZ7KhVPiSL4lVJJ91PxZfd
	YnHFiyo0ueqhHBSEP/Wyj7m5Ms5TIvBNiBl8bzJpKiqTEWltJ6U5hXgkM3pLRU60fSpyP5VQYww
	dbmIEq6p4hBDyPRu6EeoOUX+hXFsxER6QW401iRODg2wHJb7eNCvnJCkZm7HYkc/3KkVcVnicKS
	TWvZ3iu
X-Received: by 2002:ad4:5aeb:0:b0:89a:149:bef8 with SMTP id 6a1803df08f44-89a66ab8864mr83684736d6.47.1773318140521;
        Thu, 12 Mar 2026 05:22:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfd520sm33832386d6.36.2026.03.12.05.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:22:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0f3S-00000006euK-0fs1;
	Thu, 12 Mar 2026 09:22:18 -0300
Date: Thu, 12 Mar 2026 09:22:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 7/8] RDMA/umem: Tell DMA mapping that UMEM requires
 coherency
Message-ID: <20260312122218.GF1469476@ziepe.ca>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>

On Wed, Mar 11, 2026 at 09:08:50PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The RDMA subsystem exposes DMA regions through the verbs interface, which
> assumes a coherent system. Use the DMA_ATTR_REQUIRE_COHERENCE attribute to
> ensure coherency and avoid taking the SWIOTLB path.
> 
> In addition, a given region may be exported multiple times, which will trigger
> warnings about cacheline overlaps. These warnings are suppressed when using
> the new attribute.
 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/umem.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
