Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9511B4F2C;
	Sun, 12 Apr 2026 12:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775998205; cv=none; b=HifRRAxy5B3CeKcDMGUnZTNj25WnsARGaYKLv1W1rfZIY3S/LmwuuwKbIdhv1Dvky4Ma/jlYPW793MxbH/kb2v3LoXQnr8IaH30BPla7wZGfKBj6bNDuNf/2TBvHjeEHOHIdJBeVBG2+cEoZSDVA19p4HWBz3y/c3smA3u2XNLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775998205; c=relaxed/simple;
	bh=cbC6PZSXYKpThgPVPXKvotKY9vK1A+vj+Eg9/VR8KXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/JoYk+VFRlFN4RxU9oeZ9IgooRNjiukjEy0rpTiqDqHFq485K7Enf9/J1eF8hFdJ5OrfDdxN4gbcJQhJCHJfG4yAQPUMoogytAhxvCuBn9nxm2gf6k6wujIRXUN40mripPbrKb6S+qTWJvzw3/TquJm6r5dPkZs8m1RTQ28RK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXZoEuOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXZoEuOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE702C19424;
	Sun, 12 Apr 2026 12:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775998204;
	bh=cbC6PZSXYKpThgPVPXKvotKY9vK1A+vj+Eg9/VR8KXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VXZoEuOXPwbEtyYCBEl1GVBjV/PyvZcIavkVwmJtwptwlbdd6jkqxalo9FGyMJQcA
	 qjdMG5GvABpwrrnWaW1owSP0ECHnt3PKmeWlqzTfMEj/JwDGph5wBj39X+aPGi0AyJ
	 bpTfTcTqgmo/fnGJ9yrOX8ynWxdhgIl+S+Wym5ZpQ8pkVw3LeMAeRpwa9GGLrARtg6
	 xq04TeJAgHtR7lOtTaasb5FhcwyAdsJZkXiVoieKAmqToP7WtjD1eImPxIpnoVzw0O
	 GyoeW4K/cHxNGElU8SJ/M+8ww0Hw+1UOdyHGrr9S0CaIWOnigjzT5T9SpTX7OuHWYo
	 XMEnE9SFao2BQ==
Date: Sun, 12 Apr 2026 13:49:58 +0100
From: Simon Horman <horms@kernel.org>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kotaranov@microsoft.com,
	shradhagupta@linux.microsoft.com, shirazsaleem@microsoft.com,
	yury.norov@gmail.com, kees@kernel.org, ssengar@linux.microsoft.com,
	dipayanroy@linux.microsoft.com, gargaditya@linux.microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: mana: Expose hardware diagnostic info
 via debugfs
Message-ID: <20260412124958.GH469338@kernel.org>
References: <20260408081555.302620-1-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408081555.302620-1-ernis@linux.microsoft.com>

On Wed, Apr 08, 2026 at 01:15:46AM -0700, Erni Sri Satya Vennela wrote:
> Add debugfs entries to expose hardware configuration and diagnostic
> information that aids in debugging driver initialization and runtime
> operations without adding noise to dmesg.
> 
> The debugfs directory for each PCI device is named using pci_name()
> (the unique BDF address), and its creation and removal is integrated
> into mana_gd_setup() and mana_gd_cleanup_device() respectively, so
> that all callers (probe, remove, suspend, resume, shutdown) share a
> single code path.
> 
> Device-level entries (under /sys/kernel/debug/mana/<BDF>/):
>   - num_msix_usable, max_num_queues: Max resources from hardware
>   - gdma_protocol_ver, pf_cap_flags1: VF version negotiation results
>   - num_vports, bm_hostmode: Device configuration
> 
> Per-vPort entries (under /sys/kernel/debug/mana/<BDF>/vportN/):
>   - port_handle: Hardware vPort handle
>   - max_sq, max_rq: Max queues from vPort config
>   - indir_table_sz: Indirection table size
>   - steer_rx, steer_rss, steer_update_tab, steer_cqe_coalescing:
>     Last applied steering configuration parameters
> 
> Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> ---
> This patch depends on the following fixes submitted to net:
>   - "net: mana: Use pci_name() for debugfs directory naming"
>   - "net: mana: Move current_speed debugfs file to mana_init_port()"
> Conflict resolution may be needed when net merges into net-next.

Unfortunately this patch doesn't apply to net-next,
which is a requirement for our workflow.

-- 
pw-bot: changes-requested
