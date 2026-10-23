Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792771157;
	b=Qoksp/9L/T8AN+88og724UOejTnZvvKMz1bovmeqmlh+jwn5S3/6GHy9TBklayUu2qau
	 UvoLAGAkDrGmD5d1m9rM0FqSDkdJn922Fe1hb1UR3i3SuS+WGBayv45qg0C5Xb86Dw65s
	 /zkpAPlBNxgqp1xDaKYfHdW7RLj1FiXK6uQFl+YpfrS7v4ad9EFmVlRc6Tw0wFT5+K6mc
	 nAIkIHe3KhgRGe9BlXno5dXciW95h4PcsLR27fL/DSgc7d2D1Dj7kS0RMgYczZ03OXtxf
	 7orMaQ6mDpXbS1Dk3Aa5ICG3QX6biAwTAnMIH08FmUz88xxZEAsP+0dn0m3h8fjkelA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792771157;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=qfip9nPMyQ6NKHGpF7rQvQFL04olz8IZl5yoz+w1jok=;
	b=H7S+CFTdE8zd7TQTTf8Y/Mq7py2g1FWEQFPnYv6pm8Hjv7mfGYGMX+YbNmBTj7WApWVG
	 5ueIwYu0fy/Lf3utdqZgNRYQNDbEb93nuJXLKxMeI/vPYSuiW9hfcWrEGwGYLLc50d3VC
	 sdkKxHLNbTGKoxK0P3FV1ttqpRmFxu/d6q8cke4UfhzsLRdKGc2tpiMRItK1R9slyQbyM
	 NXESNxU4puKzxYqI1jmJUqoM8+TeRjLaOJfFR/xfxuNv/YperSWghhS6D6Q4pqxabT7Xv
	 DKtReba2830vxnSad3lli9zllxFrrKRX5jtOji1dErA/IPTZrwGFXVVV9xzGvdRE1vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=pOV9sna9;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724E9606A321
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 15:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 724E9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=pOV9sna9
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5365d26ccbdso11362631cf.0
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 08:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792771155; x=1793375955; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qfip9nPMyQ6NKHGpF7rQvQFL04olz8IZl5yoz+w1jok=;
        b=pOV9sna9TZaCqywtdDI8h+mSGdu3kY7TvcG6DQSaz/wzZ4RWxvzzkBqqhU+wauIVz0
         y7gqDg4Pv98+G/EoG0dUf5Bpk4Cl0e0UZ7LUISdotu9Tsw4EOlJNa9g21e1C+Zf9KMZH
         gYHQI9+v1MeGOmU6kjTdceiCLbZqOiGD/vZZ2gPbf7Lfpg+R46vh7tpjBVmQ5GGunmYC
         VtuXQ6ZEps4zStuYQLp7cEl/vePQpZ5aYQvoiujxoHTHp/fCRUKvmNk27XK19PLiHYCI
         JYluupC4j0EMlwXjgXHC4TBCzVFNeQ1eRj7qeCWp0ln6/w6oJwD1gZkKqq5ddT+khVyu
         ejmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792771155; x=1793375955;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qfip9nPMyQ6NKHGpF7rQvQFL04olz8IZl5yoz+w1jok=;
        b=BmEw3FcSK8N8sJaDXABXTvAS4wW5Py1mG6v0dbdzaTYnspRhOAwaBBEbor2mKpiHrB
         7a+fqkne3m1QTsz/ER2DKQnFJHNRD8YyHLqiDCQzMmAgDRXW2GVjydMQL6obSoB1HDCi
         7gTD8k0mazM7jKTsEetR90/5gvV2Gfi25cgUjhHQ4Zd8qRTNX0LRPIFtGWgeaVRfUJLT
         tSgUxF1zt4yQKQznr1y8MWatZDoXE+8gFCc+2v4B9LsWGAECiR9EueaCl0ciJuQhJNXB
         62Yx+uTAvEtZwSk5C/iz6b6XWLf4zP9Le6dMCGKnElbYnGoFkeGXoK85x63tOSDhVo4S
         tdXw==
X-Forwarded-Encrypted: i=1; AKwUvBzz8hztqdiEVRPD+IkphDGnIUlJ5qVNzhhv18dSgLXnZ+SS7+usKDkgjIRZ9zMkbI6etcWosFOVoAAQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLwj+p7y/zVclQbq+QMi4kqqVsP8SalG+o6YCQ0taNTFxOXCNwa
	RXr0FqgwMLv3mxYrXqFhTcpZ2UStSxWWIst9mNeL2a3XjXZWbZyVlzGAv4/G/HaCoDU=
X-Gm-Gg: AYBFou0+ayNtBR8FO6SysDCfnNn5r1Q6zAPIWpeaoabIL82G0bRje7FZmGa4cUVRv0u
	I2HLSQBe5TXj/YmfSmRfovx6cKJxcvu8TdHYsmXOAotKYcoTHqwBcHjIc2fJTE15c5Gxws41u+k
	T9DQFXU2nZhSEMDXn4XdTDLOotHCqI6D0p9Ia0sBvlkife+QRvFaLK+sbwizplaBUNWo8YZgQ9Q
	lcQV89XDii2b4aonF8FZ0jD+/Q5W5khpvh7sYdSY53i3lcmbjuDofpOICJ6yYfKkVBRiftOCRJ7
	yFOMG0yuOmS+ievxyp1kkzP0QcmyZbi140gRn8AtLUkgDwma4ugluMG1Qr0ybl4FmPp2NnEaVfA
	nQY5UMj/VXZ3oT2u2app3LnJS38tx1iVQUgnhVE2KNARTPmHeLBBPyFn6rfWJF0cug1bAT+dEaG
	iOEvR5olwh7Z8Fs2SniZRv6CikAoWHP2hpEBt4l6NJMyAP75DMPSZQ3zKPR5RQSlaxhQMXrraMf
	TS2V/rvjh56cwHydkpBclJDsqVUijPBljD2DsgCN3P15tzC4t4vHGCpKxMoKf3Gkm/0PpoWwOmu
	oujn08guoDLt+RZlNTNSYG0SejJ7Jz0VYISA4Q==
X-Received: by 2002:a05:622a:a0e:b0:535:859c:b6ff with SMTP id d75a77b69052e-536c24e2452mr39136051cf.20.1792771155235;
        Fri, 23 Oct 2026 08:59:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53836c78f67sm656181cf.27.2026.10.23.08.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 08:59:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKHfm-0000000Go19-0EMi;
	Fri, 23 Oct 2026 12:59:14 -0300
Date: Fri, 23 Oct 2026 12:59:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <20261023155914.GK3977851@ziepe.ca>
References: <20261007063227.GC7822@unreal>
 <20261007204045.GA783967@bhelgaas>
 <20261009174301.GC11438@unreal>
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
In-Reply-To: <20261009174301.GC11438@unreal>

On Fri, Oct 09, 2026 at 08:43:01PM +0300, Leon Romanovsky wrote:
> On Wed, Oct 07, 2026 at 03:40:45PM -0500, Bjorn Helgaas wrote:
> > On Wed, Oct 07, 2026 at 09:32:27AM +0300, Leon Romanovsky wrote:
> > > On Tue, Oct 06, 2026 at 03:49:47PM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Oct 01, 2026 at 02:55:10PM +0300, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> > > > > interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> > > > > direction can unnecessarily force P2PDMA through the host bridge.
> > > > 
> > > > Does "the reverse TLP direction" refer to Completions?
> > > 
> > > In general, the P2P code treats TLPs flowing from device A to device B the
> > > same as TLPs flowing from device B to device A.
> > > 
> > > However, in the context of this commit message, yes: completions flow in the
> > > opposite direction from the device's perspective.
> > 
> > And I guess asymmetric fabrics must mean fabrics where Request
> > Redirect and Completion Redirect are not set the same way?
> 
> Yes, in some of our systems, deviceA to deviceB is going through
> different route than deviceB to deviceA.

It is a little more subtle, I think practical systems try very hard to
avoid that since many host bridges do not like seeing only half of an
exchange.

What we end up with is Relaxed Ordering and Strict Ordering take
different flows in the fabric.

> > But I asked about ordering because it sounds like this patch expects
> > to encounter asymmetric fabrics where Request Redirect and Completion
> > Redirect may not be set the same way, and the spec implies that
> > asymmetry may result in ordering violations.
> 
> My guess is that the hardware and system architects have ensured this
> doesn't happen. At least, I haven't received any complaints about this
> series during internal testing.

Yes, the ACS combination is selected to avoid ordering issues

Jason
