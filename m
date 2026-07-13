Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EBE43802F
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951669; cv=none; b=mPkAc3qOknU8M7CIOCpfRmVYxjBLrijPza8FmgAeLYo3AqRjoYe4DnW6fAqb1Re2uR3DIA0+ou/JuoCeCuXsfjh0J1HGNcVOmfK+BZFuWeJf3l+gg0JPBDpolARmwi7FSYbkDSLuBeKU2Hjqeme7LfS+SR4VdL6MYLU83OIw4S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951669; c=relaxed/simple;
	bh=FFPww0XzWUBRk8G9ZVyzjUx0Yq5zNSm6eB/zv/qXF5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbyWmjdikbxDoMJQiNAyYlaqsRZJLDnbT2xtEsQQWcUwuNOTQRdkIVd7IV8qiPfgaSOBeZ/EoCP/oSKmC3O/IFo/LADv5/PMa808CRacGBKeLfUnZP/WvAjrs6oZMP7vh/4SdDly085IoHigQBOEfrubyilv5n8FZRqkfkgLMA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1awWfYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1awWfYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786E71F000E9;
	Mon, 13 Jul 2026 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951665;
	bh=ntw3goZdAM05lAG1AKRisVn1zZdb8jrCzgeqQS/qYJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A1awWfYHHuZyUoN/ydlQePN4+1bby4cDEVsk7HwYkj30oAV1ctzH6ABdyw5xWhXSc
	 b0aDNe8eTWJ5O10qOGZLQOwrx7hF1PalL3Evr+xDdfsNBW1qjtJvrK8k8hZsO7D36x
	 0zj0Oj8+HnVtt1vzMf17VqJo0a2KRn2sTWtVFvsn6yqDcPt5vcKBabOmhCKArOlLyk
	 k8hn5FO1PW5ot649LmcNrbHH2e5utlrN4rN4WAd6X58DWJKvOvrwtc8Nwrmqepgkm3
	 0cwBiVG/U9ET+o64YWs4eBFGhSVYf5T79Yuof5oeUOtObsLfQiLhQ9caVWswuIsNZA
	 /+hNm9JgZl2wg==
Date: Mon, 13 Jul 2026 17:07:36 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Kamal Heib <kheib@redhat.com>
Cc: linux-rdma@vger.kernel.org, Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-rc 0/2] RDMA/ionic: Fix NULL pointer dereferences
Message-ID: <20260713140736.GN33197@unreal>
References: <20260709220353.729951-1-kheib@redhat.com>
 <20260712091326.GG33197@unreal>
 <alPrQa9ZgDaGuPYo@lima-fedora43>
 <20260713091733.GJ33197@unreal>
 <alTICI1PQ_7D7_ea@lima-fedora43>
 <20260713113521.GM33197@unreal>
 <alTc3yfXNyGyzjCw@lima-fedora43>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTc3yfXNyGyzjCw@lima-fedora43>

On Mon, Jul 13, 2026 at 08:41:03AM -0400, Kamal Heib wrote:
> On Mon, Jul 13, 2026 at 02:35:21PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 13, 2026 at 07:12:08AM -0400, Kamal Heib wrote:
> > > On Mon, Jul 13, 2026 at 12:17:33PM +0300, Leon Romanovsky wrote:
> > > > On Sun, Jul 12, 2026 at 03:30:09PM -0400, Kamal Heib wrote:
> > > > > On Sun, Jul 12, 2026 at 12:13:26PM +0300, Leon Romanovsky wrote:
> > > > > > On Thu, Jul 09, 2026 at 06:03:51PM -0400, Kamal Heib wrote:
> > > > > > > Fix two potential NULL pointer dereferences in the ionic driver by
> > > > > > > adding the missing NULL checks before dereferencing netdev pointers.
> > > > > > 
> > > > > > How is it possible to have ionic IB driver without netdev?
> > > > > > 
> > > > > > Thanks
> > > > > >
> > > > > 
> > > > > Thanks for your review, after taking a deeper look:
> > > > > 
> > > > > For Patch 2 (ionic_create_ibdev): You are right. Since lif is embedded in
> > > > > netdev via netdev_priv() and they are allocated/freed together,
> > > > > lif->netdev cannot be NULL if lif is valid, Please drop this patch.
> > > > > 
> > > > > For Patch 1 (ionic_query_device): This one should remain.
> > > > > ib_device_get_netdev() is a core RDMA API that explicitly returns NULL in
> > > > > multiple code paths:
> > > > > 
> > > > > - Invalid port: if (!rdma_is_port_valid(ib_dev, port)) return NULL;
> > > > > - No port_data: if (!ib_dev->port_data) return NULL;
> > > > > - NULL netdev pointer stored in port_data
> > > > > 
> > > > > Also, the return value from ib_device_get_netdev() is being checked in
> > > > > multiple places in both drivers and the RDMA core.
> > > > > 
> > > > > Let me know what you think?
> > > > 
> > > > I think that you shouldn't copy/paste answers from your favorite AI tool.
> > > > 
> > > > Thanks
> > > >
> > > 
> > > With all due respect..., Your response is not contributing to the
> > > discussion about the patch, if you don't like the change or you think
> > > that it is not justified, you can say so.
> > 
> > Kamal,
> > 
> > You pasted a response from Claude/Codex while at the same time, you are expecting
> > me to spend time and effort explaining why all of it does not apply to the current
> > code.
> >
> 
> Lean,
> 
> AI is havely used in multiple kernel development areas including RDMA.
> Also, I think you should already know that from the company that you
> work for...
> 
> Many respected kernel developers already using AI as productivity tool,
> Judging a patch based on whether AI may have used or not is not a
> valid argument, again if you don't like the change or you think it is
> not justified, you can say so.

Like Jason wrote, we have no issue with patches developed with the
assistance of AI. We do, however, object to AI-generated emails and
replies.

Thanks

> 
> 
> > Thanks
> > 
> > > 
> > > > > 
> > > > > Thanks,
> > > > > Kamal
> > > > > 
> > > > > > > 
> > > > > > > Kamal Heib (2):
> > > > > > >   RDMA/ionic: Fix potential NULL pointer dereference in
> > > > > > >     ionic_query_device
> > > > > > >   RDMA/ionic: Fix potential NULL pointer dereference in
> > > > > > >     ionic_create_ibdev
> > > > > > > 
> > > > > > >  drivers/infiniband/hw/ionic/ionic_ibdev.c | 8 ++++++++
> > > > > > >  1 file changed, 8 insertions(+)
> > > > > > > 
> > > > > > > -- 
> > > > > > > 2.55.0
> > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
