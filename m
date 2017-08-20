From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Possible race in mlx5_ib.ko
Date: Sun, 20 Aug 2017 13:15:48 +0300
Message-ID: <20170820101548.GA1724@mtr-leonro.local>
References: <64936cc7-12b2-3a8f-b6dc-54f6f7cf7d6a@ispras.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <64936cc7-12b2-3a8f-b6dc-54f6f7cf7d6a-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anton Volkov <avolkov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org, Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 18, 2017 at 06:17:15PM +0300, Anton Volkov wrote:
> Hello.
>
> While searching for races in the Linux kernel I've come across
> "drivers/infiniband/hw/mlx5/mlx5_ib.ko" module. Here are questions that I
> came up with while analyzing results. Lines are given using the info from
> Linux v4.12.
>
> Consider the following case:
>
> Thread 1:              Thread 2:
> size_write
> ->remove_keys          limit_write
>     ent->cur--;          if (ent->cur < ent->limit)
>     (mr.c: line 234)     (mr.c: line 335)
>                             err = add_keys(... ent->limit - ent->cur);
>
> If size_write and limit_write are able to work concurrently with the same
> ent then there is a possibility of a race between the accesses to ent->cur.
> In worst case in limit_write new keys wouldn't be added. Is it feasible from
> your point of view? If so, is it a benign race or a serious one?

Technically yes, it can race, but it gives a little value to protect
the ent->check with lock, because the limit_eize instruction is triggered
by debugfs write and is used for the debug.

Thanks

>
> Thank you for your time.
>
> -- Anton Volkov
> Linux Verification Center, ISPRAS
> web: http://linuxtesting.org
> e-mail: avolkov-ufN2psIa012HXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmZYVQACgkQ5GN7iDZy
WKeOzA/9Gm7PSLmbmLsiDik5T7gP30Uau5WZLVwZ47ZsOa+nSWB6M1TmLPz8S/3m
r5KKMGHCDbWROm4bm3D7EOEppApjG6Hd/r9523EhyMlFckDvbAI6U9Pfx8G6et0F
qcgRK2bNDrd/VgCq51pi+lAwe1GyVBsmDSq80Ig/zdLUeZcRn6LMeDebS1fHmhfK
I0Hg/kilA3+tri1LjPbTqBJFWz2rnGZZRWpa2yTidW5kZ/M6oQTqxQAtaQb59SDk
g4LQLQ4K3KI0qhh5wN3EhIxH/VE8PQr06CpUaPeIKEP5Ds4Un3R3wSVCAMLG1pIy
3RMVwHy5yHxA3ibpOmoBS0xPmBiC2etY6zlnDM5Xw8eoNfn7wUwMctWXRmEDksrZ
FP44VIRqQeZBdyTgSVtJz99oNvir8uDS7mvKsBhDykkYBINETR0+NivJboTgLG5P
Q9A1d84hlLvcjsBZ5VIli4gCtwGZTXuep7gxMbxp0dccXe7pKKzPITWKf7Nebfzi
qNF4HPLysHQE6HrlenAMwf4cTMHExVhmFSR/S4KT923N6yPyQTD6zvqhe4AjEql/
3t0iqe/u74lfu58Q8uPw4Eq2BYZD+vkTix9cihFgkqd4tY/wAzRtlwSzR8xEnVgW
C/rzmWjFTHiE7KBuaoPO7GhHFvn4IUlsGm1OAhiZyeSus+qfTPo=
=pttY
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
