From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 0/6] RDMA core and mlx5 fixes and
 refactoring for 4.15
Date: Wed, 18 Oct 2017 12:20:27 -0400
Message-ID: <1508343627.2951.4.camel@redhat.com>
References: <20171016054517.30643-1-leon@kernel.org>
         <1508340309.46071.76.camel@redhat.com>
         <20171018154006.GS2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171018154006.GS2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-10-18 at 18:40 +0300, Leon Romanovsky wrote:
> On Wed, Oct 18, 2017 at 11:25:09AM -0400, Doug Ledford wrote:
> > On Mon, 2017-10-16 at 08:45 +0300, Leon Romanovsky wrote:
> > > The patches are available in the git repository at:
> > >   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> > > tags/rdma-next-2017-10-16
> > 
> > This branch is unpullable for me.  Trying to pull this on top of
> > the
> > shared pull request brings in a ton of other stuff.  My diffstat
> > ends
> > up looking like this:
> 
> <....>
> 
> > 
> > So, with a shared pull request, your submissions either need to be
> > against that shared pull request, or against my for-next, and you
> > need
> > to let me know which one it is.
> 
> I didn't know that you are using this as a pull request, we tried it
> in
> last cycle and it didn't truly work, so I stopped it and changed the
> title
> (instead of pull requests, it is patches now), removed invitation to
> pull from
> the cover letter and prepared the series (with tags) as standalone
> patches
> and not as pull request.

OK, but you still had the pull request URL in the cover letter, so I
tried it.  Anyway, not a big deal as far as that goes.

> > 
> > I can grab these out of patchworks, but even that way I still need
> > you
> > to be clear about what tree/branch these are intended to be applied
> > to.
> 
> It should apply cleanly as patches grabbed from the patchworks and if
> for any reasons it doesn't work for you, please drop it and I'll
> resubmit.

Apply cleanly where?  That was the other part of my email.  When you
have a shared pull request, and it isn't based on my for-next branch
(as this one isn't), please let me know in each patch series whether
you intend it to be applied on the shared pull request or my for-next
branch.

I actually applied it to the shared pull request branch, but I didn't
know if that's what you had intended.  Also, I rewrote the commit
message in patch 5/6 entirely.  But, otherwise, thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
