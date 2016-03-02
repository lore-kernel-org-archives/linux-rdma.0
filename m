From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Wed, 2 Mar 2016 13:08:30 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1603021300491.15609@east.gentwo.org>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com> <1456306924-31298-2-git-send-email-yishaih@mellanox.com> <20160224190230.GA10588@obsidianresearch.com> <56CEB4C7.60607@dev.mellanox.co.il> <20160225170541.GA22513@obsidianresearch.com>
 <56D31A58.20205@mellanox.com> <20160229191734.GA15042@obsidianresearch.com> <56D55851.60206@mellanox.com> <20160301172448.GA24031@obsidianresearch.com> <56D6979F.6000400@mellanox.com> <20160302182836.GA7084@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160302182836.GA7084-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2 Mar 2016, Jason Gunthorpe wrote:

> So all this ugly API to minimize cache line usage has no measured
> performance gain?

We have seen an increased cacheline footprint adding ~100-200ns to receive
latencies during loops. This does not show up in synthetic loads that do
not do much processing since their cache footprint is minimal.

> > Does the opaque pointer guarantees an aligned access? Who allocates the
> > space for the vendor's CQE? Any concrete example?
> > One of the problems here are that CQEs could be formatted as -
> > "if QP type is y, then copy the field z from o". Doing that this way may
> > result doing the same "if" multiple times. The current approach could still
> > avoid memcpy and write straight to the user's buffer.
>
> No, none of that...
>
> struct ibv_cq
> {
>     int (*read_next_cq)(ibv_cq *cq,struct common_wr *res);
>     int (*read_address)(ibv_cq *cq,struct wr_address *res);
>     uint64_t (*read_timestamp(ibv_cq *cq);
>     uint32_t (*read_immediate_data(ibv_cq *cq);
>     void (*read_something_else)(ibv_cq *cq,struct something_else *res);
> };

Argh. You are requiring multiple indirect function calls
top retrieve the same imformation and therefore significantly increase
latency. This is going to cause lots of problems for procesing at high
speed where we have to use the processor caches as carefully as possible
to squeeze out all we can get.

> 4) A basic analysis says this trades cache line dirtying of the wc
>    array for unconditional branches.
>    It  eliminates at least 1 conditional branch per CQE iteration by
>    using only 1 loop.

This done none of that stuff at all if the device directly follows the
programmed format. There will be no need to do any driver formatting at
all.

>    Compared to the poll_ex proposal this eliminates a huge
>    number of conditional branches as 'wc_flags' and related no longer
>    exist at all.

wc_flags may be something bothersome. You do not want to check inside the
loop. All cqe's should come with the fields requested and the
layout of the data must be fixed when in the receive loop. No additional
branches in the loop.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
