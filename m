From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 1/6] Common infrastructure for auto loading
 rdma modules
Date: Fri, 28 Jul 2017 16:48:55 -0500
Message-ID: <20170728214855.GA13840@ctung-MOBL3.amr.corp.intel.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501194685-9447-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501194685-9447-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 27, 2017 at 04:31:20PM -0600, Jason Gunthorpe wrote:

[...]

Sorry Jason, I can't test this till next week.  On inspection I found a couple of issues
below.

> diff --git a/kernel-boot/rdma-description.rules b/kernel-boot/rdma-description.rules
> new file mode 100644
> index 00000000000000..4d7c5808401ac7
> --- /dev/null
> +++ b/kernel-boot/rdma-description.rules
> @@ -0,0 +1,42 @@
> +# This is a version of net-description.rules for /sys/class/infiniband devices
> +
> +ACTION=="remove", GOTO="rdma_description_end"
> +SUBSYSTEM!="infiniband", GOTO="rdma_description_end"
> +
> +# NOTE: DRIVERS searches up the sysfs path to find the driver that is bound to
> +# the PCI/etc device that the RDMA device is linked to. This is not the kernel
> +# driver that is supplying the RDMA device (eg as seen in ID_NET_DRIVER)
> +
> +# FIXME: with kernel support we could actually detect the protocols the RDMA
> +# driver itself supports, this is a work around for lack of that support.
> +# In future we could do this with a udev IMPORT{program} helper program
> +# that extracted the ID information from the RDMA netlink.
> +
> +# Hardware that supports InfiniBand
> +DRIVERS=="mlx4_core", ENV{ID_RDMA_INFINIBAND}="1"
> +DRIVERS=="mlx5_core", ENV{ID_RDMA_INFINIBAND}="1"
> +DRIVERS=="qib", ENV{ID_RDMA_INFINIBAND}="1"
> +
> +# Hardware that supports OPA
> +DRIVERS=="hfi1verbs", ENV{ID_RDMA_OPA}="1"
> +
> +# Hardware that supports iWarp
> +DRIVERS=="cxgb3", ENV{ID_RDMA_IWARP}="1"
> +DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"

Need to add nes and i40e here under iWARP.
This is enough to autoload iwpmd for nes and i40e/i40iw, correct?

> +
> +# Hardware that supports RoCE
> +DRIVERS=="be2net", ENV{ID_RDMA_ROCE}="1"
> +DRIVERS=="bnxt_en", ENV{ID_RDMA_ROCE}="1"
> +DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
> +DRIVERS=="i40e", ENV{ID_RDMA_ROCE}="1"

i40e does not support RoCE, see above.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
