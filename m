Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F3B246BD5;
	Tue, 16 Jun 2026 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781569998; cv=none; b=Vo4knd5/XLyUw9NkQ3UwKlEpABxcC1BwR313RkQaFUziIbGB8Cn9PSJf338RXzNN8suZdiDeEJRu+CObxZIb34uERpEGF5mjzn3d2pjwdAFsEXT2/2Epn8HmCq+Rc7QZ5eLRpr8cO/vMVdKCFGsmx0bZYhE9iVdMns8eVJMNYCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781569998; c=relaxed/simple;
	bh=QFvD9jCjp9gdZIph8m4xgZh7pDD+9ZFFbGUYFuhiEWs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yy5mS0AOcPTlchnYdxoBypQkh+7B+rir8V7dSXjj2FxGVAxMKJELbZAxg8/JW0TSxif/MSlgGs0rIA88URE71Ah/4hTUhSQfacJxxUlwB78QnCQZ4Od3sGrPM519A5hyPO7N0uee/8p0hIz1USIqoPUkVqM0ffiGy1D43rlHa0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klHL2vIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klHL2vIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669E81F00ADE;
	Tue, 16 Jun 2026 00:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781569996;
	bh=+K/IMa8F/ssrDKZahEBsAtE1o+3QX5n+1ZUkmyJ5JfM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=klHL2vIwvcs/MnUgaLhac22PWlRE86KB4RGM1bRHf97EKGcUFeSH7/rorig1QKRN3
	 DegjygYckV7WGqY5I/qVXxUtLGJDzaPDMpT6Io/RxMZ/xIQhR1c+9LERlm1Nj5E2y0
	 5ihUWyx4lA1h/siPOvbEpSkqABqjx7AerYQI+jWfsHfFC1bbErp8JwN2WU6z1uYicS
	 emBjXBGzBTXfg6qRflO/L83hTdmpIxGWuqCSpffd2R8ogAz2d3O/FXerYGQ+OcRLZy
	 epq/PtKr1lD7mC6/xmMU3QjTIiiKq2Wj/j8Rk09O2M0+PeXGE6sGGWHuRCBMyl56Yr
	 iAxNAB6rdI4Sg==
Date: Mon, 15 Jun 2026 17:33:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com,
 dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
 john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
 yury.norov@gmail.com, pavan.chebbi@broadcom.com
Subject: Re: [PATCH net-next v10 0/2] net: mana: add ethtool private flag
 for full-page RX buffers
Message-ID: <20260615173314.677c33a8@kernel.org>
In-Reply-To: <ajCXIpDVaVcUcQwd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260602202801.1873742-1-dipayanroy@linux.microsoft.com>
	<ajBRwYftEol8IE49@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
	<20260615134247.0bd7e16e@kernel.org>
	<ajCXIpDVaVcUcQwd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jun 2026 17:21:54 -0700 Dipayaan Roy wrote:
> On Mon, Jun 15, 2026 at 01:42:47PM -0700, Jakub Kicinski wrote:
> > On Mon, 15 Jun 2026 12:25:53 -0700 Dipayaan Roy wrote:  
> > > Just a gentle ping on this series. The approach was agreed upon, and it
> > > has picked up a few Reviewed-by tags as well.
> > > 
> > > Please let me know if you need anything else from me, or if I should
> > > resend it to collect the tags.  
> > 
> > Don't recall now what the exact sequence was but pretty sure this 
> > no longer applied after some other mana series was merged.  
> 
> I see, the net-next is closed now, I will rebase and resend this
> once it opens on June 29th.

Sorry for not flagging this sooner, IDK how it escaped the reply.
Maybe some mix of Jake's comments plus it not being applicable 
later.

Not to deflect blame but y'all should coordinate better, the "no longer
applies" situation happens in mana a lot more often than with other
drivers :(
