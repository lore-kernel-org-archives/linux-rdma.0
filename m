From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Tue, 27 Mar 2018 09:23:56 -0600
Message-ID: <20180327152356.GH12318@ziepe.ca>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <20180326211505.GF15554@ziepe.ca>
 <b5f651c2-8f71-bc1b-32b8-f4c5175fb4a0@opengridcomputing.com>
 <20180326223033.GK15554@ziepe.ca>
 <20180327032141.GS1877@mtr-leonro.local>
 <20180327144455.GG12318@ziepe.ca>
 <20180327151544.GZ1877@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180327151544.GZ1877@mtr-leonro.local>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>, David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 06:15:44PM +0300, Leon Romanovsky wrote:
> On Tue, Mar 27, 2018 at 08:44:55AM -0600, Jason Gunthorpe wrote:
> > On Tue, Mar 27, 2018 at 06:21:41AM +0300, Leon Romanovsky wrote:
> > > On Mon, Mar 26, 2018 at 04:30:33PM -0600, Jason Gunthorpe wrote:
> > > > On Mon, Mar 26, 2018 at 04:34:44PM -0500, Steve Wise wrote:
> > > > >
> > > > > On 3/26/2018 4:15 PM, Jason Gunthorpe wrote:
> > > > > > On Mon, Mar 26, 2018 at 09:30:41AM -0500, Steve Wise wrote:
> > > > > >>
> > > > > >> On 3/26/2018 9:17 AM, David Ahern wrote:
> > > > > >>> On 2/27/18 9:07 AM, Steve Wise wrote:
> > > > > >>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
> > > > > >>>> index 5809f70..e55205b 100644
> > > > > >>>> +++ b/rdma/rdma.h
> > > > > >>>> @@ -18,10 +18,12 @@
> > > > > >>>>  #include <libmnl/libmnl.h>
> > > > > >>>>  #include <rdma/rdma_netlink.h>
> > > > > >>>>  #include <time.h>
> > > > > >>>> +#include <net/if_arp.h>
> > > > > >>>>
> > > > > >>>>  #include "list.h"
> > > > > >>>>  #include "utils.h"
> > > > > >>>>  #include "json_writer.h"
> > > > > >>>> +#include <rdma/rdma_cma.h>
> > > > > >>>>
> > > > > >>> did you forget to add rdma_cma.h? I don't see that file in my repo.
> > > > > >> It is provided by the rdma-core package, upon which rdma tool now
> > > > > >> depends for the rdma_port_space enum.
> > > > > > It is a kernel bug that enum is not in an include/uapi/rdma header
> > > > > >
> > > > > > Fix it there and don't try to use rdma-core headers to get kernel ABI.
> > > > > >
> > > > > > Jason
> > > > >
> > > > > I wish you'd commented on this just a little sooner.  I just resent v3
> > > > > of this series... with rdma_cma.h included. :)
> > > > >
> > > > > How about the restrack/nldev code just translates the port space from
> > > > > enum rdma_port_space to a new ABI enum, say nldev_rdma_port_space, that
> > > > > i add to rdma_netlink.h?  I'd hate to open the can of worms of trying to
> > > > > split rdma_cma.h into uabi and no uabi headers. :(
> > > >
> > > > If port space is already part of the ABI there isn't much reason to
> > > > translate it.
> > > >
> > > > You just need to pick the right header to put it in, since it is a verbs
> > > > define it doesn't belong in the netlink header.
> > >
> > > I completely understand Steve's concerns.
> > >
> > > I tried to do such thing (expose kernel headers) in first incarnation of
> > > rdmatool with attempt to clean IB/core as well to ensure that we won't expose
> > > anything that is not implemented. It didn't go well.
> >
> > rdma-core is now using the kernel uapi/ headers natively, seems to be
> > going OK. What problem did you face?
> 
> I didn't agree to move to UAPI defines which are not implemented and not
> used in the kernel, so I sent small number of patches similar to those [1, 2].
> 
> Those patches were rejected.
> 
> So please don't mix Steve's need to use 3 defines with very large and
> painful task to expose proper UAPIs.

Steve can just move the 3 defines he needs to the uapi, we are doing
this incrementally..

rdma_core does not define kernel ABI and it is totally wrong to use
random constants from rdma_cma.h as kernel ABI.

Jason
