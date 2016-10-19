From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Wed, 19 Oct 2016 12:51:02 -0700
Message-ID: <12243e3b-87cf-2bd4-d097-1dd0a7907f41@vmware.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <20161019163913.GA30843@infradead.org>
 <6b57d79c-dbd3-cd9b-061e-27a3d3968845@vmware.com>
 <20161019175926.GD29879@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161019175926.GD29879-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 11:59:26AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 19, 2016 at 10:28:36AM -0700, Adit Ranadive wrote:
> 
> > > Requiring installed super updtodate kernel headers isn't going to
> > > help development.  It would be good to keep a copy of the kernel
> > > headers in the rdma-core repo, similar to what most kernel tools
> > > tied to bleeding edge ABIs do.
> > 
> > Thanks for the heads up. I had a few questions regarding the ABI stuff.
> > What happens in case of providers that arent part of the kernel as yet?
> > I would like to send out a pull request soonish for libpvrdma. I would 
> > need to include the abi files in that request since cmake would fail.
> 
> Follow the pattern rxe is using:
> 
> CHECK_INCLUDE_FILE("rdma/rdma_user_rxe.h" HAVE_RDMA_USER_RXE)
> RDMA_DoFixup("${HAVE_RDMA_USER_RXE}" "rdma/rdma_user_rxe.h")
> 
> Which uses the compat header file in
> buildlib/fixup-include/rdma-rdma_user_rxe.h, which must be a
> byte-for-byte copy of the kernel header.

I see that rxe still has a rxe-abi header in the providers/rxe folder.
Would that also move to the kernel as part of the conversion?

One of the things I'm unclear about what happends to the IBV structs
included in the user-level ABI headers, for example, the ibv_get_context_resp
here:
https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx4/mlx4-abi.h#L48

Since these are not present in the kernel, how would the libibverbs/core
uverbs stack handle this? Would there be forthcoming changes for that too?

> > Or do you want me to wait till Doug adds the PVRDMA driver to the tree?
> 
> FWIW, we can't take a rdma-core provider until the kernel side is
> accepted, but you can certainly start the process now and get it to an
> OK state. Doug will be able to take both parts simultaneously.
> 

Makes sense.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
