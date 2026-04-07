Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BF63B8958;
	Tue,  7 Apr 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570080; cv=none; b=bjOMTrkJZQSsfDvQ5m2X27reXXpxw8qvIlDCKsU8JgNXoKtLzDA1H5IpDluXZfzuta+/kRF0wto4+X0XF0qgqVMpCYCEdsQjQr2VzvUC4aWwJ0OeFWjL5BiyDnQvl/c0Uz4BMy0DBB+TOiqNy6FiD78mRV1jEjpXLWKU+iA3MN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570080; c=relaxed/simple;
	bh=O1PydtrZmxFy8rB689FjQ1ywOSEusWCJPTtvtLeKIaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVGr7vES5kPDoS95GxhFRzdwaGkW8yanLzoB1dhFVgIH14Hc8XJUBuiQ78gXXuuEHiIHxqNr5unyyI0xsTz6dcbko7xzmWUfYvBpQWuClbQXKqw7zOu+imWs0oRy1rSJKHPxMuWs8A5/w5o54579S/F9QJrTPj6dhNAMY9FQpVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=At3ZclNL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="At3ZclNL"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 45BA520B710C; Tue,  7 Apr 2026 06:54:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 45BA520B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1775570077;
	bh=olc/L9k1GWNZLE0TYLsQ/fNujwydX/8pxnCvYO6B1zY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=At3ZclNLRsBqpFzVIwcKB95e83TsP95E/4TYosQBjXa8rPnw9ct+InVgvdx4hlB9T
	 0L1YtB5Xemq8qADi5/M4BhIL1S4UK2nWJQJ2LecdnXf12cVWqwQiObDUcuQ1buiH3H
	 h5tT/gSzEbkVVxqLJkAVrWafd3TUKR/6vnSormag=
Date: Tue, 7 Apr 2026 06:54:37 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	leon@kernel.org, longli@microsoft.com, kotaranov@microsoft.com,
	horms@kernel.org, shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com, ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, stephen@networkplumber.org,
	jacob.e.keller@intel.com, dipayanroy@microsoft.com,
	leitao@debian.org, kees@kernel.org
Subject: Re: [PATCH net-next v5 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <adUMnWHybqX+4aG5@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <adHaF6DloRthctRb@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <e80b603d-8be0-4aee-8a31-c9cbb4a8ab00@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e80b603d-8be0-4aee-8a31-c9cbb4a8ab00@intel.com>

On Tue, Apr 07, 2026 at 03:10:45PM +0200, Alexander Lobakin wrote:
> From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Date: Sat, 4 Apr 2026 20:42:15 -0700
> 
> > On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool 
> > fragments for allocation in the RX refill path (~2kB buffer per fragment)
> > causes 15-20% throughput regression under high connection counts
> > (>16 TCP streams at 180+ Gbps). Using full-page buffers on these
> > platforms shows no regression and restores line-rate performance.
> > 
> > This behavior is observed on a single platform; other platforms
> > perform better with page_pool fragments, indicating this is not a
> > page_pool issue but platform-specific.
> > 
> > This series adds an ethtool private flag "full-page-rx" to let the
> > user opt in to one RX buffer per page:
> > 
> >   ethtool --set-priv-flags eth0 full-page-rx on
> 
> Sorry I may've missed the previous threads.
> 
> Has this approach been discussed here? Private flags are generally
> discouraged.
> 
> Alternatively, you can provide Ethtool ops to change the Rx buffer size,
> so that you'd be able to set it to PAGE_SIZE on affected platforms and
> the result would be the same.
>
Hi Alex, 
This was discussed here:
https://lore.kernel.org/all/adHTm2SvjDrezEdv@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/ 
> > 
> > There is no behavioral change by default. The flag can be persisted
> > via udev rule for affected platforms.
> > 
> > Changes in v5:
> >   - Split prep refactor into separate patch (patch 1/2)
> > Changes in v4:
> >   - Dropping the smbios string parsing and add ethtool priv flag
> >     to reconfigure the queues with full page rx buffers.
> > Changes in v3:
> >   - changed u8* to char*
> > Changes in v2:
> >   - separate reading string index and the string, remove inline.
> > 
> > Dipayaan Roy (2):
> >   net: mana: refactor mana_get_strings() and mana_get_sset_count() to
> >     use switch
> >   net: mana: force full-page RX buffers via ethtool private flag
> > 
> >  drivers/net/ethernet/microsoft/mana/mana_en.c |  22 ++-
> >  .../ethernet/microsoft/mana/mana_ethtool.c    | 164 ++++++++++++++----
> >  include/net/mana/mana.h                       |   8 +
> >  3 files changed, 163 insertions(+), 31 deletions(-)
> 
> Thanks,
> Olek
