From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem running rping over Intel adapters
Date: Thu, 04 Oct 2012 10:08:48 -0500
Message-ID: <506DA680.5080706@opengridcomputing.com>
References: <506CB0E9.90201@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E58@FMSMSX151.amr.corp.intel.com> <506CB4D8.4010604@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E8E@FMSMSX151.amr.corp.intel.com> <506CEAC1.9070808@opengridcomputing.com> <506D2174.10601@mellanox.com> <506D9CD2.20606@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A8237346A99126@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A99126-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/4/2012 10:01 AM, Hefty, Sean wrote:
>> retry_count, I assume, is for connection establishment?  For the Chelsio
>> devices, this is all up to the TCP stack and thus this counter is not
>> used.  If there is no TCP listener, then the connection establishment
>> will fail immediately.  If the node is not reachable, then normal TCP
>> retransmit rules apply, but once TCP gives up, then the rdma connection
>> establishment will fail.
> On IB, this is a transport level retry of a lost request.
Ah, ok.  Regardless, TCP handles all that for IWARP and we currently 
don't provide the rdma application any way to manipulate the TCP behavior.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
