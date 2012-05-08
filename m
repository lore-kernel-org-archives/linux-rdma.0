From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] net/mlx4_core: change bitmap allocator to
 work in round-robin fashion
Date: Tue, 8 May 2012 11:46:55 -0700
Message-ID: <CAL1RGDXYeGZCWty5ysfOTD_yYaSJb+FCGsDyG3P7pszDnG43tQ@mail.gmail.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com> <1335708267-30284-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> --- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
> @@ -124,7 +124,6 @@ void mlx4_bitmap_free_range(struct mlx4_bitmap *b=
itmap, u32 obj, int cnt)
>
> =A0 =A0 =A0 =A0spin_lock(&bitmap->lock);
> =A0 =A0 =A0 =A0bitmap_clear(bitmap->table, obj, cnt);
> - =A0 =A0 =A0 bitmap->last =3D min(bitmap->last, obj);
> =A0 =A0 =A0 =A0bitmap->top =3D (bitmap->top + bitmap->max + bitmap->r=
eserved_top)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& bitmap->mask;
> =A0 =A0 =A0 =A0bitmap->avail +=3D cnt;

I think this mostly makes sense, although the explanation doesn't quite
make sense.

However I think it would also make sense to get rid of changing the
bitmap->top value here when freeing.  Then we would really go
round-robin, and only bump bitmap->top each time we wrap around
during allocation.

Does that make sense to you?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
