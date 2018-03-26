From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 15:15:05 -0600
Message-ID: <20180326211505.GF15554@ziepe.ca>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: David Ahern <dsahern@gmail.com>, leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 26, 2018 at 09:30:41AM -0500, Steve Wise wrote:
> 
> 
> On 3/26/2018 9:17 AM, David Ahern wrote:
> > On 2/27/18 9:07 AM, Steve Wise wrote:
> >> diff --git a/rdma/rdma.h b/rdma/rdma.h
> >> index 5809f70..e55205b 100644
> >> +++ b/rdma/rdma.h
> >> @@ -18,10 +18,12 @@
> >>  #include <libmnl/libmnl.h>
> >>  #include <rdma/rdma_netlink.h>
> >>  #include <time.h>
> >> +#include <net/if_arp.h>
> >>  
> >>  #include "list.h"
> >>  #include "utils.h"
> >>  #include "json_writer.h"
> >> +#include <rdma/rdma_cma.h>
> >>  
> > did you forget to add rdma_cma.h? I don't see that file in my repo.
> 
> It is provided by the rdma-core package, upon which rdma tool now
> depends for the rdma_port_space enum.

It is a kernel bug that enum is not in an include/uapi/rdma header

Fix it there and don't try to use rdma-core headers to get kernel ABI.

Jason
