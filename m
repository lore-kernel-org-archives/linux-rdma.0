From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] net/mlx4_core: change bitmap allocator to work in round-robin fashion
Date: Wed, 9 May 2012 16:04:32 +0300
Message-ID: <201205091604.33167.jackm@dev.mellanox.co.il>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com> <1335708267-30284-4-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXYeGZCWty5ysfOTD_yYaSJb+FCGsDyG3P7pszDnG43tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXYeGZCWty5ysfOTD_yYaSJb+FCGsDyG3P7pszDnG43tQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday 08 May 2012 21:46, Roland Dreier wrote:
> > --- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
> > @@ -124,7 +124,6 @@ void mlx4_bitmap_free_range(struct mlx4_bitmap =
*bitmap, u32 obj, int cnt)
> >
> > =A0 =A0 =A0 =A0spin_lock(&bitmap->lock);
> > =A0 =A0 =A0 =A0bitmap_clear(bitmap->table, obj, cnt);
> > - =A0 =A0 =A0 bitmap->last =3D min(bitmap->last, obj);
> > =A0 =A0 =A0 =A0bitmap->top =3D (bitmap->top + bitmap->max + bitmap-=
>reserved_top)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& bitmap->mask;
> > =A0 =A0 =A0 =A0bitmap->avail +=3D cnt;
>=20
> I think this mostly makes sense, although the explanation doesn't qui=
te
> make sense.
>=20
> However I think it would also make sense to get rid of changing the
> bitmap->top value here when freeing.  Then we would really go
> round-robin, and only bump bitmap->top each time we wrap around
> during allocation.
>=20
> Does that make sense to you?

It does make sense.  Very good catch!  If we also get rid of the bitmap=
_top
modification in mlx4_bitmap_free_range(), then it will be a VERY long t=
ime
before resource numbers repeat. This can only be a good thing.

You are correct that if we do not immediately re-use resource numbers,
then incrementing bitmap_top is only really needed/desirable per wrap-a=
round of the
bitmap.

-Jack
>=20
>  - R.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
