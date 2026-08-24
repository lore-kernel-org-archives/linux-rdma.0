Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C65D46AEDD;
	Mon, 24 Aug 2026 16:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787590556; cv=none; b=XVCKK8tdQPV8xTKarUH0lWZRpkfV/TMMGJWUs3Q7dDf4STnKHwVFSTPSnRbmxQzOPDbUXwJ/Iqm4qqcYzAmzF7stDcSsY40bygDp/AODCaY9cb5jYtNkcs5I7ER1RYXmgAgXniV8An+0N7ZzZZH5Wkv7VQUWg7yDg6gi+yura+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787590556; c=relaxed/simple;
	bh=QTfhsM4tx7H9Nid8lOZz9x6zBpJM/kF+pd9YOx9Wb2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsOYvRxtz7NZNCbhqbVsyaic/L4GmfyXEVzSsDpcXuYeC18triQptksiEcMGJKU7IL80YVn4OfmaiXcwjPi0UUUPLsK4L4cpc+F/zU0qC9Epp5aux2SuAhP9Xl07DOeVbpVvYKU3qVpcsqHYFk4JkKGZo6aGvV4kwcPjy4wQ8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNS3XifT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNS3XifT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE02C1F0155C;
	Mon, 24 Aug 2026 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590554;
	bh=OutC5dLw6ljlz2bW2icJUsCK2hZR63wcb5VCopr1tlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mNS3XifTBPUW1kJ9Nd7MyVaiP8bxWjy27JxyFZUZW6RLpLE5n7f1e0FP9e7ZbnnGf
	 0iduJabMNOAABEKQOHFks9a/QQDmNyKGhdmo1OPWdxtRRKvgJF3oSsV8lz4HLeabcS
	 4JL6dSoxdgxMuvT4eN6/VaSfehOnm/adEraTe+07bNiS5zfFsstw0ADNIEJKcVEkoq
	 GxovXf9brW8qW7yUDbF7/L/DsjrBsu42EcYCpJyQ7n9nsxDJp5J0ECU6hanLMUCfcP
	 Ki9HpiYf7Ac8NaF0VKm+UEV1p3ZwBzZGlO7WcBn5vQtMLp8Yj+i8Q2fJyyKFznyTIx
	 U1GvGncutwRKQ==
Date: Mon, 24 Aug 2026 17:55:50 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org, jhubbard@nvidia.com,
	woni9911@gmail.com, michal.kubiak@intel.com, leon@kernel.org
Subject: Re: [PATCH net] net/rds: use wq_has_sleeper() in
 rds_cong_map_updated()
Message-ID: <20260824165550.GZ265046@horms.kernel.org>
References: <20260822052647.88318-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822052647.88318-1-achender@kernel.org>

On Fri, Aug 21, 2026 at 10:26:47PM -0700, Allison Henderson wrote:
> rds_cong_map_updated() runs after a peer's congestion map has been
> rewritten (by rds_tcp_cong_recv() and rds_ib_cong_recv(), or the
> clear-all in the loopback and IB send-completion paths).  It bumps
> rds_cong_generation and then checks waitqueue_active() on
> map->m_waitq and on rds_poll_waitq to decide whether anyone needs
> waking.  atomic_inc() carries no ordering and waitqueue_active() is a
> plain load, so nothing orders the map and generation stores before
> the wait queue reads.  The waiters do the mirror image: rds_cong_wait()
> adds itself to m_waitq and then tests the port bit, and rds_poll()
> registers on rds_poll_waitq and then reads the generation.  That is
> the store-buffering pattern described above waitqueue_active() in
> include/linux/wait.h - the updater can observe an empty wait queue
> while the waiter still observes the port as congested, and no wake-up
> is issued.
> 
> rds_cong_wait() is an interruptible sleep with no timeout, so a
> sender blocked on a congested port stays blocked until the next
> congestion update from that peer arrives or a signal is delivered.
> A poll() waiter misses the map-updated notification the same way.
> 
> Use wq_has_sleeper(), which is waitqueue_active() preceded by the
> required full barrier, as rds_tcp_state_change() already does for
> the same pattern.
> 
> Fixes: 922cb17a5c81 ("RDS: Congestion-handling code")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>
> ---
> Raised during review of "net/rds: own the fastpath locks across
> connection teardown", whose first patch fixes the same pattern in
> release_in_xmit():
> https://lore.kernel.org/netdev/20260820133832.5384be37@kernel.org/
> This patch is independent of that set and applies on its own.

Reviewed-by: Simon Horman <horms@kernel.org>

