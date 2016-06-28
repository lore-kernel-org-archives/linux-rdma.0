From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/isert: Limit the number of SG elements per work request
Date: Tue, 28 Jun 2016 10:09:18 -0500
Message-ID: <01ca01d1d14f$0ae47160$20ad5420$@opengridcomputing.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com> <885f39a6-9d75-9999-d582-e403f072bec1@sandisk.com> <006d01d1d14a$0574f0b0$105ed210$@opengridcomputing.com> <6e513522-6b06-d942-bddd-cc00f9a32f44@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6e513522-6b06-d942-bddd-cc00f9a32f44-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Parav Pandit' <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On 06/28/2016 04:33 PM, Steve Wise wrote:
> >> -----Original Message-----
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> >> Sent: Tuesday, June 28, 2016 6:27 AM
> >> To: Doug Ledford
> >> Cc: Christoph Hellwig; Sagi Grimberg; Nicholas A. Bellinger; Parav Pandit;
> Laurence
> >> Oberman; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Subject: [PATCH 3/5] IB/isert: Limit the number of SG elements per work request
> >>
> >> Limit the number of SG elements per work request to what the queue
> >> pair supports.
> >>
> >
> > Hey Bart, do you think this patch fixes this error we're seeing?
> >
> > isert: isert_rdma_rw_ctx_post: Cmd: ffff880f30eb0278 failed to post RDMA res
> 
> Hello Steve,
> 
> Do you perhaps know how many SGE elements the failed work request
> contains? The reason I came up with the max_sge patch is because I
> noticed that the ib_srpt driver reported ib_post_send() failures for
> certain RDMA work requests. A debug printk() confirmed that
> ib_post_send() failed because the following test in the mlx4 driver was hit:
> 
> 		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
> 			err = -EINVAL;
> 			*bad_wr = wr;
> 			goto out;
> 		}
> 
> For the mlx4 HCA in my test setup max_sge == 32, max_sge_rd == 30 and
> with the QP creation parameters I used max_gs == 28.
> 
> Bart.
> 

I'll let you know as I gather more data.  For now I'm retrying with patches 1-3 of this series to see if it alleviates the problem.  

Stevo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
