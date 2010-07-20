From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Tue, 20 Jul 2010 14:57:46 -0600
Message-ID: <20100720205746.GL7920@obsidianresearch.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com> <20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com> <4C45E701.7030501@opengridcomputing.com> <20100720184620.GJ7920@obsidianresearch.com> <4C45F6F5.6050008@opengridcomputing.com> <20100720203044.GK7920@obsidianresearch.com> <4C460BFD.5010707@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C460BFD.5010707-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 20, 2010 at 03:50:05PM -0500, Steve Wise wrote:

>> I think if RDMACM manages the dst and lets the devices access it then
>> all the existing netdev infrastructure for poking at a dst should be
>> available to the device?
>
> Yes. But I'm not sure exactly how the logic I described previous for  
> cxgb* would be handled in the design being ironed out here.

I'm thinking something like this..

- The RDMA CM gets the dst from its route lookup locks it and stores
  it.
- Instead of doing a route lookup cxgb gets the dst from RDMA CM,
  locks it and stores it
- RDMA CM traps all notifications/etc and generates callback to cxgb
  to say the dst has changed.
- cxgb releases the old dst and grabs the new one, updates the HW,
  etc.

Basically the same as what you have now, but all the logic to find
and monitor the dst moves to RDMA CM..

redirects/etc are all handled by netdev/rdma cm and just generate the
same 'dst has changed' call back to cxgb..

Or's user space notification stuff hooks the same callback to generate
a notification to userspace about the new dst.

All the stuff you do now with the dst you can keep doing, you just
remove all the route lookup and netdev hooking to get the dst from
RDMA CM.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
