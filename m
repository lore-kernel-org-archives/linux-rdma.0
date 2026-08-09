Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3354279DCA
	for <linux-rdma@vger.kernel.org>; Sun,  9 Aug 2026 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786290937; cv=none; b=BtB7IRwK7StQGdUOEkoc+/s+hAJk8i3Y9uJf1TxBWXav2z3zWfeUSneYPlS/RujPDgm2Y2v+HS00oMpdCSApH5dablgT2vgBEnNAMbaMWkUIytqdjV88Ug9Tw7KbHNT4k7MGXvmtscCFwl4vhRWw2p8gxZDIqMQmL6BnqfHHz30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786290937; c=relaxed/simple;
	bh=QcFrRCeDI/i3Ew/e11cx7MxC5wvLiH/lxBlsj++ms2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLO1TaJrjR0cqopvj+msJZKG5fZMTHNgVbALvD5Cj4PlpgiLpvzjPIbonzijOYWtJ6IaYv6o3TCVSY1cqBJfjgA2Jw/97/lF9ugPALFsGbbB32qbmaaN+zq/eb4yCGkcTymytWXT5f47Y96tVEYpzq4O4ExHgBMWo7cPre/d5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=BMBwbgMk; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="BMBwbgMk"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49800c6a846so9726895e9.3
        for <linux-rdma@vger.kernel.org>; Sun, 09 Aug 2026 08:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1786290932; x=1786895732; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QcFrRCeDI/i3Ew/e11cx7MxC5wvLiH/lxBlsj++ms2E=;
        b=BMBwbgMkP18hHiz81HK0br1cLQexDPtxAmivgb5rJ1GN5stbdt9BFYDbrlTlWx2a0C
         dsgyVQOggkTPXVOaTL2y2SDL+4LLxG9uUMmg1TSkLT7S7NPBmDndYm84ge+eglHtE6pk
         I8XmE21HWJoU0PYuPb8KkPlU8dT/bbpxsl43loqY3RaK5SvZAlvPrdNMOdPV9r2a6n4w
         hMJKX0jU5Txj8nRhE/Om3WDpz1JtTg3SPeA44DF5yjBE7FXWobKw+VaPM2GLfZUwW75p
         3bUrNcP0Zr0TGGnWRSQ+Z83BjVnUQBqR0Vv15ueYZ41vFWiPSKgNd94XmjZFK1PlaLXh
         zt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786290932; x=1786895732;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QcFrRCeDI/i3Ew/e11cx7MxC5wvLiH/lxBlsj++ms2E=;
        b=jwSIffR4mvgVlz54Xlm8ySBZ4I6k1Kf12ow/HN3jtUJUhP+OU6KxtKZTnlM4RRDESC
         QMKjpfNJItP1PCnTTiQC76WYCE1LlcJQYpqvCPuqG0WeXd8n4/vo1rQRXA3786HB7DYS
         QCfzT2iPXgH1KjsNTfjZgNo4X6EPUP1TouvcJFxlaTKic0GGdemvDAHJ1G3q2s+wRDD+
         ygQ3HeEUswu3TbGYkYHuajwsXrZ2VGZwfLl+z4J5vr2kO1mIYp7oQRZ68yZPgHZaeLvb
         nFr8r4CHWw07o3bCBuUNxtfMp7fogr8PDpKtVgr4Vpwgsw4b65/v94RfZ3XeP/b5Sx1D
         v1Sg==
X-Forwarded-Encrypted: i=1; AHgh+RoQMlmuEWhSrRxZdwMqNVBYVuLRSvbLA/23HjUKMJgtKX/yg9q3I+pY6z9do8dvpXtcfwN1QPEHLEap@vger.kernel.org
X-Gm-Message-State: AOJu0YyfFYxfYuFT341nhIACNjJqUE6FOFHF4m9sue2lI7qgG9mshmLC
	UxxrxBtuV2s2MXreC9zT078xE3NmfvZKEYAyJ/dHKAWuKmMyDORTj2N6ma+kJjWL+zQ=
X-Gm-Gg: AR+sD12BGnrIsQMPg0nxZyltjuqfjyleOLI99iOEUBSVOOyb4b7NyR0rDA0nRmgBp4p
	6ycM9tKIV7gzvFYS4UpMrmwXXK4HZuYFNBbVIUbaWfcm7NCOgibUCXbTPimwHYwwOWNtI5n/2Fx
	1rZnXYgMT7jGWm7CwYq6HfUvrAyKK+wBRisAu/HromrBg+kfQynjx9JDhKCB05VwNAaxIJDxKhw
	f8VpAc/uTLpE82pn9Q2io/jN8euw+O3dZKhUJ9KSQvT6lQ7XJdWY5P7+8sCcsT0/tF6Yxt2llHG
	ttJSl9AVYxoNCC6XzB8g0F0uZzP6pXBduIME9HVIMZ2PucsRP3Sx/qdDfYTDnXbi7HchOkHQ31Y
	QmD3jVe4v6baq4fgsZKIJ2znsgvWRTAAB0toRLmWqzYcn59kP+tTDyjfWlDRLICGrYZ/29cqrl0
	Mq+ycUXYC2PUpQ2Pr67f8c2Y7TOrAKLPoNljqBm7OXep+fctzjdNSv8jGQ1gXhe7z6+4lVuOdou
	AVJbyVe
X-Received: by 2002:a05:600c:6c50:b0:499:48bb:417e with SMTP id 5b1f17b1804b1-49959e0176bmr225272675e9.2.1786290931844;
        Sun, 09 Aug 2026 08:55:31 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995e9f060bsm217952505e9.7.2026.08.09.08.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 08:55:31 -0700 (PDT)
Date: Sun, 9 Aug 2026 17:55:27 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "leon@kernel.org" <leon@kernel.org>, 
	Long Li <longli@microsoft.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Message-ID: <aniik0sdK04Ie4HH@FV6GYCPJ69>
References: <20260731091041.2250897-1-jiri@resnulli.us>
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
 <anCBtLSxn8TtFcSz@FV6GYCPJ69>
 <20260807231356.GM200537@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807231356.GM200537@ziepe.ca>

Sat, Aug 08, 2026 at 01:13:56AM +0200, jgg@ziepe.ca wrote:
>On Mon, Aug 03, 2026 at 01:59:07PM +0200, Jiri Pirko wrote:
>
>> That is not doable in UAPI. Some userspace app, like rdma-core in
>> this case, might use it and rename breaks the compilation. Some other
>> app you don't know about may use it.
>
>Linus actualy had some comments on this once (which I will never be
>able to find I guess), but we broadly follow what he outlined. The
>userspace has copies of the kernel headers embedded in it. When the
>kernel headers change the user space updates it's copy and fixes any
>build breaks.
>
>So long as the build breaks are fixable, and don't change the ABI, it
>is fine.
>
>Many parts of the kernel work like this because userspace is not
>supposed to directly use the kernel headers themselves, they are
>supposed to be sanitized by glibc or some other helper library.
>
>There are a few places that don't work like this of course..

Yeah, me being mainly netdev-guy, that was never allowed there. Not sure
about now. But makes sense. Would be nice to have it explicitly
documented in kernel docs though.

Thanks!

