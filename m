From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 20:30:53 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601DF1@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
 <4C618334.7010106@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
 <20100810171405.GM11306@obsidianresearch.com>
 <4C61BF26.9060003@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com>
 <20100811231017.GD10271@obsidianresearch.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601D3C@orsmsx501.amr.corp.intel.com>
 <20100812015531.GA22548@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100812015531.GA22548-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Even so, the point of passing it into rdma_getaddrinfo is to restrict
> the device rdma_getaddrinfo selects, it doesn't matter that you can get
> back to the PD from the addrinfo if that PD doesn't have the resources
> you need attached to it. Again, I'm thinking from the app perspective
> where juggling multiple PDs isn't really done, and thus multiple
> connections on different HCAs are not supported by the app. This model
> should be supportable without introducing random failures when
> rdma_getaddrinfo returns things that use other devices.

But why select the PD as the restriction, rather than just the device?

If rdma_getaddrinfo calls into a service to obtain some of its information, then at some point an address must be sufficient.  What about just passing in a device guid as the ai_src_addr?

or, I guess we could add the device to rdma_getaddrinfo:

rdma_getaddrinfo(struct ibv_context *verbs, char *node, char *service,
		struct rdma_addrinfo *hints, struct rdma_addrinfo **res);

>  - Create the TGT QP on the initiator side and pass its info in the
>    private message and do a double QP setup. More complex - does
>    rdmacm provide hooks to do this?

I thought about this as well.  The librdmacm could steal more of the private data for this - just giving less to the user when connecting using XRC.  Right now, the rdma_cm doesn't provide anything to help connect XRC QPs, so we can do what makes the most sense.  I still don't know how the apps exchange SRQs, which is really part of the entire connection process...

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
