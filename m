From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 12:31:32 -0600
Message-ID: <20091020183132.GE14520@obsidianresearch.com>
References: <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9F76F7CD7B9048E8821A1B05CC5FAFE8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 11:08:58AM -0700, Sean Hefty wrote:
> >Looking on kernel cma.c format_hdr code it first branches on the address
> >family and next of the port space.
> >
> >Going with your proposed flow, I understand that an app call to
> >rdma_resolve_addr will be broken down to rdma_bind_addr, ACM resolution
> >of the destination GID and then rdma_set_ib_dest, so things should work
> >perfect for AF_INET / PS_TCP apps, correct?
> 
> This is my current plan for the kernel:
> 
> Export rdma_set_ib_paths to user space.  Submit a patch.  Get it accepted
> upstream.  Eat ice cream to celebrate.
> 
> Define AF_IB and struct sockaddr_ib (contains a gid and service id).  Update
> rdma_bind_addr, rdma_resolve_addr, and rdma_connect to handle AF_IB.
> 
> rdma_bind_addr fills in the service id according RDMA IP CM service
> annex.

Hm? If the sockaddr_ib contains the service ID why override it in the
kernel?

The AF_IB/PS_IB flow in the kernel side must just use straight service
IDs.

This is why I suggested rdma_getaddrinfo - if you specify an address
string that uses IP port notation but rdma_getaddrinfo decides to use
AF_GID/PS_IB then it can create the proper service ID for that port
number and build it into the sockaddr_ib.

Like in IP you'd use rdma_getaddrinfo with hints.flags = AI_PASSIVE to
construct a description for a listening RDMA connection, and it can
construct either a AF_GID with a service ID or AF_IP with the port.

> >> The ACM responds based on a configuration file.  The ib_acme utility can
> >create that file using the active IP, pkey, port information of the system, but
> >the current ACM implementation does not adjust to dynamic changes or detect
> >misconfigurations or other made up words.
> 
> >I see. Does the new flow of librdmacm is going to be under new API, eg
> >rdma_resolve_addr/route_ext  or the same API optionally talking to ACM
> >through some IPC if the ACM daemon is running, or something else?
> 
> I hope we can do this under the existing APIs with an optional ability to use
> ACM, but I like the idea of adding rdma_getaddrinfo.

IHMO, I would much rather see your ACM as part of a rdma_getaddrinfo
API. If you implement the nscd-like unix domain socket then ACM can
completely live outside the main stack as a bolt-on.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
