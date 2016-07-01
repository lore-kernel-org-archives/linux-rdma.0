From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Reduce RDMA RW API SGE limit
Date: Fri, 1 Jul 2016 10:52:07 -0400 (EDT)
Message-ID: <707542212.2472047.1467384727758.JavaMail.zimbra@redhat.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com> <1995455969.2271399.1467294878655.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1995455969.2271399.1467294878655.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "Parav Pandit" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Steve Wise"
> <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, June 30, 2016 9:54:38 AM
> Subject: Re: [PATCH v2 0/5] Reduce RDMA RW API SGE limit
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> > "Nicholas A. Bellinger"
> > <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "Parav Pandit" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Laurence
> > Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Steve
> > Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Thursday, June 30, 2016 9:46:06 AM
> > Subject: [PATCH v2 0/5] Reduce RDMA RW API SGE limit
> > 
> > Hello Doug,
> > 
> > The five patches in this series modify the RDMA RW API slightly. This is
> > needed to avoid that the SRP and iSER target drivers submit RDMA
> > requests with an SGE list that exceeds the queue pair limits. The
> > ib_srpt changes in this series have been tested but the ib_isert changes
> > not yet.
> > 
> > The changes compared to v1 of this patch series are:
> > * max_send_sge is now stored in struct ib_qp. This greatly simplifies
> >    this patch series.
> > * An unneeded initialization that I had added to rdma_rw_init_one_mr()
> >    has been left out again.
> > * Corrected "Fixes" tag in the patch description where needed.
> > 
> > The individual patches in this series are:
> > 
> > 0001-IB-core-Make-rdma_rw_ctx_init-initialize-all-used-fi.patch
> > 0002-IB-core-RDMA-RW-API-Do-not-exceed-QP-SGE-send-limit.patch
> > 0003-IB-srpt-Limit-the-number-of-SG-elements-per-work-req.patch
> > 0004-IB-srpt-Simplify-srpt_queue_response.patch
> > 0005-IB-isert-Remove-an-unused-member-variable.patch
> > 
> > Thanks,
> > 
> > Bart.
> > 
> 
> Hell Bart
> Thanks
> Pulling and testing

For the series:
Applied to target server and srp client, tested with MLX4 at FDR 56Gbit

Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
