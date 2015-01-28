From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] ibtracert.c: Remove checking the port
 0 state for BasePort0 switches
Date: Wed, 28 Jan 2015 23:12:33 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC0DB18@CRSMSX101.amr.corp.intel.com>
References: <54BE514B.5030904@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC0D7F9@CRSMSX101.amr.corp.intel.com>
 <54C96586.3080309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C96586.3080309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>
> >> +static int is_route_inactive_port0(Node * node, Port * port, Switch
> >> +*
> >> +sw) {
> >
> > I would prefer this function be named something like:
> >
> > port_inactive_not_bsp0
> >
> > The current name is confusing as to what the logic is.
> 
> How about is_port_inactive ?

That is fine.

> 
> >> +	int res = 0;
> >> +	/* not active for HCA and for enhanced port0 Switches */
> >> +	if (port->state != 4 &&
> >
> > Please use #defines here even though the original code did not.
> 
> This is an issue throughout infiniband-diags. I think it should be addressed by
> separate patch(es) for this.

I would rather see us do the right thing going forward.  This saves work trying to find all these majic numbers later.

Ira


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
