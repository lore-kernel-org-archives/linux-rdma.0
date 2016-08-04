From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Thu, 4 Aug 2016 19:18:25 +0000
Message-ID: <BLUPR0501MB836AD5025DF368D82DF21C9C5070@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
 <20160804065352.GJ27667@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160804065352.GJ27667-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-88hImbXBzXrLi+/K9TH57EEOCMrvLtNR@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 04, 2016 at 06:54:04 +0000, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Aug 03, 2016 at 04:27:41PM -0700, Adit Ranadive wrote:
> > This patch adds the support to register a RDMA device with the kernel RDMA
> > stack as well as a kernel module. This also initializes the underlying
> > virtual PCI device.
> >
> > Changes from v1: Addressed 32-bit build errors. Addressed comments by
> > Yuval Shaia.
> >
> > Changes v2->v3:
> >  - Removed boolean in pvrdma_cmd_post.
> 
> Please put changelog after  "---", we don't want to see them in git
> history.

Ok. Sorry about that.

> 
> >
> > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---

...

> > +
> > +#include "pvrdma.h"
> > +#include "pvrdma_user.h"
> > +
> > +#define PCI_DEVICE_ID_VMWARE_VMXNET3	0x07B0
> 
> You have this define in drivers/net/vmxnet3/vmxnet3_int.h and it looks
> strange to have same defines two different files.
> 
> Does it belong to include/linux/pci_ids.h file?

Possibly. I'll talk to our maintainer of VMXNet3 code to see if we can
move it there.
Until that time, we would have to leave it defined here since we have to 
check for the paired device ID. I can remove it in a future patch.

> > +
> > +#define DRV_NAME	"pvrdma"
> > +#define DRV_VERSION	"1.0"
> > +#define DRV_RELDATE	"January 1, 2013"
> > +
> > +static const char pvrdma_version[] =
> > +	DRV_NAME ": PVRDMA InfiniBand driver v"
> > +	DRV_VERSION " (" DRV_RELDATE ")\n";
> > +
> > +static DEFINE_MUTEX(pvrdma_device_list_lock);
> > +static LIST_HEAD(pvrdma_device_list);
> > +
> > +static int pvrdma_add_gid(struct ib_device *ibdev,
> > +			  u8 port_num,
> > +			  unsigned int index,
> > +			  const union ib_gid *gid,
> > +			  const struct ib_gid_attr *attr,
> > +			  void **context);
> > +static int pvrdma_del_gid(struct ib_device *ibdev,
> > +			  u8 port_num,
> > +			  unsigned int index,
> > +			  void **context);
> > +
> > +
> > +static ssize_t show_hca(struct device *device, struct device_attribute *attr,
> > +			char *buf)
> > +{
> > +	return sprintf(buf, "PVRDMA%s\n", DRV_VERSION);
> > +}
> > +
> > +static ssize_t show_fw_ver(struct device *device,
> > +			   struct device_attribute *attr, char *buf)
> 
> We have general show_fw_ver utility in core/sysfs.c,  Please use it.
> 

Ok. Will add support for the new get_dev_fw_str device function. Thanks
for catching that!

-  Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
