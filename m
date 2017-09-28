From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Thu, 28 Sep 2017 10:29:17 -0600
Message-ID: <20170928162917.GA17880@obsidianresearch.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
 <20170926051349.GA1230@mtr-leonro.local>
 <20170926065600.GA6816@mtr-leonro.local>
 <6fa41141-cae5-da51-94ef-afe5bdec22bd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6fa41141-cae5-da51-94ef-afe5bdec22bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 12:03:01PM -0400, Doug Ledford wrote:
> >> You probably mean the conversation after that pull request.
> >>  * First round of RC fixes for 4.13
> >>    https://marc.info/?l=linux-rdma&m=150039306716272&w=2
> 
> More than just that conversation.  There have been offline conversations
> too.

Other trees are certainly not doing something as restrictive as 'only
base branches off rc2'...

branches should be based off a point that makes the patches work, and
ideally, the point at which the patches were actually tested.

Patches should never, ever be applied against a branch where they are
known to be broken (either compile wise, or functionality wise)
because of missing dependent patches from other trees.

This is all done to make future bisection work properly.

Overall, the only solution is to use a variety of bases on a variety
of branches. This is what other trees are doing, and AFAIK Linus
accepts it.

So, in your new multi-branch work flow, when patches come to you, you
have to decide if they can be safely applied to an existing branch (eg
'fixes' in arm-soc nomenclature), or if a new feature branch, with a
new base is required.

You *will* find you have branch bases all over the place due to the
co-ordination with other parts of the tree.. And you may find you have
feature branches based on your own branches too if things get a bit
complex.

> I didn't think this would work on k.o (and it's why I did the merge),
> but it does work.  The reason I didn't think it would work is that
> even

The multi-branch work flow is less of a 'force push' more of a 'delete
the banch once merged', 'create a new branch at a choosen starting
point'. The fact the two branch have the same name means most people
just handle it with 'git reset --hard' and 'git push -f'..

But it is worth while to have in mind the overall picture that the
multi-branch work flow is 'create a branch at good base & apply
patches', 'merge the branch', 'discard the branch'.. repeat..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
