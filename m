Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF37374A16;
	Tue,  9 Jun 2026 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781042451; cv=none; b=AvVKv6D5PlJXczKOyqWznbNhwZG1PltmB074+8zV5LeQpoTfVHWbfaIZYBxYJIYazuknW/dUWphNi58FeMeqxC+DmM1aQmuxZSHtSACVDunU8oMPAQyghJtBh7fValUXNevzKUh9dNfPDCZDgmypUYLNW4VBznIsFdMyLteC4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781042451; c=relaxed/simple;
	bh=oe4lddgZZKEfFWqDhCIeacT5D2ccGGi9a8jlXHl9VX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2J2mR4uO20EJYuhfwjZFBvtPGKAva4ag2exNDqB6acfz0Bsk9JUubsjbuZPgLyeby/CGAeyGW4L1X+AHEfvdvXCIEYAeeOilcJIm91Uui4LEQYikPSbCLyydxyBrnS+bIYF82XduHcZArTyef9A5DUNkboyJDtNBPNQ59cT5us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwFhBrRS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwFhBrRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380151F00893;
	Tue,  9 Jun 2026 22:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781042450;
	bh=bmEuIigsmL7HWH7m8kxNpsbmaCiGGk7QrPGi54GMZn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WwFhBrRSKVYVtdsk3o4dKtmtIbWi7bPypc9T6efDEkS5Zcm8/jYHOg77OBcNVZiRn
	 g96h+oMy0dRhHDncE/8d8zqsEKcQ2SnFV/L0vC8SnIgG72fXN2r5U9SwjMTgksWqSB
	 JespkbhbhnA5NIPAn89ZCTvLJ9BPmfXg3C96bOWDCljvwYYm1eHzvphxNnzZuL+L5g
	 yOqgoY9n1XJaMTiRLm/FIjHk2GDAizI5oRRsQ7pL8Fr4iXcSuML9PbZ18Jt5cus1O5
	 emNMWZpDHiL8O1lf44m3JxOt5SvHz9ypsbZTN0UvTtgyfsNolC0TyRg38OBg+DKU4h
	 nRcXpiubKX8yg==
Date: Tue, 9 Jun 2026 16:00:48 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org,
	linux-rdma@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2] nvmet-rdma: handle inline data with a nonzero offset
Message-ID: <aiiNEEdfVbRvtfuy@kbusch-mbp>
References: <LM21QIR-1-qJb7PViyJKCnGBnUzizeiNJVWQ3wb7ZwGezodjgKg3f-iobqOyequ-sT1jFCKJImfqNO_BKU3KO80xFITnaI5GTV_GxLUNDDc=@proton.me>
 <ahm6Ksr3rfGdnOsN@kbusch-mbp>
 <20260604084624.120032-1-hexlabsecurity@proton.me>
 <aiFR81yE9_BIsNbM@kbusch-mbp>
 <20260604193645.178350-1-hexlabsecurity@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604193645.178350-1-hexlabsecurity@proton.me>

On Thu, Jun 04, 2026 at 07:36:54PM +0000, Bryam Vargas wrote:
> nvmet_rdma_use_inline_sg() maps the host-controlled inline data offset
> into the per-command inline scatterlist.  The bounds check admits any
> offset with off + len <= inline_data_size, but the mapping still assumes
> the data begins in the first inline page:

Thanks applied to nvme-7.2.

And not necessarily directed at you since apparently many people do
this, but it would help me a great deal if subsequent versions were
posted as a new thread rather than appending to the previous. The
interleaving of the intermediate just makes this harder to sift through.

I'm actually not even sure how so many people converged on this
anti-pattern, as 'git send-email' would have naturally created a new
thread for each new version. What exactly are people doing here?
