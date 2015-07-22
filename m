From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
Date: Wed, 22 Jul 2015 12:04:19 -0400
Message-ID: <5114D0F0-7C66-4889-85D8-E7297009AF23@oracle.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-38-git-send-email-sagig@mellanox.com> <795F4F28-D92F-46A1-8DA3-2B1B19A17AA3@oracle.com> <55AFB9A7.4030103@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AFB9A7.4030103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 22, 2015, at 11:41 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> =
wrote:

>=20
>>> +	for (i =3D 0; i < nsegs;) {
>>> +		sg_set_page(&frmr->sg[i], seg->mr_page,
>>> +			    seg->mr_len, offset_in_page(seg->mr_offset));
>>=20
>> Cautionary note: here we=92re dealing with both the =93contiguous
>> set of pages=94 case and the =93small region of bytes in a single pa=
ge=94
>> case. See rpcrdma_convert_iovs(): sometimes RPC send or receive
>> buffers can be registered (RDMA_NOMSG).
>=20
> I noticed that (I think). I think this is handled correctly.
> What exactly is the caution note here?

Well the sg is turned into a page list below your API. Just
want to make sure that we have tested your xprtrdma alterations
with all the ULP possibilities. When you are further along I
can pull this and run my functional tests.


>>> 	mr =3D frmr->fr_mr;
>>> +	access =3D writing ? IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRI=
TE :
>>> +			   IB_ACCESS_REMOTE_READ;
>>> +	rc =3D ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, access);
>>=20
>> I like this (and the matching ib_dma_unmap_sg). But why wouldn=92t
>> this function be called ib_dma_map_sg() ? The name ib_map_mr_sg()
>> had me thinking for a moment that this API actually posted the
>> FASTREG WR, but I see that it doesn=92t.
>=20
> Umm, ib_dma_map_sg is already taken :)
>=20
> This is what I came up with, it maps the SG elements to the MR
> private context.
>=20
> I'd like to keep the post API for now. It will be possible to
> to add a wrapper function that would do:
> - dma_map_sg
> - ib_map_mr_sg
> - init fastreg send_wr
> - post_send (maybe)

Where xprtrdma might improve is by setting up all the FASTREG
WRs for one RPC with a single chain and post_send. We could do
that with your INDIR_MR concept, for example.


>>> -	while (seg1->mr_nsegs--)
>>> -		rpcrdma_unmap_one(ia->ri_device, seg++);
>>> +	ib_dma_unmap_sg(ia->ri_device, frmr->sg, frmr->sg_nents, seg1->mr=
_dir);
>>=20
>> ->mr_dir was previously set by rpcrdma_map_one(), which you=92ve rep=
laced
>> with ib_map_mr_sg(). So maybe frwr_op_map() needs to save =93directi=
on=94
>> in the rpcrdma_frmr.
>=20
> Yep, that's correct, if I had turned on dma mapping debug it would sh=
out
> at me here...
>=20
> Note, I added in the git repo a patch to allow arbitrary sg lists in
> frwr_op_map() which would allow you to skip the holes check... seems =
to
> work with mlx5...
>=20
> I did noticed the mlx4 gives a protection error with after the conver=
sion... I'll look into that...

Should also get Steve and Devesh to try this with their adapters.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
