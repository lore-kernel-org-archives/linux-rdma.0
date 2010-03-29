From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 14:51:46 -0500
Message-ID: <4BB104D2.9080309@opengridcomputing.com>
References: <4BB0E670.3010507@opengridcomputing.com> <B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com> <adaiq8fvtos.fsf@roland-alpha.cisco.com> <20100329193715.GA28070@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100329193715.GA28070-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Mon, Mar 29, 2010 at 12:01:07PM -0700, Roland Dreier wrote:
>   
>>  > > The rdma_cm might be able to support this if the port space were separated based
>>  > > on the address family, depending on how PS IB ends up.
>>  > 
>>  > I think separate port spaces is the correct solution.
>>
>> This gets a bit tricky -- for normal IP stuff, there's the "bindv6only"
>> sysctl (and the IPV6_V6ONLY socket option).  Without that, you can't
>> bind an IPv4 socket to the same port as an IPv6 socket, since the IPv6
>> socket will accept IPv4 connections via an v4->v6 mapped address.  (You
>> can look at inet_csk_bind_conflict() to see the full complexity of the
>> checking done when binding an IPv4 socket)
>>     
>
> Yeah, exactly, it is very complex and there is a real need for
> things pretending to be IP to capture all this subtlety. The details
> can't just be skipped over, people will notice :(
>
> Though, I'm also not entirely certain that NFS-RDMA is right to bind
> to both AFs, generally speaking on Linux for a multi-protocol app you
> only want to bind to v6 addresses.. Or is it using IPV6_V6ONLY or alike?
>
>   

This issue is really not in the NFS-RDMA code.  the nfsd code is doing 
the binding.  See commit:


37498292aa97658a5d0a9bb84699ce8c1016bb74
Author: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Tue Jan 26 14:04:22 2010 -0500

    NFSD: Create PF_INET6 listener in write_ports


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
