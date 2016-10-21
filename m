From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 00/16] Add Paravirtual RDMA Driver
Date: Fri, 21 Oct 2016 10:49:33 -0700
Message-ID: <004115cf-2b58-2473-ee5d-88ae326b3809@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
 <20161005134421.GI9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161005134421.GI9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 05, 2016 at 4:44:21PM +0300, Leon Romanovsky wrote:
> On Sun, Oct 02, 2016 at 07:10:20PM -0700, Adit Ranadive wrote:

<snip>

> >
> > ---
> > Adit Ranadive (16):
> >   vmxnet3: Move PCI Id to pci_ids.h
> >   IB/pvrdma: Add user-level shared functions
> >   IB/pvrdma: Add functions for ring traversal
> >   IB/pvrdma: Add the paravirtual RDMA device specification
> >   IB/pvrdma: Add functions for Verbs support
> >   IB/pvrdma: Add paravirtual rdma device
> >   IB/pvrdma: Add helper functions
> >   IB/pvrdma: Add device command support
> >   IB/pvrdma: Add support for Completion Queues
> >   IB/pvrdma: Add UAR support
> >   IB/pvrdma: Add support for memory regions
> >   IB/pvrdma: Add Queue Pair support
> >   IB/pvrdma: Add the main driver module for PVRDMA
> >   IB/pvrdma: Add Kconfig and Makefile
> >   IB: Add PVRDMA driver
> >   MAINTAINERS: Update for PVRDMA driver
> >
> >  MAINTAINERS                                    |    7 +
> >  drivers/infiniband/Kconfig                     |    1 +
> >  drivers/infiniband/hw/Makefile                 |    1 +
> >  drivers/infiniband/hw/pvrdma/Kconfig           |    7 +
> >  drivers/infiniband/hw/pvrdma/Makefile          |    3 +
> >  drivers/infiniband/hw/pvrdma/pvrdma.h          |  474 ++++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_cmd.c      |  119 +++
> >  drivers/infiniband/hw/pvrdma/pvrdma_cq.c       |  425 +++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h  |  586 ++++++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c |  127 +++
> >  drivers/infiniband/hw/pvrdma/pvrdma_main.c     | 1211 ++++++++++++++++++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_misc.c     |  304 ++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_mr.c       |  334 +++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_qp.c       |  972 +++++++++++++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_ring.h     |  131 +++
> >  drivers/infiniband/hw/pvrdma/pvrdma_verbs.c    |  577 +++++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_verbs.h    |  435 +++++++++
> >  drivers/net/vmxnet3/vmxnet3_int.h              |    3 +-
> >  include/linux/pci_ids.h                        |    1 +
> >  include/uapi/rdma/Kbuild                       |    2 +
> >  include/uapi/rdma/pvrdma-abi.h                 |  289 ++++++
> >  21 files changed, 6007 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/Kconfig
> >  create mode 100644 drivers/infiniband/hw/pvrdma/Makefile
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cq.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_main.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_misc.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_mr.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_qp.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ring.h
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h
> >  create mode 100644 include/uapi/rdma/pvrdma-abi.h
> 
> Except patch 02, looks good to me.
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Thanks

Doug, have you had a chance to look at this patch series?
Since this didnt make it into 4.9 what are your plans for
this patch series?

Thanks to Yuval, Leon who have already reviewed these patches.
The PCI related change was also acked by Bjorn[1].

Thanks,
Adit

[1] http://marc.info/?l=linux-rdma&m=147370089824083&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
