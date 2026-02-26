Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5063437418C;
	Thu, 26 Feb 2026 07:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772089798; cv=none; b=HMakRAP0fXCMCAy3JwnuCRwxM7Kt3E+tiomDv2FMMcNj56WBwsfopM9+IfISujmC9hWdmSObVLciLHBGLh4zNrwerv9/Ioas2KshM97aOw68VfN2kmnaiVzd5r6a17tvzvadnWTPzokRy3TGsZTeH1M/BV97ToNLthZ+A8ePu6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772089798; c=relaxed/simple;
	bh=EXG2vTsBZOVVqAomHjOacJ+jd7HRSgEW6H+9P27AWiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRZiaKANgY80HM+3BblJLuQGMERY9yz6cWkc1smx+AZhGyiQmnwkJkFTknXAVJDsw9KIp+sZeA9W9ApHVmgndyRxfG71gPOzKgvzE3hzvRdcOb9KkoDQtG69bZKnYK3K+i3lkxbOkni7Of3kA7G0c96Y8UXMeNLPkIkKp5dNNWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ak7l2LWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ak7l2LWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8358AC19424;
	Thu, 26 Feb 2026 07:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772089798;
	bh=EXG2vTsBZOVVqAomHjOacJ+jd7HRSgEW6H+9P27AWiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ak7l2LWJHFY7OI9NF3tpbWZ8ydzse/gEKyBDF3CYciBH6bPN9U/QvIHQzCaqNoPov
	 qoEf1SEmpftQAMoc51hQQVV3QsTMSsmZP9ulIQQUkovNOlXjkIi97n7dwKFt5bUop7
	 qRxy0BmESbgsQ13b8e6omZBAhy9kuYw8H+x6DpcC1KLgk7qlXhZx4cT5+sZeSLQtdA
	 eQBMYQA5QOwamSFvXz8uGc8vrn9x3GUCTgpg2cynBIb9+1yT+SHqfXqS7buuet6VX4
	 K7cZCoUQL42R38FiEib8vY7P09GD1xSB5N6tAv2y/Xgd4DI7LTe17qFFifenia3Sk2
	 RP8QK7lNXqRJg==
Date: Thu, 26 Feb 2026 09:09:54 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>
Cc: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2?=
 =?utf-8?B?XSBSZTogW1BBVENIXVtyZG1hLW5leHQ=?= =?utf-8?Q?=5D?= RDMA/erdma: Use
 NUMA-aware allocation for MTT tables
Message-ID: <20260226070954.GC12611@unreal>
References: <20260225085143.1721-1-lirongqing@baidu.com>
 <7cfd31d3-fe40-8b2d-cea8-14748db5f35b@linux.alibaba.com>
 <81eac7dd27d344b59da16bd4cef7bc77@baidu.com>
 <b00bcf9a1aee447eb64d955c52851c05@baidu.com>
 <39e148d1-6a56-863f-8126-e92d452b3106@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39e148d1-6a56-863f-8126-e92d452b3106@linux.alibaba.com>

On Thu, Feb 26, 2026 at 09:50:00AM +0800, Cheng Xu wrote:
> 
> 
> On 2/25/26 8:07 PM, Li,Rongqing(ACG CCN) wrote:
> > 
> >>> On 2/25/26 4:51 PM, lirongqing wrote:
> >>>> From: Li RongQing <lirongqing@baidu.com>
> >>>>
> >>>> Currently, MTT (Memory Translation Table) buffers are allocated
> >>>> without NUMA awareness using kzalloc() and vzalloc(), which allocate
> >>>> memory on the NUMA node of the calling CPU. This can lead to
> >>>> cross-node memory access latencies if the erdma device is attached
> >>>> to a different NUMA socket.
> >>>>
> >>>> Switch to kzalloc_node() and vzalloc_node() to ensure MTT buffers
> >>>> are allocated on the local NUMA node of the PCIe device
> >> (dev->attrs.numa_node).
> >>>> This reduces latency for hardware access and improves performance.
> >>>>
> >>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> >>>> ---
> >>>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 4 ++--
> >>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>
> >>> Hi, Li RongQing,
> >>>
> >>> Thanks for the patch. However, I think it is better to keep the
> >>> current behavior, for the following reasons:
> >>>
> >>> 1. This path is in the control plane, so allocating memory from a remote
> >>>    NUMA node should not have a noticeable performance impact.
> >>
> >> If TLB Miss , or the internal cache misses , does the HCA need to query the MTT?
> >>
> 
> This is rarely happen in our chip.

So why do we need this patch? The xxx_node() functions are useful when you
need to force allocation on a specific NUMA node. In most cases, a plain
kmalloc() will allocate memory on the same node as 'struct erdma_dev *dev',
which typically matches the PCI device's NUMA node.

Please avoid vague phrasing like 'potentially improves performance' in the
commit message and responses. It adds no meaningful information.

Also, please remove the dev->attrs.numa_node caching from erdma and rely on
dev_to_node() instead.

Thanks
