Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0866449B13;
	Tue, 11 Aug 2026 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786459868; cv=none; b=JTOXTax8L0EqQkBW+KtP/uv3zYm2Qc07x1TjwN4vhW/8X0GZCSiYmce9OycUrcbBfifBlHNpFxU7WEnUaPkrqBK4oCnokE9dhvWlSEgwaO/mgdooLeKcAooPIgop4In9CGP5QJxqFRzbc1INmCUH3C0G+lGRndYUovxjU6Iyy/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786459868; c=relaxed/simple;
	bh=rqu8jS3anZAL/br0gBitePzXff7fiVul2q5O3XUbBFM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ey4/NY2CK2fBnF/7pzjq0V0rm6mv4Zx5eAr6IZDmCPOxwxUv/ZHOll6YfMDhQNhETXA3Wc9+zfZXpj5GfJTCDvvhrlFnBiGWMPM7FYJe7wIfA0gSgm+Bu8cJXU/Z64itwTpr7qXEMbOT/zb5gBSJ5l9IIgnxQqdYW7g26e+wT2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcLppvUP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcLppvUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E141F000E9;
	Tue, 11 Aug 2026 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786459866;
	bh=KmOnNXudqcFp6teaxFKRc1ujH1quWByZqtk3hAP9zdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hcLppvUPDfD3HtYAA6l5AOwGbvZDWqXtfjtOdEnByjpDC9RB5gjVTfsozUoouP09d
	 9PUFEI4jn/mb3na3w9Pv5f4Vho3MUwWeZav2vj4VjEOeTjS+SHffn1aUFIuSkOZdFt
	 DdWWFhHCrvB9OmCq3vX1PP1wugtOdDvfW8Jys6sffb+zuqe9h/gO5SS8OlzmsO4zqj
	 TgLNvXSUOF8y4cuIT7d2pGUmmxi1WUtFEu5EpLpcNo8cQSDgJaRVnTq7tCkG8Q6BRW
	 5Y1pf15PVRgZUWYqEWZLjvD1bYsIVQ0BD64800nPOMJPts6yT1EynBwkiFdIbG3Hfw
	 FtBGFpu5HZnSA==
Date: Tue, 11 Aug 2026 07:51:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: Patrisious Haddad <phaddad@nvidia.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "daniel.zahka@gmail.com"
 <daniel.zahka@gmail.com>, Chris Mi <cmi@nvidia.com>, "davem@davemloft.net"
 <davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "horms@kernel.org" <horms@kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kees@kernel.org" <kees@kernel.org>, Dragos
 Tatulea <dtatulea@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
 "leon@kernel.org" <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 "shuah@kernel.org" <shuah@kernel.org>, "sd@queasysnail.net"
 <sd@queasysnail.net>, Mark Bloch <mbloch@nvidia.com>, Alex Lazar
 <alazar@nvidia.com>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, Gal
 Pressman <gal@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Raed Salem
 <raeds@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
 "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "edumazet@google.com" <edumazet@google.com>, Lama Kayal
 <lkayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "sdf.kernel@gmail.com" <sdf.kernel@gmail.com>, "doruk@0sec.ai"
 <doruk@0sec.ai>, "sdf@fomichev.me" <sdf@fomichev.me>,
 "aleksandr.loktionov@intel.com" <aleksandr.loktionov@intel.com>
Subject: Re: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix
 responder parsing
Message-ID: <20260811075104.0fabe360@kernel.org>
In-Reply-To: <73586539333ece6aff68ff29f7e43ceb59e7b581.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	<20260804083535.2946459-13-tariqt@nvidia.com>
	<20260807175858.70a717d6@kernel.org>
	<51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
	<20260810133305.3b7448c8@kernel.org>
	<73586539333ece6aff68ff29f7e43ceb59e7b581.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2026 12:41:14 +0000 Cosmin Ratiu wrote:
> > > I actually replaced n by off. Did you mean "don't replace n by
> > > off"?  
> > 
> > Of course!
> >   
> > > Because the two are identical after the recv error checking. I
> > > don't
> > > see the point of maintaining two variables when one suffices.
> > > Either n
> > > or off can describe the number of bytes in buf. off is static and
> > > persists across chunks, while n is temporary.  
> > 
> > The variables have semantic meaning, which makes it easier to follow
> > the code.
> >   
> > > So to clarify, do you want to keep both?  
> > 
> > Yes.  
> 
> I'm sorry, but the code is wrong.
> cmd() matches on n (which never changes!) but __consume() only
> decrements off. Strap a loop on top and the result is just confusion
> and a source of bugs (e.g. the one I'm trying to fix with this patch).
> 
> A single variable should be used to keep track of the length of data
> left to parse.

and in your opinion that variable, which represents the amount of data
left to parse is supposed to be called "off" ?
