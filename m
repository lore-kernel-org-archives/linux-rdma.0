Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6AE51D53C;
	Tue,  8 Sep 2026 09:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860610; cv=none; b=HqFImufGcGOCnWZpwYuZn0P7HFEPDlQn7jyDQ7mf8+LtzsABHe1qDg3u6vZ/kI6/dIfiNnk7ltKUrXQHcFw2XO0L0Eoze8oX3zQpZhEjadKbmBSNbuPZqAC7ceEnwYUt/WxjL1Tq6Sno+FGyLHz0yoQClWzDBuNru/CILwzMFQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860610; c=relaxed/simple;
	bh=ypQ/NBUWIij4nOURs6S8UJvhAaIHJw+ASwJyjj9K2hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmV7UMz0D2MZ6Ai0XuX3HQMdr9XnoZO5YO7IgLQOYyfhKrbuUKfoQ+PHHAvEKEJITxZd62bApL69rvlZvaw7tDlBKzGWz5wrU8yRqOgPBZpa+Jy0krrPQEpqLDytaUV9EDmJCTWOQqcs9TqgfUSrtLx6o9cbK+H6TvOGPOSAOmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14941F00A3A;
	Tue,  8 Sep 2026 09:43:24 +0000 (UTC)
Date: Tue, 8 Sep 2026 10:43:21 +0100
From: Simon Horman <horms@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com, ernis@linux.microsoft.com,
	stephen@networkplumber.org, shirazsaleem@microsoft.com,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net,
	hawk@kernel.org, ast@kernel.org, john.fastabend@gmail.com
Subject: Re: [PATCH net] net: mana: restore the XDP program pointer when
 pre-allocation fails
Message-ID: <20260908094321.GR40544@horms.kernel.org>
References: <20260904202640.3900685-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904202640.3900685-1-longli@microsoft.com>

On Fri, Sep 04, 2026 at 01:26:40PM -0700, Long Li wrote:
> mana_xdp_set() publishes the new program into apc->bpf_prog before it
> allocates anything, because mana_pre_alloc_rxbufs() sizes the buffers
> from it via mana_get_rxbuf_cfg(). When that allocation fails the
> function returns the error directly, skipping the err_dealloc_rxbuffs
> label which is the only place that restores the previous pointer.
> 
> The attach is reported as failed, so the BPF core drops the reference it
> held for the caller and the program can be freed, while apc->bpf_prog
> still points at it. The next consumer of mana_xdp_get() - typically
> mana_chn_setxdp() from mana_alloc_queues() on the following ifup, or
> after a TX timeout reset - then calls bpf_prog_add() on freed memory.
> 
> This is reachable from an ordinary "ip link set dev ethX xdp obj ..."
> whenever the per-queue RX buffer pre-allocation cannot be satisfied.
> 
> Restore the previous program on that error path.
> 
> Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Simon Horman <horms@kernel.org>

