From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Sun, 28 Aug 2016 11:32:14 +0300
Message-ID: <20160828083214.GK594@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828080954.GB10131@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLauP2uySp+9cKYP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828080954.GB10131@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--SLauP2uySp+9cKYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 28, 2016 at 11:09:55AM +0300, Yuval Shaia wrote:
> On Sun, Aug 28, 2016 at 10:58:32AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > By Mellanox HW design and SW implementation poll_cq never
> > fails and returns errors, so all these prints are to catch ULP bugs.
> >
> > In case of such bug, the reverted patch patch will cause to reentry
>
> s/patch patch/atch

Doug,
Do you want me to respin it?

Thanks

--SLauP2uySp+9cKYP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwqGOAAoJEORje4g2clinzpwP/RaR6RpISG7QkRCOJmVjbuMH
ZyMJ8U0cBP5yPWsUOJvjI6XRlGUWCIofSUg0L4uJvPqPRxL+h410vFn44Cld2IpU
eoOxZiMbBPwI9Gtw48/fEtx3dt1wH+JY53zEN6lC7zwBb9Kwzh3uynDNaDOes1+4
WvWv8AE9cX8ZIORv7RX7a1UCFyzuAlO5Uiu7uRnfZvsMRy5SvSyAUnbfD26lbzYI
ZZkFGSjAxxEuovIVLU0ybDUQmewXVYWLrPVLkhPQxGv2H0fwG7kWMdVLmEeDRjYu
tBJJmKA3w20DSj82+9tnJw1Slas4n6aUsrK0d+flUGly5GhFeezU74BuRCz8rPDG
q4jWMbmPWJ9DCgoZy0R0U3C2HtQ4diPH5rMpcWkalNMAvxEJD3jJX19Gh4E72PjF
rTqPxW8DDDHASKPaGMz1thwmyTBq8kutrhu1l0GhBZKsvCmeCG8+zFYBFViUM7XU
06NGALfVqLavK37phqfqPe8unrd+yoOxeR4Wf+VW7OSyFZRgqQiDwPn9IoEzTosT
Sm97pHxD0gQDcnYOusq0loU01lbpg92hMqCZRk9Zl0CB0IItOP6QkVK5KXBUAwn7
9dJTHAnv2qebPw1wfXKp3FNnrJ0dL4bX3/NtCehgEqy+W5ybOtIr+kb3Jn0o/WNf
vsdnI4XPPhNoVJfpKgvN
=9As+
-----END PGP SIGNATURE-----

--SLauP2uySp+9cKYP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
