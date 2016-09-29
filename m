From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: RQ overflow seen running isert traffic
Date: Thu, 29 Sep 2016 09:12:38 -0500
Message-ID: <003d01d21a5b$88c2a750$9a47f5f0$@opengridcomputing.com>
References: <20160927070157.GA13140@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160927070157.GA13140-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Sagi,
> I've been trying to understand the isert functionality with respect to
> RDMA Receive Queue sizing and Queue full handling. Here is the problem
> is see with iw_cxgb4:
> 
> After running few minutes of iSER traffic with iw_cxgb4, I am seeing
> post receive failures due to receive queue full returning -ENOMEM.
> In case of iw_cxgb4 the RQ size is 130 with qp attribute max_recv_wr = 129,
> passed down by isert to iw_cxgb4.isert decides on max_recv_wr as 129 based
> on (ISERT_QP_MAX_RECV_DTOS = ISCSI_DEF_XMIT_CMDS_MAX = 128) + 1.
> 

Just to clarify:  The RQ size of 130 in iw_cxgb4 has to do with how the the SW
and HW share the queue state.  It will always be at least 1 more than the
application's size.  So the RQ depth is 129, and a post_recv() is done when the
RQ is full, which should never happen...

> My debug suggests that at some point isert tries to post more than
> 129 receive WRs into the RQ and fails as the queue is full already. From
> the code most of the recv wr are posted only after a recieve completion,
> but few datain operations(isert_put_datain()) are done independent of
> receive completions. In fact the last WR failed to post in to RQ is from
> isert_put_datain() through target_complete_ok_work(). CQ stats at the
> time of failure shows the cq polled to empty.
> 
> How could I check for the possible conditions leading to this issue?
> I am happy to provide you any details further.
> Thanks for your time.
>
> Bharat.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
