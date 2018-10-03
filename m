From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 1/9] PCI: sysfs: Export available PCIe bandwidth
Date: Wed, 3 Oct 2018 16:30:54 -0500
Message-ID: <20181003213054.GH120535@bhelgaas-glaptop.roam.corp.google.com>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
 <20180903180242.14504-2-mr.nuke.me@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903180242.14504-2-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com, Stephen Hemminger <stephen@network>
List-Id: linux-rdma@vger.kernel.org

[+cc Stephen, Martin (for possible lspci changes)]

Hi Alexandru,

On Mon, Sep 03, 2018 at 01:02:28PM -0500, Alexandru Gagniuc wrote:
> For certain bandwidth-critical devices (e.g. multi-port network cards)
> it is useful to know the available bandwidth to the root complex. This
> information is only available via the system log, which doesn't
> account for link degradation after probing.
> 
> With a sysfs attribute, we can computes the bandwidth on-demand, and
> will detect degraded links.
> 
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/pci/pci-sysfs.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 9ecfe13157c0..6658e927b1f5 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -218,6 +218,18 @@ static ssize_t current_link_width_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(current_link_width);
>  
> +static ssize_t available_bandwidth_show(struct device *dev,
> +				       struct device_attribute *attr, char *buf)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	u32 bw_avail;
> +
> +	bw_avail = pcie_bandwidth_available(pci_dev, NULL, NULL, NULL);
> +
> +	return sprintf(buf, "%u.%03u Gb/s\n", bw_avail / 1000, bw_avail % 1000);
> +}
> +static DEVICE_ATTR_RO(available_bandwidth);

Help me understand this.  We already have these sysfs attributes:

  max_link_speed          # eg, 16 GT/s
  max_link_width          # eg, 8
  current_link_speed      # eg, 16 GT/s
  current_link_width      # eg, 8

so I think the raw materials are already exposed.

The benefits I see for this new file are that

  - pcie_bandwidth_available() does the work of traversing up the
    tree, doing the computations (link width * speed, reduced by
    encoding overhead), and finding the minimum, and

  - it re-traverses the path every time we look at it, while the
    boot-time check is a one-time event.

In principle this could all be done in user space with the attributes
that are already exported.  There's some precedent for things like
this in lspci, e.g., "NUMA node" [1], and lspci might even be a more
user-friendly place for users to look for this, as opposed to
searching through sysfs.

[1] https://git.kernel.org/pub/scm/utils/pciutils/pciutils.git/commit/?id=90ec4a6d0ae8

>  static ssize_t secondary_bus_number_show(struct device *dev,
>  					 struct device_attribute *attr,
>  					 char *buf)
> @@ -786,6 +798,7 @@ static struct attribute *pcie_dev_attrs[] = {
>  	&dev_attr_current_link_width.attr,
>  	&dev_attr_max_link_width.attr,
>  	&dev_attr_max_link_speed.attr,
> +	&dev_attr_available_bandwidth.attr,
>  	NULL,
>  };
>  
> -- 
> 2.17.1
> 
