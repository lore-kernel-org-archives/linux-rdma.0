From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Tue, 30 Jun 2015 14:47:00 +0300
Message-ID: <559281B4.6010807@dev.mellanox.co.il>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <1433769339-949-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5C7C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE5C7C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/8/2015 11:49 PM, Hefty, Sean wrote:

Sean,

>
> IMO, we need to introduce vendor specific header files and interfaces.
> It is unmaintainable to drive an API from the bottom up and expose the 'bare metal'
> implementation of a bunch of disjoint pieces of hardware.  (Yeah, because we need yet another way of registering memory...
> just reading the process for a yet another set of hoops that an app must jump through in order to register memory makes my head hurt.)
> Everything about this continual approach needs to end.
>

I think that the related thread on this patchset makes it clear that
there is a fundamental limitation in the RDMA stack where it allows
to register page lists and not generic SG lists. I strongly disagree
that this is an exposure of some bare metal implementation.

Kernel 4.1 introduced the new pmem driver for byte addressable storage
(https://lwn.net/Articles/640115/). It won't be long before we see HA
models where secondary persistent memory devices will sit across an
RDMA fabric. 
(http://www.snia.org/sites/default/files/DougVoigt_RDMA_Requirements_for_HA.pdf)

We cannot afford to work around the stack block alignment limitation
and meet the latency requirements of such fast devices. This means no
bounce-buffering what-so-ever and we need efficient remote access to
multiple byte ranges.

Moreover, this feature also opens fast registration to user-space (i.e.
"user-space FRWR"). user-space cannot use FRWR as it is not exposed to
the memory physical mapping. Indirect registration allows users to
fast register with ibv_sges. HPC applications need efficient access
to remote scatters.

Do we want to live with this limitation forever?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
