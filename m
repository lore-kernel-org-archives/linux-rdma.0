Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741991B3925;
	Fri, 20 Mar 2026 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774000560; cv=none; b=TPMqb5W3QOZ5oVe4Bq/ive9GgzxBSz80vgHGYgmJAO6fC7fXyRgc05Y17y/oHrI5/qdncU6+vBMUPKEsMGmnI0OQ2epFOsk2PalfPpzxTiCcR5moR8AoChBFHbKiwXjliSCPwyYhmmwZqIAT4Fsoy673TOW6aykBwirXZAl4oNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774000560; c=relaxed/simple;
	bh=623iNHEo9Lx3CTyFj1XQ3Tb8dZwfqVZ4nDlwLICOGOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNH0ddx1JDIE0ZFW9M83uXSS5PFuT+eHr4tviSE5gEjbPSu+/f9//aBJNbdjY0KgxMzn9gkwJQE+IB2B1zLTMd+y1FjcNoc2yLPDKiZDo42RtCe1KiMK6HgXHWs3qZpqZZ5fMKV2CTB6MeYPuvJ+RmS2pABkAvAAdrPtfi3c5Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUbg/8NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUbg/8NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1273C4CEF7;
	Fri, 20 Mar 2026 09:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000559;
	bh=623iNHEo9Lx3CTyFj1XQ3Tb8dZwfqVZ4nDlwLICOGOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cUbg/8NXG3OZ3aqDbbu0ZF7Xlgg/mMa1uVvBe0VVF9qJu14G6q5weqLBn/KJ0hXZl
	 fyhOqLwQvgE4h2q2K8SO9VdZCUZ2X6BOHS19VnEPmMPPJH8AgnOiN/qVJPwXODDOeA
	 J5n8etfF55U+uF7YWjon2CNadkoKWL/EGsGhL3swqeUyDXWwpvPiD+55O7EKsOFrAj
	 bxlOJlgB/wt6E6ICwceWIE/DykLmAhywBNAlxqePAA4F64y0VoJFvYqTZM4kaLrHva
	 H63o6SYyJdAELw7SVHMcAa1EVm8hVeMw0DNDTBHtnyjtQqwkpv4hC/owWgJcT2wsG/
	 L66DckitYpcKw==
Date: Fri, 20 Mar 2026 09:55:53 +0000
From: Simon Horman <horms@kernel.org>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kotaranov@microsoft.com,
	shradhagupta@linux.microsoft.com, shirazsaleem@microsoft.com,
	dipayanroy@linux.microsoft.com, yury.norov@gmail.com,
	kees@kernel.org, ssengar@linux.microsoft.com,
	gargaditya@linux.microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: mana: Expose hardware diagnostic info
 via debugfs
Message-ID: <20260320095553.GD1753385@horms.kernel.org>
References: <20260319070926.1459515-1-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319070926.1459515-1-ernis@linux.microsoft.com>

On Thu, Mar 19, 2026 at 12:09:13AM -0700, Erni Sri Satya Vennela wrote:
> Add debugfs entries to expose hardware configuration and diagnostic
> information that aids in debugging driver initialization and runtime
> operations without adding noise to dmesg.
> 
> The debugfs directory creation and removal for each PCI device is
> integrated into mana_gd_setup() and mana_gd_cleanup_device()
> respectively, so that all callers (probe, remove, suspend, resume,
> shutdown) share a single code path.
> 
> Device-level entries (under /sys/kernel/debug/mana/<slot>/):
>   - num_msix_usable, max_num_queues: Max resources from hardware
>   - gdma_protocol_ver, pf_cap_flags1: VF version negotiation results
>   - num_vports, bm_hostmode: Device configuration
> 
> Per-vPort entries (under /sys/kernel/debug/mana/<slot>/vportN/):
>   - port_handle: Hardware vPort handle
>   - max_sq, max_rq: Max queues from vPort config
>   - indir_table_sz: Indirection table size
>   - steer_rx, steer_rss, steer_update_tab, steer_cqe_coalescing:
>     Last applied steering configuration parameters
> 
> Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> ---
> Changes in v4:
> * Rebase and fix conflicts.
> Changes in v3:
> * Rename mana_gd_cleanup to mana_gd_cleanup_device.
> * Add creation of debugfs entries in mana_gd_setup.
> * Add removal of debugfs entries in mana_gd_cleanup_device.
> * Remove bm_hostmode and num_vports from debugfs in mana_remove itself,
>   because "ac" gets freed before debugfs_remove_recursive, to avoid
>   Use-After-Free error.
> * Add "goto out:" in mana_cfg_vport_steering to avoid populating apc
>   values when resp.hdr.status is not NULL.

Thanks for the updates.

Reviewed-by: Simon Horman <horms@kernel.org>

