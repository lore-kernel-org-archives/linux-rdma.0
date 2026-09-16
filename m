Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AE533ADB3;
	Wed, 16 Sep 2026 05:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789537412; cv=none; b=IkwbeNR4HqqjJmfJHjHCZ9GFyEMhat4zuQDSIlThkqNlAlwTBPzygEP/c/0zlptJZcjVp4yeQ8kSRoOgAAqZwlmRtxO6reZBMigMRwauQb658xeDQhrz7hpX8bWxHPI/m2tNI7oHIeGgqER/1WXF1nWO0ewgihxVeDctMThwnFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789537412; c=relaxed/simple;
	bh=wf/1jru+aMYSumhxE5iOYPf3Amw3MI4oOnb0+XeVrEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWsH+OQZ6IktbLJrN1fyGLCLCwi/BdxiEwnLkQRaEYpubxcmcMxoQJEHCz7lutee23J4qWoQfPZow0RsyCFI5Hhn3cIhzIXaULH6eBnxKgmhhQ0kYkcdS09P+wlRefEYse1YRp1Ir2TkFHW6IlIfCs8obE0kUniNno4BsgZbbzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6i+R0hE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6i+R0hE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5151F000FF;
	Wed, 16 Sep 2026 05:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789537410;
	bh=0D4F9J8GyvV8UNIgLHxwBC19/ZDtdi0XII192xUvI3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c6i+R0hE2m8W9y3OjMfTRYbnxr3chTUhIYOA44RShV9xOtvJ3X0MeGLfqb+x5AvOz
	 ymtIZkbqsT/kTh2AD9u/VQ+Jkh2NzOimyvsLsFUrk73CL39ks4ClPpkfrl9Kl9JoAa
	 o+53A/O7qeK5IHvVFc6CLOwWZGm+kGkPB/qYi/jSteXgtF45cusgBNI/q7/vuYN6I1
	 HLteFJi28pf1UyGH+9tevzvll4cVawm1V614kRLg2pstVSPY1oAFYqF78TKD0htr9W
	 L7EOgB2nLZsWS0ynELXf45aqjoQTbPgUN3LJcVdttCNpdEm/R3rGqnFvVlqC8KudbU
	 O5wz1Esj1P4VQ==
Date: Wed, 16 Sep 2026 08:43:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Honggang LI <honggangli@163.com>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion
 for RDMA message in 2GiB size
Message-ID: <20260916054326.GT13683@unreal>
References: <20260915064532.194540-1-honggangli@163.com>
 <20260915114914.GL13683@unreal>
 <aqoLuVxDIOHMuePi@fedora>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqoLuVxDIOHMuePi@fedora>

On Wed, Sep 16, 2026 at 11:23:37AM +0800, Honggang LI wrote:
> On Tue, Sep 15, 2026 at 02:49:14PM +0300, Leon Romanovsky wrote:
> > > After fixed it, the active side of RDMA READ failed with error code
> > > "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> > > the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
> > > 
> > >    int resid	= dma->resid;
> > > 
> > > This conversion set resid to -2147483648. `copy_data` abort as length
> > > greater than resid. Change resid to int64_t fixes this issue.
> > 
> > Why not size_t?
> 
> First, size_t is u64. dma->resid is u32. If use unsigned type, u32 is enough.

"Change resid to int64_t": originally, you used u64, which is equivalent
to size_t on 64-bit systems.

> 
> Second, I'm not sure it is right to use unsigned type. In `copy_data`,
> the loop terminate on negative value of `length`.

Length should never be negative. This is another example of rather
unclean code.

> 
> Use int64_t is safe and minimal changes of the code.
> 
> int copy_data(
> ..................
> 	while (length > 0) {
> 	^^^^^^^^^^^^^^^^^^^^^^^^
> 		bytes = length;
> ..............
> 		if (bytes > sge->length - offset)
> 			bytes = sge->length - offset;
> 
> 		if (bytes > 0) {
> 			iova = sge->addr + offset;
> 			err = rxe_mr_copy(mr, iova, addr, bytes, dir);
> 
> 			offset	+= bytes;
> 			resid	-= bytes;
> 			length	-= bytes;
> 			addr	+= bytes;
> 		}
> 	}
> 
> > 
> > >  
> > > -	payload = min_t(int, res->read.resid, mtu);
> > > +	payload = min_t(u32, res->read.resid, mtu);
> > 
> > Why don't we use the proper types from the start to avoid the need for
> > u32 casts?
> 
> Again, minimal the changes with u32 casts. We need something like this
> to use u32.

1. `int64_t` is not commonly used in the kernel. Please use `s64` instead.
2. I'm looking for a correct change and don't care whether it is minimal.

Thanks

> 
> ---
>  drivers/infiniband/sw/rxe/rxe_loc.h  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_resp.c | 15 ++++++++-------
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..ceb9321add96 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -91,7 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
>  
>  /* rxe_net.c */
>  struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
> -				int paylen, struct rxe_pkt_info *pkt);
> +				u32 paylen, struct rxe_pkt_info *pkt);
>  int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
>  		struct sk_buff *skb);
>  int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 53daaf4c1eb2..f548f312b393 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -536,7 +536,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>  }
>  
>  struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
> -				int paylen, struct rxe_pkt_info *pkt)
> +				u32 paylen, struct rxe_pkt_info *pkt)
>  {
>  	unsigned int hdr_len;
>  	struct sk_buff *skb = NULL;
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 02b16e2b49b8..383706de0b29 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -827,20 +827,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
>  static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
>  					  struct rxe_pkt_info *ack,
>  					  int opcode,
> -					  int payload,
> +					  u32 payload,
>  					  u32 psn,
>  					  u8 syndrome)
>  {
>  	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
>  	struct sk_buff *skb;
> -	int paylen;
> -	int pad;
> +	u32 paylen;
> +	u32 pad = 0;
>  	int err;
>  
>  	/*
>  	 * allocate packet
>  	 */
> -	pad = (-payload) & 0x3;
> +	if (payload % 4)
> +		pad = 4 - payload % 4;
>  	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
>  
>  	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
> @@ -934,9 +935,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>  {
>  	struct rxe_pkt_info ack_pkt;
>  	struct sk_buff *skb;
> -	int mtu = qp->mtu;
> +	u32 mtu = qp->mtu;
>  	enum resp_states state;
> -	int payload;
> +	u32 payload;
>  	int opcode;
>  	int err;
>  	struct resp_res *res = qp->resp.res;
> @@ -982,7 +983,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>  
>  	res->state = rdatm_res_state_next;
>  
> -	payload = min_t(int, res->read.resid, mtu);
> +	payload = min(res->read.resid, mtu);
>  
>  	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
>  				 res->cur_psn, AETH_ACK_UNLIMITED);
> 
> ---
> Thanks				 
> 
