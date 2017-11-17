From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Fri, 17 Nov 2017 14:32:27 -0700
Message-ID: <20171117213227.GQ4276@ziepe.ca>
References: <20171116204400.GA28216@mellanox.com>
 <1510941272.2846.46.camel@wdc.com>
 <20171117181410.GL4276@ziepe.ca>
 <1510947901.3973.26.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510947901.3973.26.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 17, 2017 at 02:45:01PM -0500, Doug Ledford wrote:

> On that point...I have my github repo tied into the 0day infrastructure,
> not the official repo.  I do that because I've publicly announced that
> my github repo is a WIP repo, and that it might be rebased.  That allows
> me to correct build issues by fixing up the broken patch and thereby
> keep bisectability at its highest.  If you use a branch/tag on k.o for
> your 0day testing, then fixes have to be incremental and depending on
> which patch broke the build, there might be a significant segment of
> code that is no longer bisectable.

.. and this is because the k.o repo is setup to disallow force push
for each branch, so a 0 day testing branch cannot be rebased?

> > Doug will send Stephen Rothwell a note to move his for-next pull for
> > RDMA from Doug's personal directory to:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
> > 
> > Branch k.o/for-next
> 
> Actually, the linux-next testing uses a tag instead of a branch.  That
> allows for oddball scenarios that you might want to get testing.  Say,
> for instance, that you have a for-next branch with most of your stuff,
> but you also have a separate branch that simply isn't ready to be pushed
> yet, but you still want to get some early merge analysis, then you
> create a throwaway branch, merge your for-next and this topic branch
> together, throw the for-next tag on it for a couple or three days, and
> if Stephen doesn't find anything, you're on the right path with your
> development code.  Then you just reset the tag prior to pushing to
> Linus.

Makes sense, this is why I said you'll send the note, because you know
how it is setup :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
