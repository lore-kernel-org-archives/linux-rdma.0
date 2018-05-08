From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Tue, 8 May 2018 07:31:30 -0700
Message-ID: <CAPcyv4g+5N_n03J-VhmJfrr60Sqk95ZapLKBkwSsGvV4nQ+ZRw@mail.gmail.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180423233046.21476-5-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 23, 2018 at 4:30 PM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
> For peer-to-peer transactions to work the downstream ports in each
> switch must not have the ACS flags set. At this time there is no way
> to dynamically change the flags and update the corresponding IOMMU
> groups so this is done at enumeration time before the groups are
> assigned.
>
> This effectively means that if CONFIG_PCI_P2PDMA is selected then
> all devices behind any PCIe switch heirarchy will be in the same IOMMU
> group. Which implies that individual devices behind any switch
> heirarchy will not be able to be assigned to separate VMs because
> there is no isolation between them. Additionally, any malicious PCIe
> devices will be able to DMA to memory exposed by other EPs in the same
> domain as TLPs will not be checked by the IOMMU.
>
> Given that the intended use case of P2P Memory is for users with
> custom hardware designed for purpose, we do not expect distributors
> to ever need to enable this option. Users that want to use P2P
> must have compiled a custom kernel with this configuration option
> and understand the implications regarding ACS. They will either
> not require ACS or will have design the system in such a way that
> devices that require isolation will be separate from those using P2P
> transactions.

>
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/pci/Kconfig        |  9 +++++++++
>  drivers/pci/p2pdma.c       | 45 ++++++++++++++++++++++++++++++---------------
>  drivers/pci/pci.c          |  6 ++++++
>  include/linux/pci-p2pdma.h |  5 +++++
>  4 files changed, 50 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index b2396c22b53e..b6db41d4b708 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -139,6 +139,15 @@ config PCI_P2PDMA
>           transations must be between devices behind the same root port.
>           (Typically behind a network of PCIe switches).
>
> +         Enabling this option will also disable ACS on all ports behind
> +         any PCIe switch. This effectively puts all devices behind any
> +         switch heirarchy into the same IOMMU group. Which implies that
> +         individual devices behind any switch will not be able to be
> +         assigned to separate VMs because there is no isolation between
> +         them. Additionally, any malicious PCIe devices will be able to
> +         DMA to memory exposed by other EPs in the same domain as TLPs
> +         will not be checked by the IOMMU.
> +
>           If unsure, say N.

It seems unwieldy that this is a compile time option and not a runtime
option. Can't we have a kernel command line option to opt-in to this
behavior rather than require a wholly separate kernel image?

Why is this text added in a follow on patch and not the patch that
introduced the config option?

I'm also wondering if that command line option can take a 'bus device
function' address of a switch to limit the scope of where ACS is
disabled.
