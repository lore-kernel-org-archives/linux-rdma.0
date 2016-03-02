From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 05/13] IB/core: add a simple MR pool
Date: Wed, 2 Mar 2016 10:15:54 +0100
Message-ID: <20160302091554.GC1308@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de> <1456596631-19418-6-git-send-email-hch@lst.de> <CAG53R5W2Xi--LdMwwcB68d+2VYS100zEM+zW4Qi79SwoUiQE=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5W2Xi--LdMwwcB68d+2VYS100zEM+zW4Qi79SwoUiQE=w@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 02, 2016 at 08:18:14AM +0530, Parav Pandit wrote:
> >         struct list_head        xrcd_list;
> > +
> > +       spinlock_t              mr_lock;
> > +       int                     mrs_used;
> > +
> 
> Can you please add the comment for mr_lock as requested by the
> checkpatch script?

No.  checkpath is asking for silly things (and apparently this one
is so silly it doesn't even ask for it by default).

> Also you might want to consider adding this field after recv_cq so
> that we find mr_lock and used count in single cache line along with
> other data for the qp?

That sounds useful, I'll look into it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
