Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCFC3CB2D4;
	Thu, 11 Jun 2026 11:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179148; cv=none; b=C5TUlUseaZSVjn6sfyOUoie4WIBv9h0KfYLko8oS3nUE96uVa962n58w35xDE+IPJrE4gae9Qw/NRJJnp7l80WK1hLz1oz1lD1KA+MwRCnnAMAAU2GNApz1zodUNztH1MqXxYW0DZFnfAinj5lZK8MAjDzkhLcYue0coI5dni/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179148; c=relaxed/simple;
	bh=8KaF6mblFTthT4vUi6B2dz8Qy2dVYAv+MLA4DxjD5UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AunnQo2/YybbmbtLxq/uS3g5BbT633Za47huOQlaeYyLXfOCZGam6ptC2HsoZni8PKe2/ihkHOGqIHCj/KBxKcRtg5RFbsGGeH6ehUXSJ/ieLau7i8NVDMdAE8XGvVN/yTr+Vail0LWY646bibhBwDJrfRxTEto7fwNM90sh/jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEjMqfo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEjMqfo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198A91F00893;
	Thu, 11 Jun 2026 11:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781179146;
	bh=9Z4ndnCxV+CiLTTLCplpjJEgcmLTMIk7XFj1r1QBl6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MEjMqfo29SfAQpahMBxLdEUP40M8qYZSS8LoII0n+6hpcFkJQCokTqDfgzQKjjG6O
	 tWjhkSF9KBrwG/hjbkl5yeAtC5IqK0hOFQfeS3DibgMV+5heGY7tzwMesHipuB4COk
	 PLn4AQoKXotCKcpqHoOjyTjaG9/vJit4SiSJGb3zjWMBDmmWkRnn/O1eDAJkR8CMYH
	 1WqaqFNMIYbfK0oVqaVD1GemoGAl4fbW/QRwcmz1ZDMVsXydl14zVP7ENGSsZZpGs6
	 bN3S1pw+4QnhmXRq+p1W3wwJfuTaogA8zcXShzKHqgikkbjR0WoohISBVeG7EwK33U
	 ihMO/c7IPrk2g==
Date: Thu, 11 Jun 2026 14:59:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, axboe@kernel.dk, bvanassche@acm.org,
	hch@lst.de, jgg@ziepe.ca, jinpu.wang@ionos.com
Subject: Re: [LSF/MM/BPF RFC PATCH 00/13]
Message-ID: <20260611115902.GO327369@unreal>
References: <20260505074644.195453-1-haris.iqbal@ionos.com>
 <20260512103424.GR15586@unreal>
 <CAJpMwyg-6Qxskq2ktuhvf46yD5848J9BYLMPPfBLjg2Uzs=xnw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJpMwyg-6Qxskq2ktuhvf46yD5848J9BYLMPPfBLjg2Uzs=xnw@mail.gmail.com>

On Wed, May 27, 2026 at 02:44:08PM +0200, Haris Iqbal wrote:
> On Tue, May 12, 2026 at 12:34 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, May 05, 2026 at 09:46:12AM +0200, Md Haris Iqbal wrote:
> > > Following a conversation with Bart yesterday, I am sending the RMR+BRMR
> > > code through patch for easier review.
> > >
> > > The patches apply over the for-next branch of the block tree over commit
> > > 07dfa981ca3
> > >
> > > For context,
> > > RMR (Reliable Multicast over RTRS) is a kernel module that provides
> > > active-active block-level replication over RDMA. It guarantees delivery
> > > of IO to a group of storage nodes and handles resynchronization of data
> > > directly between storage nodes without involving the compute client.
> > >
> > > BRMR (Block device over RMR) sits on top of RMR and exposes a standard
> > > Linux block device (/dev/brmrX) backed by an RMR pool. Together, RMR and
> > > BRMR provide a single-hop replication and resynchronization solution for
> > > RDMA-connected storage clusters.
> > >
> > > My session is on Wednesday, at 12 in the storage room (Istanbul).
> >
> > To summarize the discussion:
> >
> > 1. Move as much logic as possible into the block layer; RDMA should serve
> >    strictly as a transport.
> > 2. Identify another in‑kernel user of this functionality, and add support for
> >    it if required. At least accommodate potential users elsewhere in the
> >    kernel.
> 
> Thanks for the summary Leon.
> 
> The main logic which handles multicast/replication legs, missed I/O
> tracking, re-synchronization, etc are the core parts of RMR.
> If we move those to a separate module, there won't be much left in
> RMR. RMR already uses RTRS from the RDMA subsystem as transport.
> 
> Having said that, I am not against moving RMR out of the RDMA layer.
> It can serve as a reliable replication service/library for any other
> user in the kernel to use.
> Which subsystem (block or something else) would be a better fit then,
> can be discussed.
> 
> PS: Would this be a good candidate for a session/discussion in the upcoming LPC?

Probably yes.

Thanks

> 
> >
> > Thanks
