From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: IB on s390 broken with commit 99db94940 "IB/core: Remove
 ib_device.dma_device"
Date: Mon, 27 Feb 2017 21:17:44 +0100 (CET)
Message-ID: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

commit 99db94940 "IB/core: Remove ib_device.dma_device"
breaks infiniband on s390 (and I think also other archs that do something
like to_pci_dev(dev) in one of their dma_ops callbacks).

With this commit you use the dma_ops of the device that called
ib_register_device but you call e.g. dma_map with ib_device->dev
as an argument.

S390's (pci specific) dma_map uses to_pci_dev(dev) to look into the
pci device (and its arch specific data) and oopses.

Calling dma_map with ib_device->dev.parent would work but then it
wouldn't make sense to copy dma_ops and mask from ib_device->dev.parent
to ib_device->dev..

Regards,
Sebastian
