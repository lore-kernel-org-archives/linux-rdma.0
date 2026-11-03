Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716210;
	b=i6TmeyIjF2+V22yANPiv5BFpbLgE86am2YPzPLQwrAqs7sWIKyGddFIqNsg5oinqXRVj
	 D1O+ZshY50QfWyRS56NfZFfHaamC3e8eMb3bcZv78VivgtNVaBqiY3GXZEUEIZKyZWFJA
	 47czXUUHZCgVlE9+2ArftbKfDGommcksg/7kTw/B2c14eEXDUHpib378Wj+j2QeUrUTtT
	 2XCnEUTCcr1Je+7uCAZXzTox79wqN/1gzFg24YIvWP54ALCc2AO3kquyQC8e59WR2Mv3S
	 K150omLxxwf82YQ8IeDDx7k/orTlCwMZHRMf6KU7nqmJHwCLIY84wRXap+0NgOrioIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716210;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=S4N3HahgFh8uNZM4yzvkVFDOTn406BEclz2Tzu3vcjg=;
	b=XbISa1CVZ9BCOfxf3Lc8S8nP+dNqsx7ejlXdmoMmHS7j10Ah/gSfxMGOTRC0p5aomK6G
	 sHMyvUmdt9t3egpmcxKVv0JWCi14e+APJ+w4H7paVp/Y1RwNYr653BzUf9Sb2oU0cCzQP
	 Fv48My0D9EjuaE2qBFf4vvBbzweJnKV94/nwJHxdGj567SKkwha/tDhhAycEiOaGsxMpk
	 YwVuBiHm16v/rGg7f7aBp+YyDPegZdV18DjalFBncA+yhCMdjYWIKm4s4LArx2WmesVew
	 uBse7k5yYEboML2lJ2ynHDQBKrHbtfSaacYK10ybXfNNdglzmx75GnnSJH/lRHCNWig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=lL9eOiVW;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6373606A32D
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 14:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6373606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=lL9eOiVW
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c8fef5ce2so52537986d6.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 06:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793716209; x=1794321009; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S4N3HahgFh8uNZM4yzvkVFDOTn406BEclz2Tzu3vcjg=;
        b=lL9eOiVWM8NSqwjwqgl3pa8SBGTJmq2udFyCUbB8ZP8LdjN008u64cdl09/tqzLYYh
         gqBXRk+xG32xFMjlRVOf+kFr5tuNpJ2KipIDBLNUauoBg/59Uod6syqZqVzX/k3shZXG
         Aef+vP2KysAtmjJE0j69IFGrTymLta2z03JCNnWYUPVlumzHyIhreFJdoyUH4rYhMHb8
         CMjbsVXmq4pO+eqWw5u7idJVFKg0o+0yHFKJ2Fs2V8XaQSqFBvf4CS9g0xPq1fUl2XCB
         xtBVfPyd1YKPOOxi4PvaqEDyusJkd2Km5bDAKZUwNIer0Ooup3EiSY9NaQrrgldC/Ef7
         koNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716209; x=1794321009;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S4N3HahgFh8uNZM4yzvkVFDOTn406BEclz2Tzu3vcjg=;
        b=ZSCz7QHMIBfEiDoXQjt4gBQKkUVDCe0fhYQrYpM14h+ucR0PERqfl8B0VS+9eoyVy0
         u53V6EBAigu5HLNQrCAPUY30LCTPlTxZER9z4nKINqY04xyeOqFuvvVSSpzKqnZt8fcZ
         JXjlOFNAeeYOsMdTwh6z0pL9Xq5c9Y0wb5vKBryVWzMiNGqFKIvivH+VnoE9umJVr5tf
         fIIMxyRxT2RxCS9Bd2jfaf4JXHOofQFKUTxUkprQK0e4Y0JhPTgbBXzYsE6E7tZpKPlf
         OHs1uJY3Yybws4OxA2GqrMyP4EeAUmfCj5QyQmhNqIxNb/UxGAD7w0etKzifeMIU8+iS
         G5VA==
X-Forwarded-Encrypted: i=1; AKwUvBwRhyMdAYsZn9MamjU/4P6Ojyy2WFAtQnVx8Mv0zEyGL1WGiNIp8RnV9bGOPN4urvn9exn5RCUI94/8@vger.kernel.org
X-Gm-Message-State: APuU4Z+yOatYbnnSJo6h1UJnyYZJTq79uYPkIGGyKzFIv8u2EavthaxI
	IIrGQuVHUmkEgrjZpZK3F7lUSXEVeJ35nMPIJxk9eSgvqZ0N4l4qz9U+Yhgl8jR6Ebg=
X-Gm-Gg: AYBFou0SsioBSvpwktPc8Kpqq/+2wXJgpkh2k3AZVdXaWZCmmvPZfxo442DdbdH/wTK
	Og1IkAmlkC5EebK2ARsjG/27a9f/nlo86jGzWNtRIRZ+FHw1a1kTqDcndIfhhX1CKe7yrbAaSVD
	ksXNmUUDVKYHHzS+8T8b4aIYyj4dJURcbCfPI3jsdcHKZJ39CNpssMdTEUMYi6lWCKr8Yxk+oH9
	Cx2B1dl/iT95PV+Ezhu68YSo+T41H3kGinOgs9ArId+HqlKhk7My4Pg8RNhq71FiJz/tLRYFIWV
	19Z5X4VTA+AyIfSfzRMDfjJmn3UKhS6S78IYVJVao8MPnaw1W0Sw7lxTLEgEs+3P+MgGm4px3jd
	/DG30krgpMwQg05tOPYuV6QzsLkTzEUWzgnkmO/Y3IbAtYjJV2Pocr/Sytt7ZPeuXg7KnDW7RGz
	puUeTgpZ9YeCw2275vHCg8HirBDp3ByrizTZpYQEdM4enlDUuJzUrUn9aW4r+8VALnHruZMVYpe
	/uW7XdITBBAvZ2neFlGfRFrJglq2tI8D/qrwIkCVRXobJLZX67pSoaqZBx++0+OE0DeTzLXZ5lZ
	qaKH/1tzLGs5TzGz7oS4mm4ihJ9+On96qUHLPMYJiKybJLnqHRbiGsN1YCHUqB2aQTT2/H/dDfb
	QBs04K02+SQ==
X-Received: by 2002:a05:6214:2461:b0:91c:77b0:1f4c with SMTP id 6a1803df08f44-91ca4ad418bmr221541976d6.17.1793716208467;
        Tue, 03 Nov 2026 06:30:08 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7f26f1esm119002876d6.13.2026.11.03.06.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:30:05 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOFWW-0000000D4vp-116r;
	Tue, 03 Nov 2026 10:30:04 -0400
Date: Tue, 3 Nov 2026 10:30:04 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <doug.ledford@hpe.com>,
	Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Iraimani P <iraimani.pavadai@hpe.com>,
	Mamila Santosh <santosh-kumar.mamila@hpe.com>
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
Message-ID: <20261103143004.GJ3889730@ziepe.ca>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261103142826.GJ264423@unreal>
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
In-Reply-To: <20261103142826.GJ264423@unreal>

On Tue, Nov 03, 2026 at 04:28:26PM +0200, Leon Romanovsky wrote:
> On Fri, Oct 30, 2026 at 09:35:28PM -0700, Doug Ledford wrote:
> > This series adds cxiverbs, an RDMA driver for the HPE Slingshot Cassini
> > NIC. It exposes the NIC through the verbs API using the UET reliable
> > unconnected (RU) queue pair type from the UET RDMA core series.
> > 
> > cxiverbs does not drive the hardware itself. It is an auxiliary bus
> > client of the cxi-ss1 Cassini core driver and does everything through
> > that driver's exported CXI interface.
> 
> <...>
> 
> > Before posting, the series was reviewed with the Sashiko AI code
> > review tool and checkpatch. All valid findings are fixed, except the
> > open items listed above.
> 
> <...>
> 
> > ---
> > base-commit: 306a2f8432f516069b2e673de7a07043132c034f
> 
> Sashiko failed to apply this series as this base-commit doesn't exist.
> ➜  kernel git:(wip/leon-for-rc) git show 306a2f8432f516069b2e673de7a07043132c034f
> fatal: bad object 306a2f8432f516069b2e673de7a07043132c034f
> 
> https://sashiko.dev/#/patchset/20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com
> 
> Please make sure that upstream sashiko runs on it too.

I don't think he can, it relies on the core code series. I Don't know
how to instruct sashiko how to find another series to stich it
together

Jason
