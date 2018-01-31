From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH iproute2-next 00/10] RDMA resource tracking
Date: Wed, 31 Jan 2018 10:17:00 +0200
Message-ID: <20180131081700.GS2055@mtr-leonro.local>
References: <20180131081156.19607-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="68uOmRXIw+u8y5pO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180131081156.19607-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--68uOmRXIw+u8y5pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 10:11:46AM +0200, Leon Romanovsky wrote:
> Changelog:
>  v2 -> v3:
>    * Rebased to commit: 1e24e773f144 ("Merge branch 'iproute2-master' into iproute2-next")
>    * Refreshed include/uapi/rdma/rdma_netlink.h file
>    * Fixed bug, where cxgb4 was printed twice.
>  v1 -> v2;
>    * Added checks for all occurrences of strdup failures and added patch
>      with fix of already merged code.
>    * Sync with latest kernel code.
>    * Rewrote table representation to be similar to "ip route" output.
>    * Implemented string filters.
>    * Removed curr/max representation from the summary output.
>  v0 -> v1:
>    * Fixed subject title in patch #1: rdam -> rdma.
>    * Added newline between variable declaration and the code.
>    * Add check to failure in strdup() call in rd_check_is_string_filtered().
>    * Rewrote res_qp_parse_cb() to avoid long lines and extra indentation.
>
> ------------------------------------------------------------------------
>
> David, Stephen,
>
> The kernel code is accepted to the RDMA and will be sent to Linus in
> this merge window, and this is refreshed version of user space part.
>
> Because, I found bug in handling cxgb4 devices and we cleaned header
> file a little bit more, it was more wise to resend the series instead
> of applying v2.
>
> https://patchwork.ozlabs.org/project/netdev/list/?series=RDMA+resource+tracking&submitter=68852&state=8&q=&archive=&delegate=
>
> Thanks

And as expected, I forgot to add version in the subject line.
Sorry for that.

Thanks

--68uOmRXIw+u8y5pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxe3wACgkQ5GN7iDZy
WKeL7g//byXcU2fqzRKm7/cZ31qAx7JniKWIEQEis70uFPdlji4peesUAOYlNCfP
z/jJB3ilPvJHlxBRJhtWN2t3qrPK3q3Qdp5cDGchlWDaOuHSrYtN4qxy9s5K23IH
Kv/U0HK7HsaKFRi1GcQTXDSik4uWZ0tf/t/Ubd9adifTivnYytZ4MvzdKJJjfrmz
vbF19PARM0eKr7JjvWOMA0T7WaO+gqRB3LfDiBQtuFYuaNUa7atSwdWqRVQ6I0vZ
wtzhhaNRhRrO+8GhO/vhKeWFB2fjc1NTgGQj0TbHAmvRy3WKOucMaSY6ukxf740/
RliH0RcKl/ESXdO3JZU3xaFBnBsikpKoxxTpfCd33IAutdAsDvNyI8eMognF9HUk
rkuM2UqYvgu2qpcmeVrUrfP08WS/CcsXXTio0AveLsWHYirWkojhFEt8vMdZ5EjP
j36EFZSz7RC3bfdp4eewnHjbgJLsrHPxvjn9S++YEjAtwp1whySmzJkscGtZCIPw
dpTU0RW+fq3CSoPJloPDiXfk3E/9le40upjh6tIxvuBFUgJOmxfxM7fLE6T/d5Qx
lSFeCY09pe7ZCs9+/PL6VIl3w3dGxmrJYHsfRMjz9eaz4SwFISxSAX2wUp3Z/Rt6
r/taNrW2rzeZy37a9gWNhyfaJ0iVeMzn//y6aXKJyLK4EPqPc1E=
=3A4A
-----END PGP SIGNATURE-----

--68uOmRXIw+u8y5pO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
