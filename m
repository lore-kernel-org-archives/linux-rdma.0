From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 15:22:45 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
 <4C618334.7010106@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
 <20100810171405.GM11306@obsidianresearch.com>
 <4C61BF26.9060003@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C61BF26.9060003-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It seems the new API has too many constraints for XRC. There are a couple
> things that don't fit:
> 
> - XRC needs a domain, which must be created before creating the QP, but
> after we know
>   the device to use. In addition it also needs a file descriptor. The
> application may
>   want to use a different fd depending on the device. Currently the domain
> can only
>   be created in the middle of rdma_create_ep().

This looks like a gap in the APIs.  There's no easy way to associate the data returned by rdma_addrinfo to a specific ibv_device.  Part of the issue is that rdma_addrinfo may not have an ai_src_addr.  gurgle...

I agree with Jason that we can still change the newer calls.  In this case, the problem isn't limited to XRC.  The user will have issues just trying to specify the CQs that should be associated with the QP.  Maybe the 'fix' here is to remove rdma_create_qp() from rdma_create_ep() -- which basically replaces that API with rdma_create_id2(**id, *res).

> - The server side of the connection also needs an SRQ. It's not obvious
> whether it's
>   the application or rdma cm to create that SRQ. And that SRQ number must
> be
>   given to the client side, presumably in the private data.

The desired mapping of XRC to the librdmacm isn't clear to me.  For example, after 'connecting' is two-way communication possible (setting up INI/TGT pairs on both nodes), or is a connection only one-way (setup local INI to remote TGT)?  Also, as you point out, how are SRQ values exchanged?  Does private data carry one SRQ value, all SRQ values for remote processes, none?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
