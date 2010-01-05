From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv7 2/9] ib_core: RoCEE support only QP1
Date: Tue, 5 Jan 2010 15:00:09 -0800
Message-ID: <3C9FA4CD26174188832FDD339D658C66@amr.corp.intel.com>
References: <20100105103237.GD31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105103237.GD31480@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Eli Cohen' <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>@@ -2941,21 +2960,24 @@ static void ib_mad_init_device(struct ib_device

This is at the top of ib_mad_init_device():

        if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
                return;
...

>*device)
> 	return;
>
> error_agent:
>-	if (ib_mad_port_close(device, i))
>-		printk(KERN_ERR PFX "Couldn't close %s port %d\n",
>-		       device->name, i);
>+	if (rdma_node_get_transport(device->node_type) == RDMA_TRANSPORT_IB)

... so this if statement will always be true.  Using rdma_port_link_layer()
doesn't seem quite right for QP 1 support, so I'm not sure that you want this
check at all.

>+		if (ib_mad_port_close(device, i))
>+			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
>+			       device->name, i);
>
> error:
> 	i--;
>
> 	while (i >= start) {
>-		if (ib_agent_port_close(device, i))
>-			printk(KERN_ERR PFX "Couldn't close %s port %d "
>-			       "for agents\n",
>-			       device->name, i);
>-		if (ib_mad_port_close(device, i))
>-			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
>-			       device->name, i);
>+		if (rdma_node_get_transport(device->node_type) ==
>RDMA_TRANSPORT_IB) {

Same here.

>+			if (ib_agent_port_close(device, i))
>+				printk(KERN_ERR PFX "Couldn't close %s port %d "
>+				       "for agents\n",
>+				       device->name, i);
>+			if (ib_mad_port_close(device, i))
>+				printk(KERN_ERR PFX "Couldn't close %s port
%d\n",
>+				       device->name, i);
>+		}
> 		i--;
> 	}
> }
>@@ -2972,13 +2994,15 @@ static void ib_mad_remove_device(struct ib_device
>*device)
> 		cur_port = 1;
> 	}
> 	for (i = 0; i < num_ports; i++, cur_port++) {
>-		if (ib_agent_port_close(device, cur_port))
>-			printk(KERN_ERR PFX "Couldn't close %s port %d "
>-			       "for agents\n",
>-			       device->name, cur_port);
>-		if (ib_mad_port_close(device, cur_port))
>-			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
>-			       device->name, cur_port);
>+		if (rdma_node_get_transport(device->node_type) ==
>RDMA_TRANSPORT_IB) {

It would be more efficient to move this check outside of the for loop, similar
to the check in ib_mad_init_device().

>+			if (ib_agent_port_close(device, cur_port))
>+				printk(KERN_ERR PFX "Couldn't close %s port %d "
>+				       "for agents\n",
>+				       device->name, cur_port);
>+			if (ib_mad_port_close(device, cur_port))
>+				printk(KERN_ERR PFX "Couldn't close %s port
%d\n",
>+				       device->name, cur_port);
>+		}
> 	}
> }
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
