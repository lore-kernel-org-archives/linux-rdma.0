Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792792912;
	b=Wr4EcnoZvh/PwE1XTZm1c9adHcTnlsq+OUOyA/6FoxSZTV7MojhK7QltRl0AaL8E5zlv
	 mvktboxU7YYsmeRhDfsAKVFdzUEFXSZL1gcDzuibRXrzv9RSxYShHKYVvKbg6Muff4Y9E
	 kX3diJ6sJkntBo31qiGkJTx5yfjdUdVxOYMqGbChoAT+OphbJMu952c9OOPmJ5Ag0kgby
	 W6fhyWEUONaMfGjw2mWF4bqZJgJZvwbjM8FdA5MMhCN8Gna2nbloIqwjvEcWi2QD0TGau
	 5IhHNZ08Ep8J3HTb7Zd/qFYFLy/hFidtnqXQ2YEUyhGzFWdDGaHqRRQwz624ZIfPrGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792792912;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=7bRloCtYRc/1CN8Q7Hs9aasGSanwrF1DkhN4CIO4rT0=;
	b=g4PuCgtbV76oMMEORJBanb0h7asPO6K0woBs3zSgUczWbnOSAi/84V04ANX0WRQxpUv2
	 EBV/yX0jVikmoIYmZetOiudE2u5bwmpQfiSYacHGfdpiqq503wpdU91VQVPIxWapzziYt
	 T9ghc19bSUJw9H+UVlTKu3S3Jg1G25ierqIlCDnxMoOXO7lkr4hLPm6AwjV4h2dW3XgXJ
	 O4zjZZ/whmf+98qh46voBqU0mq99cdPmaC9I7ssPLHKxxBH9baxDI1VJzNag55f6UgUJP
	 frM2L6fz0uxNTWZib3JBMUYKQjdl7DawOKN1VdVEveU6+TEMpCK7zfqAW84wxu+qzMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=H2Nk80SC;
	arc=none smtp.remote-ip=209.85.222.171
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ABA606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 22:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4ABA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=H2Nk80SC
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f1cf92c9eso150977685a.0
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 15:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792792911; x=1793397711; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7bRloCtYRc/1CN8Q7Hs9aasGSanwrF1DkhN4CIO4rT0=;
        b=H2Nk80SC0IE0suPURnYr9e6hZbC4LBCNbP2UbticIu/vM5Zx8lZxl1WF9oIVeOGweJ
         W19x63RIXk3jCkb/8AZ9w0/6q6ZaY29bsZqX8VJh3ACjKIAi6gixXOH39qqPhJV0UGZD
         h9hrX7AQMBlOV6X6RgQiCpuKPLs0LqoIe0SH9hdfWiIr6eNHUZFFbT0I/kCisS92xxMY
         Ucn1ZlEpvxoCWlvTmp2e0dWk4YFXYfROdABgbIgP0F4SF8jcDI2aMT5TzMY19oaj7RhQ
         ktu/3+o+78VzxnRBhNe+IMPeqMjRjTTMOSsOLuA26L6BAOJT0HaC4+T4MRB1PHDXmGMo
         Ignw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792911; x=1793397711;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7bRloCtYRc/1CN8Q7Hs9aasGSanwrF1DkhN4CIO4rT0=;
        b=gsOoGdDHA4yCqlagoXc/qMWNbcoq5EjeMlI4PfWsHjqwTK/Nfg4n7klOsyrjBy4YlX
         xJV0+hwgMhccdrqKhY3hKUk0WP5A2zkTZqfpDmVCvrtoq7fBOKuLV3gdR25nJK+q3fhK
         RVHZ/9I/h6pbYDkbqozD1YEbslAzRa9AfT+RH4g8QTzrR95Ozsycw4kVHzoXfQLg6vpb
         5Aw1F0L7jKGOrb73fv/ddUH87mKLeVYBdB88yhbyHjbXNIIHqQGFKQ6lUP1pICk+BTC6
         bPY/F5dVY3O9EYf5n7aefK5qVcNB8JLVr1eNxhItUobEN7z18xa2BL4nlXoFhp4z+wDf
         Wzsw==
X-Forwarded-Encrypted: i=1; AKwUvBxoYz2jEa7H5diV/xpJoccwdeifillVewG2ECfyCwA4/coImDBilIU2YWzOuDANoDGmtHBjCoSE7n0x@vger.kernel.org
X-Gm-Message-State: AFq9FYLIIUE12r/JVSmhJ4okzejt81outLbfY7GUi4ioLifU5ETQ3b0i
	5q+nhjDrz0W4mV2mCauqOnzECKPm7t4oAn1h+sD23VhajKvdr0fu6Y3FbUpol4F4/j0=
X-Gm-Gg: AYBFou33ADiIXcjLVbEaS6u5j7VEnyxnF1C920otNdcY6g162lEZfVbLoMc1V18eAom
	8+pwTY4g5lYosGb/f6MfvjPDeL8lA6TVVa+fgfYFjXEd6I+eERXL7tzBbboKb8yIYKaFTv0p5ic
	fO9nLRaLFbrhTJkCqocw2CTkWnvOTLcKzQ9rg/D0LT/1ySK8L8oDILW2747k+gE/QbKDcA5FkFF
	3LL0Iw5iVKNEIDBa8Xp2b5KKrT1CJZK9LFQ/n88TJuyNpEzKeA7UlVLGj1ITQDXtsUaZoCqgkwf
	7LbjHaMTJkrIz+phj4JJt+lxE9VUxRgXNEGXB8TUXD33eH1AeYng7PbcMZqslxu43tH6fcQPyLb
	s5uepJQxC5OfP/iVxjX8uxc/alS+HazyjYVywJeXzjIt3okQf7RiJb1ztlAap9MDdAHOhiFh0dY
	OgI0n5mL3lUhtYbpMYaN8Pnew+WNI7df3jFGRh9mt2Xe6ySSIoiJ0y79bdUyc7H81b2rl1NU6yU
	vnspaUE4ekIDa6/Y4n1fhUUlxjJmAFI4T2j/7XbswNNvGGaw7lxyS1isdjR6hEXECsBbgVT7Lza
	fMIkPImdfDc6LXi0EalD0NtoAUwiWX/Gk3WfHg==
X-Received: by 2002:a05:620a:4441:b0:93e:c12c:f137 with SMTP id af79cd13be357-940ef9c87e0mr54142985a.82.1792792910841;
        Fri, 23 Oct 2026 15:01:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f078a762sm18520585a.30.2026.10.23.15.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 15:01:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKNKe-0000000H7Vk-3jIV;
	Fri, 23 Oct 2026 19:01:48 -0300
Date: Fri, 23 Oct 2026 19:01:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v9 02/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
Message-ID: <20261023220148.GN3977851@ziepe.ca>
References: <20261023190036.GL3977851@ziepe.ca>
 <20261023201531.GA2805244@bhelgaas>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023201531.GA2805244@bhelgaas>

On Fri, Oct 23, 2026 at 03:15:31PM -0500, Bjorn Helgaas wrote:
> On Fri, Oct 23, 2026 at 04:00:36PM -0300, Jason Gunthorpe wrote:
> > On Fri, Oct 23, 2026 at 01:27:15PM -0500, Bjorn Helgaas wrote:
> > 
> > > > Yes, the ACS combination is selected to avoid ordering issues
> > > 
> > > Does a user have any way to know whether the configuration is safe?
> > 
> > No, unfortunately in PCIe so much is really difficult when it comes to
> > deployment :(
> > 
> > > I'm wondering whether users might use "pci=config_acs=" to configure
> > > ACS so things appear to work as they prefer but may not provide the
> > > ordering guarantees drivers depend on.
> > 
> > I imagine that could happen, but on most practical systems the root
> > complex will blow up if you do asymmetric routing so there is an early
> > indication.
> > 
> > I know this because I've help debug such configurations at
> > customers. Some servers helpfully MCE if you do this. Lovely.
> 
> I'm still confused about this because earlier in this thread, I
> thought Leon said you do asymmetric routing:
> 
>   Bjorn> And I guess asymmetric fabrics must mean fabrics where
>   Bjorn> Request Redirect and Completion Redirect are not set the same
>   Bjorn> way?
> 
>   Leon> Yes, in some of our systems, deviceA to deviceB is going
>   Leon> through different route than deviceB to deviceA.

Yeah, that's what I clarifed, it isn't quite accurate. The asymetric
routing is between Strict Order and Relaxed Order TLPs, not
request/response.

Jason
