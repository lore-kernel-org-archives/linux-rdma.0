From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] iw_cxgb4: fix a missing-check bug
Date: Sat, 20 Oct 2018 19:15:17 -0500
Message-ID: <000401d468d3$259c3790$70d4a6b0$@opengridcomputing.com>
References: <1540072741-18856-1-git-send-email-wang6495@umn.edu> <038301d468ca$9d30ca90$d7925fb0$@opengridcomputing.com> <CAAa=b7fPLM-kF+VyZhhj2tzhzuFNnXpv=gPVJ2mCcfQyToew0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAa=b7fPLM-kF+VyZhhj2tzhzuFNnXpv=gPVJ2mCcfQyToew0Q@mail.gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Wenwen Wang' <wang6495@umn.edu>
Cc: 'Kangjie Lu' <kjlu@umn.edu>, swise@chelsio.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Wenwen Wang <wang6495@umn.edu>
> Sent: Saturday, October 20, 2018 6:56 PM
> To: swise@opengridcomputing.com
> Cc: Kangjie Lu <kjlu@umn.edu>; swise@chelsio.com; dledford@redhat.com;
> jgg@ziepe.ca; linux-rdma@vger.kernel.org; open list <linux-
> kernel@vger.kernel.org>; Wenwen Wang <wang6495@umn.edu>
> Subject: Re: [PATCH] iw_cxgb4: fix a missing-check bug
> 
> On Sat, Oct 20, 2018 at 6:41 PM Steve Wise
> <swise@opengridcomputing.com> wrote:
> >
> > Hey Wenwen,
> >
> > > Subject: [PATCH] iw_cxgb4: fix a missing-check bug
> > >
> > > In c4iw_flush_hw_cq, the next CQE is acquired through
> t4_next_hw_cqe(). In
> > > t4_next_hw_cqe(), the CQE, i.e., 'cq->queue[cq->cidx]', is checked to see
> > > whether it is valid through t4_valid_cqe(). If it is valid, the address of
> > > the CQE is then saved to 'hw_cqe'. Later on, the CQE is copied to the
> > local
> > > memory in create_read_req_cqe(). The problem here is that the CQE is
> > > actually in a DMA region allocated by dma_alloc_coherent() in
> create_cq().
> > > Given that the device also has the permission to access the DMA region, a
> > > malicious device controlled by an attacker can modify the CQE in the DMA
> > > region after the check in t4_next_hw_cqe() but before the copy in
> > > create_read_req_cqe(). By doing so, the attacker can supply invalid CQE,
> > > which can cause undefined behavior of the kernel and introduce
> potential
> > > security risks.
> > >
> >
> > If the dma device is malicious, couldn't it just dma some incorrect CQE but
> > still valid in the first place?  I don't think this patch actually solves
> > the issue, and it forces a copy of a 64B CQE in a critical data io path.
> 
> Thanks for your response! If the malicious dma device just dma some
> incorrect CQE, it will not be able to pass the verification in
> t4_valid_cqe().
> 

As long as the gen bit is correct, the CQE is considered valid.  You cannot protect against a malicious dma device.  Or at least not with the current driver/device contract.

Steve.
