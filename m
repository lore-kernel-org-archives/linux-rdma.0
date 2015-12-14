From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended set
Date: Mon, 14 Dec 2015 16:03:20 +0200
Message-ID: <CAAKD3BAT36BGP+21y9oz1E4EuURFuwiAHi558ho8y+k3GEy4Ww@mail.gmail.com>
References: <20151211182532.332343651@linux.com>
	<20151211182543.329283794@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151211182543.329283794-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 11, 2015 at 8:25 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> Display the additional 64 bit counters available through the extended
> set and replace the existing 32 bit counters if there is a 64 bit
> alternative available.
>
> Note: This requires universal support of extended counters in
> the devices. If there are still devices around that do not
> support extended counters then we will have to add some fallback
> technique here.
>
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index 0083a4f..f7f2954 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -406,10 +406,14 @@ static PORT_PMA_ATTR(port_rcv_constraint_errors       ,  8,  8, 136, IB_PMA_PORT_C
>  static PORT_PMA_ATTR(local_link_integrity_errors    ,  9,  4, 152, IB_PMA_PORT_COUNTERS);
>  static PORT_PMA_ATTR(excessive_buffer_overrun_errors, 10,  4, 156, IB_PMA_PORT_COUNTERS);
>  static PORT_PMA_ATTR(VL15_dropped                  , 11, 16, 176, IB_PMA_PORT_COUNTERS);
> -static PORT_PMA_ATTR(port_xmit_data                , 12, 32, 192, IB_PMA_PORT_COUNTERS);
> -static PORT_PMA_ATTR(port_rcv_data                 , 13, 32, 224, IB_PMA_PORT_COUNTERS);
> -static PORT_PMA_ATTR(port_xmit_packets             , 14, 32, 256, IB_PMA_PORT_COUNTERS);
> -static PORT_PMA_ATTR(port_rcv_packets              , 15, 32, 288, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_xmit_data                ,  0, 64,  64, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(port_rcv_data                 ,  0, 64, 128, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(port_xmit_packets             ,  0, 64, 192, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(port_rcv_packets              ,  0, 64, 256, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(unicast_xmit_packets          ,  0, 64, 320, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(unicast_rcv_packets           ,  0, 64, 384, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(multicast_xmit_packets        ,  0, 64, 448, IB_PMA_PORT_COUNTERS_EXT);
> +static PORT_PMA_ATTR(multicast_rcv_packets         ,  0, 64, 512, IB_PMA_PORT_COUNTERS_EXT);
>

Why do we use 0 as the counter argument for all EXT counters?

>  static struct attribute *pma_attrs[] = {
>         &port_pma_attr_symbol_error.attr.attr,
> @@ -428,6 +432,10 @@ static struct attribute *pma_attrs[] = {
>         &port_pma_attr_port_rcv_data.attr.attr,
>         &port_pma_attr_port_xmit_packets.attr.attr,
>         &port_pma_attr_port_rcv_packets.attr.attr,
> +       &port_pma_attr_unicast_rcv_packets.attr.attr,
> +       &port_pma_attr_unicast_xmit_packets.attr.attr,
> +       &port_pma_attr_multicast_rcv_packets.attr.attr,
> +       &port_pma_attr_multicast_xmit_packets.attr.attr,
>         NULL
>  };
>
> --
> 2.5.0
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
