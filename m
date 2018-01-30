From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 15:02:33 -0700
Message-ID: <20180130220233.GN17053@ziepe.ca>
References: <20180130163330.GE17053@ziepe.ca>
 <1517339252.2589.34.camel@wdc.com>
 <20180130194639.GJ17053@ziepe.ca>
 <1517344962.2589.39.camel@wdc.com>
 <20180130204840.GK17053@ziepe.ca>
 <1517347322.2589.58.camel@wdc.com>
 <1517347999.15224.2.camel@redhat.com>
 <1517348412.2589.60.camel@wdc.com>
 <20180130214227.GM17053@ziepe.ca>
 <1517348867.2589.63.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517348867.2589.63.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 09:47:48PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 14:42 -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 30, 2018 at 09:40:14PM +0000, Bart Van Assche wrote:
> > > On Tue, 2018-01-30 at 16:33 -0500, Laurence Oberman wrote:
> > > > Can I take your tree and see if this fails for me too,
> > > > Your last tree was fine, so did not have this latest stuff.
> > > > Can I just pull to what I have
> > > 
> > > Hello Laurence,
> > > 
> > > So far I have seen this behavior only inside a VM but not yet on a system
> > > with more memory than the VM. This issue may be specific to the memory size
> > > of the VM. I think we should try to isolate furhter what caused this before
> > > trying to reproduce it on more setups.
> > 
> > Did you get an oops print related a kalloc failure?
> > 
> > Or am I wrong and the ENOMEM is coming from someplace else?
> 
> Hello Jason,
> 
> I just noticed the following in the system log:
> 
> Jan 30 12:53:15 ubuntu-vm kernel: ib_srp: rxe0: ib_alloc_mr() failed. Try to reduce max_cmd_per_lun, max_sect or ch_count
> 
> So apparently the ib_alloc_mr() fails sometimes (but not the first few times
> it is called).

Looks like the only way you can get that without hitting an kalloc
oops print is if rxe_alloc() fails, and probably here:

	if (atomic_inc_return(&pool->num_elem) > pool->max_elem)
		goto out_put_pool;

Suggesting srp hit the max # of mrs in rxe:

	RXE_MAX_MR			= 2 * 1024,

Or maybe we are now leaking mrs someplace?

There is nothing accepted recently that mucks with this, still not
seeing even a tenuous connection to any patches in the last few days

What was accepted in the past week(s) was a bunch of srp stuff
though:

$ git diff --stat 052eac6eeb5655c52a490a49f09c55500f868558
 MAINTAINERS                                  |   3 +-
 drivers/infiniband/core/Makefile             |   2 +-
 drivers/infiniband/core/cm.c                 |   6 +-
 drivers/infiniband/core/cma.c                |   2 +-
 drivers/infiniband/core/core_priv.h          |  28 ++++
 drivers/infiniband/core/cq.c                 |  16 ++-
 drivers/infiniband/core/device.c             |   4 +
 drivers/infiniband/core/nldev.c              | 374 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.c           | 164 ++++++++++++++++++++++
 drivers/infiniband/core/user_mad.c           |   2 +-
 drivers/infiniband/core/uverbs_cmd.c         |   7 +-
 drivers/infiniband/core/uverbs_ioctl.c       |  19 ++-
 drivers/infiniband/core/uverbs_std_types.c   |   3 +
 drivers/infiniband/core/verbs.c              |  17 ++-
 drivers/infiniband/hw/mlx4/cq.c              |   4 +-
 drivers/infiniband/hw/mlx5/cq.c              |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   4 +-
 drivers/infiniband/hw/mlx5/qp.c              |   5 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c  |   2 +-
 drivers/infiniband/hw/mthca/mthca_user.h     | 112 ---------------
 drivers/infiniband/hw/qedr/verbs.c           |   6 +-
 drivers/infiniband/hw/qib/qib_keys.c         | 235 -------------------------------
 drivers/infiniband/sw/rxe/Kconfig            |   4 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |  16 +--
 drivers/infiniband/ulp/srp/ib_srp.c          | 723 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/infiniband/ulp/srp/ib_srp.h          |  43 +++++-
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   2 -
 include/rdma/ib_verbs.h                      |  39 ++++--
 include/rdma/restrack.h                      | 157 +++++++++++++++++++++
 include/scsi/srp.h                           |  17 +++
 include/uapi/rdma/ib_user_verbs.h            |   7 +-
 include/uapi/rdma/rdma_netlink.h             |  49 +++++++
 lib/kobject.c                                |   2 +
 33 files changed, 1511 insertions(+), 565 deletions(-)

Any chance one of the SRP patches got mishandled somehow??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
