From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: compile ofed 1.5.3 against lustre kernel
Date: Wed, 15 Jun 2011 19:40:19 -0400
Message-ID: <BANLkTimz3h0C1Z9SUSXx3=LWqpt=T4v10g@mail.gmail.com>
References: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com>
	<4DF7C80D.1060408@opengridcomputing.com>
	<alpine.DEB.2.00.1106151610040.4224@router.home>
	<382A478CAD40FA4FB46605CF81FE39F4F92EC95C@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <382A478CAD40FA4FB46605CF81FE39F4F92EC95C-osO9UTpF0URzLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 15, 2011 at 7:25 PM, Woodruff, Robert J
<robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Christoph wrote,
>>I surely wish this constant nightmare would go away. Could we please have
>>OFED trees against each kernel version in use somewhere so that we can
>>just do a git pull to get these into the respective trees?
>
> Other people have also asked for this, i.e., a source tree for each kernel
> that OFED supports that already has the backports applied, or an install.pl
> option that will generate the tree for a given kernel. Perhaps we can
> try to get this support in the OFED-1.5.4 release. I will bring it up
> For discussion in the OFA EWG that manages the releases.

For those of us that are not hardcore kernel developers can you
explain what this change would actually do?  I'm not sure i understand
how having a source tree with the patches already applied is any
different then taking the base kernel and applying a patch tree.  But
then again i probably don't understand what your talking about at all
(me == admin not developer).

> Long term it would also be good if these lustre patches were in the upstream
> kernel, which would allow them to eventually get into the Linux distros so that
> people did not have to be applying patches and building custom kernels.

I think (but could be wrong) I recall some number of years ago a
skirmish between the lustre developers and the kernel maintainers over
their patches, which is why they never have been added.  But i think
some number of the patches have been applied or lustre code changes
over the years, i seem to recall in the lustre 1.6 days the patch tree
was monstrous, the one i applied for 2.6.18 was pretty short only
20-30 patches or so

what I'd really wish for is a completely patchless version of lustre,
I'd be happy with a 10% performance hit over the compilation
complexity.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
