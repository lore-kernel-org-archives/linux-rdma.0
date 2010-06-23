From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 13:52:10 -0600
Message-ID: <20100623195210.GU4630@obsidianresearch.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com> <ada8w65veq4.fsf@roland-alpha.cisco.com> <4C225078.6050001@opengridcomputing.com> <adar5jxtxho.fsf@roland-alpha.cisco.com> <4C225697.6060702@opengridcomputing.com> <20100623192909.GT4630@obsidianresearch.com> <4C2263B3.9010608@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2263B3.9010608-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 23, 2010 at 02:42:43PM -0500, Steve Wise wrote:
>> I wonder how does neighbor discovery, routing, etc work with iscsi?
>
> For cxgb3i:
>
> ND is handled by initiating ND via exported kernel services  
> (neigh_event_send()) and registering for NETEVENT_NEIGH_UPDATE net  
> events to get updated neigh entries.
>
> The host routing table is consulted via ip_route_output_flow() to map a  
> destination ip address to a local netdev, and then if that device is T3,  
> it will do the iscsi offload.

That is what RDMA does.. So that means that the IP used for iscsi is
actually an IP assigned to the interface? Doesn't that mean the port
collision problem still exits, although probably less likely?

>> Well, maybe you can get netdev to agree on some way to create an
>> interface that has all the IP services, but no TCP protocol binding?
>> Then the configuration could be largely the same. If you could share
>> that with the iscsi world then maybe it isn't so bad?

> Maybe.  I fear this will meet the same resistance from the netdev folks.

Hmm.. It kinds codifies what is already in the kernel, these offload
devices rely on neighbour and routing services from netdev and provide
their own TCP on top of it...

But.. having a device that effectively swaps the entire TCP
implementation for a proprietary version is not going to be popular
either.

At the very least, bringing iSCSI offload NICs into your solution
broadens the applicability.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
