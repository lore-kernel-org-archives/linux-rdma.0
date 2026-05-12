Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72CF3839A3;
	Tue, 12 May 2026 10:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582072; cv=none; b=AZ+/Feh+ABYidpS9KmUVQ531IIqdZXRjPO1NsvT9GUm/gj0iALrwsIQAbTATw/oxwxRPaHrGJB6QTistuiXSaSXoLFKE7NWRP5hNBv1ASMMKwFJrEmURj6OT9r59GR5q4y1D6TVIXmhZ1rhgkEGNVW18AA4m6yQ2e5dNuuq5YXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582072; c=relaxed/simple;
	bh=wJkRRJmvxRupR2yVHxSz5Mc/9Io6ZJ6HYHt995K3SyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHTwEBCOXhRgdYgHraTOCaHkDoaNv/iwcwjZk/ewj/c925jYhhhF0q0kiTV0WkpXu50koq9K+RlwlN/hhmpqgTaTpcTBdd7wrajJ3y2ST1+IQtQYixiqPFyw8xhVBnxYY7Lp5X7Ar0Hj7LF3OeGRfGwkC1IK/xhJG7igY6i2yP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TB6biqgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TB6biqgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E4C2BCB0;
	Tue, 12 May 2026 10:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582071;
	bh=wJkRRJmvxRupR2yVHxSz5Mc/9Io6ZJ6HYHt995K3SyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TB6biqgp/tkQI0aH6nDB5AkmATMuF2TXIp8WRkHCuLxcCd7fCE/WE7pKORNZER3Uo
	 6e1NklaZRhigC0+mIinxo+iEGjBFyIQqzYqS0CoVoTSUfm1uuI3rwM4OtzZj6iAsKo
	 7JVYavS0vKvqaEDIfYfnVCbURxMOwNO36K84UrfQwpKOK4wbr9V5ZbRSfybVK/jw42
	 dF4JEuQ2VwLHfd2s5Lzil3bOQhTVuEK6qf8kS6cbLKjp9eY7eJpJZvG9FbgAd+XO7j
	 e9XkdKPRjwP5bCN7zN0z1KbSkDhFGr1DgxwP7SGISgnuJwQVR0xcNlt+Vfh03Frz4j
	 riTEfuuhcJxDg==
Date: Tue, 12 May 2026 13:34:24 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Md Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, axboe@kernel.dk, bvanassche@acm.org,
	hch@lst.de, jgg@ziepe.ca, jinpu.wang@ionos.com
Subject: Re: [LSF/MM/BPF RFC PATCH 00/13]
Message-ID: <20260512103424.GR15586@unreal>
References: <20260505074644.195453-1-haris.iqbal@ionos.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260505074644.195453-1-haris.iqbal@ionos.com>

On Tue, May 05, 2026 at 09:46:12AM +0200, Md Haris Iqbal wrote:
> Following a conversation with Bart yesterday, I am sending the RMR+BRMR
> code through patch for easier review.
> 
> The patches apply over the for-next branch of the block tree over commit
> 07dfa981ca3
> 
> For context,
> RMR (Reliable Multicast over RTRS) is a kernel module that provides
> active-active block-level replication over RDMA. It guarantees delivery
> of IO to a group of storage nodes and handles resynchronization of data
> directly between storage nodes without involving the compute client.
> 
> BRMR (Block device over RMR) sits on top of RMR and exposes a standard
> Linux block device (/dev/brmrX) backed by an RMR pool. Together, RMR and
> BRMR provide a single-hop replication and resynchronization solution for
> RDMA-connected storage clusters.
> 
> My session is on Wednesday, at 12 in the storage room (Istanbul).

To summarize the discussion:

1. Move as much logic as possible into the block layer; RDMA should serve
   strictly as a transport.
2. Identify another in‑kernel user of this functionality, and add support for
   it if required. At least accommodate potential users elsewhere in the
   kernel.

Thanks
