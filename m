From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v1 iproute2-next 2/4] Sync up rdma_netlink.h
Date: Thu, 21 Feb 2019 16:11:16 -0700
Message-ID: <20190221231116.GU17500@ziepe.ca>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
 <20190221105631.7dfa5217@shemminger-XPS-13-9360>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190221105631.7dfa5217@shemminger-XPS-13-9360>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Steve Wise <swise@opengridcomputing.com>, dsahern@gmail.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 21, 2019 at 10:56:31AM -0800, Stephen Hemminger wrote:
> On Thu, 21 Feb 2019 08:19:07 -0800
> Steve Wise <swise@opengridcomputing.com> wrote:
> 
> > Pull in the latest rdma_netlink.h to get the RDMA_NLDEV_CMD_NEWLINK /
> > RDMA_NLDEV_CMD_DELLINK API.
> > 
> > Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> >  rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
> >  1 file changed, 58 insertions(+), 16 deletions(-)
> > 
> > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> > index 04c80cebef49..23a90ad52485 100644
> > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > @@ -5,8 +5,7 @@
> >  #include <linux/types.h>
> >  
> >  enum {
> > -	RDMA_NL_RDMA_CM = 1,
> > -	RDMA_NL_IWCM,
> > +	RDMA_NL_IWCM = 2,
> >  	RDMA_NL_RSVD,
> >  	RDMA_NL_LS,	/* RDMA Local Services */
> >  	RDMA_NL_NLDEV,	/* RDMA device interface */
> 
> You can't just drop elements from user ABI headers.
> That is a break of kernel ABI guarantee.

The ABI didn't change..

We don't promise unlimited source code compatibility in the uapi
headers. 

If the kernel doesn't support something better to remove all traces of
it so userspace users are aware of the change when their compile
breaks.

Jason
