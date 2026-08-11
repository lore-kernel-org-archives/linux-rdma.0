Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD643CED2;
	Tue, 11 Aug 2026 10:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786445700; cv=none; b=BiBlJ9IR8X5rVo0zYljsGr6DFh62Tyx4BtxlsQgDiuFQGVPBbgDqDEjO7HaGd0kBZBQXBv1SFgP4TJ4kc0RkfcSQXsRAHncp6JHeFDAoNNzBVWf/zQcpuhd0ZDtV+Bckb78eqhVDxzqgbJiXQbnd/foLzAaBDVQUHEEBuc7DUlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786445700; c=relaxed/simple;
	bh=X2A3ool26CXDRd7lffFmwwSFV399ydcQuU+hazRqR7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrcxUx+i9Hch3RO/nGLYdN4c0g0VE53C0a66EUf1ia0IUY8xC98k0sHzNJxKhPiKFp1RNDQ9qSyKTWT/Rj0gsH8WnjYmfTVOI/9myFWqzBDtOO90LBLjhMgnIGPVDk1MmrNlA2jEi7N36C5J8Th6zntRTjG7eICKVdbEXP7ovig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIBPUBG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIBPUBG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C091F000E9;
	Tue, 11 Aug 2026 10:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786445696;
	bh=CYyLtmKCofbFY3er/KWtc0jGG+UjoitrmvJnghjgTAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GIBPUBG58boWm+J2b9Gu8IW9KgsK7c4IUHigOIiCSx5s/+kmsFeI7oxnDrCM10dJV
	 eybcjeBq1afNKGguQmCGsIG/9rzQdaL2MeCiJwGFrbPttFlempjq6HrEljfPC5llSW
	 QW+j5uWyqnxTM1u/NWfgjZKHaQFpMXUOqgfkxygJ4WLjuT6zc+7KFeoJXSmbu6o2GD
	 v2GEjQFxv08OYHP5tKbd/wHn4k/m40CGH84mzuvtGWsdTNHMwUSZded2h3E2/m8z11
	 iXqql1EnutBtx7ACj6Unkcx01vCduh112sfo/AlHyUFvCEToT9Z0sXj0HUHd8+YISj
	 BcCLGghtNgLbA==
Date: Tue, 11 Aug 2026 11:54:52 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org, jhubbard@nvidia.com,
	leon@kernel.org
Subject: Re: [PATCH net-next] net/rds: clear i_rx_lat_trace in
 rds_inc_path_init()
Message-ID: <20260811105452.GC51943@horms.kernel.org>
References: <20260810055631.299558-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810055631.299558-1-achender@kernel.org>

On Sun, Aug 09, 2026 at 10:56:31PM -0700, Allison Henderson wrote:
> The commit that introduced the receive-path latency trace added the
> clearing of inc->i_rx_lat_trace[] to rds_inc_init() only;
> rds_inc_path_init() never got it.
> 
> That asymmetry matters for the one caller that reuses memory:
> rds_tcp_data_recv() carves its rds_tcp_incoming out of a kmem_cache
> with no zeroing and no constructor, so after rds_inc_path_init() the
> array still holds the timestamps of whatever message previously
> occupied that slab object.  No stale value is user-visible today -
> every message that reaches the socket happens to overwrite all four
> slots (RX_HDR at allocation, RX_START when the header completes,
> RX_END at delivery, RX_CMSG at recvmsg time) before
> RDS_CMSG_RXPATH_LATENCY reads them back as deltas - but that is a
> property of the current writers, not of the init contract, and a
> future trace point or an early-exit path would expose another
> message's timestamps to userspace.
> 
> Clear the array in rds_inc_path_init() too, so both init helpers
> leave the inc fully initialized.  memset is the form the clearing
> already takes on the rds_inc_init() side since commit 1635bb548f84
> ("net: rds: use memset to optimize the recv").  Hardening only; no
> user-visible bug in the current code.
> 
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Reviewed-by: Simon Horman <horms@kernel.org>

