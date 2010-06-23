From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 15:11:27 -0500
Message-ID: <4C226A6F.4000801@opengridcomputing.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com> <ada8w65veq4.fsf@roland-alpha.cisco.com> <4C225078.6050001@opengridcomputing.com> <adar5jxtxho.fsf@roland-alpha.cisco.com> <4C225697.6060702@opengridcomputing.com> <20100623192909.GT4630@obsidianresearch.com> <4C2263B3.9010608@opengridcomputing.com> <20100623195210.GU4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100623195210.GU4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Wed, Jun 23, 2010 at 02:42:43PM -0500, Steve Wise wrote:
>   
>>> I wonder how does neighbor discovery, routing, etc work with iscsi?
>>>       
>> For cxgb3i:
>>
>> ND is handled by initiating ND via exported kernel services  
>> (neigh_event_send()) and registering for NETEVENT_NEIGH_UPDATE net  
>> events to get updated neigh entries.
>>
>> The host routing table is consulted via ip_route_output_flow() to map a  
>> destination ip address to a local netdev, and then if that device is T3,  
>> it will do the iscsi offload.
>>     
>
> That is what RDMA does.. So that means that the IP used for iscsi is
> actually an IP assigned to the interface?
>
>   

The IP address assigned for the cxgb3i iscsi device is _not_ assigned to 
a netdev interface via ifconfig, as far as I understand it (by looking 
at the cxgb3i code).  So the host stack doesn't know about this 
address.  There is an administrative requirement, I assume, that the 
secret iscsi ipaddr is within a subnet that is bound to the T3 ethX 
interface.  Otherwise the routing lookup wouldn't work.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
