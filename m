From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 11:20:18 -0600
Message-ID: <20170802172018.GA1361@obsidianresearch.com>
References: <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <20170801195840.GC31205@obsidianresearch.com>
 <20170802034438.GV13672@mtr-leonro.local>
 <20170802155856.GA21208@obsidianresearch.com>
 <20170802162938.GC13672@mtr-leonro.local>
 <20170802164553.GA31901@obsidianresearch.com>
 <1501692660.2437.4.camel@wdc.com>
 <20170802170823.GA32513@obsidianresearch.com>
 <1501693892.2437.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501693892.2437.6.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2017 at 05:11:33PM +0000, Bart Van Assche wrote:

> Because it is not possible to make the current iwpm netlink code work 100%
> reliably,

Well, I don't know enough about what iwpm has exactly done in those
details to be sure of that statement.. I'm not sure what the message
loss strategy is. It looks like loss on connect() just refuses the
connection, which seems fine, but loss on close() looks troubled? Not
sure.

I'm not really inclined to look into iwpm in any detail, but I really
want to see Leon's patch series progress, so overcoming that hurdle by
using the patch Chien pointed out seems perfectly fine to me.

> my proposal is to add a new and redesigned interface for iwpm
> communication between user space and kernel and to deprecate the
> current API.

What would you do differently?

And even if this is the best path, the use of blocking send in the
compat uAPI code is *still* very appropriate.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
