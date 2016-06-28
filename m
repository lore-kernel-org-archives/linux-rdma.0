From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/isert: Limit the number of SG elements per work request
Date: Tue, 28 Jun 2016 09:33:21 -0500
Message-ID: <006d01d1d14a$0574f0b0$105ed210$@opengridcomputing.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com> <885f39a6-9d75-9999-d582-e403f072bec1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <885f39a6-9d75-9999-d582-e403f072bec1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Parav Pandit' <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Tuesday, June 28, 2016 6:27 AM
> To: Doug Ledford
> Cc: Christoph Hellwig; Sagi Grimberg; Nicholas A. Bellinger; Parav Pandit; Laurence
> Oberman; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH 3/5] IB/isert: Limit the number of SG elements per work request
> 
> Limit the number of SG elements per work request to what the queue
> pair supports.
> 

Hey Bart, do you think this patch fixes this error we're seeing?

isert: isert_rdma_rw_ctx_post: Cmd: ffff880f30eb0278 failed to post RDMA res
isert: isert_rdma_rw_ctx_post: Cmd: ffff880f30e85ef8 failed to post RDMA res
ABORT_TASK: Found referenced iSCSI task_tag: 14
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 14
ABORT_TASK: Found referenced iSCSI task_tag: 40
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 40
isert: isert_rdma_rw_ctx_post: Cmd: ffff880f311519f0 failed to post RDMA res
ABORT_TASK: Found referenced iSCSI task_tag: 70
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 70
isert: isert_rdma_rw_ctx_post: Cmd: ffff880f311720a0 failed to post RDMA res
ABORT_TASK: Found referenced iSCSI task_tag: 86
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 86
isert: isert_rdma_rw_ctx_post: Cmd: ffff880f31160528 failed to post RDMA res
isert: isert_rdma_rw_ctx_post: Cmd: ffff880f30ead238 failed to post RDMA res
isert: isert_rdma_rw_ctx_post: Cmd: ffff880f30ea8fe0 failed to post RDMA res
ABORT_TASK: Found referenced iSCSI task_tag: 124
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 124
ABORT_TASK: Found referenced iSCSI task_tag: 120
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 120
ABORT_TASK: Found referenced iSCSI task_tag: 111
ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 111

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
