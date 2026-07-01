Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0E9330D43;
	Wed,  1 Jul 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782916179; cv=none; b=HOZdHEqBKxaCDGYZ/yf05OWPgJoG7ZUkkHKsFyhftSI18gNk5p9BALaIDijiCE5tTo74iIQLnBO6EArqiyogC/1gnZtbE8abEAnoLi2kzvrGpPpihsZPPeAbWvogOzCR1ZHVvexhl2sGoWTA9cKnE+vqPPvfSQHOt/zvCjjTFgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782916179; c=relaxed/simple;
	bh=e9zG2J/6CtdG9sjGYRXm1SrI6+g1Ut9XvKMQhA1bYmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbnJj4dfTDyZ2ZIZRbJo05bq7wwuGXNNXC9Iq4c48OfurYe47xTcCw3ExRlJEkOVEhrCO4wdGxsrlkDm2OZUg5jE4DrzEpDvNj2V1Otb8UsAc++1Hi/g9ncbiev8slCchaU/pcyBrsAS3fiuJ9tQXAGN/+n5MwkFQEaGUdfuIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Yg7NZpNh; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Yg7NZpNh"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 6968F20B7166; Wed,  1 Jul 2026 07:29:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6968F20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782916177;
	bh=TuyXNNDkjGNekj9kasMP1vdYOegRSZ1Lu0MTl3ivfaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yg7NZpNhaMOocVoelqZdHjJCxfd5hjS25T7nWNlCwzs1y5cgpyXjbPY6Xm1zySWOo
	 AGmfgQmaaVX/xd4Y8fQ//w/DkYHAnqM8T5WRPjB5kWmq26PcxtuW4pZMRrB4aQ3yKP
	 P711eBRlyu/iRbBcM5k7AYT6kqrUFVymte/yljL0=
Date: Wed, 1 Jul 2026 07:29:37 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
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
Subject: Re: [PATCH net-next v10 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <akUkUQodHuxZFUZV@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260602202801.1873742-1-dipayanroy@linux.microsoft.com>
 <ajBRwYftEol8IE49@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260615134247.0bd7e16e@kernel.org>
 <ajCXIpDVaVcUcQwd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260615173314.677c33a8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615173314.677c33a8@kernel.org>

On Mon, Jun 15, 2026 at 05:33:14PM -0700, Jakub Kicinski wrote:
> On Mon, 15 Jun 2026 17:21:54 -0700 Dipayaan Roy wrote:
> > On Mon, Jun 15, 2026 at 01:42:47PM -0700, Jakub Kicinski wrote:
> > > On Mon, 15 Jun 2026 12:25:53 -0700 Dipayaan Roy wrote:  
> > > > Just a gentle ping on this series. The approach was agreed upon, and it
> > > > has picked up a few Reviewed-by tags as well.
> > > > 
> > > > Please let me know if you need anything else from me, or if I should
> > > > resend it to collect the tags.  
> > > 
> > > Don't recall now what the exact sequence was but pretty sure this 
> > > no longer applied after some other mana series was merged.  
> > 
> > I see, the net-next is closed now, I will rebase and resend this
> > once it opens on June 29th.
> 
> Sorry for not flagging this sooner, IDK how it escaped the reply.
> Maybe some mix of Jake's comments plus it not being applicable 
> later.
> 
> Not to deflect blame but y'all should coordinate better, the "no longer
> applies" situation happens in mana a lot more often than with other
> drivers :(

Hi Jakub,

I have rebased and sent a v11:
https://lore.kernel.org/all/20260701141808.461554-1-dipayanroy@linux.microsoft.com/

Thank you for all the support.

Regards
Dipayaan Roy
