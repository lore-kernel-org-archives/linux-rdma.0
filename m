Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF03CFF42
	for <linux-rdma@vger.kernel.org>; Tue, 10 Mar 2026 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165630; cv=none; b=LQqZEZVXvkrkBsfjLILronYUZFRi9K2fxhkQuayXkuOyX2TN26UISAl24OE6CEqCBJHLR06waGNz8ZhYIaxfGvhBRPei2Hv5BL8vXfUM1ljAbKu6JQk3QvyMYgeKxkGxFzPDkbLscWdm4hXK7Y1zg/WEs0AF7fuJ6NbZ6gRsWZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165630; c=relaxed/simple;
	bh=lA/uUOLuriZ9nvTPsXGdpzr8A6kAY8/36ijkhKGjH+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqRaLiwvNCUEz91KWUTNjzrxx9evJ/BFwypyMVjLDob7bTO1qbulMzpQSSaRBA6GJtVQ19AC/SpKcbOfjeBlLLU/NIQU5NemhV0f59qeq67cSzgX36wxAR2quxzPf4rm5ip+PEYJHutkH06ddlMSntPvVDpelniJXcpz8vCR3zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpHEqLQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpHEqLQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB5DC19423;
	Tue, 10 Mar 2026 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773165629;
	bh=lA/uUOLuriZ9nvTPsXGdpzr8A6kAY8/36ijkhKGjH+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JpHEqLQmm3L2YYFS1DXZmNr/r20Kb+d662kwy2ujydVwqwtyU1X1M/8TiRo3z0/dE
	 V/S44FJ3ND6kfNrPSjicrQyxgqaOdUyVvfT5ca7Qhww69euE1EzBf50/quUZ6ddyX3
	 l9Y2XKalKsCe2smziwcjdQ4IM8N8qd4YSpc7S+zB28W9hqqjEy/s+tfC98pWFYpWMW
	 KD7mGRWvhW01q10i/eIRz/aC7/XlsCumrrbzgoRdk0YVATOyxfEKBH8x448Nu9tDqL
	 mS2UCVWN1tkkWaLUfHmfoMR/pgSp6JwNzKHDfGwbTRr95f1PIb/aD/lTUSuuhlbIn3
	 cRjxjuzDlQzAw==
Date: Tue, 10 Mar 2026 20:00:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: jgg@ziepe.ca, Dean Luick <dean.luick@cornelisnetworks.com>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-next 0/4] Prepare for hfi2 submission
Message-ID: <20260310180026.GE12611@unreal>
References: <177308892140.1279894.3475429390519673020.stgit@awdrv-04.cornelisnetworks.com>
 <20260310110806.GC12611@unreal>
 <9c9ffd7b-0124-4d72-a894-4498b7c44f96@cornelisnetworks.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9ffd7b-0124-4d72-a894-4498b7c44f96@cornelisnetworks.com>

On Tue, Mar 10, 2026 at 10:14:55AM -0400, Dennis Dalessandro wrote:
> On 3/10/26 7:08 AM, Leon Romanovsky wrote:
> > On Mon, Mar 09, 2026 at 04:44:39PM -0400, Dennis Dalessandro wrote:
> > > These 4 patches get rdmavt ready for hfi2 support. This is being split out
> > > from the previous patch submission [1].
> > > 
> > > [1] https://lore.kernel.org/linux-rdma/175129726945.1859400.4492277779101226937.stgit@awdrv-04.cornelisnetworks.com/
> > > 
> > > ---
> > > 
> > > Dean Luick (4):
> > >        RDMA/OPA: Update OPA link speed list
> > >        RDMA/rdmavt: Add ucontext alloc/dealloc passthrough
> > >        RDMA/rdmavt: Correct multi-port QP iteration
> > >        RDMA/rdmavt: Add driver mmap callback
> > 
> > Something went wrong, second patch didn't arrive.
> > https://lore.kernel.org/all/177308892140.1279894.3475429390519673020.stgit@awdrv-04.cornelisnetworks.com/
> 
> Sorry about that, I'm working the problem with our IT dept right now. The
> mailserver decided to eat half of my patches.

In the meantime, I can take these three patches if you prefer.

By the way, these patches currently have no in-kernel consumers, but
let's assume you plan to use them in your hfi2 driver."

Thanks

> 
> -Denny
