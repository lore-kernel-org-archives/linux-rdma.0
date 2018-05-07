From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 06/14] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
Date: Mon, 7 May 2018 18:20:29 -0500
Message-ID: <20180507232029.GH161390@bhelgaas-glaptop.roam.corp.google.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-7-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180423233046.21476-7-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 23, 2018 at 05:30:38PM -0600, Logan Gunthorpe wrote:
> Add a restructured text file describing how to write drivers
> with support for P2P DMA transactions. The document describes
> how to use the APIs that were added in the previous few
> commits.
> 
> Also adds an index for the PCI documentation tree even though this
> is the only PCI document that has been converted to restructured text
> at this time.
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> ---
>  Documentation/PCI/index.rst             |  14 +++
>  Documentation/driver-api/pci/index.rst  |   1 +
>  Documentation/driver-api/pci/p2pdma.rst | 166 ++++++++++++++++++++++++++++++++
>  Documentation/index.rst                 |   3 +-
>  4 files changed, 183 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/PCI/index.rst
>  create mode 100644 Documentation/driver-api/pci/p2pdma.rst
> 
> diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
> new file mode 100644
> index 000000000000..2fdc4b3c291d
> --- /dev/null
> +++ b/Documentation/PCI/index.rst
> @@ -0,0 +1,14 @@
> +==================================
> +Linux PCI Driver Developer's Guide
> +==================================
> +
> +.. toctree::
> +
> +   p2pdma
> +
> +.. only::  subproject and html
> +
> +   Indices
> +   =======
> +
> +   * :ref:`genindex`
> diff --git a/Documentation/driver-api/pci/index.rst b/Documentation/driver-api/pci/index.rst
> index 03b57cbf8cc2..d12eeafbfc90 100644
> --- a/Documentation/driver-api/pci/index.rst
> +++ b/Documentation/driver-api/pci/index.rst
> @@ -10,6 +10,7 @@ The Linux PCI driver implementer's API guide
>     :maxdepth: 2
>  
>     pci
> +   p2pdma
>  
>  .. only::  subproject and html
>  
> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> new file mode 100644
> index 000000000000..49a512c405b2
> --- /dev/null
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -0,0 +1,166 @@
> +============================
> +PCI Peer-to-Peer DMA Support
> +============================
> +
> +The PCI bus has pretty decent support for performing DMA transfers
> +between two endpoints on the bus. This type of transaction is

s/endpoints/devices/

> +henceforth called Peer-to-Peer (or P2P). However, there are a number of
> +issues that make P2P transactions tricky to do in a perfectly safe way.
> +
> +One of the biggest issues is that PCI Root Complexes are not required

s/PCI Root Complexes .../
  PCI doesn't require forwarding transactions between hierarchy domains,
and in PCIe, each Root Port defines a separate hierarchy domain./

> +to support forwarding packets between Root Ports. To make things worse,
> +there is no simple way to determine if a given Root Complex supports
> +this or not. (See PCIe r4.0, sec 1.3.1). Therefore, as of this writing,
> +the kernel only supports doing P2P when the endpoints involved are all
> +behind the same PCIe root port as the spec guarantees that all
> +packets will always be routable but does not require routing between
> +root ports.

s/endpoints involved .../
  devices involved are all behind the same PCI bridge, as such devices are
  all in the same PCI hierarchy domain, and the spec guarantees that all
  transactions within the hierarchy will be routable, but it does not
  require routing between hierarchies./

> +
> +The second issue is that to make use of existing interfaces in Linux,
> +memory that is used for P2P transactions needs to be backed by struct
> +pages. However, PCI BARs are not typically cache coherent so there are
> +a few corner case gotchas with these pages so developers need to
> +be careful about what they do with them.
