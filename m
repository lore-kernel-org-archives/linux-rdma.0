From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: SQ overflow seen running isert traffic
Date: Tue, 18 Oct 2016 16:58:13 +0530
Message-ID: <20161018112801.GA3117@chelsio.com>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
 <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Steve Wise <swise@opengridcomputing.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday, October 10/18/16, 2016 at 11:04:00 +0300, Sagi Grimberg wrote:
> Hey Steve and Baharat,
> 
> >Hey Sagi, I'm looking at isert_create_qp() and it appears to not be correctly
> >sizing the SQ:
> >...
> >#define ISERT_QP_MAX_REQ_DTOS   (ISCSI_DEF_XMIT_CMDS_MAX +    \
> >                                ISERT_MAX_TX_MISC_PDUS  + \
> >                                ISERT_MAX_RX_MISC_PDUS)
> >...
> >        attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS + 1;
> >        attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
> >...
> >
> >I think above snipit assumes a DTO consumes exactly one WR/WQE in the SQ.  But
> >the DTO can be broken into multiple WRs to handle REG_MRs, multiple WRITE or
> >READ WRs due to limits on local sge depths target sge depths, etc.  Yes?  Or am
> >I all wet?  Or perhaps isert doesn't require the SQ to be the max possible
> >because it flow controls the DTO submissions?
> 
> I think you are correct.
> 
> On my test devices, I didn't see that multiple WRs has had any effect
> becuase:
> 1. My test devices usually give next power of 2 (256)
> 2. workloads that involved multiple rdma operations never stressed the
> system enough to get the queues full.
> 
> Now, in iWARP for non-immediate writes we'll need more than a single
> wr per IO (I think the SQ size is expanded with the new rdma RW API
> which implicitly increases with attr.cap.max_rdma_ctxs).
Yes, rdma RW api factors the attr.cap.max_rdma_ctxs based on attr Flags.
> 
> But I do agree that we need to take into account that each IO needs
> at least 2 WRs (one for rdma and one for send).
> 
> So a temp bandage would be:
> --
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.h
> b/drivers/infiniband/ulp/isert/ib_isert.h
> index fc791efe3a10..81afb95aeea9 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.h
> +++ b/drivers/infiniband/ulp/isert/ib_isert.h
> @@ -54,8 +54,14 @@
> 
>  #define ISERT_MIN_POSTED_RX    (ISCSI_DEF_XMIT_CMDS_MAX >> 2)
> 
> -#define ISERT_QP_MAX_REQ_DTOS  (ISCSI_DEF_XMIT_CMDS_MAX +    \
> -                               ISERT_MAX_TX_MISC_PDUS  + \
> +/*
> + * Max QP send work requests consist of:
> + * - RDMA + SEND for each iscsi IO
> + * - iscsi misc TX pdus
> + * - iscsi misc RX response pdus
> + */
> +#define ISERT_QP_MAX_REQ_DTOS  ((ISCSI_DEF_XMIT_CMDS_MAX * 2 ) +       \
> +                               ISERT_MAX_TX_MISC_PDUS          +       \
>                                 ISERT_MAX_RX_MISC_PDUS)
> 
>  #define ISER_RX_PAD_SIZE       (ISCSI_DEF_MAX_RECV_SEG_LEN + 4096 - \
> --
> 
I tried out this change and it works fine with iwarp. I dont see SQ
overflow. Apparently we have increased the sq too big to overflow. I am going
to let it run with higher workloads for longer time, to see if it holds good.
> But we do need to track the SQ overflow and queue a retransmit work when
> we don't have enough available SQ slots..
Agreed, iscsi-target (LIO in our case)expects failure to be returned by
overlying modules Or it could be for tcp as it handling is different to
that of iser.
It queues the WR and schedules it for repost incase
of post failures with ENOMEM/EAGAIN. Shall send the necessary change if
it is needed.

Thanks,
Bharat.
> 
> Thoughts?
