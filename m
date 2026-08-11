Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E99415F18;
	Tue, 11 Aug 2026 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437435; cv=none; b=YjEiD7aZJS7ULkxhswIvHC0h5/1ZE36u+boFMGdLO6ZigNVfKATNAMug5sFku09/NVdjrVjAoHqAm+As7gO4ov+EQiT7ZzZbcJP+hSeyV9v5scNSn8BYcdNSX02mFLGrRgcFsYhRM7z9ZhK8H7fFrnfChm7l1yaG6liy2ZPRUVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437435; c=relaxed/simple;
	bh=MV3yCdXc6feSDumzLtfxaTVv6+J9D5CQFKEpWEDzY8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgTh3t/fWYWcpWIIkXlNiKbd3UGzlXc7EYcYN62EfJsBiw+ZGFwUMCEPuWi5hbwbAtHc9vUWxwFicNhNTHB61kVQyt42u6tyA7flNeKqhLqZxC1iTPuVtVGjCdJ3IqtX4J+W1cDWc3OVg7AqV6s6mPpIOCPwNFBHc8mX0XLk268=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CbEoa63G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CbEoa63G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C5F1F000E9;
	Tue, 11 Aug 2026 08:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437434;
	bh=yzn4SnI88fLgsSnBroGoGVcmDPELG5VTl04ALkSkq70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CbEoa63GM1uYyRkKYLe73s9GbjklK1vwpXSEa0ZpPpg7jDeLFZbScWQSKFRLyf2Uo
	 VmUwTJnMW8GQJA0NORsEBYwhNs4oAtgjTHRwLO7FfoJtbVg3FlL7uRF7731jqtEJYL
	 RlKdhr/ovOUgrO98xbO0NqGHpvzPXed40brDpWPDxsm1KofH7atTREGu0AY0C9LjIV
	 jfhqRI0fxZ+hHt0ihLkwFOIgRwXhttdiS7M8RDfJLg4A/cHkVVO+WlglJ8DXFCbSri
	 35gM2Vufuqj5OrxxqlXo7nJLHfux+gkp1gnBhktJFyQhyV58PM0QhT9wDe4KkfAZMJ
	 bYPx8rBD6Lyvg==
Date: Tue, 11 Aug 2026 09:37:10 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org, jhubbard@nvidia.com,
	leon@kernel.org
Subject: Re: [PATCH net-next v2 0/2] net/rds: Bug fix ports, part 2
Message-ID: <20260811083710.GY51943@horms.kernel.org>
References: <20260809005103.82371-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809005103.82371-1-achender@kernel.org>

On Sat, Aug 08, 2026 at 05:51:01PM -0700, Allison Henderson wrote:
> Hi all,
> 
> This is the next batch of net/rds fixes ported from the Oracle UEK
> kernel, following up on the first set now in net-next [1].  
> 
> This is v2 of patches 1 and 2 of "net/rds: Bug fix ports, part 2"
> [2], which contained two initialization-hardening ports.  While
> re-reviewing v1's patches 3 and 4 (the fastpath-lock teardown changes)
> I found their locking needs more rework than a respin should carry, so
> they are split out and will return as their own series together with
> two companion fixes.  The two patches here are independent of them.
> 
> [PATCH net 1/2] net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
>   Port commit 7f52b9968d79 ("net/rds: rds_send_xmit should INIT_LIST_HEAD (&to_be_dropped) on restart")
>   https://github.com/oracle/linux-uek/commit/7f52b9968d79 
> 
> [PATCH net 2/2] net/rds: initialize i_conn_path in rds_inc_init()
>   Port commit 0ec6a520da4f ("rds: rds_inc_init() should initialize the inc->i_conn_path field")
>   https://github.com/oracle/linux-uek/commit/0ec6a520da4f
> 
> Questions and comments appreciated!
> 
> Thanks,
> Allison
> 
> v2:
>   - Patch 1: the comment now names rds_send_remove_from_sock()
>     instead of vaguely blaming "the callees", and the restart-time
>     invariant is enforced with a WARN_ON_ONCE(): entries still on
>     the list there would keep their message reference and their
>     RDS_MSG_ON_SOCK accounting, so a silent re-init would orphan
>     them.
>   - Patch 2: for loopback the field held a live value written by
>     rds_send_queue_rm(), not garbage; rds_loop_xmit() now uses
>     rds_inc_path_init() so the re-initialization keeps it valid, and
>     the commit message describes the two transports accurately.
> 
> [1] https://lore.kernel.org/netdev/20260730041629.3512480-1-achender@kernel.org/
> [2] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>

