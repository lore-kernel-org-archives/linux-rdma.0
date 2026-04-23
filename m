Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2898337D137;
	Thu, 23 Apr 2026 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776962251; cv=none; b=O3L75rAApkcx36MovBENvcEM6rWs/+DV2C2EBzKC0/4BW9uoHFqa3kxgH0y3jhP//qq/QONixNh/9AdkYOG1EYAFxlk2QyF+tC3zBYN+TWfk2Mqke3jpt/5wy38ZD6Nru0jBxTmGIHjMl7OWF87W/A2kb3nIAzQ9OFHwLbysqEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776962251; c=relaxed/simple;
	bh=tvZ308WD3VglOQ4pZ/aOKmGXAoRvJXyRkk4hEefUg4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I63AayPzDMZjFpX9YvSPcjxesX+p7TgUdybJ5E7J22iuZX6tic7PUx6AU0lsMM6N3/Hg+UOf5V68YHGqLVeYFkMui9CPa3AmqhX51AHu1UL94ppzIDnFF+Erwn3hRDWtLN/uojmFSgdtthbRgrmqN/H/4c9U6kgbOkgGLjkr4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=FD44ZvXi; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="FD44ZvXi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=LkCXysjBxUfLMfJbaiV8vjoVUfydT3ARl3itfoUFp4Q=; b=FD44ZvXicW/rgxPLhXFwtborg8
	/DrbMf4pt1scblPA+hI/VnepbMyiSR/+AGVCBzLQ7WmWVzv5kw/U5X/p9hDlbKYKbykshRiwd00SA
	kwTlCK1y8S0yhWDTAp84wG8oTHDmQkSZRfcCgQ5wTb3KpMuIQMzxv3Nxth2joIpYeSA0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wFx32-00HGkD-IN; Thu, 23 Apr 2026 18:37:04 +0200
Date: Thu, 23 Apr 2026 18:37:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
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
	leitao@debian.org, kees@kernel.org, john.fastabend@gmail.com,
	hawk@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
	ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com
Subject: Re: [PATCH net] net: mana: hardening: Validate SHM offset from BAR0
 register to prevent crash due to alignment fault
Message-ID: <edccaafd-73f3-421d-a48e-a6cb704d39e6@lunn.ch>
References: <aepF3NwyANeklkfD@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aepF3NwyANeklkfD@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

> The root cause is in mana_gd_init_vf_regs(), which computes:
> 
>   gc->shm_base = gc->bar0_va + mana_gd_r64(gc, GDMA_REG_SHM_OFFSET);
> 
> without validating the offset read from hardware. If the register
> returns a garbage value that is neither within bar 0 bounds nor aligned
> to the 4-byte granularity, thus causing the alignment fault.

Is GDMA_REG_SHM_OFFSET special?

What if GDMA_REG_DB_PAGE_SIZE or GDMA_REG_DB_PAGE_OFFSET have returned
garbage? Are you going to die a horrible death as well?

Isn't there a way you can poll the firmware to ask it if it is ready?

And what about the PF case. Can GDMA_PF_REG_SHM_OFF also be garbage?

      Andrew
