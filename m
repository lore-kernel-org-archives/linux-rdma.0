From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:41:34 -0600
Message-ID: <20150720224134.GA12278@obsidianresearch.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <20150720222608.GA12005@obsidianresearch.com>
 <73A27338-7EFC-4F54-A15E-09B9D5145242@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <73A27338-7EFC-4F54-A15E-09B9D5145242-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 06:31:11PM -0400, Chuck Lever wrote:
>=20
> On Jul 20, 2015, at 6:26 PM, Jason Gunthorpe <jgunthorpe@obsidianrese=
arch.com> wrote:
>=20
> > On Mon, Jul 20, 2015 at 03:03:11PM -0400, Chuck Lever wrote:
> >> +	iov->length =3D size;
> >> +	iov->lkey =3D ia->ri_have_dma_lkey ?
> >> +				ia->ri_dma_lkey : ia->ri_bind_mem->lkey;
> >> +	rb->rg_size =3D size;
> >> +	rb->rg_owner =3D NULL;
> >> 	return rb;
> >=20
> > There is something odd looking about this..
> >=20
> > ri_bind_mem is only setup in the RPCRDMA_ALLPHYSICAL and
> > RPCRDMA_MTHCAFMR cases.
> >=20
> > RPCRDMA_FRMR doesn't set it up.
> >=20
> > So this code in rpcrdma_alloc_regbuf is never called for the FRMR
> > case?
> >=20
> > If yes, then, how is FRMR working? There is absolutely no reason to
> > use FRMR to register local send buffers, just use the global all
> > memory lkey...
> >=20
> > If no, then that is an oops?
>=20
> I=E2=80=99ve tested this code, no oops.
>=20
> FRWR always uses the DMA lkey. xprtrdma does not use FRWR if
> IB_DEVICE_LOCAL_DMA_LKEY is not asserted.

Ah, I see. Ok.

Is there a reason to link FRWR and LOCAL_DMA_LKEY together? Just use
the code you have for fmr with frwr to get the lkey, probably move it
to rpcrdma_ia_open .. Physical MR should create a 2nd MR dedicated for
rkey use.

That will work really well with the series I'm working on:

https://github.com/jgunthorpe/linux/tree/remove-ib_get_dma_mr

To just drop ib_get_dma_mr entirely.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
