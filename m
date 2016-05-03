From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Tue, 3 May 2016 16:31:05 +0200
Message-ID: <20160503143104.GA30342@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <571AA5C8.4080502@sandisk.com> <20160502151535.GA520@lst.de> <5727A5C7.1090009@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5727A5C7.1090009-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 02, 2016 at 12:08:55PM -0700, Bart Van Assche wrote:
> After having disabled CONFIG_SLUB_DEBUG_ON I don't see the "QP event" 
> message anymore.

This brings up memories: we've seen odd, unexplainable with SLUB debug and
MRs during NVMe over fabrics development..

> But running xfstests triggered the following (mlx4 
> hardware; SRP initiator and LIO target running on the same server and 
> communicating over loopback):

I can reproduce this, thanks.  The issue was that my implementation
of keeping the MRs around when getting an -EAGAIN for setting up new
RDMA R/W contexts wasn't correct.  To make it properly work we'd need
a pointer to the send ioctx from the recv ioctx.  I don't feel safe
to make this change at this point, and given that force_mr is only
a debug option for the SRP target until RDMA/CM support goes in I
think we should be fine without it.  I'll resend the series once I
get feedback from the buildbot, and I'd be happy if you could review
it quickly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
