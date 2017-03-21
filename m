From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [SPAMMY (7.002)]Re: SQ overflow seen running isert traffic
Date: Tue, 21 Mar 2017 20:55:07 +0530
Message-ID: <20170321152506.GA32655@chelsio.com>
References: <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
 <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
 <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
 <1477885208.27946.8.camel@haakon3.risingtidesystems.com>
 <20161108100617.GA2812@chelsio.com>
 <20170320101526.GA11699@chelsio.com>
 <1490077940.8236.77.camel@haakon3.risingtidesystems.com>
 <20170321075131.GA11565@chelsio.com>
 <945e2947-f67a-4202-cd27-d4631fe10f68@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <945e2947-f67a-4202-cd27-d4631fe10f68-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday, March 03/21/17, 2017 at 19:22:30 +0530, Sagi Grimberg wrote:
Hi Sagi,
The patch works fine!
>    Hi Baharat and Nic,
> 
>    Apologies for the late reply,
> 
>    > Hi Nicholas,
>    > I see them from 2MB onwards.
>    >>
>    >>    > Here is what I see with the 3 patches alone applied:
>    >>    >
>    >>    > -> In isert_put_datain() and isert_post_response() a corresponding
>    recv
>    >>    WR is posted before
>    >>    > posting a send and hence for every post failure a recv is already
>    posted
>    >>    into a tightly packed
>    >>    > RQ, causing it to overflow.
>    >>
>    >>    Just for me to understand, the intermittent TMR ABORT_TASKs are
>    caused
>    >>    by the repeated failure to post RDMA_WRITE WRs for a large ISER
>    Data-In
>    >>    payload, due to mis-sizing of needed WRs from RDMA R/W API vs.
>    >>    underlying hardware capabilities.
>    > Yes.
>    >>
>    >>    Moving the recv posts after the send post for RDMA_WRITEs helps to
>    >>    reduce the severity of the issue with iw_cxgb4, but doesn't
>    completely
>    >>    eliminate the issue under load.
>    > Moving recv posts only comes in to effect along with your changes.
> 
>    ...
> 
>    >>    So the reason why your patch to swap post_recv -> post_send to
>    post_send
>    >>    -> post_recv makes a difference is because it allows enough trickle
>    of
>    >>    RDMA_WRITEs to make it through, where iser-initiator doesn't attempt
>    to
>    >>    escalate recovery and doesn't attempt session reinstatement.
>    > I dont exactly know if above thing comes into play but the actual reason
>    I did
>    > swap posting RQ and SQ is, unlike SQ, RQ is posted with WRs to the brim
>    during
>    > the intialisation itself. From thereon we post a RQ WR for every RQ
>    completion
>    > That makes it almost full at any point of time.
>    >
>    > Now in our scenario, SQ is miscalulated and too small for few adapters
>    and so
>    > filled gradually as the IO starts. Once SQ is full, according to your
>    patches
>    > isert queues it and tries to repost the command again. Here in iser
>    functions
>    > like isert_post_response(), isert_put_datain() post send is done after
>    post recv.
>    > For the first post send failure in say isert_put_datain(), the
>    corresponding
>    > post recv is already posted, then on queuing the command and trying
>    reposting
>    > an extra recv is again posted which fills up the RQ also.
>    >
>    >  By swapping post recv and send as in my incermental patch, we dont post
>    that
>    > extra recv, and post recv only on successful post send.
>    > Therfore I think this incremental patch is necessary.
> 
>    Reversing the order to recv and send posting will cause problems
>    in stress IO workloads (especially for iWARP). The problem of sending
>    a reply before reposting the recv buffer is that the initiator can send
>    immediately a new request and we don't have a recv buffer waiting for
>    it, which will cause RNR-NAK. This *will* cause performance drops and
>    jitters for sure.
Totally agree with you.
> 
>    How about we just track the rx_desc to know if we already posted it as
>    a start (untested as I don't have access to RDMA HW this week):
>    --
>    diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
>    b/drivers/infiniband/ulp/isert/ib_isert.c
>    index 9b33c0c97468..fcbed35e95a8 100644
>    --- a/drivers/infiniband/ulp/isert/ib_isert.c
>    +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>    @@ -817,6 +817,7 @@ isert_post_recvm(struct isert_conn *isert_conn, u32
>    count)
>                     rx_wr->sg_list = &rx_desc->rx_sg;
>                     rx_wr->num_sge = 1;
>                     rx_wr->next = rx_wr + 1;
>    +               rx_desc->in_use = false;
>             }
>             rx_wr--;
>             rx_wr->next = NULL; /* mark end of work requests list */
>    @@ -835,6 +836,15 @@ isert_post_recv(struct isert_conn *isert_conn,
>    struct iser_rx_desc *rx_desc)
>             struct ib_recv_wr *rx_wr_failed, rx_wr;
>             int ret;
> 
>    +       if (!rx_desc->in_use) {
>    +               /*
>    +                * if the descriptor is not in-use we already reposted it
>    +                * for recv, so just silently return
>    +                */
>    +               return 0;
>    +       }
>    +
>    +       rx_desc->in_use = false;
>             rx_wr.wr_cqe = &rx_desc->rx_cqe;
>             rx_wr.sg_list = &rx_desc->rx_sg;
>             rx_wr.num_sge = 1;
>    @@ -1397,6 +1407,8 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>                     return;
>             }
> 
>    +       rx_desc->in_use = true;
>    +
>             ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
>                             ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
> 
>    diff --git a/drivers/infiniband/ulp/isert/ib_isert.h
>    b/drivers/infiniband/ulp/isert/ib_isert.h
>    index c02ada57d7f5..87d994de8c91 100644
>    --- a/drivers/infiniband/ulp/isert/ib_isert.h
>    +++ b/drivers/infiniband/ulp/isert/ib_isert.h
>    @@ -60,7 +60,7 @@
> 
>      #define ISER_RX_PAD_SIZE       (ISCSI_DEF_MAX_RECV_SEG_LEN + 4096 - \
>                     (ISER_RX_PAYLOAD_SIZE + sizeof(u64) + sizeof(struct
>    ib_sge) + \
>    -                sizeof(struct ib_cqe)))
>    +                sizeof(struct ib_cqe) + sizeof(bool)))
> 
>      #define ISCSI_ISER_SG_TABLESIZE                256
> 
>    @@ -85,6 +85,7 @@ struct iser_rx_desc {
>             u64             dma_addr;
>             struct ib_sge   rx_sg;
>             struct ib_cqe   rx_cqe;
>    +       bool            in_use;
>             char            pad[ISER_RX_PAD_SIZE];
>      } __packed;
>    --
> 
>    We have a lot of room for cleanups in isert... I'll need to
>    make some time to get it going...
> 
>    I'll be waiting to hear from you if it makes your issue go away.
Test runs fine and it solved the issue.
Thanks for the patch!
> 
>    Cheers,
>    Sagi.
Thanks,
Bharat.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
