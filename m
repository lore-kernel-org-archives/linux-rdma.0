From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IPoIB CM connection establishment protocol question
Date: Wed, 25 Aug 2010 14:45:32 +0300
Message-ID: <20100825114532.GA19968@mtldesk30>
References: <3F6F638B8D880340AB536D29CD4C1E1925AC41133A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1925AC41133A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi stan,

Here's a short summary:
An IPoIB interface encodes it capability of supporting CM mode in the
hardware adress it publishes. Once the stack hands an SKB to IPoIB for
transmission (unicast), IPoIB needs to resolve the hardware address to
IB adress information (LID, SL etc.). Once resolution is complete, it
will create a RC connection with the other host using IB CM. This
process is symetrical - that is, for two communicating hosts there are
two RC connections so that each connection works half duplex.

Hope that helps.

On Thu, Aug 05, 2010 at 10:25:27AM -0700, Smith, Stan wrote:
> 
> Could someone who is OFED IPoIB knowledgeable help me understand which IPoIB side starts the RC connection establishment (Tx REQ) to an ARP unknown remote host?
> 
> I tried reading the Linux IPoIB code and realized it's been too many years since writing Linux network drivers (2001) and found myself lost in the bits w.r.t. CM connection mgmt. and ARP handling.
> 
> >From limited observation, it looks like the ACTIVE side (ttcp -t) of an IPoIB network connection broadcasts an IB ARP-REQ which indicates CM capability in the IB ARP flags byte.
> 
> When the PASSIVE IPoIB (ttcp -r) receives the IB ARP-REQ, it sends back an IB ARP-REPLY which indicates it's CM capability among other items.
> 
> Now the confusing part: which IPoIB CM side starts the CM-RC connection establishment?
> 
> Does the PASSIVE IPoIB start the RC connection (Tx REQ) prior to sending the IB ARP-REPLY?
> 
> Or does the ACTIVE IPoIB side receive the IB ARP-REPLY and then start an ACTIVE RC connection (Tx REQ) now that it knows the remote side is CM capable?
> 
> thanks,
> 
> stan.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
