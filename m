From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Wed, 7 Oct 2009 16:42:13 -0700
Message-ID: <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>	 <4ACAF913.3050909@voltaire.com>	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <15ddcffd0910071523w4f229b14j905ad170ceb8c21f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I understand that rdma_bind_address covers the local device and vlan
>resolutions, but I we should also --keep-- supporting also
>applications that use an explicit source address in rdma_resolve_addr
>or that don't do bind, provide src=NULL to resolve_addr and rely on
>the rdma-cm to use route lookup (as the rdma_resolve_addr man page
>indicates) for the device/vlan resolution.

My intent, which differs from Jason's, was to fully support the existing
librdmacm interfaces as they are defined.

Implementation wise, if the user of the librdmacm calls rdma_resolve_addr with a
src address, it's easy.  Without the src address, it's hard, but I may just be
missing some easy interface for finding the src address.

Between the two patches, I'm fine with the change to set the PR and still
looking at ways to handle rdma_resolve_addr.

>> If a user sets the wrong address mapping or route, they should only affect
>themselves
>
>I wasn't sure to follow this comment, can you elaborate a bit more?

I meant that if some bogus app wants to specify an IP to GID mapping that's
invalid, the incorrect mapping should only affect connections for that app.
When used over IB, the IP address is little more than a qualifier contained
within the IB CM REQ private data.

>I assume you was referring rdma_resolve_addr, correct? there should be
>a way to do that from user space and if not, you can go down to the
>kernel, resolve the device/vlan and then call ACM to resolve the
>destination. It seems that you must resolve the dev/vlan for issuing
>the ACM ARP replacement...

Technically, rdma_resolve_addr could remain unchanged, in which case it will do
everything it does today, which may include sending an ARP.  This is the
specific operation that I'd like to avoid.

>I am not sure to fully follow on the easily-change-kernel-drivers
>claim, isn't some change to the kernel rdma-cm being a must for the
>ACM + librdmacm solution to work? suppose you have a way to fully do
>the addr+route resolutions from user space, will the kernel rdma-cm
>state machine will be willing to issue

All of our larger clusters are for production use.  Asking them to install and
use a supported kernel / OFED release is different than me asking them to apply
a patch to the kernel on all systems.

I can somewhat implement an ACM + librdmacm solution entirely in user space by
layering the librdmacm over libibcm.  Because of the event reporting, it would
be limited in how it could be use, and is unlikely to be something that would
ever be supported.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
