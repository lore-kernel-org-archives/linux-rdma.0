From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 13:46:47 -0500
Message-ID: <4C225697.6060702@opengridcomputing.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com>	<ada8w65veq4.fsf@roland-alpha.cisco.com>	<4C225078.6050001@opengridcomputing.com> <adar5jxtxho.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adar5jxtxho.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > Roland, do you think the iSCSI approach is a "good design" for iWARP
>  > devices?
>
> Well, it's a different problem since as I said the port collision
> problem is a non-issue for iSCSI anyway.  But yes having a separate
> interface to assign an iWARP IP address to an RNIC does seem to avoid
> the immediate problem.
>
> I actually don't know what the right answer is -- having a separate IP
> address for iWARP does seem to lead to having to duplicate everything
> for configuring it.  (And this is the approach for the cxgb[34] iSCSI
> drivers, right?)
>
>   

Yes.  Perusing the drivers/scsi/cxgb3i code I see the iscsi ipaddr is 
actually stored in the port_info struct which is hung of the netdev_priv 
of the cxgb3 device.  It is set by cxgb3i_host_set_param() which is part 
of the iscsi transport interface.

I just think the customer looses when we add iwarp-specific tools, 
ipaddrs, subnets, etc etc.  And what about software iwarp?  Will it use 
the host stack tools and not these new tools?  So then we end up with 2 
sets of tools for iwarp devices. :(


> On the other hand trying to hook offloaded iWARP into the normal stack
> does seem to lead to a mess.  I see DaveM's point: TCP port space is
> just the beginning -- filtering, queueing, etc also have config that
> ultimately an offload device would want to hook too.
>
> Maybe the sanest out of a bad set of options would be to come up with a
> standard way to configure independent TCP/IP stacks that share a link.
>
> really, dunno.
>
>  - R.
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
