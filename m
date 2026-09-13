Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590323B840F
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789326468; cv=none; b=glC3G7Q8guvqLd2Me2qV0fw6H4quCpFbVywIHkAloSBL9Mhb7RLVVLDjKmUIicVqroMTDRe7ONY44QQISNkJufFeyCgy/a6gWQfC7ToiZYln3Sgm3Ju+DE55j04rkXFi4NKOUqPNRJqy0U/SLrEFiLYOUR4Njra3uRKQN9H1nj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789326468; c=relaxed/simple;
	bh=FJuNyLY/pzbcykVKwcXUGco3PIus266cOgV5iuyaxpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obpM7OfiBPGbJoDIcjBCf9wmelQ6/Zhmb+4kVQ67YIXL8GJB3o5oNOYxjd5t3hcbAParutaacRHzQXYuVvrp219YxpohFS6k6/eAgiFu2cKHWoyJNR1evgE1BwMzMse0Bddb1hYpPsG8PeyeKSRpRQiUNff8ja5m35Qv0laCq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UpFx2Y5g; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UpFx2Y5g"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b917769so57585ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 12:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789326467; x=1789931267; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wLKsYyHDEIG+EScQ7Yc5Jy2hjjtWSDf1s+mRpjU6xek=;
        b=UpFx2Y5gAkORqOCg0ondjxyMYemkeXHMcY/8BA0HDzEXWssbfiuUknCX9RUbtgUcyk
         Allx2sc6EJn5jRlmTFx1R4v0pAhRJEfSjglepLf2uT4JpzBRc/kNyugJssNbOjNYaQXS
         S+oBM5nrfWDdXsdqWLfGxvgBxrS8899Fv1fKllPUUTJP6TN1z6kZKUw9dVc5pwn8D+1X
         JocU9DUkWM5cvFhaWiDLJnQt/gZehtTjhc4mIrApW1fGC/uDoCEVN4IE6IkQy1OwGk1e
         fEcPynMhQzqX21IGpWKsOuaZguGQgDf8P0oUkrxP5uwIq2HwcLVDiVSAAzXsKPSC1D3v
         UGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789326467; x=1789931267;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wLKsYyHDEIG+EScQ7Yc5Jy2hjjtWSDf1s+mRpjU6xek=;
        b=Q0nTSTDNqdWspzHwH+GgeOAqGls412Jkp2amWEf8u2BVmR2n+/pSskois6uQ+Vkkky
         FUXjI+wBvcQv5AEdAk+cqtPNFhS1NmqJ5druIA3fjrUHneAdfQhHnklrtv2tN4fVXk7a
         RnreQOcvi5tq9Gr0zTahxAURDjdkQgsLN+M5yt4Jm1wn2WTCxC5fpxc7oz1dS61VFW8K
         WMD1GdmPVjP3rfoCPOQCRt1dildknpx8C5AttMXPH8fEcTDKtLU4YrdwvqDzu5+dYZKX
         x70XCi250A5QSYMEH9PyCHlZJ7ffp5zqx7jVu4nNTWtuVeZEzt6tjevJtnn/tVi9nxtd
         UDEw==
X-Forwarded-Encrypted: i=1; AKwUvByJc5FrNeBu2/nHqQCEr4znEuCmvrb0DvevSq2+51BhiCswCMhRZhtb6lhTlp1drkp6bVFlSp/+z5rJ@vger.kernel.org
X-Gm-Message-State: AFuF++mVQUZFcuO7H0yZixrPMWKqotdv0eBCLacW8y2BAkRtryimgNOr
	VwG5fa0YN5fZEq51PN2LqSZhL9V3z7sqS60us4Hotr1R88LcKDrCH6PHDzq7aQCZ8Q==
X-Gm-Gg: AYBFou0vpvYgeWlNrsXTh4bWVrRx8ArbN6V0XKop2LZo3c5Ipj0NZwtuHAvfgIyYaYy
	7GlvLxyMk6jbMjJPeSisWG1wbZF1fX4cCKy7eassoQ2RrI5gCWGV5b1Ks7/Ea3QjaAX982ZQEw4
	kYMXy5r+2tO9kkvXxpaxZWtgZZeXiesCx5WIYwrH5jeqaau/uUiALTpKhVVSSePGgSXOunb1Qmi
	N24RYuhtZQ07fg4SFSdo4ck+ca41Na6gincq1TDg3HB5xXmwlTdAzdcOv/GeegRHOtQRh63N+C1
	DzEPp1VpId//WJMsdv82p63KrBd5ZJ0MgIPrv8yR4k/Z0e1sZy/HrHZhkiIiFru+66f6RIy1GlI
	RXqump9H3CZ7pzNvk0niSTd1FP/Vl11I1Rc+c9b7CmkjZJ9x+vIE5vZN7DE2So+PihDcOvWhC2Z
	Mh14ImblIFmBoJplV7EPrS6/iJEJJuOMfUFyWKSdBmiP9Kbx/oG2TwRK6c+S2+ygqE+fOxuA4jP
	pP2yXRhwipY9LDCJbnzpUK0m0XrIV3boyCMiasuwafXfmw=
X-Received: by 2002:a17:902:ce8a:b0:2ce:b436:272a with SMTP id d9443c01a7336-2dd5e385cb3mr1616295ad.3.1789326466028;
        Sun, 13 Sep 2026 12:07:46 -0700 (PDT)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd561e2af6sm14996025ad.70.2026.09.13.12.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 12:07:45 -0700 (PDT)
Date: Sun, 13 Sep 2026 19:07:38 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Anna Schumaker <anna@kernel.org>
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>
Subject: Re: [PATCH v6 0/5] nfs: modernize direct I/O path
Message-ID: <aqb0ejwzD8citck6@google.com>
References: <20260814143255.861084-1-praan@google.com>
 <aqP6nM7OSX087UCs@google.com>
 <0b3d8f13-e691-411a-a507-d3e6bd1608c6@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b3d8f13-e691-411a-a507-d3e6bd1608c6@app.fastmail.com>

On Fri, Sep 11, 2026 at 10:41:57AM -0400, Anna Schumaker wrote:
> Hi Pranjal,
> 
> On Fri, Sep 11, 2026, at 8:57 AM, Pranjal Shrivastava wrote:
> > On Fri, Aug 14, 2026 at 02:32:50PM +0000, Pranjal Shrivastava wrote:
> >> Modernize the NFS Direct I/O path as a preparatory step to enable PCI
> >> Peer-to-Peer DMA (P2PDMA) support. Following feedback on the initial
> >> RFC [1], the modernization and architectural changes are split into
> >> different series. Additionally, based on the discussion in the v2 [2]
> >> of this series, the migration of NFS Direct I/O to folios would be
> >> handled in a separate follow-up series.
> >> 
> >> Currently, NFS O_DIRECT relies on the legacy iov_iter_get_pages_alloc2()
> >> API which does not support the pinning requirements for P2P memory.
> >> The implementation moves NFS to the modern iov_iter_extract_pages() API.
> >> 
> >
> > Gentle ping on this series. 
> > (I realized that I sent it close to the merge window, Apologies).
> >
> > Please let me know if anything else needs to be done for this..
> 
> Thanks for the ping! The plan right now is to send it along as part of
> the 7.4 merge window. I haven't pushed out a public linux-next branch
> yet, but when I do these patches will be included.
> 
> I hope this helps!
> Anna
> 

Thanks a lot for responding, quite helpful! :)

Best,
Praan
