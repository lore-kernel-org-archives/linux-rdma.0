From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/IPoIB: Support SRIOV standard configuration
Date: Thu, 21 May 2015 12:46:13 -0600
Message-ID: <20150521184613.GD6771@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432225447-6536-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432225447-6536-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 07:24:05PM +0300, Or Gerlitz wrote:
> Standard configuration of SRIOV VFs through the host is done over the
> following chain of calls: libvirt --> netlink --> PF netdevice
> 
> When this comes to IB/IPoIB we should normalize this into the verbs
> framework so we further go: PF IPoIB --> verbs API --> PF HW driver
> 
> Virtualization systems assign VMs 48 bits mac, to allow working with
> non-modified SW layers (open-stack, libvirt, etc), we can safely
> extend this mac to unique 64 bits GUID. Hence the IPoIB ndo_set_vf_mac
> entry calls the set_vf_guid verb.
> 
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |   39 +++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h                   |    4 +++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 9e1b203..8f82870 100644
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1357,6 +1357,43 @@ void ipoib_dev_cleanup(struct net_device *dev)
>  	priv->tx_ring = NULL;
>  }
>  
> +static int ipoib_get_vf_config(struct net_device *dev, int vf, struct ifla_vf_info *ivf)
> +{
> +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> +
> +	if (priv->ca->get_vf_config)
> +		return priv->ca->get_vf_config(priv->ca, priv->port, vf, ivf);
> +	else
> +		return -EINVAL;
> +}
> +
> +static int ipoib_set_vf_mac(struct net_device *dev, int queue, u8 *mac)
> +{
> +	char *raw_guid;
> +	u64 guid = 0;

This doesn't seem right at all.

It makes no sense that a IPoIB interface with a 20 byte LLADDR would
accept an 8 byte LLADDR only for 'ip link set vf mac'

The definition of the netlink struct seems to confirm this:

struct ifla_vf_mac {
        __u32 vf;
        __u8 mac[32]; /* MAX_ADDR_LEN */
};

If it was really just ever a mac it would really only be 6 bytes.
[Honestly, this whole feature seems very inconistent with the rest of
 the design of ip net link, so who knows]

If the ifla_vf_mac had been variable-sized (like every other address
related attribute) then sure, auto detect the length and do the right
thing.

But with this API, I think you have no choice, 'ip set vf mac LLADDR'
can only be the 20 byte address.

If you really, really want this: Get someone from iproute or netdev to
sign off that they really mean that 'ip set vf mac LLADDR' is always a
6 byte mac.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
