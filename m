Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BC6128395;
	Fri,  1 Aug 2025 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754079690; cv=none; b=rEi5llXauueViTiJh+YqdzTU7Ctny0uJhJlZxnvdeGsaGW+o1OrV8z9H6P2Usz68A30qyebg8TZJOB6wili2mu0DnYB/Kn1nWR1dZ5eYHZ5yW6k23L9jKtEy7M2Fvxk7Lx0r7FrdeMPEbgmhWbZ0D5c831ODD97KPgTAZBiSRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754079690; c=relaxed/simple;
	bh=uzfXcqaKzSAMPF8WTrZ+l7HXSGL+mUzNDECjAPvknK0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnphRB4bGMOvISU8F3QLSr7taSVn22cNhhUbx3gW164z591Vdgr7PhBbuuYXmEtO5G5ZABLmIXA9oJLQohnk2I764Lt5R1gXTFmVkk9ifdAUTgzWDUznsIxWxjqa4t35RDjv4+0J0d8Kd4Cv8mAtfnhysflZVwoK1ioDQQDEgWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpZ4t0bE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpZ4t0bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB68C4CEE7;
	Fri,  1 Aug 2025 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754079689;
	bh=uzfXcqaKzSAMPF8WTrZ+l7HXSGL+mUzNDECjAPvknK0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cpZ4t0bEhU7dtMgA1StfRnVbji8n51H7lwTh6EpSjrXISkFYz7WQDVP+ABjsu+5Wi
	 b1fBw+bxFJmTHDTdXA90kzgafiNoooApEM788Eh+rhlmXpMYu/KrVG4x/XXzVO0dm6
	 mJLVPfl6rHsTEFU7QAxWlONEAHsCpplrVRT5WZLu+GdCZ9oCEISlOIHURAo2Z2Q1zh
	 Y+61vJtHlCBw7rhkyhiug4Yyhm5FrK0lPaRQUSuXMdNIJhiLwE0JlojXRtJOwz+MT0
	 2xAT3/4UxbKp8tcuc/w4ITLFWzDsxX6PQX7cpinGJIMYOvKCqJOTgNeoKrJDoxNG3w
	 pCkNcABS+dibg==
Date: Fri, 1 Aug 2025 13:21:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Simon Horman <horms@kernel.org>, Abhijit Gangurde
 <abhijit.gangurde@amd.com>, shannon.nelson@amd.com, brett.creeley@amd.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 corbet@lwn.net, leon@kernel.org, andrew+netdev@lunn.ch,
 allen.hubbe@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/14] net: ionic: Export the APIs from net driver to
 support device commands
Message-ID: <20250801132128.69940aab@kernel.org>
In-Reply-To: <20250801170014.GG26511@ziepe.ca>
References: <20250723173149.2568776-1-abhijit.gangurde@amd.com>
	<20250723173149.2568776-4-abhijit.gangurde@amd.com>
	<20250725164106.GI1367887@horms.kernel.org>
	<20250801170014.GG26511@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 1 Aug 2025 14:00:14 -0300 Jason Gunthorpe wrote:
> > Perhaps I misunderstand things, or otherwise am on the wrong track here.
> > But this seems to open the possibility of users of ionic_adminq_post_wait(),
> > outside the Ethernet driver, executing a wide range or admin commands.
> > It seems to me that it would be nice to narrow that surface.  
> 
> The kernel is monolithic, it is not normal to spend performance
> aggressively policing APIs.
> 
> mlx5 and other drivers already have interfaces almost exactly like this.

Which is not to say that it's a good idea.
