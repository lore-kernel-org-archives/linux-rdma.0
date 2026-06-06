Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294C6250C06;
	Sat,  6 Jun 2026 11:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780744639; cv=none; b=bBY808DyqJFQDGqNfJcXL4jX6jGN7/qG48p7gtrKsLdn5O1GV5PM6UveBkTvC8DrloVYcvysI15yp0mfuVkFx8gShR6GXUcyeSNdQl2ogK0B97OTGPVvB2iFlrtMUucT8gqW3UDmQpZXQIg3voRT1MdXd7jwpqGXDZ+ihqESz6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780744639; c=relaxed/simple;
	bh=fSCOQ3CKhcQYybMNKWIvrSnwq+trdvcpaWJ6EQwwszI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjVZdM2jkXS0iPMQE22td1JK2yAII1kY2yHFNf5i9wjJRYybGPHcJo3Xqh+anK+HCGv+5p49EZk4I5ZA+O2vL/8ZBJtQgaRAs0n/nP3N+7tXbQBiq126gTVF/LL773SJgJyePgHA26R38K8pvYUAP1MADN5gCMDCHOrp9m70BbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hzfpoljS; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hzfpoljS"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id 3279620B7168; Sat,  6 Jun 2026 04:17:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3279620B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780744622;
	bh=E+DzoOgSVx4pkA7Iqw1GhA/F0mK8v9T/uwrmGwJZdzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hzfpoljS6WTZm6/KbuhY0O1GHZwtmvRWIWwKYKxmw4ntnGz+kj8G2okp9bkrlhFAG
	 UJHiOcYcjaVd/dElUcxq8zjUk49mKuGF3WfIBxUGT9ythc0cf/8XAi4nW8bIm1dZ+G
	 WikbRWMluzCyPtli6krnLhX/f8WrvTJ2Cz0RfUDo=
Date: Sat, 6 Jun 2026 04:17:02 -0700
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	kotaranov@microsoft.com, horms@kernel.org,
	dipayanroy@linux.microsoft.com, kees@kernel.org,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Cache MANA_QUERY_LINK_CONFIG result
 to avoid repeated HWC queries
Message-ID: <aiQBronIOEl4V5R5@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260528180757.1536640-1-ernis@linux.microsoft.com>
 <20260602132127.25fc27ee@kernel.org>
 <aiJeuU3DLKL7JcPN@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260605161315.26784677@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605161315.26784677@kernel.org>

On Fri, Jun 05, 2026 at 04:13:15PM -0700, Jakub Kicinski wrote:
> On Thu, 4 Jun 2026 22:29:29 -0700 Erni Sri Satya Vennela wrote:
> > I tried two netdev_lock-based variants. 
> > 
> > mana_query_link_cfg() has four callers:
> > 
> > 1 ethtool ioctl/netlink			- has RTNL	- has netdev->lock
> > 2 sysfs speed_show/duplex_show		- has RTNL	- no netdev->lock
> > 3 netvsc_get_link_ksettings VF forward	- has RTNL	- no netdev->lock
> > 4 mana_shaper_set			- no RTNL	- has netdev->lock
> > 
> > No existing lock covers all four.
> 
> How fresh is your tree? The just-minted commit 9f275c2e9020 should
> address the gap, I believe?

Hi Jakub,

Thanks for pointing out the commit 9f275c2e9020. It does close the gap.
My analysis was against a tree that predated it but the commit landed
on net-next on Jun 4 21:30 UTC and my reply went out about an hour later,
so the rebase that picked it up hadn't happened on my end yet.

I've now rebased to current net-next and re-walked the four callers of
mana_query_link_cfg(). All of them hold netdev->lock by the time they 
reach mana_query_link_cfg(), and the race scenarios I described no longer
apply.

Thanks,
Vennela
