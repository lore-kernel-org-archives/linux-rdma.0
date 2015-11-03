From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 16:49:22 -0800
Message-ID: <20151103004922.GA22926@kroah.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com>
 <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de>
 <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <5637F97C.5090205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5637F97C.5090205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 07:02:04PM -0500, Doug Ledford wrote:
> > so overall it still benifits being in the
> > staging tree, so a few minor breakages every once in a while should be
> > easy for you to fix up, _if_ they happen.
> > 
> > Again, I don't know of any recent api change that has caused any
> > problems in a long time, but the VFS developers really hate having to
> > touch lustre code, and I don't blame them, so sometimes that codebase
> > breaks.  That will not affect your drivers at all, so I wouldn't worry
> > about this.
> 
> Yes.  I get that.  And I understand that.  But because of Lustre, you
> have made a global policy that effects all staging drivers without
> legitimate cause, proudly broadcast that policy at a conference, even
> answered a question from Christoph confirming that policy, and now in
> this email thread where I object to that policy you say "It doesn't
> really happen anyway, don't worry about it.'

No, it's not "because" of lustre, it's been that way since day one when
we started the staging tree.  Christoph was just annoyed that someone
was trying to tell him otherwise.  And he is right.

> But the person who quoted
> you (Christoph) is the author of one of the API changes that *did* break
> the RDMA drivers in the staging tree and he fixed them up when I asked
> him to.  Christoph then later quoted you and his interaction with you at
> conference to indicate he didn't have to.

He didn't have to.  He was being nice.  That's your job to fix them up
if you want the code in staging.

> And what I'm telling him, and
> you since you are the person he's quoting to justify not fixing up
> things, is that I don't care what you say, when it comes to those
> drivers that I moved into staging, if he wants me to take his core
> patches, then he needs to make sure they don't break those drivers I
> moved into staging.

Nope, not true.  If you don't like this, I'll gladly just delete the
drivers from staging, sorry.  You don't get a "free ride" in staging at
all.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
