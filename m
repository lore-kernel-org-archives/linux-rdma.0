Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0883B34A796;
	Mon, 23 Feb 2026 07:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771831030; cv=none; b=CX1irhgdpoWGytZ5hKoQs3EIS0uVbvGqpkKrRI/A5tLoiCxkhJ7I+ynq/I/woJnSn6LmjUcTuA39uSCMAny0Img239+x0yLH0TDGN9G5Q4J7JYIqq2Gy+Z9gokgkpIO0k10EzKmCCtK9nK/5n3R930fhC/V+hEmYqWQ5NuH7ozE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771831030; c=relaxed/simple;
	bh=f8l2/4noAcJnq+ttTInXUmnEOp8ump43LAOqmtY5gJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWRcqRUmc6UjLjaemoaLIyrtj0zfOlrmUkmfv1dbgzUCExh1QUklKdQt2qqlQUJvPWaOVf/AsoqwEAdWwV8/srHdJKlF06OpqOW+yXjKGz64m+slIqPJFO0BHF8oHIepshtVBr/9yJkiImR4DjfCqJrYXl9lJn7ILSFoBDcy3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtlQerpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtlQerpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016C0C116C6;
	Mon, 23 Feb 2026 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771831029;
	bh=f8l2/4noAcJnq+ttTInXUmnEOp8ump43LAOqmtY5gJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YtlQerpoNYKVfHcLgBb2S2Rn5O8l5/2+anNviDJpHQ+u1MSlnjkwd05i9Jon/WhZf
	 7Tpbo+BvCXkeLbWlGJrZMiNMqG2EkWME7OAx8Nb2ZODwuobR5ww2MXmPrg0m6Uf+oa
	 G1Kl8Zid2rC8JWJcYxKGlPIVSER+DH6DThSVLwLJH/RkXVSdXr16vp6RIVkoW7UHr0
	 t5AuN2FqKi7ahrG36Z7iz/TGmAZ/159LUq+xOT6CAJn+ZfsOCH/IVn8XuPzlhKBytm
	 24a/F+FqxR3XHXg/5ta73UZdykp/r6L3B2rUuq8NqT0c1LWvgJmTov74Elctpr6X1e
	 jdGn29aU9IfEg==
Date: Fri, 20 Feb 2026 16:11:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Amir Tzin <amirtz@nvidia.com>
Subject: Re: [PATCH V2] driver core: auxiliary bus: Fix sysfs creation on bind
Message-ID: <20260220141156.GE10607@unreal>
References: <20260219210435.1769394-1-tariqt@nvidia.com>
 <DGJCHYS3SKIQ.1TIHQCMEOCRC@kernel.org>
 <20260220080413.GB10607@unreal>
 <DGJQUDBN8WQ2.BPQRSNNGMH6X@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DGJQUDBN8WQ2.BPQRSNNGMH6X@kernel.org>

On Fri, Feb 20, 2026 at 12:14:12PM +0100, Danilo Krummrich wrote:
> On Fri Feb 20, 2026 at 9:04 AM CET, Leon Romanovsky wrote:
> > This init->add->remove->destroy pattern follows standard Linux kernel practice.
> > I expect all current review tools to flag any missing function call
> > among these three.
> 
> I'm not saying that the flow is not logical, goes against existing patterns,
> etc., I'm saying that it is unnecessary to expose a new API to drivers, since
> this is already handled internally.
> 
> I.e. we can easily fix the bug without increasing the API surface exposing a new
> API to drivers.
> 
> > It is not, atomic is not a replacement for locking and this hunk is
> > going to be racy as hell:
> 
> No, of course not, but it is sufficient to ensure that something runs only once.

No, atomic doesn't ensure that. Atomic makes sure that write/read
variable isn't "interrupted" in the middle.

Multiple simultaneous calls to auxiliary_irq_dir_prepare() without lock can return
that sysfs.irq_dir_exists isn't set yet, will try to call to devm_device_add_group()
which will fail.

> 
> However, you are still right, since sysfs_create_group() can still fail, we
> still need the mutex, because we may need to unwind.

If you decide to keep lock, you won't need atomic_t for irq_dir_exists.

Thanks
