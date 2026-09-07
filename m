Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFC846DFF2;
	Mon,  7 Sep 2026 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788780292; cv=none; b=lextLbwjuzcq+h06AaBUbvxhhfgXSLyTKxx0pjVa/4sjVw0pCfZSm97105Z6enYlY6sAhO3EjcST4pYJC8pokflbjz42SSxJ6ZzudTDEIbbudJw3G/7GTIBBPTWlQ2Ctq8sE6H7xnf3MGm3E23ic/9+jMAHrDJQjVddpPQkJ3TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788780292; c=relaxed/simple;
	bh=k+4VrOnfFX0H0G3m1gIhYB6Rz2mM8ExOaty1y2KxFRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMDEEJgMr7xmIX2n9XxxYEAsz/zKb13qNd8P3BC58+hc9kum24FBAQbDi5Ve+6CE3sCn98tt9/YMqs7bbfR0gL2HhLahr2jrBNVsk3fzjnUEepDoYV6ux+l6aygrFX2hcxHaiLW774MLwozdq1MJ+0MQRLOphk6kmGOWwg1lJ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAkGzpIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAkGzpIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270DD1F00A3A;
	Mon,  7 Sep 2026 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780290;
	bh=zbidziLDau1K5hrlS7XXsbdbdXRZHSsHhqI2/Zw0dbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cAkGzpIiByH5c6rI5DHUYcg69YJwBFQ16SXmAUDyDWcLEygTJ8E6+QelXqGdA5V7J
	 nglwj41oHvJIzcGhiSWmeRlmub85iddW0RWnvZ73NfCyjFB419Yy1jfQyHC+0uF/DJ
	 hIQvt+GTci2LvhMtIP+YqxYj4H2t8YERd7QZ5d5B6fmsn8urBZcusdsL/wuPnL2IGZ
	 Lx/LqTuli6py0YhuPGVyhDE9Amtdo5hT1frYPWuFOZB4z1+9LDc5LhuFoIkPykPRpD
	 23BIi6scPqsb7uLSMOQZI11EqrLJnRFHaqxigHzWj5ZqHLLNiR0Xtam6gqGr+4CDMi
	 J8TGyauCMEdKA==
Date: Mon, 7 Sep 2026 14:24:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA: fix typos in comments
Message-ID: <20260907112446.GI13683@unreal>
References: <20260907065047.26773-1-hemanth.selam@gmail.com>
 <20260907065047.26773-2-hemanth.selam@gmail.com>
 <20260907082728.GH13683@unreal>
 <20260907093109.24023-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907093109.24023-1-hemanth.selam@gmail.com>

On Mon, Sep 07, 2026 at 03:01:09PM +0530, Hemanth Selam wrote:
> On Mon, Sep 07, 2026 at 11:27:28AM +0300, Leon Romanovsky wrote:
> > >  			 * release_cleanup is the exception because
> > >  			 * uverbs_uobject_fd_release() needs it. In this case
> > > -			 * the module reference held by the fops will guarentee
> > > +			 * the module reference held by the fops will guarantee
> > >  			 * the type_class remains valid too.
> > >  			 */
> >
> > And what has changed here?
> 
> Sorry, that one is easy to miss: it is a single letter in the middle of
> the word.
> 
>   guarentee
>       ^
>   guarantee
>       ^
> 
> The fifth character goes from 'e' to 'a'.  "guarentee" is a misspelling
> of "guarantee", and it is listed in scripts/spelling.txt, which is how
> checkpatch.pl flagged it.

Ahh, thanks

> 
> Hemanth
