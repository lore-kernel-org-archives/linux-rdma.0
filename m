From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 11:08:58 -0700
Message-ID: <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>		<F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>		<4ACAF913.3050909@voltaire.com>		<AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>		<15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>		<9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>		<0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>	<15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ADD8F5F.3010008-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>okay, I just wanted to make sure that the whole thing (ACM + modified
>librdmacm + modifed rdma-cm) is applicable AND inter-operable for
>AF_INET / PS_TCP applications.

I do not intend to have any changes that break anything.

>Looking on kernel cma.c format_hdr code it first branches on the address
>family and next of the port space.
>
>Going with your proposed flow, I understand that an app call to
>rdma_resolve_addr will be broken down to rdma_bind_addr, ACM resolution
>of the destination GID and then rdma_set_ib_dest, so things should work
>perfect for AF_INET / PS_TCP apps, correct?

This is my current plan for the kernel:

Export rdma_set_ib_paths to user space.  Submit a patch.  Get it accepted
upstream.  Eat ice cream to celebrate.

Define AF_IB and struct sockaddr_ib (contains a gid and service id).  Update
rdma_bind_addr, rdma_resolve_addr, and rdma_connect to handle AF_IB.

rdma_bind_addr fills in the service id according RDMA IP CM service annex.
rdma_resolve_addr just needs to save the GIDs.
rdma_connect will not modify the private data in the CM REQ for AF_IB.

For user space:

Initially, ACM support must be specifically built in and enabled using an
environment variable.  If it's enabled, the librdmacm will convert AF_INET and
pass AF_IB to the kernel.  The librdmacm will fall back to normal operation if
ACM fails.

With AF_IB, the flow would probably be something like: rdma_resolve_addr -> ACM
resolution, ucma_resolve_addr, then rdma_resolve_route -> ucma_set_ib_paths.

>The only missing piece here is the route lookup from user space for
>applications not specifying a source address in their rdma_resolve_addr
>invocation, do you still need help to implement that?

This is still missing, and help would be great.

>> The ACM responds based on a configuration file.  The ib_acme utility can
>create that file using the active IP, pkey, port information of the system, but
>the current ACM implementation does not adjust to dynamic changes or detect
>misconfigurations or other made up words.

>I see. Does the new flow of librdmacm is going to be under new API, eg
>rdma_resolve_addr/route_ext  or the same API optionally talking to ACM
>through some IPC if the ACM daemon is running, or something else?

I hope we can do this under the existing APIs with an optional ability to use
ACM, but I like the idea of adding rdma_getaddrinfo.

- Sean 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
