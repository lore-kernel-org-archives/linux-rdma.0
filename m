From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
Date: Wed, 22 Jul 2015 18:41:27 +0300
Message-ID: <55AFB9A7.4030103@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-38-git-send-email-sagig@mellanox.com>
 <795F4F28-D92F-46A1-8DA3-2B1B19A17AA3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <795F4F28-D92F-46A1-8DA3-2B1B19A17AA3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> +	for (i =3D 0; i < nsegs;) {
>> +		sg_set_page(&frmr->sg[i], seg->mr_page,
>> +			    seg->mr_len, offset_in_page(seg->mr_offset));
>
> Cautionary note: here we=92re dealing with both the =93contiguous
> set of pages=94 case and the =93small region of bytes in a single pag=
e=94
> case. See rpcrdma_convert_iovs(): sometimes RPC send or receive
> buffers can be registered (RDMA_NOMSG).

I noticed that (I think). I think this is handled correctly.
What exactly is the caution note here?

>> 	mr =3D frmr->fr_mr;
>> +	access =3D writing ? IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRIT=
E :
>> +			   IB_ACCESS_REMOTE_READ;
>> +	rc =3D ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, access);
>
> I like this (and the matching ib_dma_unmap_sg). But why wouldn=92t
> this function be called ib_dma_map_sg() ? The name ib_map_mr_sg()
> had me thinking for a moment that this API actually posted the
> FASTREG WR, but I see that it doesn=92t.

Umm, ib_dma_map_sg is already taken :)

This is what I came up with, it maps the SG elements to the MR
private context.

I'd like to keep the post API for now. It will be possible to
to add a wrapper function that would do:
- dma_map_sg
- ib_map_mr_sg
- init fastreg send_wr
- post_send (maybe)


>> -	while (seg1->mr_nsegs--)
>> -		rpcrdma_unmap_one(ia->ri_device, seg++);
>> +	ib_dma_unmap_sg(ia->ri_device, frmr->sg, frmr->sg_nents, seg1->mr_=
dir);
>
> ->mr_dir was previously set by rpcrdma_map_one(), which you=92ve repl=
aced
> with ib_map_mr_sg(). So maybe frwr_op_map() needs to save =93directio=
n=94
> in the rpcrdma_frmr.

Yep, that's correct, if I had turned on dma mapping debug it would shou=
t
at me here...

Note, I added in the git repo a patch to allow arbitrary sg lists in
frwr_op_map() which would allow you to skip the holes check... seems to
work with mlx5...

I did noticed the mlx4 gives a protection error with after the=20
conversion... I'll look into that...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
