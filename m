From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 12:22:23 +0200
Message-ID: <4ADD8F5F.3010008@voltaire.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>		<F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>		<4ACAF913.3050909@voltaire.com>		<AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>		<15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>		<9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>		<0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>	<15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <859D79BFCA4741F393AABF76BBCA4F7B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> From the perspective of IB, the RDMA CM simply defines a specific format to private data and service ID carried in the IB CM REQ.  As long as any use adheres to that protocol, interoperability won't be an issue.
okay, I just wanted to make sure that the whole thing (ACM + modified 
librdmacm + modifed rdma-cm) is applicable AND inter-operable for 
AF_INET / PS_TCP applications.
Looking on kernel cma.c format_hdr code it first branches on the address 
family and next of the port space.

Going with your proposed flow, I understand that an app call to 
rdma_resolve_addr will be broken down to rdma_bind_addr, ACM resolution 
of the destination GID and then rdma_set_ib_dest, so things should work 
perfect for AF_INET / PS_TCP apps, correct?

The only missing piece here is the route lookup from user space for 
applications not specifying a source address in their rdma_resolve_addr 
invocation, do you still need help to implement that?

> Essentially, the RDMA CM interface would become capable of connecting to any IB application.  (I really haven't thought through the details yet, and the addition of RDMA_PS_IB shouldn't be part of the initial patch submission.)

fair-enough, I just wanted to make sure with you that AF_IB / PS_IB 
aren't tightly coupled with the proposed change and you have clarified that.

> The ACM responds based on a configuration file.  The ib_acme utility can create that file using the active IP, pkey, port information of the system, but the current ACM implementation does not adjust to dynamic changes or detect misconfigurations or other made up words.
I see. Does the new flow of librdmacm is going to be under new API, eg 
rdma_resolve_addr/route_ext  or the same API optionally talking to ACM 
through some IPC if the ACM daemon is running, or something else?

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
