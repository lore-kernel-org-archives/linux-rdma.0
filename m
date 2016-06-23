From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/1] Fix for nvme-rdma host crash in nvmf-all.3
Date: Thu, 23 Jun 2016 10:59:47 -0500
Message-ID: <00ee01d1cd68$4451a7f0$ccf4f7d0$@opengridcomputing.com>
References: <cover.1466626499.git.swise@opengridcomputing.com> <576B8FB7.5000305@grimberg.me> <004f01d1cd57$85fc0530$91f40f90$@opengridcomputing.com> <576C0547.4060403@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <576C0547.4060403-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >> Hey Steve, I don't see how this bug fixes the root-cause. Not exactly
> >> sure we understand the root-cause. Is it possible that this is a chelsio
> >> specific issue with send completion signaling (like we saw before)? Did
> >> this happen with a non-chelsio device?
> >
> > Due to the stack trace, I believe this is a similar issue we saw before.  It
is
> > probably chelsio-specific.  I don't see it on mlx4.
> >
> > The fix for the previous occurrence of this crash was to signal all FLUSH
> > commands.  Do you recall why that fixed it?  Perhaps this failure path needs
> > some other signaled command to force the pending unsignaled WRs to be marked
> > "complete" by the driver?
> 
> OK, so as discussed off-list signaling connect sends resolves the issue.
> My recollection was that when the Chelsio queue-pair transitions to
> error/drain state, the cxgb4 driver does not know which sends were
> completed without the completion signal causing it to complete it again
> and the wr_cqe might have been already freed. I assume the same is going
> on here as we free the tag set before draining the qp...

Yes.  Thanks for the summary :)



> 
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
