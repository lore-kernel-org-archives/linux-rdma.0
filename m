Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704666;
	b=GSp+7SAP9JA0MC5ntKgQA3y43lYYCVVD96lZBeXpH9QDOQSqOJXFPBneJMtPKa+Pmj8p
	 yKfcf/jwgWeDOWJzw5Tvzm3vBAdsvWHs9lRIJ6c/sI5xDtsXC181pU1nKzq0Aq2E73wn+
	 LxSaSLp9esmN5g3VivQOgR9QWvxwLtvk3w/fNsGbFzIq1FeZYCSJr+L1vKMhFTIY8ayHi
	 9LjnixAeOMDyR84sBWw3uWdzOnDdrd2wXzWPVz+FKCETw/QEaV6dxVWErWECOYGVAWOwG
	 k82024dWmNgxAg1OLiV9LRPNvsf31hoTjY3bAoyT0uqMaDw1M/sd5VQeef1QAP2KGcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704666;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=14PADosa9LGZypBRqhyHl1GEnIAFICXyC3zXl4MGCeM=;
	b=pOSsJsFE+jhVEMMGAty2eYHApwtdoqJPc3HfSOYqfhWqfJF1yYN89K9eijd0YqvuXjvb
	 l5da/0JY9hmxMxVftjVnPUq+mGteYrnEd7foOP/iO8rRgx5nCQAPI4FjDPNOmacxeaTNg
	 Wn4wjWbjs8CC2EtYEwomZOGLAsRIRqCEosK0gW9iJ1026o5T4PI9eT50qxEP1DEAL7r6X
	 45656Blv7bd9m+3yoh1wynNYGA5RRqFlkz+SUUIyEFl1t3+Q4CL0qlcdo2hyG892sKrb0
	 BrnYuXbmKaehH0f2m6oTjPs5KrsnAX4XMrIujVrS5NZDefjHObMZUy53L/io1nUDvEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NAtWGEMP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6643F606EEAB;
	Tue,  3 Nov 2026 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NAtWGEMP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EEB1F00A15;
	Tue,  3 Nov 2026 11:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704666;
	bh=14PADosa9LGZypBRqhyHl1GEnIAFICXyC3zXl4MGCeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NAtWGEMPOLaU/NIOwRea79LCxRdmTRThHZGEPvUuuUXdK2DUiElp62+wv8q5vqNgo
	 FMaU7+zvLHCthHnuM3x2Urx91FwqxWh2Fmmln4VU/9N3j3q7C0HDrA3B8IwTIDDVrp
	 9H+dy3+Iqo3EU9d8OwuOltDFAeB+h6Wi0ezedkK7V/B8PitV6zmY1Okir2TIknoiow
	 FsTlwaFeypF7rtvHosSHOsmtcVsKJDT3Zsx4KHCts8DpwV/M5Aru7TY9eOeVuP/uSP
	 mV/xdLA36XO6MFagkRkslj5et9m5fltv8N5Q3QAO5iKQRF8MNqcXcTwhHZfiODetxH
	 4/2E36sUgThLA==
Date: Tue, 3 Nov 2026 13:17:41 +0200
From: Leon Romanovsky <leon@kernel.org>
To: David Hu <dhu@x6u.co>
Cc: Jacob Moroni <jmoroni@google.com>, sashiko-reviews@lists.linux.dev,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v3 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
Message-ID: <20261103111741.GC264423@unreal>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-4-dhu@x6u.co>
 <sashiko-outbox-174922@kernel.org>
 <CABdL-LTgFTwJPTD0vyScNsvCSAW_04TgOyO1swVBgHxDcmJsfg@mail.gmail.com>
 <CAHYDg1QGH=GwAB-acW_oj3DJdSZBPidv9Xxn+n9=RT9Ss2PC1Q@mail.gmail.com>
 <CABdL-LQUdPaHu1tKW7fyXraBEUQBK-Xuv59e6u9_U7+AO7NivQ@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdL-LQUdPaHu1tKW7fyXraBEUQBK-Xuv59e6u9_U7+AO7NivQ@mail.gmail.com>

On Tue, Oct 27, 2026 at 06:37:56PM -0400, David Hu wrote:
> On Mon, Oct 26, 2026 at 8:02 AM Jacob Moroni <jmoroni@google.com> wrote:
> >
> > Hi David,
> >
> > Looks good in general, but since this IRDMA driver is used with iWARP
> > NICs today,
> > can you double check this Sashiko finding? Maybe this newer path can be rejected
> > for iWARP NIC types at first? Or if there's a way to make this new path work for
> > iWARP, even better. I am not sure if there's some generic way to map the generic
> > umem for CPU access that works even for dmabufs?
> 
> Hi Jacob,
> 
> Thank you for the feedback. I double-checked the Sashiko finding -
> yes, we can make the rejection explicit. I'll send out a v4 shortly.
> 
> re: Making the path work for dma-buf + iWARP.  This seems doable; it
> just requires moderate work to plumb iWARP specific quirks to be
> dma-buf aware. However, I wasn't able to find a compelling real-world
> use case for this. If there is a strong preference to pursue this as
> part of this series, please let me know.

I wouldn't recommend investing too much effort in this. Ultimately, iWARP is
not widely used in practice, so dma-buf + iWARP is unlikely to see much use.

Thanks
