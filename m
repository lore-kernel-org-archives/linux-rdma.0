From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibcm] Return errors from the kernel consistently
Date: Tue, 20 Oct 2009 11:13:52 -0600
Message-ID: <20091020171352.GB14520@obsidianresearch.com>
References: <20091020055834.GA26350@obsidianresearch.com> <34B1325549824112A02BFE95F2886CB2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <34B1325549824112A02BFE95F2886CB2-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 10:09:22AM -0700, Sean Hefty wrote:
> >This fixes one subtle bug, where a return of 0 from the kernel will
> >result in a success report from the library, and fixes a terrible
> >API in the process. Use errno, or return the code, or both.
> >Not half and half..
> >
> >It is easier to return errno than to fixup the cases that don't,
> >so lets stick with that.
> >
> >Codes should have been be positive for alignment with POSIX, but
> >it is much too late for that..
> >
> >Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > src/cm.c |   30 +++++++++++++++---------------
> > 1 files changed, 15 insertions(+), 15 deletions(-)
> >
> >librdmacm has the same basic flaw too.
> 
> Thanks - I'll fixup librdmacm the same way.
> 
> Is there a reason that you used -1*errno, rather than just -errno?

Nope, just do things like that

Actually, please don't apply. I was thinking about this more deeply
and it would be much better to bite the bullet and fix the other cases
that don't set errno than to do this. Ie always return -1 and remove
the -errno thingy entirely.

The documentation says this is OK, and anyone taking shortcuts in this
area are more likely to have checked errno then to check the return
result, as the return errors are of the rare sort.

I'll send another attempt..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
