From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Wed, 3 Jan 2018 10:36:58 -0700
Message-ID: <20180103173658.GE11348@ziepe.ca>
References: <20171014064132.GT2106@mtr-leonro.local>
 <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
 <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
 <20180102213706.GB19027@ziepe.ca>
 <20180103052529.GI10145@mtr-leonro.local>
 <20180103155225.GA11348@ziepe.ca>
 <20180103173105.GX10145@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103173105.GX10145-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 07:31:05PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 03, 2018 at 08:52:25AM -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 03, 2018 at 07:25:29AM +0200, Leon Romanovsky wrote:
> > > On Tue, Jan 02, 2018 at 02:37:06PM -0700, Jason Gunthorpe wrote:
> > > > On Fri, Dec 22, 2017 at 11:29:38AM +0000, Bernard Metzler wrote:
> > > >
> > > > > One question I have - what is the recommended way of replacing
> > > > > those module parameters, if we need to flexibly parameterize
> > > > > things from user land? For the rxe driver, I see the usage of
> > > > > module_param_cb, but this probably is not what we want in the
> > > > > long run? Would a sysctl be appropriate, or a char device
> > > > > (we may need to pass strings like interface names), or configfs?
> > > >
> > > > Probably something like 'rdmatool interface attach' eg cause it to
> > > > create using the RDMA netlink protocol.
> > > >
> > > > Leon?
> > >
> > > https://www.spinics.net/lists/linux-rdma/msg58498.html
> > > "It looks like "ip" tool can be good fit ..."
> > >
> > > ip link add ...
> > > ip link set ...
> >
> > ip link adds netdevs, so that doesn't quite feel right for adding rdma
> > devices???
> 
> It depends on the add/delete order, currently we are adding
> RDMA (RXE/SoftiWARP) device to existing netdev.

> Will it make sense to reverse order and add/delete netdev device for
> the existing RDMA (RXE/SoftiWARP) device?

No.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
