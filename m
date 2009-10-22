From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 22 Oct 2009 12:14:03 -0700
Message-ID: <9574E625AB3C48E6A7DF1A2760882363@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>		<F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>		<4ACAF913.3050909@voltaire.com>		<AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>		<15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>		<9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>		<0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>	<15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com>	<859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com>	<4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <4AE07D41.7040300@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AE07D41.7040300-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I really tried to follow the thread between you and Jason with quite
>little success, and I am going to give it more tries... in parallel,
>could you help me understand what is the --drive/reasoning-- from your
>perspective to add AF_IB / PS_IB here?

These are the things done today in the kernel wrt IB:

* Map a local or remote IP address to a GID.
* If a local address is not given, provide a usable address
  based on the destination address.
* Acquire a path between the source and destination.
* Format the first 36 bytes of private data in the CM REQ.

Any or all of these could be done in user space instead.  Adding AF_IB to the
kernel can provide a clean way of enabling this.  It can also allow full support
of IB CM functionality through the RDMA CM interfaces.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
