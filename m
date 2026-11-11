Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794382133;
	b=hGlLbBF0O8hKuWzKFYyCBgVFSCGlUmvltEPJdqg35NJ91IMQn6ltL7rHlgL9tfTalwiQ
	 LJl6rFUJPE0usYmEQW+xbKLypBXs8WTFBsLZ8N2RX5l/Qfj/qeZckFbu2tuy5UFzVAGd8
	 2UXLmezoEVgWHSsxBMbN1D4ryHHOk2TdaSDMPGTshrOgq6KRne2CItB3mQRFO75nHAbhb
	 ejWd3i6q4nSLUO0X/P9G5+MvGwq9gy7QBZrGZRbCZLYRk06fAbf6IhKedOyecIRjgw763
	 1GxCFYStG+13UCA/DIWpHFjXPHm/JSHGvzKC7OfanKDNbWIZzuw3uyuojBd5Qy+gFyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794382133;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=V0HrLuJAtlC0soQN/5wC6HITjQMD/GmMYN1vKaj00R8=;
	b=Eks/9D0EvkjbL+r/YpyzOv6FZ49WPNsjtP/y9pj1aNY46+G9l5MEioxfKCwt1FXhZzrN
	 YURmeKBncpuFWp670gCmw4HAem5Yr2OhLgzDpgsM9j6dYoUJ2BKasZ3ZOWCp2v36Ws5tW
	 MTtHeSNW33PU0A7sAWYZ6j/Bc49PGNaIF/eKk/ipZn+17M9kme9yhxaeOszHTmJAw3iZY
	 ru5lExXdIUvJETI2UdXGoUQPdhGHJKlgbak4mJcpvkW1ZLpNxF1zkfWV/6/Wf7kHVAuX8
	 sam+aS2qNOZZla1xKzO6ogbCOpskIwTIVr85FbCv55EUR6GtkFtv0XKerusLQloPqnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nx+9A8lf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E222E606A324;
	Wed, 11 Nov 2026 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nx+9A8lf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F591F00A06;
	Wed, 11 Nov 2026 07:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794382132;
	bh=V0HrLuJAtlC0soQN/5wC6HITjQMD/GmMYN1vKaj00R8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nx+9A8lfHMYZgE+ZyzuvryRRFjElroAP9q3KOn371xuH0oMpkeC8/wB6LTlViQxWs
	 cXIuEBxZzMOC+9xb+d9kFSVgMJ2AtPBizjMoDgsfkRyz6YEdHN6rxuAuY/4Cnd0B2a
	 EpcSBeG/UTqtA+UY2VjCv0swfpjmQzUkkWSaVLrZittFp1/WCYB+adpZ/jjTqZyzPS
	 1pzEadCwRNewM4SJ2y/vRyGNj54NxpozSoEk8l8bmhyvx7grBpJp6vpDGgrCxCazwz
	 MLXzsJZ3nZ0BZ5eV7dS30rjEJHFNzfAz+cr7W2+RWg1j/AiwQHPIZiqtUt8XPWQPo3
	 Ylm6eVTzwWaaA==
Date: Wed, 11 Nov 2026 09:28:48 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@microsoft.com>
Cc: Konstantin Taranov <kotaranov@linux.microsoft.com>,
	Snehal Sanghvi <snsanghvi@microsoft.com>,
	"longli@microsoft.com" <longli@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v9 2/9] RDMA/mana: Create and destroy kernel RC
 QPs
Message-ID: <20261111072848.GO8635@unreal>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-3-kotaranov@linux.microsoft.com>
 <20261110154117.GN8635@unreal>
 <MA8PR83MB46500225F6F556D2D6D930B45CB4722@MA8PR83MB465002.EURPRD83.prod.outlook.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MA8PR83MB46500225F6F556D2D6D930B45CB4722@MA8PR83MB465002.EURPRD83.prod.outlook.com>

On Tue, Nov 10, 2026 at 06:55:49PM +0000, Konstantin Taranov wrote:
> > On Thu, Nov 05, 2026 at 09:59:21AM -0800, Konstantin Taranov wrote:
> > > From: Konstantin Taranov <kotaranov@microsoft.com>
> > >
> > > Implement kernel RC QP creation and destruction. This feature requires
> > > extended-WQE and power-of-two-SQ support from the HW.
> > >
> > > Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> > > ---
> > > v5:
> > > - Validate kernel QP queue sizes before allocating queues.
> > > - Bound SGE counts and enforce the TX/RX WQE size limits.
> > > v4:
> > > - Reject RNIC firmware send-SGE counts below 2.
> > > - Subtract the reserved SGE for extra-large OOB only for RNIC mana_ib.
> > >
> > >  drivers/infiniband/hw/mana/main.c    |  10 +-
> > >  drivers/infiniband/hw/mana/mana_ib.h |   6 +
> > >  drivers/infiniband/hw/mana/qp.c      | 206 +++++++++++++++++++++++++--
> > >  3 files changed, 211 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mana/main.c
> > b/drivers/infiniband/hw/mana/main.c
> > > index ceb4ec58023a..f54905764f59 100644
> > > --- a/drivers/infiniband/hw/mana/main.c
> > > +++ b/drivers/infiniband/hw/mana/main.c
> > > @@ -733,6 +733,13 @@ int mana_ib_gd_query_adapter_caps(struct
> > mana_ib_dev *dev)
> > >  	if (err)
> > >  		return err;
> > >
> > > +	/* Hardware supports at least one data SGE plus one reserved for extra-
> > large OOB. */
> > > +	if (resp.max_send_sge_count < 2) {
> > > +		ibdev_err(&dev->ib_dev, "Invalid max_send_sge_count %u,
> > expected at least 2\n",
> > > +			  resp.max_send_sge_count);
> > > +		return -EINVAL;
> > > +	}
> > 
> > This check does not make sense here. If this firmware is present, continue to
> > support it; do not fail just because the kernel has been upgraded. If it is
> > not present, why check for it?
> 
> It was Sashiko comment at some point that I should add this protection as
> a faulty HW could respond with sge cap to be 0 or 1. I can remove this check as 
> it is useless, but it is true that a faulty HW could return 0 or 1 and it may result
> in a bug. I am happy to remove, but I also think that AI had a point.
> 
> Leon, should I remote it?

You should review Sashiko's reports and reply to them. This helps ensure that
your responses are taken into account in subsequent review iterations, reducing
hallucinations and preventing the AI from silently resubmitting the same
suggestions. If you do not reply, the AI assumes it was right.

Reports are classified into three levels:

- **High**: Mostly correct.
- **Medium**: May be correct if you agree with the assumption, but most
  assumptions are wrong.
- **Low**: Worth a look, but can usually be ignored.

Regarding your question, I don't want to see dead or unreachable code,
especially in drivers, which need to act as a conduit between the core
and its firmware. The less logic in a driver, the better.

> 
> > 
> > > +
> > >  	caps->max_sq_id = resp.max_sq_id;
> > >  	caps->max_rq_id = resp.max_rq_id;
> > >  	caps->max_cq_id = resp.max_cq_id;
> > > @@ -748,7 +755,8 @@ int mana_ib_gd_query_adapter_caps(struct
> > mana_ib_dev *dev)
> > >  				resp.max_requester_sq_size /
> > GDMA_MAX_SQE_SIZE,
> > >  				resp.max_requester_rq_size /
> > GDMA_MAX_RQE_SIZE);
> > >  	caps->max_inline_data_size = resp.max_inline_data_size;
> > > -	caps->max_send_sge_count = resp.max_send_sge_count;
> > > +	/* Account for the SGE reserved for extra-large OOB. */
> > > +	caps->max_send_sge_count = resp.max_send_sge_count - 1;
> > >  	caps->max_recv_sge_count = resp.max_recv_sge_count;
> > >  	caps->feature_flags = resp.feature_flags;
> > >
> > > diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> > b/drivers/infiniband/hw/mana/mana_ib.h
> > > index 5ca6e2acf974..6f5df64e838a 100644
> > > --- a/drivers/infiniband/hw/mana/mana_ib.h
> > > +++ b/drivers/infiniband/hw/mana/mana_ib.h
> > > @@ -267,6 +267,10 @@ struct mana_ib_qp {
> > >  	u32 sq_psn;
> > >  	bool sq_sig_all;
> > >
> > > +	/* Serializes receive WR posting. */
> > > +	spinlock_t rq_lock;
> > > +	/* Serializes send and memory-management WR posting. */
> > > +	spinlock_t sq_lock;
> > >  	/* Serializes QP modification and error-list transitions. */
> > >  	struct mutex modify_lock;
> > >
> > > @@ -274,6 +278,7 @@ struct mana_ib_qp {
> > >  	struct list_head recv_err_node;
> > >  	struct shadow_queue shadow_rq;
> > >  	struct shadow_queue shadow_sq;
> > > +	struct shadow_queue shadow_mmq;
> > >
> > >  	refcount_t		refcount;
> > >  	struct completion	free;
> > > @@ -315,6 +320,7 @@ enum mana_ib_adapter_features {
> > >  	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
> > >  	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
> > >  	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
> > > +	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT = BIT(9),
> > >  	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
> > >  	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
> > >  };
> > > diff --git a/drivers/infiniband/hw/mana/qp.c
> > b/drivers/infiniband/hw/mana/qp.c
> > > index ae2ebbcc759a..387586c45aa0 100644
> > > --- a/drivers/infiniband/hw/mana/qp.c
> > > +++ b/drivers/infiniband/hw/mana/qp.c
> > > @@ -427,27 +427,88 @@ static u32 mana_ib_fixed_wqe_size(u32 sge, u32
> > oob_size)
> > >  	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size));
> > >  }
> > >
> > > -static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_type)
> > > +static u32 mana_ib_queue_size(struct mana_ib_dev *mdev, struct
> > ib_qp_init_attr *attr,
> > > +			      u32 queue_type)
> > >  {
> > > -	u32 queue_size;
> > > +	u32 send_wr = max(attr->cap.max_send_wr, 1U);
> > > +	u32 recv_wr = max(attr->cap.max_recv_wr, 1U);
> > > +	u32 max_wqe_size = MAX_TX_WQE_SIZE;
> > > +	u32 wr, wqe_size, read_sge;
> > > +	u64 queue_size;
> > > +
> > > +	if (attr->cap.max_send_sge > MAX_TX_WQE_SIZE / sizeof(struct
> > gdma_sge) ||
> > > +	    attr->cap.max_recv_sge > MAX_RX_WQE_SIZE / sizeof(struct
> > gdma_sge))
> > > +		return 0;
> > >
> > >  	switch (attr->qp_type) {
> > >  	case IB_QPT_UD:
> > >  	case IB_QPT_GSI:
> > > -		if (queue_type == MANA_UD_SEND_QUEUE)
> > > -			queue_size = attr->cap.max_send_wr *
> > > -				mana_ib_wqe_size(attr->cap.max_send_sge,
> > INLINE_OOB_LARGE_SIZE);
> > > -		else
> > > -			queue_size = attr->cap.max_recv_wr *
> > > -				mana_ib_wqe_size(attr->cap.max_recv_sge,
> > INLINE_OOB_SMALL_SIZE);
> > > +		if (queue_type == MANA_UD_SEND_QUEUE) {
> > > +			wr = send_wr;
> > > +			wqe_size = mana_ib_wqe_size(attr-
> > >cap.max_send_sge, INLINE_OOB_LARGE_SIZE);
> > > +		} else {
> > > +			wr = recv_wr;
> > > +			max_wqe_size = MAX_RX_WQE_SIZE;
> > > +			wqe_size = mana_ib_wqe_size(attr->cap.max_recv_sge,
> > INLINE_OOB_SMALL_SIZE);
> > > +		}
> > > +		break;
> > > +	case IB_QPT_RC:
> > > +		switch (queue_type) {
> > > +		case MANA_RC_SEND_QUEUE_REQUESTER:
> > > +			wr = send_wr;
> > > +			wqe_size = mana_ib_fixed_wqe_size(attr-
> > >cap.max_send_sge,
> > > +
> > INLINE_OOB_EXTRA_LARGE_SIZE);
> > > +			break;
> > > +		case MANA_RC_SEND_QUEUE_MMQ:
> > > +			wr = send_wr;
> > > +			wqe_size = mana_ib_wqe_size(1U,
> > INLINE_OOB_EXTRA_LARGE_SIZE);
> > > +			break;
> > > +		case MANA_RC_SEND_QUEUE_RESPONDER:
> > > +			return MANA_PAGE_SIZE;
> > > +		case MANA_RC_RECV_QUEUE_REQUESTER:
> > > +			wr = send_wr;
> > > +			max_wqe_size = MAX_RX_WQE_SIZE;
> > > +			read_sge = min(attr->cap.max_send_sge, mdev-
> > >ib_dev.attrs.max_sge_rd);
> > > +			wqe_size = mana_ib_wqe_size(read_sge,
> > INLINE_OOB_SMALL_SIZE);
> > > +			break;
> > > +		case MANA_RC_RECV_QUEUE_RESPONDER:
> > > +			wr = recv_wr;
> > > +			max_wqe_size = MAX_RX_WQE_SIZE;
> > > +			wqe_size = mana_ib_wqe_size(attr->cap.max_recv_sge,
> > INLINE_OOB_SMALL_SIZE);
> > > +			break;
> > > +		default:
> > > +			return 0;
> > > +		}
> > >  		break;
> > >  	default:
> > >  		return 0;
> > >  	}
> > >
> > > +	if (!wqe_size || wqe_size > max_wqe_size)
> > > +		return 0;
> > > +
> > > +	queue_size = (u64)wr * wqe_size;
> > > +	if (queue_size > U32_MAX / 2 + 1)
> > > +		return 0;
> > > +
> > >  	return MANA_PAGE_ALIGN(roundup_pow_of_two(queue_size));
> > >  }
> > >
> > > +static int mana_ib_check_kernel_qp_sizes(struct mana_ib_dev *mdev,
> > > +					 struct ib_qp_init_attr *attr, u32
> > num_queues)
> > > +{
> > > +	u32 i;
> > > +
> > > +	for (i = 0; i < num_queues; i++) {
> > > +		if (!mana_ib_queue_size(mdev, attr, i)) {
> > > +			ibdev_dbg(&mdev->ib_dev, "Invalid kernel QP queue
> > %u size\n", i);
> > 
> > If your code needs to validate in-kernel users, something is fundamentally
> > wrong
> > with your design. We trust them.
> 
> It was Sashiko comment at some point. I also agree that it is partially redundant, but it also
> helps to detect u32 overflow. I think we should keep as we had a similar comment
> for CQ u32 overflow, and Sashiko rated it as High. I think better safe than sorry

In these cases, we fix the core in-kernel API to supply the correct values without overflow.

Thanks


> 
> > 
> > Thanks
