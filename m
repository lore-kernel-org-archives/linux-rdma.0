Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADE637187C;
	Mon, 27 Apr 2026 23:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777331952; cv=none; b=OoBHzevVzrD9CIpjs1JMbqKzcaGhYbAqFgaV+NGv7etfC5FNephm+m0AUdBReOwrdi5bpo1Xq2S+842OONNlgK4bEvZz+pDJf3W+CZojwxA5fpFfTQ7b/BsCWCh+S7Fy9hH+tiP2lfKfBa4DMSbIjbFpQp3MBJ4BB1SWE8Iml3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777331952; c=relaxed/simple;
	bh=fl6jiyndXGosxRIeiSSRWVpzK52bfTzdd2/+Tk1yp0U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9UNPDB47shc2tbL2PWCUhGRMd2YJpBwoPLHa/1CHkzc15l8IvQBIDWegEANTzRQLBZiqVPp3fG0tLCUbnV/bJOlRc3bwewSWIe6NYUqOVZSb2iVXxtZ9D1uX6i+rLKQKVN/ejMxA4L6qbiFE4s/KZmLnEgRYNN1FKxQYEWyiN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5kT8ebW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5kT8ebW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAEEC19425;
	Mon, 27 Apr 2026 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777331952;
	bh=fl6jiyndXGosxRIeiSSRWVpzK52bfTzdd2/+Tk1yp0U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P5kT8ebWjDPSav/4EQ9IMNKp2IQ1OFIkVE5zpPqH0pTQPLcf2zAdRUwbm0qnyekQg
	 GP1CwPng50NEL0GgCm7KHcojyJE2JM34/SbHYKeKCmBGJY8GioBnEyEqxoxEDCkVrN
	 VIzoJWKlT8dg/NMOGlfw825iHNPqtEZketkChtwJmEe3XbAvwUI8TQUQ1c1SusBj/U
	 gQHhKezM68/O7Xa1+XRY5Pr9QNEiJJWg3rmTafTNQ8yuvP789/CUUoHz0pnxop2VFZ
	 +viqeDgiQBLVfDcyFuijvk9CEWK+MZSk4oBNQw4qb+hl6Qm1/zv2w2ZFhwtbKrDNRx
	 ShfMUWXXcnd1g==
Date: Mon, 27 Apr 2026 16:19:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aditya Garg <gargaditya@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ssengar@linux.microsoft.com,
 jacob.e.keller@intel.com, dipayanroy@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com, kees@kernel.org,
 sbhatta@marvell.com, leitao@debian.org, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, gargaditya@microsoft.com
Subject: Re: [PATCH net-next v2 0/2] net: mana: Avoid queue struct
 allocation failure under memory fragmentation
Message-ID: <20260427161910.6b3cb5cb@kernel.org>
In-Reply-To: <20260427132807.1642290-1-gargaditya@linux.microsoft.com>
References: <20260427132807.1642290-1-gargaditya@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Apr 2026 06:23:33 -0700 Aditya Garg wrote:
> The MANA driver can fail to load on systems with high memory
> utilization because several allocations in the queue setup paths
> require large physically contiguous blocks via kmalloc. Under memory
> fragmentation these high-order allocations may fail, preventing the
> driver from creating queues at probe time or when reconfiguring
> channels, ring parameters or MTU at runtime.

net-next wasn't open yet, when you posted.
Please resubmit in a couple of days.
-- 
pw-bot: defer
