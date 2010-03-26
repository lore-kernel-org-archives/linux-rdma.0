From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port	reservation to support AF_IB
Date: Fri, 26 Mar 2010 09:06:56 -0700
Message-ID: <57287E48AAAD47A4BD50719B889F4596@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com> <20100325220435.GP29129@obsidianresearch.com> <C70579E21917462C89AAEAE3C225A58B@amr.corp.intel.com> <FD7DFBFAF86D4EA99F82836CBCA8AB33@amr.corp.intel.com> <20100326040809.GD9769@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100326040809.GD9769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Right :) I just don't understand why you think AF_IB/RDMA_PS_TCP has
>to be a supported combination.

I don't see any reason to prevent it.  It works unless a specific check is added
in the kernel to prevent it.  Do I think it absolutely must be supported?  No -
so I don't have a strong disagreement on this.

It just seems like the code ends up as either:

	if (sa_family == AF_IB) {
		if (ps != PS_IB)
			fail;
		use_ps = get_ps(sid, mask);
	}
or

	if (sa_family == AF_IB) {
		if (get_ps(sid, mask) != ps)
			fail;
		use_ps = ps;
	}

>Is there some use case you see where having RDMA_PS_TCP/UDP work with
>AF_IB is an advantage?

Consider UDP, an application can create an id and join multicast groups using
AF_INET, AF_INET6, and/or AF_IB - whatever addressing scheme is most convenient.

What I have right now for user space support requires application changes to
make use of AF_IB anyway, so only supporting PS_IB isn't a big deal.  The
benefit to existing code is limited to user space path record queries. 

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
