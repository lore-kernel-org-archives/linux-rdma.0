Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FF23E1D1D;
	Wed, 16 Sep 2026 08:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546585; cv=none; b=Ht1BM+5xl4ROGaX8l3rWSc0OD+iPDd1wq/ztHrRcCIZ8Exf21CFt4TxX402k4fIHbjfCuX0s0WyNkfgkglUET3EjYFBDQbYg10nmVx5I4k0vdWQG6Gi/EvPMDKhE8h/kevK5GCINssD2sanxA9pDY818ej0kHL7M8QtGWUTIXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546585; c=relaxed/simple;
	bh=ZFHmCsFDXOZtI4+qJ37Ee+Bymw+byUoEkC84JB4879E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YoiEyw9ynT+bESFYmorkJRgNWFOMf/7yg+Gb3QUtJrFydQLP05KVbTBIIGEAha+5dNR3106CFVuvJO8HUzm23s8kAd7fMtQsT7oc4CncPfkpNJbjZQ5DmmvuOY6G7sIr0VE0+I8EdCwPhu8KbZXQSo4IrXVEi4YngM/y3ukT3V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+ogFS/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+ogFS/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660EA1F00898;
	Wed, 16 Sep 2026 08:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789546574;
	bh=NM3EZvZcZKs6FdJGefu5aYNnePwXy8aZCKjpbwEDYSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E+ogFS/sXA4ktW/MhJpKRcn6GEhVEDPwKaetKYxwcuShjAGT97miy0nFZrTLcHPoj
	 JQNqYyG47nDRLhZ7yokDMRTdv/5ZcU1TxTcuM5hcJEKzur0f54JUA+STQ3XNuoJXvm
	 fvBqV5nfl1gMGecCMufuEd/DMZi8tHToe38nGC0xLsK22e9o/I8kLolmFmidIum5Xu
	 nA0jv9fcWcCIOgMvz10lgn7iVpJ8E+VCc5ANE2oKiAncC8jPTg+32LEA7I0+NxbXBs
	 IiiblHLgDlhdmw516Tnfaxix1jtRQNVVgnq1/uyuXCxid7mRavNp3G77XnRfHfi2af
	 CuTwsSSYJaOxg==
Date: Wed, 16 Sep 2026 11:16:09 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Limit SRQ depth to the firmware
 command field
Message-ID: <20260916081609.GU13683@unreal>
References: <20260915-silent-16-bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com>
 <20260915132428.2C67B1F0089B@smtp.kernel.org>
 <20260915184615.GQ13683@unreal>
 <CAH-L+nOnpYLZkPh5Msvcy0pBY0VBi0tGZhP1-Q8_DC_X_wNSEg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH-L+nOnpYLZkPh5Msvcy0pBY0VBi0tGZhP1-Q8_DC_X_wNSEg@mail.gmail.com>

On Wed, Sep 16, 2026 at 01:36:28PM +0530, Kalesh Anakkur Purayil wrote:
> Hi Leon,
> 
> Thank you for the patch. We recently made a similar fix in the OOB driver
> (which is queued to push upstream).
> 
> We will check the Sashiko report on your patch and propose a fix.

Thanks
