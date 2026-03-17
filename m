Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7789E3A0EA6
	for <linux-rdma@vger.kernel.org>; Tue, 17 Mar 2026 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773741279; cv=none; b=o7zo2Ea0qFY8UHU16ZHEZQ12vyWTz0iRY0PtzJVqe97K/BZC1cMcI6YrbM16UiOwqNm0Je1sqfuurlTNuMSQ2iVwN9paI90D+J+HUNmpvKvrj4C2sRT8sT3fWlqxG/+YSWivF89oUxW/nPhsGBdFkNy/0aGYHO2ehyjxhFpF9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773741279; c=relaxed/simple;
	bh=KRbAB3nbYcdKPkPB5NxncRii3QmVu13aOTRGjoEfyWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VwMy7MTswzGR+0Zro2eqVe9AJSUunSyulU1oovVBul3X/eMv5jFHKkj6ZuOM2vqEkwv4lfdAWkkrcdDOlRue4LFEyGLq7wsmB8AV1Aq28M5jFyasHQr6+1nznS/LMxK/T5xmpsHkdByEMUIfa/zD8M0VN4Iy3+0pEDSseYE+7IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTIqKWIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTIqKWIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA363C4CEF7;
	Tue, 17 Mar 2026 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773741278;
	bh=KRbAB3nbYcdKPkPB5NxncRii3QmVu13aOTRGjoEfyWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iTIqKWIFiU7NvEvvD+LemVXcF1mrRLPcpOEc/f18wud+lUCArDwTmNoCC6wYt+/wc
	 KC0PF21jCBFvarvgfyl3vMEtcY7sggO3w9Xd/gHQCHb88YVKGkfz/gaYuL8eLNgZXl
	 EHuhGK4aECpxjNQbiEqdwHBODrGG1i+AWdSao/Ww27O+/rllv6oMKyRGCCPRKZtYGT
	 rMDKxogkmM96oIPXo/QKavxyskSYbSMtk7ymxQU/t0F3iEj9lR8gLK9c7YWCbOP1MB
	 cICPEXps4BHz7YKkaaF4FqYBqbnMHWfAWDCZGY+fzPnFZ+97zyxW2MPf8r73Vs1Nvc
	 Bv8gcUjF9JWHQ==
Date: Tue, 17 Mar 2026 11:54:33 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: jgg@ziepe.ca, Dean Luick <dean.luick@cornelisnetworks.com>,
	Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-next resend 07/24] RDMA/hfi2: Add system core header
 files
Message-ID: <20260317095433.GT61385@unreal>
References: <177325138778.57064.8330693913074464417.stgit@awdrv-04.cornelisnetworks.com>
 <177325166078.57064.16035123727786325107.stgit@awdrv-04.cornelisnetworks.com>
 <20260316155826.GD61385@unreal>
 <9ce84cf2-e916-4cac-b9a2-65f059b6508d@cornelisnetworks.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ce84cf2-e916-4cac-b9a2-65f059b6508d@cornelisnetworks.com>

On Mon, Mar 16, 2026 at 05:37:30PM -0400, Dennis Dalessandro wrote:
> On 3/16/26 11:58 AM, Leon Romanovsky wrote:
> > On Wed, Mar 11, 2026 at 01:54:20PM -0400, Dennis Dalessandro wrote:
> > > Add header files for hooking into the core system, things like IRQs and
> > > affinity.
> > > 
> > > Co-developed-by: Dean Luick <dean.luick@cornelisnetworks.com>
> > > Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
> > > Co-developed-by: Bendan Cunningham <brendan.cunningham@cornelisnetworks.com>
> > > Signed-off-by: Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>
> > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> > > ---
> > >   drivers/infiniband/hw/hfi2/affinity.h |   86 +++++++++++++++++++++++++++++++++
> > >   drivers/infiniband/hw/hfi2/aspm.h     |   36 ++++++++++++++
> > >   drivers/infiniband/hw/hfi2/efivar.h   |   17 +++++++
> > >   drivers/infiniband/hw/hfi2/eprom.h    |   11 ++++
> > >   drivers/infiniband/hw/hfi2/mmu_rb.h   |   78 ++++++++++++++++++++++++++++++
> > >   drivers/infiniband/hw/hfi2/msix.h     |   31 ++++++++++++
> > >   6 files changed, 259 insertions(+)
> > >   create mode 100644 drivers/infiniband/hw/hfi2/affinity.h
> > >   create mode 100644 drivers/infiniband/hw/hfi2/aspm.h
> > >   create mode 100644 drivers/infiniband/hw/hfi2/efivar.h
> > >   create mode 100644 drivers/infiniband/hw/hfi2/eprom.h
> > >   create mode 100644 drivers/infiniband/hw/hfi2/mmu_rb.h
> > >   create mode 100644 drivers/infiniband/hw/hfi2/msix.h
> > 
> > <...>
> > 
> > > +/* Can be used for both memory and cpu */
> > > +enum affinity_flags {
> > > +	AFF_AUTO,
> > > +	AFF_NUMA_LOCAL,
> > > +	AFF_DEV_LOCAL,
> > > +	AFF_IRQ_LOCAL
> > > +};
> > 
> > Maybe I'm misremembering, but I recall we already discussed affinity
> > management in the driver in the context of hfi1, and our position at the
> > time was that handling affinity belongs in user space.
> 
> I don't recall specifically, but I do agree it should be handled in user
> space as the ultimate decider. The driver just provides hints as to where
> best to run things for optimal performance. User space is free to manage if
> it chooses.

So there is no need in all this affinity code, which looks like policy,
just use right attributes from the beginning.

Thanks

> 
> -Denny
> 
