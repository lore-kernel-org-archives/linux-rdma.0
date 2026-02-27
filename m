Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA05F1A9F97;
	Fri, 27 Feb 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772213244; cv=none; b=kip4qLwWw1EpD5k6b+Xfh9krjJCpBQc7l+sZu1XIcxzZR1CEdXAYMp/aoF4iJmYbSbggzw5Ze+pr3xw0pMv8i5uIvYmnj9qFeauID0yvIJ/g3IikikQ/4KFThx+DL4XDPPyIdXYyU9Mu61719pwU8UTs2RPOuikvETdqdCQpeM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772213244; c=relaxed/simple;
	bh=IJ+BBVdKhAP+TZoLok4yBljAvJQMpgNSK0P0c4KWz1c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sapjizh9N5unMDFPXrkJ1FzcXhdCTSTEFeGOMhJYYp4Eaa8pUsTSCCdNv3IyM0556sib6f5/uoc5YXhjk+DB1u+o83Zl1yioo/GrNZIEUDa6rGJH25ZPu9Rt84DWFVd99CASSYVa9rN8I9iOg9KlptH1YEyOlungCE1o4p1KcGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwh+Nn5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwh+Nn5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71834C116C6;
	Fri, 27 Feb 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772213244;
	bh=IJ+BBVdKhAP+TZoLok4yBljAvJQMpgNSK0P0c4KWz1c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fwh+Nn5PMf45PAEQX9HUcB9FzPs/7tQHQRBx4yQ21R1yGJW4HaaKU56+XWZCMNu+c
	 lVSvdrdqhZdJb468TyW04Xco5HruQaK/E7tWp16vRc1RMPyy/SAyDDs8yoVurs8I4J
	 cign18Vxx6IoOi1VsjOrLt5cfrgHsvagcQwDbxE6m6yMyHW9wiWF3k5XuEe5VWlPV5
	 zQD1k9i0FnBvIScvnOjm6mDMcYAeYeqSNYx/NRjzAXEnxpQFxoKl/JWuxLPob40ZCf
	 eAR4gmu4apM3B8mIkADoR2pEKbD2h65veQjLUX5q4kqL+A/Z+lGfXZ1nVfSgZQ9RAC
	 sd90UqBqkD8Fg==
Date: Fri, 27 Feb 2026 09:27:22 -0800
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
 dipayanroy@microsoft.com
Subject: Re: [PATCH net-next] net: mana: Expose page_pool stats via ethtool
Message-ID: <20260227092722.50a7e45f@kernel.org>
In-Reply-To: <aaFmRqjjOuPIEo5x@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aaFmRqjjOuPIEo5x@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Feb 2026 01:39:18 -0800 Dipayaan Roy wrote:
> MANA relies on page_pool for RX buffers, and the buffer refill paths
> can behave quite differently across architectures and configurations (e.g.
> base page size, fragment vs full-page usage). This makes it harder to
> understand and compare RX buffer behavior when investigating performance
> and memory differences across platforms.

Standard stats must not be duplicated in ethtool -S.
ynl and ynltool provide easy access to these stats

# ynltool page-pool stats 
    eth0[2]	page pools: 44 (zombies: 0)
		refs: 495680 bytes: 2030305280 (refs: 0 bytes: 0)
		recycling: 100.0% (alloc: 7745:2097593009 recycle: 379301630:1717888312)
