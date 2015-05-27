From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Wed, 27 May 2015 11:43:33 -0600
Message-ID: <20150527174332.GC9909@obsidianresearch.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
 <20150525165449.GA4379@obsidianresearch.com>
 <1432742669.28905.228.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432742669.28905.228.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 12:04:29PM -0400, Doug Ledford wrote:
> On Mon, 2015-05-25 at 10:54 -0600, Jason Gunthorpe wrote:
> > On Wed, May 13, 2015 at 02:10:36PM +0300, Yishai Hadas wrote:
> > 
> > > +	struct srcu_struct			disassociate_srcu;
> > 
> > There is no need for rcu for this, use a rw sem.
> 
> The rcu was used becuase it's on the hot path I assume.

Perhaps, I looked at that a bit, it was used on syscall paths, but
that wasn't even the big reason I made the comment..

The use of RCU is *strange*. There is no pointer, there is no call to
rcu_derference. Stuff protected by the write lock is being touched
without any read side locking (ie ib_uverbs_event_read sure looks
funky). There is no Copy or Update phase as far as I can see. It fails
two of the tests in Documentation/RCU/checklist.txt.

I'm pretty sure what is intended here is that disassociated is
actually an unlocked atomic boolean and the RCU is being used
(abused?) to create both exclusion and a rendezvous..

I gave up at that point, if RCU is not being used properly, asking for
rwsem is a way to force the author to deal with their locking
sanely.

Jasno
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
