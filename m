From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic
Date: Mon, 20 Mar 2017 18:35:47 +0530
Message-ID: <20170320130545.GB11699@chelsio.com>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
 <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
 <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
 <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
 <20161018161313.GC24189@obsidianresearch.com>
 <f7a4b395-1786-3c7a-7639-195e830db5ad@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f7a4b395-1786-3c7a-7639-195e830db5ad-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday, October 10/20/16, 2016 at 14:04:34 +0530, Sagi Grimberg wrote:
>    Hey Jason,
> 
>    >> 1) we believe the iSER + RW API correctly sizes the SQ, yet we're
>    seeing SQ
>    >> overflows.  So the SQ sizing needs more investigation.
>    >
>    > NFS had this sort of problem - in that case it was because the code
>    > was assuming that a RQ completion implied SQ space - that is not
>    > legal, only direct completions from SQ WCs can guide available space
>    > in the SQ..
> 
>    Its not the same problem. iser-target does not tie SQ and RQ spaces.
>    The origin here is the difference between IB/RoCE and iWARP and the
>    chelsio HW that makes it hard to predict the SQ correct size.
> 
>    iWARP needs extra registration for rdma reads and the chelsio device
>    seems to be limited in the number of pages per registration so this
>    configuration will need a larger send queue.
> 
>    Another problem is that we don't have a correct retry flow.
> 
>    Hopefully we can address that in the RW API which is designed to hide
>    these details from the ULP...
Hi Sagi,
Here is what our further analysis of SQ dump at the time of overflow says:

RDMA read/write API is creating long chains (32 WRs) to handle large ISCSI 
READs. For Writing iscsi default block size of 512KB data, iw_cxgb4's max 
number of sge advertised is 4 page ~ 16KB for write, needs WR chain of 32 WRs 
(another possible factor is they all are unsignalled WRs and are completed
only after next signalled WR) But apparantly rdma_rw_init_qp() assumes that 
any given IO will take only 1 WRITE WR to convey the data.

This evidently is incorrect and rdma_rw_init_qp() needs to factor and size 
the queue based on max_sge of device for write and read and the sg_tablesize 
for which rdma read/write is used for, like ISCSI_ISER_MAX_SG_TABLESIZE of 
initiator. If above analysis is correct, please suggest how could this be fixed? 

Further, using MRs for rdma WRITE by using rdma_wr_force_mr = 1 module 
parameter of ib_core avoids SQ overflow by registering a single REG_MR and 
using that MR for a single WRITE WR. So a rdma-rw IO chain of say 32 WRITE 
WRs, becomes just 3 WRS:  REG_MR + WRITE + INV_MR as 
max_fast_reg_page_list_len of iw_cxgb4 is 128 page.

(By default force_mr is not set and iw_cxgb4 could only use MR for rdma 
READs only as per rdma_rw_io_needs_mr() if force_mr isnt set) 
>From this is there any possibility that we could use MR if the write WR
chain exceeds a certain number?

Thanks for your time!

-Bharat.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
