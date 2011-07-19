From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/7] libmlx4: add IBoE support
Date: Tue, 19 Jul 2011 22:34:08 +0300
Message-ID: <CAJZOPZ+NX90F4edjWJitF5vkW1uUqZaYEG1aMs4pnRaRKxFqcQ@mail.gmail.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1107191231540.5580@ogerlitz.voltaire.com>
	<20110719164906.GA18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110719164906.GA18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> Modify libmlx4 to support IBoE, where the only user space piece
>> to handle is the creation of UD address handles - the L2 Ethernet
>> attributes have to be resolved from the DGID.

> Other than rejecting some GIDs it doesn't seem like there is any
> operational need to learn the link type..

Jason, as the change log explains, under Ethernet link type the code
(see mlx4_resolve_grh_to_l2) goes and extracts the Ethernet L2 info
(mac and vlan, look on the last patch) from the GID.

> It seems a shame to add a kernel syscall to every ah creation just to learn the link type

AH creation is app's slow path, e.g the equivalent of session
creation, so I wouldn't bother too much on perf, on the being elegant
side, I'll check if/how I can plant/cache the link type for the ah
creation code to use.

> Also, did anyone document the GID format for IBoE? IIRC we invented
> this for Linux since IBA refused to standardize anything.

Not really, maybe we can/should add a document to the kernel IB
documentation folder with some details - as this data is more for deep
divers -  the thing is that applications that use the rdma-cm don't
deal directly with the GIDs, they just get it from the kernel and hand
it over to libibverbs (e.g UD apps use address / route resolution and
then call ah create, RC apps even don't have to call libibiverbs, as
the qp modifications go beyond the cover of librdmacm calling
libibverbs).

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
