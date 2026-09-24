Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F25A282F1F
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790292662; cv=none; b=SLuu0PBD4fhnrThQKoem1/yKSltiDTaqbFiIXairlRWlLGp2lBmg5Oi+wXBWBFjH1W6L5zWPU4JJeB6Eaprp1c9Z1kJG8c0bfpYG5Ffv45AoCPvvlOwDzg2S/SafIMi3c/kTY2pAjGxGh/TipJVkX4pkcuvGpLw/aaDNVwXUtUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790292662; c=relaxed/simple;
	bh=dew4FFqJYn+znPMh3WMUshAIF8jLNx5KHzgyCUnY03w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsOVhuPHsqhwDGJ7Xn6WFz9+runzE4wUF8f1lfEMn7+wndWI9Bm3BM4r2XXGvLxjYd9lSxjtv83DTG3DxDUrymCGL3AhUWMhKUBR/BRz7rnYzicMgu7fmXp96+jath9Kb48aoj5Elqy7Wmz8S2K1cMRZYr+CDsnkm/LtpWSwBUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fvIfgPkR; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fvIfgPkR"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664c1479so171814eec.3
        for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 16:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790292660; x=1790897460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dew4FFqJYn+znPMh3WMUshAIF8jLNx5KHzgyCUnY03w=;
        b=fvIfgPkRO9TZz3LXFT+SEG5WJaB23RfGbZHN0IYFQeijvZXin6vGZ6uFEXLej9BcNm
         W8yYhyDPhbi94lGBUsvmzO4F6yFCn7qjyQDUnhBFk0O8mbzRgz7/kytEMyuD8oHovEZ3
         rf32UZ3mJ88EXbnUVdxKz3ax7lscVCr+URuyXyj8HbQMvOUpfwKxRRbwPit7w6CcjRvH
         5Ky9u+SYae3ydpD5RkvXZi9k4sbpkszPyny09uDFhA7qcUZC9dS53dtIWnYM1rFn1LSd
         FAZrBlwHQMa3yUtlzZlmPi/lHSmoCBHfuxwnGNO+/FGW2t6c/Tcd7kyZ++XP8PISTCzo
         s8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790292660; x=1790897460;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dew4FFqJYn+znPMh3WMUshAIF8jLNx5KHzgyCUnY03w=;
        b=q+jhKCtY3Rg+hbDcPdMVtEzUI6DoiE2PRNCEQvAEueNwYxuQuklHIgHF0PfY5eGqbW
         +DnQ0s+6yM5LubLxrarr82ZTEN0FzgJeLv9dVeIJyifRYWM4MaBG/VWmdG7b2L94kt1T
         t3U8QsNZ/t5dtLqTiSCRu1q5pQ2703B4k8LhPAyWwrEns/+diZsprCQIPaV0dCYDWndn
         C2DAWQG1vgZpqtZAGf83PYOlFLDXf9JMMmd+nP9Jgw9+RuXekNvT3K9KXp1Li7i3c5yu
         9aWKsMfAz7QfD8E6zqshpsAjfjR5ePK9/16CCbHCla2aH93Smzzx6EW7LVQzAkg1XdjP
         EIyg==
X-Forwarded-Encrypted: i=1; AKwUvBy3UH3m98I2I8+lp+YHdDLAGtImIPnwlw+KoNJ2IcoEv72O15Zy2DVGrTsb2dhWDUqT427ri0heh1Cu@vger.kernel.org
X-Gm-Message-State: AFuF++kOABF54oKCe9oqpeXeJkgdzIvMPjNll6xDy7smLkiHcztMoqGY
	zrx9pyU5i8Kr3dy0jH/k4jl9wohA986VG8yF2kAqAF4FveOrJBHHPeRTdS+TMIZFDuM=
X-Gm-Gg: AYBFou02W/7F/78AuNctBwfBBPa3zoR6MG4bdzbal1VihHC2qjLiwuBe9WuspWjCABq
	J9c027t6pLtCHr7Y2jjB2lqvZmr8QhRApiP4dZ8Dc3gmSmk/AvxGjg90QPFrdX+6xiobPCkAH5/
	phpFLzFQ4XQER/AR+nPwXkrTkpFQVcXb4KpN34YpCCOeZ7+/YpjzsnOIteANoCAVJEmhThtKwbY
	F1sY4Z1NvIKM7+9KHwqNvyXTHxloEdAK4sz9furhg29NnQFKnCG33iMhpxgXwhz7/62jVKU1/Qu
	p/GlRcSV/dZvQ4MiVSn4kppdcTpAFY5IPQiCbx+R5Xc3sEwFtLExZ2mRwki/jwc01LIB3TkxBN/
	nTFvXxQd7SdaayLegeRzuE9Lsqf9q94gr54PAV1Ijqt7A92eK9gxQ62Ltj8Xpo2ImQuqVLywneN
	7n5uax5Ulz6cQgFcXw6ARTRKhfZmwX/J/Z9YZHoz+LcCWd
X-Received: by 2002:a05:7301:2811:b0:33e:53e7:1103 with SMTP id 5a478bee46e88-3400439a971mr3000301eec.13.1790292660260;
        Thu, 24 Sep 2026 16:31:00 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144757f31sm2224790eec.14.2026.09.24.16.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 16:30:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9su2-00000000gds-1vZq;
	Thu, 24 Sep 2026 20:30:58 -0300
Date: Thu, 24 Sep 2026 20:30:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: fengchengwen <fengchengwen@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v13 5/5] RDMA/mlx5: get tph for p2p access when
 registering dma-buf mr
Message-ID: <20260924233058.GA163130@ziepe.ca>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <20260731211601.3033906-6-zhipingz@meta.com>
 <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com>
 <CAH3zFs24esHCGA=wPrkiH8oKQCv7SnOwcBbkMxrOEvOVtwstYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3zFs24esHCGA=wPrkiH8oKQCv7SnOwcBbkMxrOEvOVtwstYg@mail.gmail.com>

On Wed, Sep 23, 2026 at 11:24:56PM -0700, Zhiping Zhang wrote:
> I don't think this belongs in the importer. Every in-tree dma-buf
> caller of pci_p2pdma_distance() is the exporter, in its .attach,
> clearing attach->peer2peer -- amdgpu_dma_buf.c, xe_dma_buf.c,
> habanalabs memory.c. There is no importer-side caller.

Right, and they shouldn't be doing that, but it still has to be
checked that the st is going directly to the peer device not the host
bridge. Not using the distance, but by the PCI_P2PDMA_MAP_BUS_ADDR
indication.

I fear you will need some of Leon's series to make that happen.

So probably the proposed change to dmabuf ops is far too simple.

Jason
