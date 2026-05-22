Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C25226D18;
	Fri, 22 May 2026 07:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779433959; cv=none; b=BFE3bd6XkWOtdqL6FApRnZHDfsVoF59ecXqsY/o197XxB/FMAwZkf/eOHT+mw4BfRfJLDSYiuS3C9TIc2doSDMJknDt+LJl0jII4gz+zgE/EJl94AO1g/pjXgZEvnezjtEvrvoPoBJyVIFqE2C4L1LhlSFrc/maX/8TqYLkBVn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779433959; c=relaxed/simple;
	bh=mmjD/BfwuqvlPWyD9wQSO3/75vf2wdElFWQ4twkS6lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+YkCUueUdy0v5HTZBPJzqrfVFotKGR3u45uUd3lKuWpm2fAJdz7bqGQigjyVQ2Wr8HFZ79/Cdr3L6+zfl/KuhjnVbOCUqjH5Rt++ZslDI6Wn50Ic7n6mqWaj879LLvHtO2VW+kZwdNHCb16xpi6R0ztXVjSILRoztOYPZ4V+rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/0Xw8lM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/0Xw8lM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257031F00A3D;
	Fri, 22 May 2026 07:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779433956;
	bh=KH2JbmMgdb3FAGMCfvbKA2uQ99psKpF2tMWtecKElbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f/0Xw8lMEZCN3oUF9paqLqOk7MO5W80g+bMpgSCDKundPKfSK8Uq+0jYSJ/oD7vrQ
	 m5NQK2ADqz6cGBUb+WhA9u8c2Yy8UGe12Zzhi953EY9lqHNwR17r1ZK2Vw9qKpFphA
	 Iq3Vta0D50Eaxfu3r9ak1cK0iSw1EIuCrMm2tYwTgISw3fDYeHvyl+2eq03TAwiLTY
	 NDteNj0cjSDnhUyP/0Fh1JlxrahqN0Frxf3eWEysW7ncjHQDbVFzElkj7forDP62oj
	 kzMG8Xxleb3YShCEAAmhF0On0l+AfI97ZuR4HWiV8USUlOIqC+/QWUDppq0qqNTNB4
	 pTi+jfHBeXfyQ==
Date: Fri, 22 May 2026 08:12:30 +0100
From: Simon Horman <horms@kernel.org>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kotaranov@microsoft.com,
	shradhagupta@linux.microsoft.com, dipayanroy@linux.microsoft.com,
	kees@kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v9] net: mana: Expose hardware diagnostic info
 via debugfs
Message-ID: <20260522071230.GG1506108@horms.kernel.org>
References: <20260519064621.772154-1-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519064621.772154-1-ernis@linux.microsoft.com>

On Mon, May 18, 2026 at 11:46:10PM -0700, Erni Sri Satya Vennela wrote:
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
> Change in v9:
> * Change steer_update_tab type from u32 to bool and use
>   debugfs_create_bool() accordingly
> * Guard debugfs_lookup_and_remove() calls in mana_remove() with a
>   NULL check on gc->mana_pci_debugfs
> * Fix mana_gd_resume() RDMA failure unwind: call mana_rdma_remove()
>   to undo partial RDMA state and return err, instead of
>   mana_remove(true) + mana_gd_cleanup_device(), avoiding a UAF
>   where gf_stats_work could fire against an already-destroyed HWC

Reviewed-by: Simon Horman <horms@kernel.org>

