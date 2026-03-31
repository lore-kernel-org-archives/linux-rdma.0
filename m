Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB5338CFE7;
	Tue, 31 Mar 2026 19:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774983864; cv=none; b=hdMgpxZvZ7iBg8BGPIeBTSqJwclIn5eniyDYDdQQI5Bpbw9Hl/oHN3laeTMoZIggxdmKB2eDyHFlI71qipg1NbUxEsHYZJ+Y0abeLhfW6qr4H26r0zDPYMTSOi9PXnM1LUl4mNa1pIYyckkX+L7pEf0D4p8DwbwB140ExKgWQHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774983864; c=relaxed/simple;
	bh=j8X4DzsLvitAVVL0nfNRuHGFpM67mA9JRRksyx8JUFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmgF84aYLicr9l3Xg/r91WJKRxWn2x4AXCNcBPecDzHLqXPjsg4ZpbGk1pZsuN8nVF+8J706OcGauZsChyLAbDUuqljBPxoY04LVSATLvlYToYjyTxfGeibgSJ7XnI3faHgJ1/9Iql2cPZVN7frEcJMbX4zQRX8xv4QNWYUSu/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vQvZc5Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vQvZc5Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904CCC19424;
	Tue, 31 Mar 2026 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774983864;
	bh=j8X4DzsLvitAVVL0nfNRuHGFpM67mA9JRRksyx8JUFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vQvZc5AdSd+kvVLKgjfYf/4yntG2SQxhGOZcisTTmJ4nXT4GWaNMUKaNc5QsH0sjs
	 QBxbtQLLJu7Cl0Ka82B6xwpXHb5/ngVmJ94Q045zsUcJUrnf1BBm6zn3cDN0ALiYjS
	 47Jjkrl0PVzf0MIayhPBBij529ENhX4uj4OKZh1KCBkKkDSzPTpfFYpTPHZJX5LKqo
	 Um+jmOPtwbJK96gMlRJqvc1psst2RTwW3ZEkY9Z6bOFU+F1gehZGtQwes/XuNXVCWj
	 BWSo/Lane+wS9wSrB6WqQCLuC1073ZZ8x3ZqDTC9G71cgIfM0xn43A+5/GuMy7vbHM
	 P5nLpMnkUdSpg==
Date: Tue, 31 Mar 2026 22:04:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: dledford@redhat.com, haggaie@mellanox.com, jgg@ziepe.ca,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] IB/mlx5: Fix potential NULL dereference in query_device
Message-ID: <20260331190419.GJ814676@unreal>
References: <20260331134955.GF814676@unreal>
 <20260331182615.16983-1-prathameshdeshpande7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331182615.16983-1-prathameshdeshpande7@gmail.com>

On Tue, Mar 31, 2026 at 07:25:56PM +0100, Prathamesh Deshpande wrote:
> On Tue, Mar 31, 2026 at 04:49:55PM +0300, Leon Romanovsky wrote:
> > On Tue, Mar 31, 2026 at 02:44:27AM +0100, Prathamesh Deshpande wrote:
> > > Smatch reported an inconsistent NULL check for 'uhw' in
> > > mlx5_ib_query_device(). While 'uhw_outlen' is checked at the end of
> > > the function before calling ib_copy_to_udata(), 'uhw' is explicitly
> > > checked for NULL earlier in the same function.
> > >
> > > If a caller provides a non-zero 'uhw_outlen' but a NULL 'uhw' pointer,
> > > ib_copy_to_udata() will attempt to dereference 'uhw',
> >
> > How is it possible?
> 
> Hi Leon,
> 
> You are right that in the current uverbs paths, 'uhw_outlen' and 'uhw'
> should stay in sync.
> 
> However, Smatch flags this as an inconsistency because 'uhw' is explicitly
> checked for NULL earlier in this same function (at line 968). If the code
> assumes 'uhw' could be NULL there, it is safer and more consistent to
> check the pointer directly before passing it to ib_copy_to_udata() at
> line 1357.
> 
> This prevents any future refactoring or unconventional kernel-space
> callers from accidentally triggering a NULL dereference.

Kernel-space callers don't use uverbs path. It is solely for the
user-space access.

Thanks

> 
> What do you think?
> 
> Thanks,
> Prathamesh
