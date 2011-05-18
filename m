From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 17:30:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373FBC7@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com>
 <20110518170226.GA2595@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110518170226.GA2595-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> As long as the version number in the ibv_context is increasing and not
> branching then I think it is OK. 0 = what we have now. 1 = + XRC, 2 =
> +XRC+ummunotify, etc. Drivers 0 out the function pointers they do not
> support.

I was thinking more along this line, but I can see how using a named extension could be useful for OFED or vendor specific extensions that aren't part of the upstream libibverbs.  (Whether _that_ is useful is another matter, but it seems to be the world that we're in anyway.)

I'm not familiar with OpenGL, so I'll take a look at it.  (The concept sounds similar to Window's COM interfaces.)

Beyond the interfaces, are there any thoughts on how to handle structure changes, such as:

	struct ibv_xrc_send_wr {
		struct ibv_send_wr wr;
		uint32_t remote_qpn;
	};

?  Do we want to use the existing ibv_post_send() call, or add a new ibv_post_xrc_send() routine specifically for this purpose (and simplify the above definition)?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
