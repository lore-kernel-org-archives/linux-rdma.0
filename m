From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB core sysfs: Add port_xmit_wait_counter V2
Date: Fri, 8 Jul 2016 10:08:44 -0400
Message-ID: <f77b903a-75d5-b7bf-3814-9efa3c627996@dev.mellanox.co.il>
References: <alpine.DEB.2.20.1607071231550.20276@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607071231550.20276-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/7/2016 1:36 PM, Christoph Lameter wrote:
> 
> V1->V2
> - Tested. Found that we missed modifying one table.
> 
> 
> Add the missing port_xmit_wait counter. This counter is displayed through
> some tools like perfquery but is not available via sysfs.
> 
> For the PORT_PMA_ATTR macro the _counter field is set to zero
> allowing us to specify the offset directly like with PORT_PMA_ATTR_EXT

I'm not following the relationship of _counter field to the offset other
than they are combined in the index and then I don't see counter part of
index ever being used. So it looks to me like _counter can be
deprecated/removed which is what Roland wrote in the thread you
referenced below.

> 
> See also the earlier work in 2008 by Vladimir Skolovsky
> 
> https://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg20313.html
> 
> Tested-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> 
> Index: rh73alpha/drivers/infiniband/core/sysfs.c
> ===================================================================
> --- rh73alpha.orig/drivers/infiniband/core/sysfs.c
> +++ rh73alpha/drivers/infiniband/core/sysfs.c
> @@ -530,6 +530,7 @@ static PORT_PMA_ATTR(port_xmit_data
>  static PORT_PMA_ATTR(port_rcv_data		    , 13, 32, 224);
>  static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
>  static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);
> +static PORT_PMA_ATTR(port_xmit_wait		    ,  0, 32, 320);
> 
>  /*
>   * Counters added by extended set
> @@ -560,6 +561,7 @@ static struct attribute *pma_attrs[] = {
>  	&port_pma_attr_port_rcv_data.attr.attr,
>  	&port_pma_attr_port_xmit_packets.attr.attr,
>  	&port_pma_attr_port_rcv_packets.attr.attr,
> +	&port_pma_attr_port_xmit_wait.attr.attr,
>  	NULL
>  };
> 
> @@ -579,6 +581,7 @@ static struct attribute *pma_attrs_ext[]
>  	&port_pma_attr_ext_port_xmit_data.attr.attr,
>  	&port_pma_attr_ext_port_rcv_data.attr.attr,
>  	&port_pma_attr_ext_port_xmit_packets.attr.attr,
> +	&port_pma_attr_port_xmit_wait.attr.attr,
>  	&port_pma_attr_ext_port_rcv_packets.attr.attr,
>  	&port_pma_attr_ext_unicast_rcv_packets.attr.attr,
>  	&port_pma_attr_ext_unicast_xmit_packets.attr.attr,
> @@ -604,6 +607,7 @@ static struct attribute *pma_attrs_noiet
>  	&port_pma_attr_ext_port_rcv_data.attr.attr,
>  	&port_pma_attr_ext_port_xmit_packets.attr.attr,
>  	&port_pma_attr_ext_port_rcv_packets.attr.attr,
> +	&port_pma_attr_port_xmit_wait.attr.attr,
>  	NULL
>  };
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
