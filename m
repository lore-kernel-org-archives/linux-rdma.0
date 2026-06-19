Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6610C2F8E98;
	Fri, 19 Jun 2026 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859922; cv=none; b=BGw/GZ69vRDONXnjVRmo7nBHaepi8G3B6VZZB5nEmYHdZK4hfd5huptjtM4lMvCABhRQ2S1rk99lwUlt+RZKvSNBFAVlTnnuN9pDk0vE6gRFvc3QmRJLNYp51HCNexY4lsch+qW6An79YDIZxEzS6xtgzqP0Ejx1C+rHKLLPC2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859922; c=relaxed/simple;
	bh=Y6gJkW+SMdPt4P0WObWk8jXzSDQ8tLBAMqzt6Zwp6kI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faSKyPf/oL8QMyOTfc6Z1t1F3jR6MmoLWALx9aFIv21YW8eBvxlih7m6xAITqWCglqrcKBhGY0naZnktHLy+yfI5fMU93B3m33w1bd9+x2EDtBsPCQM2GvlSEPn3xbQcwjAnHSOz/ZYqRCT5pdnNg3/r94ougw5sEOpzhVoTUDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+IESCsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+IESCsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618791F00A3A;
	Fri, 19 Jun 2026 09:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781859921;
	bh=32w9dxrk/QVTrzVo27ewIaHHRflbbYBLF2NEwB58Tvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H+IESCscotb71bLxleLrr5NhbRv3opRbYRt6AbQJS/8NCONBqWVUM9jujZL64JVtg
	 QAZcOcHMV/jf8NZYaMU6IdBaRY+yGusO0bxKCRai0jDganpc8w5aVWDmUXHkWYFr9x
	 7PvhDXWiOuUCiqiHzGhHLv01X7yj+GQYjHfdwNoA32Oaa2vuTYhka2WYjhbTVuAKBx
	 OvQOjXAe0XL6t8mZ356TuZrC3dsX5fvDimTWAcGDSLX6/eJEXiGmCMA+9Onf3Dx5oL
	 jsIAAL8f/u8/CKEx6YuEA5X0wvf2inNwu4t1HtwPNW5sD1Mlxu/OhVFsVuaebCzH+K
	 fD9fT0HisWwew==
Date: Fri, 19 Jun 2026 10:05:14 +0100
From: Simon Horman <horms@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	kotaranov@microsoft.com, ernis@linux.microsoft.com,
	dipayanroy@linux.microsoft.com, kees@kernel.org,
	jacob.e.keller@intel.com, ssengar@linux.microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Sync page pool RX frags for CPU
Message-ID: <20260619090514.GT827683@horms.kernel.org>
References: <20260618035029.249361-1-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618035029.249361-1-decui@microsoft.com>

On Wed, Jun 17, 2026 at 08:50:29PM -0700, Dexuan Cui wrote:
> MANA allocates RX buffers from page pool fragments when frag_count is
> greater than 1. In that case the buffers remain DMA mapped by page pool
> and the RX completion path does not call dma_unmap_single(). As a result,
> the implicit sync-for-CPU normally performed by dma_unmap_single() is
> missing before the packet data is passed to the networking stack.
> 
> This breaks RX on configurations which require explicit DMA syncing, for
> example when booted with swiotlb=force.
> 
> Fix this by recording the page pool page and DMA sync offset when the RX
> buffer is allocated, and syncing the received packet range for CPU access
> before handing the RX buffer to the stack.
> 
> Also validate the packet length reported in the RX CQE before using it as
> a DMA sync length or passing it to skb processing. The CQE is supplied
> by the device and should not be blindly trusted by Confidential VMs.

I think this last part warrants being split out into a separate patch.

> 
> Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

...
