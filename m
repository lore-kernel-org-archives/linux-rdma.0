Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD7A36213B
	for <linux-rdma@vger.kernel.org>; Fri, 13 Feb 2026 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770998844; cv=none; b=A6yebPnDi2aqtADce88qGidW3cF1kSM5UXnf8+j+BglJxi+Zr6pbaR+fdbaf6kbcCtYyqKkrcr3KVEgfzSklnML/HEIlbS21Os7+S1puCkyT1f/YFC5Y3x7z4C0eYYDUYVeU6M/pPkA9HICjsm51U8PJIeTXy07RKW479zJVii8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770998844; c=relaxed/simple;
	bh=gmzIdOADOCJ5OUzKtZhkwvXqtLxzoKA0Ujbjj/3jrx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udTlxADKj5OZeX6Hrk3dmyA08XDDhcarNBs2FRPLbtgrR/SCGzMNyxIWLqf8FfF9Y62+DZ1LyZyd6GG0BJxfDRDOzS8fbqbdbUDsq/tynLVZnlQmUMA5riEp+5ADDv9SPZLTTT6UXPz53Rrt3fLzOQefTLmaUQZCZg/riis9jIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oK39EKRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oK39EKRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D497C2BCB3;
	Fri, 13 Feb 2026 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770998843;
	bh=gmzIdOADOCJ5OUzKtZhkwvXqtLxzoKA0Ujbjj/3jrx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oK39EKRLsnZ3Ijzwwc6yJ5qvTbQay6r2rVb5k0wuacrHy1b/csKqpI+2bY8Tr42sM
	 KAKwYh3vWODE9l1jqcVRgny9RVmFo/SzE941jx3K7XFXIkeD+4uoaqf1C5JbIFWYEv
	 JPqCous9JnN1sWgFH4edM29YvPZdajBc31soE1d54d++jb6tE9bZdbgSZEWJg/HiQH
	 URhFZLMws6Iw8guUpe1NpiTI5fid3NNsh6+rtvUM08JxsogdotAqWoI3UXz4WEgUXm
	 FhPPhiNW5O2tpIXmgWYntgTsSvoKcbHo5/7mQeaybmStkPU6zun6pmvKpaPjCqFN0E
	 KmA2fuzvzGB0Q==
Date: Fri, 13 Feb 2026 18:07:13 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linuxarm@huawei.com,
	tangchengchang@huawei.com
Subject: Re: [PATCH for-next 2/3] RDMA/hns: Add write support to debugfs
Message-ID: <20260213160713.GU12887@unreal>
References: <20260206103110.3414311-1-huangjunxian6@hisilicon.com>
 <20260206103110.3414311-3-huangjunxian6@hisilicon.com>
 <20260212165507.GH12887@unreal>
 <28023174-dd0a-246e-ee0d-531b0bfda873@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28023174-dd0a-246e-ee0d-531b0bfda873@hisilicon.com>

On Fri, Feb 13, 2026 at 03:52:50PM +0800, Junxian Huang wrote:
> 
> 
> On 2026/2/13 0:55, Leon Romanovsky wrote:
> > On Fri, Feb 06, 2026 at 06:31:09PM +0800, Junxian Huang wrote:
> >> Add write support to debugfs.
> >>
> >> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
> >> ---
> >>  drivers/infiniband/hw/hns/hns_roce_debugfs.c | 38 +++++++++++++++++---
> >>  drivers/infiniband/hw/hns/hns_roce_debugfs.h |  1 +
> >>  2 files changed, 35 insertions(+), 4 deletions(-)
> > 
> > <...>
> > 
> >>  static const struct file_operations hns_debugfs_seqfile_fops = {
> >>  	.owner = THIS_MODULE,
> >>  	.open = hns_debugfs_seqfile_open,
> >>  	.release = single_release,
> >>  	.read = seq_read,
> >> +	.write = hns_debugfs_seqfile_write,
> >>  	.llseek = seq_lseek
> >>  };
> >>  
> > 
> > <...>
> > 
> >> -	debugfs_create_file(name, 0400, parent, seq, &hns_debugfs_seqfile_fops);
> >> +	debugfs_create_file(name, ops->write ? 0600 : 0400, parent,
> >> +			    seq, &hns_debugfs_seqfile_fops);
> > 
> > What is this "ops->write ?" check? You added write callback in this
> > exactly patch. It is always true.
> > 
> 
> This ops is the function argument "const struct hns_debugfs_rw_ops *ops", not
> the file_operations hns_debugfs_seqfile_fops. This ops->write can be NULL when
> the file is read-only, such as the change in create_sw_stat_debugfs() in this
> patch.

Excellent, inline your init_debugfs_seqfile().

Thanks

> 
> Junxian
> 
> > Thanks
> > 
