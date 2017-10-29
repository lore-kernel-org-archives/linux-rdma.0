From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Sun, 29 Oct 2017 21:11:14 +0200
Message-ID: <20171029191114.GO16127@mtr-leonro.local>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jJVMc5+FiwMz9o91"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jJVMc5+FiwMz9o91
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2017 at 12:17:18PM -0500, Chris Blake wrote:
> Hello linux-rmda,
>
> I recently upgraded one of my boxes to 4.13, and have started
> experiencing issues with ib_mthca. To start, my setup is Infiniband
> direct between 2 servers using older Mellanox Technologies MT25208
> cards for ipoib as well as NFS over RDMA. After upgrading, the
> following has been experienced:
>
> 1. On my NAS host running OpenSM, as soon as it starts I get a NULL
> pointer dereference which makes infiniband unusable. [0] This only
> occurs on kernel 4.13 or newer.
>
> 2. On my compute host not running OpenSM, connectivity works for a bit
> but shortly after dmesg is full of the following message:
> infiniband mthca0: ib_post_send_mad error
> This occurs when my compute host is on kernel 4.13 or newer.
>
> I went ahead and tested some mainline kernel versions on both of my
> nodes, and here are my findings:
> 4.13.8 = NULL pointer dereference on NAS, IPoIB not working
> 4.12.14 = Works as expected
> 4.14.0-rc5 = NULL pointer dereference on NAS, IPoIB not working
>
> I have tried to see if I could find the patch responsible for this,
> but sadly I have not had much luck.
>
> As for my systems, the following modules are loaded:
> ib_uverbs
> ib_umad
> rdma_ucm
> ib_mthca
> ib_ipoib
>
> Let me know if there is anything I can test to help diagnose what is
> causing this issue.

Do you have CONFIG_SECURITY_INFINIBAND in your .config?

Thanks

>
> Regards,
> Chris Blake
>
> [0]: https://gist.github.com/riptidewave93/48595b8bc3bca669251db7d8a8e8a803
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jJVMc5+FiwMz9o91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln2J9IACgkQ5GN7iDZy
WKcgQxAAyYq4wMmq2lfd2m7jXXeeepBHzSTecTGUkykvFIoO+X/RRLN8/Qt8zpV6
4Ei2i1xhKoF91PPMO7jHn/NU/7LLHQNrm4k40G/7xs1g9FwZkhYq5TmssS0I4mQ/
rH3xjRdaXp1VDuYlv/26TCY2gH6efBKxRjJXxecwN6f5rkEXM48RuAUjkfY+Yc8u
GhUWnolOzTsaSleHLWM/hDTvl/ORxt+lGO8RkBVo5ofxSucWwfrkmGC/Gewwm3F9
fWi1GiMFrJSzB47nZkwyKhG49qAttkmqY8IpM3QHi5o0GQtdNK3kZeX5LFQaqv4u
ThMl/0xy2ikfnFxWc3uptgECmpIrl0lcvRtyUuXAH0tkqMVuYk9zgVWrzXNP5EhU
E7fUE7DDO1u5KHAPm0J9MuEJJCO0GhpPjhr9tNok/d5JHQqIJ23P+TDc8QYdl7Ps
ImW2IOAkVFEkQ3aAndLVT1BOivwR5u3ENF/Ks33DgWRmejvRC7UrVsFsaGHiQSAn
+EuE8SCraJQGEmfAKtl12c4H8cDeSnqoviETt58qtCbqjqh9K1vB6zzBAnv0Ia33
OYVixahL/VHt977Z7PCTOjwxkWnHzQQ6oOkWN6B5wU9k6GsAxn6t27Ftm3V5agF0
snHRUKUp0lf83TqM+MsiiD0U5111JsMcUggAKFTC+Dm10e/NVJo=
=IiLg
-----END PGP SIGNATURE-----

--jJVMc5+FiwMz9o91--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
