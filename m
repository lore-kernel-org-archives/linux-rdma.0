From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] IB core: Add port_xmit_wait counter
Date: Fri, 8 Jul 2016 12:59:53 -0400
Message-ID: <3bfb4906-4089-1191-8fc9-cebc0f4275ae@dev.mellanox.co.il>
References: <alpine.DEB.2.20.1607081026550.5092@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607081026550.5092-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2016 11:27 AM, Christoph Lameter wrote:
> Add the missing port_xmit_wait counter. This counter is displayed through
> some tools like perfquery but is not available via sysfs.
> 
> For the PORT_PMA_ATTR macro the _counter field is set to zero
> allowing us to specify the offset directly like with PORT_PMA_ATTR_EXT

What does the value of the _counter field have to do with specifying the
offset directly ?

> See also the earlier work in 2008 by Vladimir Skolovsky
> 
> https://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg20313.html
> 
> Signed-off-by: Vladimir Sokolvsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> ---
> 
> V1->V2
> - Tested. Found that we missed modifying on table.
> 
> V2->V3
> - Change description, topic etc.
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

Although it doesn't matter now as it's not used, wouldn't the _counter
be better as 16 rather than 0 ? If it were to be used (in the future),
it indicates the corresponding number to the counter. In the case of set
support, it would be translated to a bit in PortCounters CounterSelect
or CounterSelect2 (if option to set port xmit wait counter is supported).

An alternative is to remove _counter which could be done as either part
of this or as a follow on change.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
