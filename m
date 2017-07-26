From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Common infrastructure for auto loading rdma
 modules
Date: Wed, 26 Jul 2017 09:48:04 -0400
Message-ID: <0b3badf8-053f-e1ed-2be8-c5e6d416384b@intel.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500929067-1583-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/24/2017 4:44 PM, Jason Gunthorpe wrote:
> diff --git a/kernel-boot/modules/opa.conf b/kernel-boot/modules/opa.conf
> new file mode 100644
> index 00000000000000..b9bc9f1f0146af
> --- /dev/null
> +++ b/kernel-boot/modules/opa.conf
> @@ -0,0 +1,10 @@
> +# These modules are loaded by the system if any OmniPath Architecture device
> +# is installed
> +# Infiniband over IP netdevice
> +ib_ipoib

Do we need to have rdmavt listed here too?

> +# Hardware that supports InfiniBand
> +DRIVERS=="mlx4_core", ENV{ID_RDMA_INFINIBAND}="1"
> +DRIVERS=="mlx5_core", ENV{ID_RDMA_INFINIBAND}="1"
> +DRIVERS=="qib", ENV{ID_RDMA_INFINIBAND}="1"
> +
> +# Hardware that supports OPA
> +DRIVERS=="hfi1verbs", ENV{ID_RDMA_IWARP}="1"

Why calling this IWARP?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
