From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH ibacm] acm.c: Handle client reregister local event
Date: Mon, 5 Aug 2013 17:39:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA2E3F@ORSMSX109.amr.corp.intel.com>
References: <51FB9F65.4040804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51FB9F65.4040804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +		case IBV_EVENT_CLIENT_REREGISTER:
> +			if (dev->port[i].state == IBV_PORT_ACTIVE) {
> +				acm_port_join(&dev->port[i]);
> +				acm_log(1, "%s %d has reregistered\n",
> +					dev->verbs->device->name, i);

applied, but changed 'i' to 'i + 1' to display the correct port number

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
