Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535D735E952;
	Tue, 11 Aug 2026 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786463334; cv=none; b=uXU/U4KTHEhiHRKze00Pm66f4R3QTgR5lFn+K+KzaKSH/JvFyxqU733YvamjqOrP7+9hPmvONHjneoQ8N0DGqKsAMJrNFBVPPzySwZ+qN6IL76Mb8g1hUfs/pPZqlr9o9mvIQqeU8F4O8NGDTDpadTBKvizoCz4FvHtaTy6YA2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786463334; c=relaxed/simple;
	bh=o2iShmrkG9bCkMfF1J2nhbl+x344ezuL1VBUZNbi6Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnqyW8Qips7UX3t4qclE6Vp1Zit4SOqzQaIbBTjuUaQXpnaF0jXn0RLwcx5dlBEJ85ulObttxcMZUbOheZRwMDjYzBD6Dc3NiUesGFLEFVXukJG4V2nMqLme4LPT9RpyfemIFDMQFksLOwq//U5WHb/OBxzr/13/JiShzQnHsdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PS7/9i0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PS7/9i0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FD01F000E9;
	Tue, 11 Aug 2026 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786463333;
	bh=MvzCYoEwQ9LzwfYHAfIi4M2yoiffcUsq5YQfwmVeJA0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PS7/9i0yc2JTvnI5xsv5AlO/tbaDB+okdgx7E/4diawngWJCOROPTwSdphUJtVI+t
	 zladpMFrOkJTdnPReyjASnfW2U88/sOd52FoMwUzQqzs8zKit5Mlx2eUFw1UVqaF6p
	 U4Y1WUX2FgccLXLhPhlBPzBRr7ayEGus6ZlRzbncJs3Ix+ajRrrmyZwnx+tugOqE56
	 xKRQvOO3PzdbdnATvhEHCXg2VKaLo1O5vbwFrQDkOuNiRMpX310WopDzoo1xJk9N3w
	 6rjA6zUJhf09I9DzIIOPslj+PYcEl5D8sOXPEDZeN1mreriPu5S5AZtU3Kljrz6t9W
	 R4a92bDPLM/SQ==
Date: Tue, 11 Aug 2026 08:48:51 -0700
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
Message-ID: <20260811084851.628260bd@kernel.org>
In-Reply-To: <6378f6171d10af5593be06ca5d0c63f885323ce6.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	<20260804083535.2946459-13-tariqt@nvidia.com>
	<20260807175858.70a717d6@kernel.org>
	<51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
	<20260810133305.3b7448c8@kernel.org>
	<73586539333ece6aff68ff29f7e43ceb59e7b581.camel@nvidia.com>
	<20260811075104.0fabe360@kernel.org>
	<6378f6171d10af5593be06ca5d0c63f885323ce6.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2026 14:59:26 +0000 Cosmin Ratiu wrote:
> > > I'm sorry, but the code is wrong.
> > > cmd() matches on n (which never changes!) but __consume() only
> > > decrements off. Strap a loop on top and the result is just
> > > confusion
> > > and a source of bugs (e.g. the one I'm trying to fix with this
> > > patch).
> > > 
> > > A single variable should be used to keep track of the length of
> > > data
> > > left to parse.  
> > 
> > and in your opinion that variable, which represents the amount of
> > data
> > left to parse is supposed to be called "off" ?  
> 
> "off" is clearly not a great name, it focuses on the offset in the
> buffer where data should be received. Perhaps it could be renamed to
> "len"? 

len would work, or we can stick to n?

> And then perhaps I can rephrase this patch as "Fix psp_responder parsing"?

ack
