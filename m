Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AD71E8342;
	Thu, 21 May 2026 00:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779322628; cv=none; b=qmyikhRZnZzLq0Z4lbDlyOLYmSta0KQq9X+9Wmfs4kdifKwlCCfrTjBeNkin+SOM+vjbGOgazIvqhnUu+TeKh1UuYowhLYU14ZvnCrydDK5iipc7JdfzD7WxUTt9TLXdM9tOVSUOPoLXpLl7piZ9C22GIU6ZikGE3Oqij24wDlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779322628; c=relaxed/simple;
	bh=9xQyMzRJDgjOsefu5RYTSnP5MQ/1ObcFiMsvdejp5ms=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fC82iRipcxvfCnux1QNoUL+5QP+s2NExsZRwtVZUPBmXmGs0kKCNyiQaS2j2wGR8+rBgBqlq+k/70tEFNWL+AI4dVUF18A/ZU+rXbaqqabzp4eprxv2WHVYkBBDGUtzIc4Io5EFsqDgrFHCMiiNABx8I4eDVc/FqHn0qJ0fEmzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcsaiMWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcsaiMWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCAC1F000E9;
	Thu, 21 May 2026 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779322625;
	bh=MFWnW8FG7FPKHLVohR1ScLZecv9inExETb+L71ZQhq0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NcsaiMWO3+TfDhFPX38AQ0QkCqwNQxSzpwYSdvZ01lVDAVksWUP6tp4njVyJ72dTu
	 /s4M+Zg9kIWs0UGDvHLB/RJClNVfgcMxmcAlX2ZQNf+ucBgqdDuejvSq30wpvt6muY
	 S89S9gvlcMsYJyTrDmjUczzZufmj0sFni/JwnCPEVE/n4nJR7PKZNariSMkdVDoOHW
	 AtzAU+erRvqXZuqG71RL9qjv4FdAt82AFIlrqxbdkRbjUoeb17/UIuViYB3K0czR4N
	 4J6k6jmHHprdU2xGcWQlxFQboRBgSvOdbfcV2ab8q05tLg43gaAX4Z7qG2QGJ9h7nP
	 YIlNwPWFV70OA==
Date: Wed, 20 May 2026 17:17:03 -0700
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
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com
Subject: Re: [PATCH net 2/2] net: mana: Skip redundant detach in queue reset
 handler if already detached
Message-ID: <20260520171703.689c5462@kernel.org>
In-Reply-To: <20260518194654.735580-3-dipayanroy@linux.microsoft.com>
References: <20260518194654.735580-1-dipayanroy@linux.microsoft.com>
	<20260518194654.735580-3-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 May 2026 12:43:51 -0700 Dipayaan Roy wrote:
> +	/* If already detached (indicates detach succeeded but attach failed
> +	 * previously). Now skip mana detach and just retry mana_attach.
> +	 */
> +	if (!netif_device_present(ndev))
> +		goto attach;
> +
>  	err = mana_detach(ndev, false);
>  	if (err) {
>  		netdev_err(ndev, "mana_detach failed: %d\n", err);
>  		goto dealloc_pre_rxbufs;
>  	}
>  
> +attach:

goto's are acceptable for error unwinding, not to jump around 
a function seemingly to avoid indenting something. Please use
normal constructs or perhaps move the netif_device_present()
into mana_detach() as an early exit condition? 

>  	err = mana_attach(ndev);
