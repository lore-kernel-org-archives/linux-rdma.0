Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C32C310774
	for <linux-rdma@vger.kernel.org>; Tue,  3 Feb 2026 09:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111994; cv=none; b=bqtSqjK4k0DguoaEZhLRDl51NkkLNXej1bdrzCJ4oyDxO1BBjznWJSw/RyE9WLjL7qf6v5sLuvl+gpD6qUI5Wfcuk+ZlwehcnzSPSm+X5D3uVyISy09l9Q8fefGralsZMLoO94diWNpawApQZuasYGryFom/jBK8G/M4+gF2i24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111994; c=relaxed/simple;
	bh=W+b/4F5SuzkuLwyQM5hHxlQ5/YOuLvDNjh9M3Zrby0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhpTru9c4CQ0Jq9RF8qBq26gNn7c0rjRXwQxYoldHVCekAercpUlLyZQ2Am/7Gxda9RfxiLscVgHfZvbB64DSHvmqP7BfPFP5yvrGb2xwZUD78rMsgs0ipWoPJNqgHhFQ/okZhf6mZEw7bkDTNGfbjZ9gLPTJ8OzQuMMY9h2UiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtfb2dZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtfb2dZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B24C19421;
	Tue,  3 Feb 2026 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770111994;
	bh=W+b/4F5SuzkuLwyQM5hHxlQ5/YOuLvDNjh9M3Zrby0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mtfb2dZqVtAyjnCXvZz9N6V5Liv4+rMlOkpv89lFJL2zxxVBGlIKLziUulwCRjNLe
	 t8DDNXt0XgHlQSufazQrUk90iLbam2sWu5RceUs7AVRV64BHXAmPH47TiqN3kH06L3
	 kofgft3mVMqaiu5nnF46bbiYQ8VxRvN0RJ97w4zm/UnamJqu2IRXuc62s4niiOqD/T
	 OhSk9RM0qU4XRRxVYHbOSoY1pmaXvyhf3t+9UgVcRomO/SweAXl865yv2ME/k9dkCO
	 fzIClIh6JJwjv09er6cYupXLEHx4VSdxWNdz5i9KZrDrpDLhJOWwCSL2VayVaAW108
	 MPu5sEyORg4Ag==
Date: Tue, 3 Feb 2026 11:46:29 +0200
From: Leon Romanovsky <leon@kernel.org>
To: YunJe Shin <yjshin0438@gmail.com>
Cc: jgg@ziepe.ca, ioerts@kookmin.ac.kr, joonkyoj@yonsei.ac.kr,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/umad: Reject negative data_len in ib_umad_write
Message-ID: <20260203094629.GQ34749@unreal>
References: <20260202183449.GL2328995@ziepe.ca>
 <20260203064620.686140-1-ioerts@kookmin.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203064620.686140-1-ioerts@kookmin.ac.kr>

On Tue, Feb 03, 2026 at 03:46:08PM +0900, YunJe Shin wrote:
> ib_umad_write computes data_len from user-controlled count and the
> MAD header sizes. With a mismatched user MAD header size and RMPP
> header length, data_len can become negative and reach ib_create_send_mad().
> This can make the padding calculation exceed the segment size and trigger
> an out-of-bounds memset in alloc_send_rmpp_list().
> 
> Add an explicit check to reject negative data_len before creating the
> send buffer.
> 
> KASAN splat:
> [  211.363464] BUG: KASAN: slab-out-of-bounds in ib_create_send_mad+0xa01/0x11b0
> [  211.364077] Write of size 220 at addr ffff88800c3fa1f8 by task spray_thread/102
> [  211.365867] ib_create_send_mad+0xa01/0x11b0
> [  211.365887] ib_umad_write+0x853/0x1c80
> 
> Fixes: 2be8e3ee8efd ("IB/umad: Add P_Key index support")
> Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
> ---
>  drivers/infiniband/core/user_mad.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Please submit this patch as a separate email, not as a reply.

Include a version number in the commit subject, and provide a changelog
below the Signed-off-by tag and the "---" marker.

Thanks
