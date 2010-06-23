From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 14:42:43 -0500
Message-ID: <4C2263B3.9010608@opengridcomputing.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com> <ada8w65veq4.fsf@roland-alpha.cisco.com> <4C225078.6050001@opengridcomputing.com> <adar5jxtxho.fsf@roland-alpha.cisco.com> <4C225697.6060702@opengridcomputing.com> <20100623192909.GT4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100623192909.GT4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Wed, Jun 23, 2010 at 01:46:47PM -0500, Steve Wise wrote:
>
>   
>> Yes.  Perusing the drivers/scsi/cxgb3i code I see the iscsi ipaddr is  
>> actually stored in the port_info struct which is hung of the netdev_priv  
>> of the cxgb3 device.  It is set by cxgb3i_host_set_param() which is part  
>> of the iscsi transport interface.
>>     
>
> I wonder how does neighbor discovery, routing, etc work with iscsi?
>
>   

For cxgb3i:

ND is handled by initiating ND via exported kernel services 
(neigh_event_send()) and registering for NETEVENT_NEIGH_UPDATE net 
events to get updated neigh entries.

The host routing table is consulted via ip_route_output_flow() to map a 
destination ip address to a local netdev, and then if that device is T3, 
it will do the iscsi offload.



>> I just think the customer looses when we add iwarp-specific tools,  
>> ipaddrs, subnets, etc etc.  And what about software iwarp?  Will it use  
>> the host stack tools and not these new tools?  So then we end up with 2  
>> sets of tools for iwarp devices. :(
>>     
>
> Well, maybe you can get netdev to agree on some way to create an
> interface that has all the IP services, but no TCP protocol binding?
> Then the configuration could be largely the same. If you could share
> that with the iscsi world then maybe it isn't so bad?
>   


Maybe.  I fear this will meet the same resistance from the netdev folks.


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
