Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D3B24A05D;
	Sun, 26 Jul 2026 08:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785054264; cv=none; b=KWt51vyaklIxRMNFmX6svDYa/Gs8IB3r2t8JzmNgjMpUsSQMLZaocOE0zqu/sZnDJpfuR3/OyI1MomW/sCqb/lSujjm2YAHCQ3pq1NdjgiP3aG25P6jT2JVlBmSbDkxfrbl16qLR7HCZOY+zM/ShqXbpOwVjaM63wR97HLzjOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785054264; c=relaxed/simple;
	bh=7w56QwqJoGYwdkDfhdvPbtCVpl7svrxZ3xQdRN9kqeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eypU912JWk7QiRv9y7HboAfKmCDNPEeyQPZ8fKv9ENZpyLSr5mdpqwCgiWi1oAVTipeEA64gEJQMQxvFJLOPQgRcNxoAX5dpUnZQ1awB2f89G6zvpc/pSUeHAP2EQFsM/QAqQBaOM19Wzl/iuZNC42nRjjXi/CnJqDrl+icBCRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=naYCHlv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naYCHlv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CFF1F000E9;
	Sun, 26 Jul 2026 08:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785054262;
	bh=1h8J0+r+HKDH96f38eGX//+FYYpw9kc8NPw1oyEbaDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=naYCHlv2BL4Vo5IMZ+rucI1IUcm2W+5FvAdPLeFy/8TMfofkrUngKY0lHlo/vG6F4
	 Lrr+4uVz6/cfuXZg0bnFRsvN2neMPceWNnPfBHNLESE+J5QuKgZ1YioVZSyBz5oJtJ
	 ze2up/U4UFtMocCPZjFKPedCx8NGK25mUxbyfXm7gzZOOz/U5J95ePcwWQiSnduZia
	 ZyS0JORzuiIOFYHqZDSK6REAX4/Td3RhawVi2D5joirUlDtFDsZ6vA1RSYiIc4ixK9
	 4TddXhyhT4jfAdrJmhVXMLJFQ1qORwSvUj8wIbVzE81kkbXNMgjtbTKzuymVgH9sGl
	 Wlt66JKBy459Q==
Date: Sun, 26 Jul 2026 11:24:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gou Hao <gouhao@uniontech.com>, maddy@linux.ibm.com, mpe@ellerman.id.au,
	npiggin@gmail.com, chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
	bharat@chelsio.com, jgg@ziepe.ca, namcao@linutronix.de,
	ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com,
	clg@kaod.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com,
	kernel@uniontech.com
Subject: Re: [PATCH v2 0/6] remove dead NULL checks after GFP_NOFAIL
 allocations and fix xive use-after-free
Message-ID: <20260726082419.GF12003@unreal>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260725202632.dcb325658896a470df91cf57@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725202632.dcb325658896a470df91cf57@linux-foundation.org>

On Sat, Jul 25, 2026 at 08:26:32PM -0700, Andrew Morton wrote:
> On Fri, 24 Jul 2026 10:28:45 +0800 Gou Hao <gouhao@uniontech.com> wrote:
> 
> > This is a code cleanup series that removes unreachable
> > NULL checks (and associated error handling) that follow allocations
> > using __GFP_NOFAIL, which guarantees non-NULL return.
> 
> Sigh.
> 
> Back when Linux ran on an abacus, I added __GFP_NOFAIL because four or
> five sites (file systems) were infinitely looping on alloc_pages until
> it succeeded.  I figured we should move this operation into the page
> allocator so we could easily find those sites and fix them to Not Do
> That.
> 
> I made it very clear (changelog and code comments) that no new code
> should use __GFP_NOFAIL.  How did that work out?
> 
> hp2:/usr/src/linux-7.2-rc4> grep -r __GFP_NOFAIL | wc -l
> 241
> 
> So much lameness!   My immediate reaction to your patchset is "No.  Fix
> the damn code instead".  But I've resoundingly lost that fight.
> 
> 
> Thanks, I'll scoop up the entire series.  If individual patches pop up
> in linux-next then I'll drop the mm.git copies.
> 
> 
> 
> AI review has a shower of possible pre-existing issues.  I'm seeing
> use-after-free, double-free, leak, system hang, NULL pointer
> dereference, usual stuff :(
> 
> They're in powerpc and cxgb4, if maintainers are interested.
> 
> 	https://sashiko.dev/#/patchset/20260724022851.466017-1-gouhao@uniontech.com

Regarding cxgb4, yes, I'm looking into it.

Thanks

