From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] IB/core: Perform modify QP on real one
Date: Wed, 28 Nov 2018 14:08:24 +0100
Message-ID: <20181128130824.GA18914@kroah.com>
References: <20181029151223.15114-1-leon@kernel.org>
 <20181128105820.GC1822@kroah.com>
 <20181128112648.GH4559@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128112648.GH4559@mtr-leonro.mtl.com>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 28, 2018 at 01:26:48PM +0200, Leon Romanovsky wrote:
> On Wed, Nov 28, 2018 at 11:58:20AM +0100, Greg KH wrote:
> > On Mon, Oct 29, 2018 at 05:12:23PM +0200, Leon Romanovsky wrote:
> > > From: Parav Pandit <parav@mellanox.com>
> > >
> > > commit b2bedfb39541a7e14798d066b6f8685d84c8fcf5 upstream
> > >
> > > Currently qp->port stores the port number whenever IB_QP_PORT
> > > QP attribute mask is set (during QP state transition to INIT state).
> > > This port number should be stored for the real QP when XRC target QP
> > > is used.
> > >
> > > Follow the ib_modify_qp() implementation and hide the access to ->real_qp.
> > >
> > > This commit is required for proper operation of commit 65be9cbe1224
> > > ("RDMA/uverbs: Expand primary and alt AV port checks") which was added
> > > to 4.14.61.
> > >
> > > Without this commit, XRC qp's do not work.
> > >
> > > Fixes: a512c2fbef9c ("IB/core: Introduce modify QP operation with udata")
> > > Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > > ---
> > >  drivers/infiniband/core/verbs.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > Does not apply to the 4.14.y tree :(
> 
> Can you please try this file patch? I tested it now on 4201a586f1fa
> (tag: v4.14.84, stable/linux-4.14.y) Linux 4.14.8.

That worked, thanks.

greg k-h
