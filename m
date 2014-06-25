From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 10/13] xprtrdma: Release FRMR segment buffers during
 LOCAL_INV completion
Date: Wed, 25 Jun 2014 09:14:38 -0700
Message-ID: <53AAF56E.7010800@oracle.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623224023.1634.67233.stgit@manet.1015granger.net> <53AA5B72.3010200@oracle.com> <89930B1D-AE3B-48AD-922C-6FCA754D2B01@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <89930B1D-AE3B-48AD-922C-6FCA754D2B01-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 06/25/2014 07:32 AM, Chuck Lever wrote:
> Hi Shirley-
>=20
> On Jun 25, 2014, at 1:17 AM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote=
:
>=20
>> Would it be possible to delay rpcrdma_buffer_put() until LOCAL_INV r=
equest send completion? remove rpcrdma_buffer_put() from xprt_rdma_free=
(), add a call back after LOCAL_INV completed?
>=20
> That=92s exactly what this patch does. The relevant part of
> rpcrdma_buffer_put() is:
>=20
>   list_add(&mw->mw_list, &buf->rb_mws);
>=20
> This is now wrapped with a reference count so that
> rpcrdma_buffer_put() and the LOCAL_INV completion can run in any
> order. The FRMR is added back to the list only after both of those
> two have finished.

What I was thinking is to run rpcrdma_buffer_put after LOCAL_INV comple=
tion without reference count.
=20
> Nothing in xprt_rdma_free() is allowed to sleep, so we can=92t wait f=
or
> LOCAL_INV completion in there.
>=20
> The only alternative I can think of is having rpcrdma_buffer_get() ch=
eck
> fr_state as it removes FRMRs from the rb_mws list. Only if the FRMR i=
s
> marked FRMR_IS_INVALID, rpcrdma_buffer_get() will add it to the
> rpcrdma_req.

I thought about it too, an atomic operation would be better than a lock=
=2E

> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
