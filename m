Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60782DF128;
	Sun, 11 Oct 2026 10:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716025; cv=none; b=dawaj2DkN5Dz0HqCaDYBz+mupuRgWLg/0tu++hocMgQfBzdcGdwa624cZgDELtjvidzMv8xLrqPUaWuDQhITW+/F0tLmJpi9X+ugGXBh/1UDewY1MuAj3zf1L2JxUkJ4Hh2LPwJRR1XUUp9CrT4W8YddxWyitH0CpF55BMWRX1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716025; c=relaxed/simple;
	bh=ZikIYLsNDP1Xlh0Hs/08w+MqXAyAzvFxJpvFTYgyLuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCuwKxT+31M8vZs9J6ESCURXhmkp9SmJnEgCKQ7BtsBdPdt0S28kooEWn6JmhE2g2SzXntj0CYMt/1ouI9jnQpy+P/H63wMoSmKF0wlodNvLwdulRuxqL7oCcM2ZM3JsBXGph/Gb4EOEReE4KS1ozG4vpSDPO8aP+oQ4toW1Fd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4aF8BBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4aF8BBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D972A1F0089B;
	Sun, 11 Oct 2026 10:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791716024;
	bh=5UxPB4QSqrNNLt5ulakoA2jmVgb3rItaahH2eQ7Y07o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G4aF8BBMxKLJZQ2IyFvxIyFFoyYWDDZYOCiMOtvAWgn1jiqs8agmExs8UjYwk+NYh
	 2XVaq4PmNipWccuCLHKK9vFD0Xubhmsk5l04P86F9pqZXAceP4peWYoOb3GtD4Sd3X
	 J8W0N7gGlLYT7+gFMEHlE+6NeY42v22Wv0F/zSWETEU9WUdOGv3C2tC1ZMtAC6bTsI
	 X2ty6yHwApxgmvc400/du7qRw+bJ5phyISmlwcTWEWlTVLpJ0r3HbxYXAsGNJIkQWy
	 r3fDvWCjV0ksVRbhau43fRcOADU3s1Z119qgzE7+/tOzTXg8IM3My+v1z+f/T+rwwu
	 Cry7zATuEsXaA==
Date: Sun, 11 Oct 2026 13:53:41 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Haitam Lazaar <haitam@lazaarsec.com>
Cc: Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	stable <stable@vger.kernel.org>
Subject: Re: [PATCH for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read
 responses
Message-ID: <20261011105341.GC27033@unreal>
References: <1a109695301.353d00802169.3051945239243282542@lazaarsec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a109695301.353d00802169.3051945239243282542@lazaarsec.com>

On Mon, Oct 05, 2026 at 12:14:19AM +0000, Haitam Lazaar wrote:
> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> 
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> 
> mask:
> 
> 
> 
>     /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
> 
>     rv = siw_check_sgl_tx(qp->pd, wqe, 0);
> 
> 
> 
> Because perms is 0, siw_check_mem()'s authorization test:
> 
>     if ((mem->perms & perms) < perms)
> 
> evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
> 
> an untrusted remote peer can issue an RDMA Read targeting any valid
> 
> STag in the Protection Domain, even if the memory was registered strictly
> 
> as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.
> 
> 
> 
> Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
> 
> when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
> 
> perms = 0 for standard local sends.
> 
> 
> 
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> 
> Cc: mailto:stable@vger.kernel.org 

Please read Documentation/process/email-clients.rst, remove stable and
resend the patch.

Thanks

> 
> Signed-off-by: Haitam Lazaar < mailto:haitam@lazaarsec.com >
> 
> ---
> 
> drivers/infiniband/sw/siw/siw_qp_tx.c | 13 +++++++++----
> 
> 1 file changed, 9 insertions(+), 4 deletions(-)
> 
> 
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> 
> index f7dd32c6e5ba..9e652585f904 100644
> 
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> 
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> 
> @@ -810,12 +810,17 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
> 
> 
> 
> if (tx_type(wqe) != SIW_OP_READ &&
> 
>     tx_type(wqe) != SIW_OP_READ_LOCAL_INV) {
> 
> +				enum ib_access_flags perms = 0;
> 
> +
> 
> /*
> 
> -				 * Reference memory to be tx'd w/o checking
> 
> -				 * access for LOCAL_READ permission, since
> 
> -				 * not defined in RDMA core.
> 
> +				 * Local READ permission doesn't exist in RDMA core.
> 
> +				 * A READ RESPONSE source is read by the remote peer,
> 
> +				 * so it must be checked for REMOTE_READ permission.
> 
> */
> 
> -				rv = siw_check_sgl_tx(qp->pd, wqe, 0);
> 
> +				if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
> 
> +					perms = IB_ACCESS_REMOTE_READ;
> 
> +
> 
> +				rv = siw_check_sgl_tx(qp->pd, wqe, perms);
> 
> if (rv < 0) {
> 
> if (tx_type(wqe) ==
> 
>     SIW_OP_READ_RESPONSE)
> 
> --
