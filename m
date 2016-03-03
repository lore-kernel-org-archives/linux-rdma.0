From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 05/13] IB/core: add a simple MR pool
Date: Thu, 3 Mar 2016 09:30:40 +0100
Message-ID: <20160303083040.GA13700@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de> <1456596631-19418-6-git-send-email-hch@lst.de> <CAG53R5W2Xi--LdMwwcB68d+2VYS100zEM+zW4Qi79SwoUiQE=w@mail.gmail.com> <20160302091554.GC1308@lst.de> <56D70543.1000506@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D70543.1000506-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 02, 2016 at 07:22:43AM -0800, Bart Van Assche wrote:
> Hello Christoph,
>
> With the approach of V2 of this patch series mr_lock and the MR pool list 
> head exist in different structures which is unfortunate. How about 
> introducing a new structure for the MR pool list head and mr_lock? An 
> additional advantage of this approach is that it would allow to move the 
> initialization of both structure members into ib_mr_pool_init().

Hi Bart,

I don't really understand what you mean.  Both the lock and the list_head
are in struct ib_qp, right next to each other.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
