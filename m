From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Mon, 2 May 2016 17:15:35 +0200
Message-ID: <20160502151535.GA520@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <571AA5C8.4080502@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571AA5C8.4080502-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 22, 2016 at 03:29:28PM -0700, Bart Van Assche wrote:
> On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
>> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>
> Hello Christoph,
>
> Is the version that has been pushed on April 18 the latest and greatest 
> version of this patch series ?

Should be.  I've pushed out a new version, but the only changes are
in response to your small review comments, and a no-op rebase to Doug's
latest tree.

> I'm asking because with that version I see 
> error messages appearing that I hadn't seen with the previous version:
>
> ib_srpt:srpt_qp_event: ib_srpt QP event 16 on cm_id=ffff8801713d5628 
> sess_name=0x0000000000000000e41d2d03000a85b1 state=1
> ib_srpt:srpt_qp_event: ib_srpt 0x0000000000000000e41d2d03000a85b1-522, 
> state live: received Last WQE event.
> ib_srpt RDMA_READ for ioctx 0xffff8804593092a8 failed with status 4
>
> This test was run with the force_mr=Y:
>
> $ cat /etc/modprobe.d/ib_core.conf
> options ib_core force_mr=Y

I haven't been able to reproduce this with my usual xfstests run
on mlx4 hardware.  What did you do to reproduce the issue, and what
hardware were you using?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
