From: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Documentation/ABI: update infiniband sysfs interfaces
Date: Mon, 5 Feb 2018 12:49:34 +0530
Message-ID: <20180205071934.GA9185@mordor.localdomain>
References: <20180201133233.GA21266@mordor.localdomain>
 <64f953cc-7831-1164-28b5-5319e72e600f@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <64f953cc-7831-1164-28b5-5319e72e600f-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 12:48:18PM -0500, Hal Rosenstock wrote:
> On 2/1/2018 8:32 AM, Aishwarya Pant wrote:
> > Add documentation for core and hardware specific infiniband interfaces.
> > The descriptions have been collected from git commit logs, reading
> > through code and data sheets. Some drivers have incomplete doc and are
> > annotated with the comment '[to be documented]'.
> > 
> > Signed-off-by: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  Documentation/ABI/testing/sysfs-class-infiniband | 755 +++++++++++++++++++++++
> >  1 file changed, 755 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-infiniband b/Documentation/ABI/testing/sysfs-class-infiniband
> > index a86abe66a316..2e150169633b 100644
> > --- a/Documentation/ABI/testing/sysfs-class-infiniband
> > +++ b/Documentation/ABI/testing/sysfs-class-infiniband
> > @@ -1,3 +1,194 @@
> > +sysfs interface common for all infiniband devices
> > +-------------------------------------------------
> > +
> > +What:		/sys/class/infiniband/<device>/node_type
> > +What:		/sys/class/infiniband/<device>/node_guid
> > +What:		/sys/class/infiniband/<device>/sys_image_guid
> > +Date:		Apr, 2005
> > +KernelVersion:	v2.6.12
> > +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > +Description:
> > +		node_type:	(RO) Node type (CA, RNIC, usNIC, usNIC UDP,
> > +				switch or router)
> > +
> > +		node_guid:	(RO) Node GUID
> > +
> > +		sys_image_guid:	(RO) System image GUID
> > +
> > +
> > +What:		/sys/class/infiniband/<device>/node_desc
> > +Date:		Feb, 2006
> > +KernelVersion:	v2.6.17
> > +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > +Description:
> > +		(RW) Update the node description with information such as the
> > +		node's hostname, so that IB network management software can tie
> > +		its view to the real world.
> > +
> > +
> > +What:		/sys/class/infiniband/<device>/fw_ver
> > +Date:		Jun, 2016
> > +KernelVersion:	v4.10
> > +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > +Description:
> > +		(RO) Display firmware version
> > +
> > +
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/lid
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/rate
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/lid_mask_count
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/sm_sl
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/sm_lid
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/state
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/phys_state
> > +What:		/sys/class/infiniband/<device>/ports/<port-num>/cap_mask
> > +Date:		Apr, 2005
> > +KernelVersion:	v2.6.12
> > +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > +Description:
> > +
> > +		lid:		(RO) Port LID
> > +
> > +		rate:		(RO) Port data rate (active width * active
> > +				speed)
> > +
> > +		lid_mask_count:	(RO) Port LID mask count
> > +
> > +		sm_slL		(RO) Subnet manager SL for port's subnet
> 
> Typo sm_sl:
> 
> > +
> > +		sm_lid:		(RO) Subnet manager LID for port's subnet
> > +
> > +		state:		(RO) Port state (DOWN, INIT, ARMED, ACTIVE or
> > +				ACTIVE_DEFER> +
> > +		phys_state:	(RO) Port physical state (Sleep, Polling,
> > +				LinkUp, etc)
> > +
> > +		cap_mask:	(RO) Port capability mask
> 
> 2 bits here are settable: IsCommunicationManagementSupported and IsSM.

Hi

Sorry, I don't quite understand this. cap_mask is a read only value which
indicates the supported functions. So the two bits-
IsCommunicationManagementSupported and IsSM, should not be setttable?

Aishwarya

<snip>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
