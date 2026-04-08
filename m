Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB42F3624D3;
	Wed,  8 Apr 2026 02:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775616910; cv=none; b=cN1n47abb/tENlFAKPzYA0pRgVu8FuLlP2Y4R+gnnsb+MlKS8VG5hS5F4kwc/F0gQFOR8HS+WaEnL/TY91tWi/GajiSYSPV/I4A4yV9CjFYuRAk9kYuMG6q+/X9usYvpV1wbOw3woCr9IF+hL4PRmrCZNMduLCipr+xp+621UBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775616910; c=relaxed/simple;
	bh=wmAOs9XJh4ziApC5SLGMiJtDFYL0cuNyEF98xXNt+DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1549sHsSrxn15FYNeGWl1MtRkJLPSoqWU2EAAzhXY1fNZicLqziNCCreFDkVCwq+DwwOsmBWcQKIED1hBViiF4ya8qcsiZPYy2jkW/6+JJ1PVxzHr8/F19teNdxTevXKp/6SKIbbbe9dzYFWOwGGslYMxde95dTKj0yFmFwyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bFjt2KCF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bFjt2KCF"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 8E33620B7128; Tue,  7 Apr 2026 19:55:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8E33620B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1775616908;
	bh=tvnLjFUq8zggoXE4pCPWv5YdNILg71v4/gJOkvRpX0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bFjt2KCF05TXatIoSlAnJPoHFFdyqW81J6X0N4mva8UgMTMlX+BF6hH+wnZ44sdKB
	 qqpBOgWGVulnI1Q+i3m6F+EMXxUo/k9EfDJ2YEo6OPRhIoOEC/86HTjFKpwvHiuQAe
	 TYOjdej5e3HnghNgsMk7ERYs/wySWzvAIbWLp9AU=
Date: Tue, 7 Apr 2026 19:55:08 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>, kys@microsoft.com,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, leon@kernel.org, longli@microsoft.com,
	kotaranov@microsoft.com, horms@kernel.org,
	shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	stephen@networkplumber.org, jacob.e.keller@intel.com,
	dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org
Subject: Re: [PATCH net-next v5 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <adXDjGN0rcahx+wt@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <adHaF6DloRthctRb@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <e80b603d-8be0-4aee-8a31-c9cbb4a8ab00@intel.com>
 <20260407185128.605dcacf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407185128.605dcacf@kernel.org>

On Tue, Apr 07, 2026 at 06:51:28PM -0700, Jakub Kicinski wrote:
> On Tue, 7 Apr 2026 15:10:45 +0200 Alexander Lobakin wrote:
> > > On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool 
> > > fragments for allocation in the RX refill path (~2kB buffer per fragment)
> > > causes 15-20% throughput regression under high connection counts  
> > > (>16 TCP streams at 180+ Gbps). Using full-page buffers on these  
> > > platforms shows no regression and restores line-rate performance.
> > > 
> > > This behavior is observed on a single platform; other platforms
> > > perform better with page_pool fragments, indicating this is not a
> > > page_pool issue but platform-specific.
> > > 
> > > This series adds an ethtool private flag "full-page-rx" to let the
> > > user opt in to one RX buffer per page:
> > > 
> > >   ethtool --set-priv-flags eth0 full-page-rx on  
> > 
> > Sorry I may've missed the previous threads.
> > 
> > Has this approach been discussed here? Private flags are generally
> > discouraged.
> > 
> > Alternatively, you can provide Ethtool ops to change the Rx buffer size,
> > so that you'd be able to set it to PAGE_SIZE on affected platforms and
> > the result would be the same.
> 
> Actually, hm. Now that you spoke up I wonder how much this is
> an inherent ARM problem vs problem in whatever ARM Microsoft's
> management empire-built themselves into.
> 
> Do you have access to any ARM servers? Google says GCP offers ARM
> instances with idpf NICs. So if idpf benefits from the same
> "tuning" we should totally push for a proper API not priv flags.

Hi,

Sharing an observation from earlier, with a different ARM64 fabric/platfrom
when configured with base size of 4Kb and the smae MANA NIC, did not show
this behaviour. In fact, it showed better performance with page fragments
in single as well as multiple connections. Thats why initial version this
patch we wanted to apply the work around only to this specific chip where
the issue is seen with page fragments.



Regards
