Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2232D77F7;
	Sat,  2 May 2026 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777735775; cv=none; b=tWRVLrnJY2KrM3um6vpx90d8vzWiucml2pPix50Ucegc6UAO2Wosv9HjDS9fsU+xIvbBVBjxWdnlpqlGxHVwtrfQfwf8N0oBcI4aTaCvvkRmp+uWjkpJGu1ZnKi6075hs8e0LSEuIFQ98F8utfhnemHdo6g4bnkG85+hiEQ2zEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777735775; c=relaxed/simple;
	bh=zc8WlUvWc0EpgXm+rDxDw/E6TdrFDkHDA+IUWiiswpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqCnvlwoD1hr3jUhfyXfhTK/bqbGHEcz1HHV2M6k6aHVup6PrxkWaDkAx/FAhPbATvyxljNYkGuTVdrXi8LsUbCBIIFWRkfkiGglVEzc2vmL7nuc3fqzN56Si/9i0t40bxz8bsCog0GT0vVGVxitchAiKQYFHVyWNW/kwRHo1u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8Sps+6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8Sps+6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1570EC19425;
	Sat,  2 May 2026 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777735775;
	bh=zc8WlUvWc0EpgXm+rDxDw/E6TdrFDkHDA+IUWiiswpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8Sps+6w/SDg7BhBggF89twzUkiT3Cyqm6VDUNc9Q2Gc2vSxAAjymmFD2x5UG5D4F
	 SAuW1G0gZnWb+Ate55cJfNE31Ud7+NK9GkXVbTI71zR+aLpUx+k8XV1LJj3YwRPvhB
	 Zi7VKb7zbMPxJB8yqdhRsfTp2JffOCBjtEYroGfWpXjpfBR24j2UJw74cKmWRrj5cZ
	 cfLwDYSIgefYEYcyJvJG/nTkzZHt6KukzUl2xIkAk0uNCng6M1uQKSwwj1H3wYOxCN
	 7nlizfsF+fYQcMe/+qfibsISZ0box/0NzDgqIaXdDOCZ+SpIZddcbbzovIg5nwTVxq
	 iYQbieacDj+1A==
Date: Sat, 2 May 2026 16:29:29 +0100
From: Simon Horman <horms@kernel.org>
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
	pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch,
	jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
	kys@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/6] net: mana: Create separate EQs for each
 vPort
Message-ID: <20260502152929.GL15617@horms.kernel.org>
References: <20260429221625.1841150-2-longli@microsoft.com>
 <20260502152354.289044-2-horms@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502152354.289044-2-horms@kernel.org>

On Sat, May 02, 2026 at 04:23:55PM +0100, Simon Horman wrote:
> From: 'Simon Horman' <horms@kernel.org>
> 
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://sashiko.dev

Sorry about this, there was supposed to be some different text here.

This review is available at https://netdev-ai.bots.linux.dev/sashiko/
And I apologise that it overlaps with the review from https://sashiko.dev
which I also posted.
