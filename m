From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
 driver for Linux
Date: Wed, 27 Jul 2016 22:32:36 +0000
Message-ID: <DM2PR0301MB0783A488E36D1BFAC43A4704A00F0@DM2PR0301MB0783.namprd03.prod.outlook.com>
References: <1469585137-31229-1-git-send-email-kys@exchange.microsoft.com>
 <20160727042521.GD4628@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20160727042521.GD4628@leon.nu>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "leann.ogasawara@canonical.com" <leann.ogasawara@canonical.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "yishaih@mellanox.com" <yishaih@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "dledford@redhat.com" <dledford@redhat.com>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "sean.hefty@intel.com" <sean.hefty@intel.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Tuesday, July 26, 2016 9:25 PM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; linux-rdma@vger.kernel.org;
> yishaih@mellanox.com; sean.hefty@intel.com; dledford@redhat.com;
> olaf@aepfle.de; apw@canonical.com; vkuznets@redhat.com;
> jasowang@redhat.com; leann.ogasawara@canonical.com; Long Li
> <longli@microsoft.com>
> Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
> driver for Linux
> 
> On Tue, Jul 26, 2016 at 07:05:37PM -0700, kys@exchange.microsoft.com
> wrote:
> > From: K. Y. Srinivasan <kys@microsoft.com>
> >
> > This driver is a bridge driver that surfaces a Mellanox device in the Linux
> guest and plugs into
> > the "NetworkDirect" RDMA infrastructure on the Windows host. Only a subset
> of the ibverbs are
> > implemented (this decision is based on the verbs supported by the Windows
> host).
> > The control path is implemented over the vmbus using the NetworkDirect
> protocol for
> > virtualized environments. The data path bypasses the guest and host kernel
> and the NIC is able to RDMA
> > into guest addresses.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/infiniband/Kconfig                  |    1 +
> >  drivers/infiniband/hw/Makefile              |    1 +
> >  drivers/infiniband/hw/vmbus-nd/Kconfig      |    5 +
> >  drivers/infiniband/hw/vmbus-nd/Makefile     |    3 +
> >  drivers/infiniband/hw/vmbus-nd/hvnd_addr.c  |  292 +++
> >  drivers/infiniband/hw/vmbus-nd/mx_abi.h     |  232 ++
> >  drivers/infiniband/hw/vmbus-nd/provider.c   | 2844
> ++++++++++++++++++++++++
> >  drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c | 3086
> +++++++++++++++++++++++++++
> >  drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h | 2205
> +++++++++++++++++++
> >  9 files changed, 8669 insertions(+), 0 deletions(-)
> 
> If your final goal is to merge this driver into Linux kernel, so I will
> ask from you to do the following actions:

Yes, our final goal is to get the driver into the Linux Kernel.

> 
> 1. Split this patch to smaller patches to allow review.

In the past I have submitted new drivers as a single patch and that is what I did here.
That said, I will try to breakup this driver on a per verb implementation basis. Hope that
is adequate for making the review easy.

> You can see as an example - latest submission of "Add Paravirtual RDMA
> Driver" [1].
> 2. Fix licenses, magic numbers, remove creepy comments and learn about
> MAINTAINERS file.
> 3. Use preferred for this susbsystem title format.

I will do that.

> 4. Find the relevant mailing list and maintainer for this submission and
> don't add unrelated people.

I looked at the MAINTAINERS file and selected the addresses that I thought I should send to.
Sean Hefty (from Intel) helped me during the initial implementation and so I included him.
In my next submission, I will do as you are recommending here.

Leon,

Thank you for your comments and I will address them all in my next submission.

Regards,

K. Y
> 
> Thanks.
> 
> [1] http://marc.info/?l=linux-rdma&m=146835226218818&w=2
> 
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/Kconfig
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/Makefile
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/hvnd_addr.c
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/mx_abi.h
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/provider.c
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c
> >  create mode 100644 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h
