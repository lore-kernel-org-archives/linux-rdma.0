From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 5/7] IB/core: Add macros for declaring types and
 type groups
Date: Tue, 17 Jan 2017 12:13:07 -0700
Message-ID: <20170117191307.GD27528@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-6-git-send-email-matanb@mellanox.com>
 <20170112001029.GE31682@obsidianresearch.com>
 <CAAKD3BCvEP4MdvSy6dD0DDjfyd+PO8Y=7O+qFwPO5rjGDW_nfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BCvEP4MdvSy6dD0DDjfyd+PO8Y=7O+qFwPO5rjGDW_nfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 07:25:22PM +0200, Matan Barak wrote:
> On Thu, Jan 12, 2017 at 2:10 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Wed, Jan 11, 2017 at 12:53:51PM +0200, Matan Barak wrote:
> >> In order to initialize and destroy types in a generic way, we need to
> >> provide information about the allocation size, release function and
> >> order. This is done through a macro based DSL (domain specific
> >> language). This patch adds macros to initialize a type and a type
> >> group.
> >>
> >> When we transform the write based commands to use this new locking and
> >> allocation schema, we use these types declarations.
> >>
> >> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>  include/rdma/uverbs_ioctl.h | 50 +++++++++++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 48 insertions(+), 2 deletions(-)
> >
> > None of this makes any sense to me at this point in the series.
> >
> > Just use a sane meta-class type and the 'usual' linux static const
> > initializer scheme.
> 
> I could of course drop this patch and use static
> initializes. However, this mean we'll re-write the next patch using
> macro language in the next patch (as we introduce actions there).  I
> also think the declarations themselves look pretty tidy this way.

Why would it be rewritten? The per-object static initializer should be
basically good indefinately? The next series will introduce macros to
add per-type functions but that shouldn't disturb the initializer.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
