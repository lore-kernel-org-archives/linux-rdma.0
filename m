From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 11:17:24 -0600
Message-ID: <20150928171724.GF12415@obsidianresearch.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56096033.8040000-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 11:43:47AM -0400, Doug Ledford wrote:
> On 09/28/2015 11:42 AM, Christoph Lameter wrote:
> > Where are these trees and who is maintaining them? I see that there is a
> > libibverbs on kernel.org that is updated by Doug.
> > 
> > There are some mlx4/5 trees around but those have no recent commits. There
> > is a libmlx4 on kernel.org as well but the last merge there was by Roland
> > in May 2014.
> > 
> 
> git://git.openfabrics.org/~yishaih/libmlx4.git
> 
> git://git.openfabrics.org/~eli/libmlx5.git

We've talked about this around and around a few times over the years,
but throwing it out there again..

Should we combine the user side of the kapi 'core' stack (libverbs,
all open source providers, libumad, libcm) into one source
package? Many projects have been working in that model lately with
some success, IMHO.

Many of these components are one or two C files, and the overhead of
maintaining N copies of all the auto-crap is more than the package
itself :|

Right now we even have the situation where some providers won't build
with some verbs's, so it isn't even really the case they are actually
independent.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
