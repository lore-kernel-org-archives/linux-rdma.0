From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: SQ overflow seen running isert traffic
Date: Mon, 20 Mar 2017 10:04:06 -0500
Message-ID: <0dc201d2a18b$385caf10$a9160d30$@opengridcomputing.com>
References: <20160927070157.GA13140@chelsio.com> <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me> <20161017111655.GA21245@chelsio.com> <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com> <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me> <20161018112801.GA3117@chelsio.com> <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me> <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com> <20161018161313.GC24189@obsidianresearch.com> <f7a4b395-1786-3c7a-7639-195e830db5ad@grimberg.me> <20170320130545.GB11699@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170320130545.GB11699@chelsio.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Potnuri Bharat Teja' <bharat@chelsio.com>, 'Sagi Grimberg' <sagi@grimberg.me>
Cc: 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

+Christoph

> 
> On Thursday, October 10/20/16, 2016 at 14:04:34 +0530, Sagi Grimberg wrote:
> >    Hey Jason,
> >
> >    >> 1) we believe the iSER + RW API correctly sizes the SQ, yet we're
> >    seeing SQ
> >    >> overflows.  So the SQ sizing needs more investigation.
> >    >
> >    > NFS had this sort of problem - in that case it was because the code
> >    > was assuming that a RQ completion implied SQ space - that is not
> >    > legal, only direct completions from SQ WCs can guide available space
> >    > in the SQ..
> >
> >    Its not the same problem. iser-target does not tie SQ and RQ spaces.
> >    The origin here is the difference between IB/RoCE and iWARP and the
> >    chelsio HW that makes it hard to predict the SQ correct size.
> >
> >    iWARP needs extra registration for rdma reads and the chelsio device
> >    seems to be limited in the number of pages per registration so this
> >    configuration will need a larger send queue.
> >
> >    Another problem is that we don't have a correct retry flow.
> >
> >    Hopefully we can address that in the RW API which is designed to hide
> >    these details from the ULP...
> Hi Sagi,
> Here is what our further analysis of SQ dump at the time of overflow says:
> 
> RDMA read/write API is creating long chains (32 WRs) to handle large ISCSI
> READs. For Writing iscsi default block size of 512KB data, iw_cxgb4's max
> number of sge advertised is 4 page ~ 16KB for write, needs WR chain of 32 WRs
> (another possible factor is they all are unsignalled WRs and are completed
> only after next signalled WR) But apparantly rdma_rw_init_qp() assumes that
> any given IO will take only 1 WRITE WR to convey the data.
> 
> This evidently is incorrect and rdma_rw_init_qp() needs to factor and size
> the queue based on max_sge of device for write and read and the sg_tablesize
> for which rdma read/write is used for, like ISCSI_ISER_MAX_SG_TABLESIZE of
> initiator. If above analysis is correct, please suggest how could this be
fixed?
> 
> Further, using MRs for rdma WRITE by using rdma_wr_force_mr = 1 module
> parameter of ib_core avoids SQ overflow by registering a single REG_MR and
> using that MR for a single WRITE WR. So a rdma-rw IO chain of say 32 WRITE
> WRs, becomes just 3 WRS:  REG_MR + WRITE + INV_MR as
> max_fast_reg_page_list_len of iw_cxgb4 is 128 page.
> 
> (By default force_mr is not set and iw_cxgb4 could only use MR for rdma
> READs only as per rdma_rw_io_needs_mr() if force_mr isnt set)
> >From this is there any possibility that we could use MR if the write WR
> chain exceeds a certain number?
> 
> Thanks for your time!
> 

I think it is time to resolve this XXX comment in rw.c for
rdma_rw_io_needs_mr():

/*
 * Check if the device will use memory registration for this RW operation.
 * We currently always use memory registrations for iWarp RDMA READs, and
 * have a debug option to force usage of MRs.
 * XXX: In the future we can hopefully fine tune this based on HCA driver
 * input.
 */

Regardless of whether the HCA driver provides input, I think 30+ RDMA WRITE WR
chains isn't as efficient as 1 REG_MR + 1 WRITE + 1 INV_MR.   Is it unreasonable
to just add some threshold in rw.c?   Also, I think rdma_rw_init_qp() does need
some tweaks:  It needs to take into account the max sge depth, the max REG_MR
depth, and the max SQ depth device attributes/capabilities when sizing the SQ.
However, if that computed depth exceeds the device max, then the SQ will not be
big enough to avoid potential overflowing, and I believe ULPs should _always_
flow control their outgoing WRs based on the SQ depth regardless.    And perhaps
rdma-rw should even avoid overly deep SQs just because that tends to inhibit
scalability.  EG: allowing lots of shallow QPs vs consuming all the device
resources with very deep QPs... 

Steve.
