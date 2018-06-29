From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH V4 4/7] PCI: Unify try slot and bus reset API
Date: Sat, 30 Jun 2018 00:43:32 +0300
Message-ID: <CAHp75VcYbeRTiggEiQnEV6DKR=F47RxNR0FZ+E-XKPpq8VNpqw@mail.gmail.com>
References: <1530214274-21139-1-git-send-email-okaya@codeaurora.org> <1530214274-21139-4-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530214274-21139-4-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Peter Xu <peterx@redhat.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 28, 2018 at 10:31 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
> Drivers are expected to call pci_try_reset_slot() or pci_try_reset_bus() by
> querying if a system supports hotplug or not. A survey showed that most
> drivers don't do this and we are leaking hotplug capability to the user.
>
> Hide pci_try_slot_reset() from drivers and embed into pci_try_bus_reset().
> Change pci_try_reset_bus() parameter from struct pci_bus to struct pci_dev.

> +/**
> + * pci_try_reset_bus - Try to reset a PCI bus
> + * @pdev: top level PCI device to reset via slot/bus
> + *
> + * Same as above except return -EAGAIN if the bus cannot be locked
> + */
> +int pci_try_reset_bus(struct pci_dev *pdev)
> +{
> +       bool slot = false;
> +
> +       if (!pci_probe_reset_slot(pdev->slot))
> +               slot = true;
> +
> +       return slot ? __pci_try_reset_slot(pdev->slot) :
> +                       __pci_try_reset_bus(pdev->bus);

This can be as simple as

  return pci_probe_reset_slot(pdev->slot) ?
    __pci_try_reset_bus(pdev->slot) : __pci_try_reset_slot(pdev->bus);


> +}
>  EXPORT_SYMBOL_GPL(pci_try_reset_bus);


-- 
With Best Regards,
Andy Shevchenko
