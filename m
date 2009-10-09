From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 8 Oct 2009 17:24:48 -0700
Message-ID: <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>	 <4ACAF913.3050909@voltaire.com>	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>	 <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>	 <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>	 <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <15ddcffd0910081633q20d98abfg41a9f4e781e486b1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>However, I don't manage to follow on your port space discussion with
>Jason. Some apps may have client in user space and server in the
>kernel or vise versa. I wouldn't tie PS_IB or a like with ACM. The ACM
>ARP replacement protocol will reply only if the ip address specified
>in the broadcast request is an ip of this host on that pkey and a port
>connected to that fabric, correct?

Nothing in any of this would require the use of a specific method for path
resolution.  The rdma_resolve_route() API does not impose any such limitation.
The problem is that the kernel implementation does.  The purpose of these
patches is to allow user space to perform the resolution using whatever
mechanism it chooses, and convey that to the kernel.  rdma_resolve_addr() is
similar.  Basically treat any mention of ACM in this discussion as an example.

>From the perspective of IB, the RDMA CM simply defines a specific format to
private data and service ID carried in the IB CM REQ.  As long as any use
adheres to that protocol, interoperability won't be an issue.

If an application uses RDMA_PS_TCP, they would expect a 16-bit port number
mapped appropriately to the 64-bit service id.  The concept of adding RDMA_PS_IB
would be to expose the full 64-bit service id.  Essentially, the RDMA CM
interface would become capable of connecting to any IB application.  (I really
haven't thought through the details yet, and the addition of RDMA_PS_IB
shouldn't be part of the initial patch submission.)

As for your ACM specific questions - the ACM responds based on a configuration
file.  The ib_acme utility can create that file using the active IP, pkey, port
information of the system, but the current ACM implementation does not adjust to
dynamic changes or detect misconfigurations or other made up words.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
