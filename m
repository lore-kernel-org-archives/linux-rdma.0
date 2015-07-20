From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 18:31:11 -0400
Message-ID: <73A27338-7EFC-4F54-A15E-09B9D5145242@oracle.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190311.10997.12636.stgit@manet.1015granger.net> <20150720222608.GA12005@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720222608.GA12005-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 20, 2015, at 6:26 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Mon, Jul 20, 2015 at 03:03:11PM -0400, Chuck Lever wrote:
>> +	iov->length =3D size;
>> +	iov->lkey =3D ia->ri_have_dma_lkey ?
>> +				ia->ri_dma_lkey : ia->ri_bind_mem->lkey;
>> +	rb->rg_size =3D size;
>> +	rb->rg_owner =3D NULL;
>> 	return rb;
>=20
> There is something odd looking about this..
>=20
> ri_bind_mem is only setup in the RPCRDMA_ALLPHYSICAL and
> RPCRDMA_MTHCAFMR cases.
>=20
> RPCRDMA_FRMR doesn't set it up.
>=20
> So this code in rpcrdma_alloc_regbuf is never called for the FRMR
> case?
>=20
> If yes, then, how is FRMR working? There is absolutely no reason to
> use FRMR to register local send buffers, just use the global all
> memory lkey...
>=20
> If no, then that is an oops?

I=92ve tested this code, no oops.

=46RWR always uses the DMA lkey. xprtrdma does not use FRWR if
IB_DEVICE_LOCAL_DMA_LKEY is not asserted.

=46MR and PHYSICAL use the DMA lkey if it exists, otherwise they
use an lkey from ib_get_dma_mr.

Look in 06/15, this is cleaned up.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
