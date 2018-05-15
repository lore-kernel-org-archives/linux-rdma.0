From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get new driver attributes
Date: Tue, 15 May 2018 15:28:33 -0500
Message-ID: <004901d3ec8b$4b9ac5c0$e2d05140$@opengridcomputing.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>         <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>         <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com> <39cd4caf34da44885021d8646699889ced482008.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <39cd4caf34da44885021d8646699889ced482008.camel@redhat.com>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>, 'David Ahern' <dsahern@gmail.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Doug Ledford
> Sent: Tuesday, May 15, 2018 2:53 PM
> To: David Ahern <dsahern@gmail.com>; Steve Wise
> <swise@opengridcomputing.com>; leon@kernel.org
> Cc: stephen@networkplumber.org; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to
> get new driver attributes
> 
> On Tue, 2018-05-15 at 13:37 -0600, David Ahern wrote:
> > On 5/14/18 9:42 AM, Steve Wise wrote:
> > > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h
> b/rdma/include/uapi/rdma/rdma_netlink.h
> > > index 60416ed..40be0d8 100644
> > > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > >
> > > @@ -387,6 +399,20 @@ enum rdma_nldev_attr {
> > >  	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
> > >  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
> > >  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> > > +	/*
> > > +	 * driver-specific attributes.
> > > +	 */
> > > +	RDMA_NLDEV_ATTR_DRIVER,			/* nested table */
> > > +	RDMA_NLDEV_ATTR_DRIVER_ENTRY,		/* nested table */
> > > +	RDMA_NLDEV_ATTR_DRIVER_STRING,		/* string */
> > > +	/*
> > > +	 * u8 values from enum rdma_nldev_print_type
> > > +	 */
> > > +	RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE,	/* u8 */
> > > +	RDMA_NLDEV_ATTR_DRIVER_S32,		/* s32 */
> > > +	RDMA_NLDEV_ATTR_DRIVER_U32,		/* u32 */
> > > +	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
> > > +	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
> >
> > and again here.
> 
> This chunk, however, is a problem.  We'll need to fix that in the kernel
> and in this patch too.

I'll fix this series once I fix the kernel side.  Doug, should I send a patch that basically moves the DRIVER attributes to the bottom?

Sorry about missing this!

Steve
