Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2C4A0913;
	Tue,  6 Oct 2026 16:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303787; cv=none; b=RyW6hGWOZ2ae1EwSs91VlFATSRFZGKfIkCOICbR87a7ykRXQjwNpl800ZSlUI+QPhfhHSeUrVSfqy1jkMweZphPUJmh4R491+tmnYL7ZMeU1EfzwednotOOGd3PJ2Y2Nb4mqRo1cZ9b9etzV4iesmO7caC3Q4VPEuzoPPAF7+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303787; c=relaxed/simple;
	bh=eB3lfCADOvqUWkGPD5jHtrvcTjOSSowSmkUWBQ2x1p8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nx2OUgnri+McEIC6IRmp+Lm0x8dfnG8YOtJ49lBGixAkH5D+yQCojxQXMRbHh/bejJvfp+zS2/2tzUBtXTkNRi2bhBSOxaBG8C/iVYIprotjUer7jbXbpTicMd3kirT5PGyPMcbNfff3AHVA+wbSaWZOapnTcsKVakKD0aLl8DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFboKg1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFboKg1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE511F0089B;
	Tue,  6 Oct 2026 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791303782;
	bh=CWSW/5o8h9zLdXTpGYOS1ghltQmvsiCBfCOWLE/YDWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IFboKg1A4Rm3orEkaH5THzPYgojrcGxqHRnftIL3TpUSOCtQh+uVeseFQ5R7fusnQ
	 EcCL5+1DqveX929Q9xvM9EBvlEqk9Qq2Ty45mUjvrG58+Dmfb4VWdPuAwRsZlIV0E7
	 KQ1289+ORfASxQUoJNqKjFVYG1PbjVpx/wyV8uG4=
Date: Tue, 6 Oct 2026 18:22:59 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: sungbyeongchan <tjdqudcks0424@naver.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [BUG] RDMA/rxe: MW rkey authorizes accesses outside the bound
 range
Message-ID: <2026100616-supper-uranium-6500@gregkh>
References: <20261006091105.827719-1-tjdqudcks0424@naver.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006091105.827719-1-tjdqudcks0424@naver.com>

On Tue, Oct 06, 2026 at 06:11:03PM +0900, sungbyeongchan wrote:
> Hello,
> 
> I found a memory-window range authorization bug in the RXE responder.

Great!  Please submit a patch for these issues as you have a reproducer
and can test them and that way you get proper credit for resolving the
issue.

Also, no need to cc: security@kernel.org on public issues like this.

thanks,

greg k-h
