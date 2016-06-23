From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Make the code easier to verify
Date: Thu, 23 Jun 2016 10:20:27 -0400
Message-ID: <5fa171f6-b7e6-3b43-d614-6cf062733043@redhat.com>
References: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I45cNOPaBVaVSbwABGT0nQc1hn7xDsDvh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I45cNOPaBVaVSbwABGT0nQc1hn7xDsDvh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/10/2016 02:08 PM, Bart Van Assche wrote:
> Static source code analysis tools like smatch cannot handle functions
> that lock or not lock a mutex depending on the value of the arguments.
> Hence inline the function cma_disable_callback(). Additionally, this
> patch realizes a small performance optimization by reducing the number =
of
> mutex_lock() and mutex_unlock() calls in the modified functions. With
> this patch applied smatch no longer complains about source file cma.c.
> Without this patch smatch reports the following for this source file:
>=20
> drivers/infiniband/core/cma.c:1959: cma_req_handler() warn: inconsisten=
t returns 'mutex:&listen_id->handler_mutex'.
>   Locked on:   line 1880
>                line 1959
>   Unlocked on: line 1941
> drivers/infiniband/core/cma.c:2112: iw_conn_req_handler() warn: inconsi=
stent returns 'mutex:&listen_id->handler_mutex'.
>   Locked on:   line 2048
>   Unlocked on: line 2112
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--I45cNOPaBVaVSbwABGT0nQc1hn7xDsDvh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa/ArAAoJELgmozMOVy/dSmMP/2x8sXSmsGj8oBSEv2wsT98X
1BSWwitUUcd/nKsWVKGLExiJ4SPRkS5RvmVrz8kz0KSlCbQtOUqsSp5EHL3XvE7C
ObJKMhc1h+AtKRdbC5ix8dxsBe5lexzGoUzVjkto7RNh9XtfFg3kOXp69+G1GDG6
x0dwwcFSsxYaU5GAIG4qyJzEqw2Fk9Tp3E81/4ZIBUbj0d8EY0WFqixo/viq+Nyv
+8MRLrhpOPEf+Od0sLntlFXZvHIKGXGUD5UGF9RytWIlD5CoS2Xu9U96p+9nMCcW
/4jECah75E085ZOfy4HjsITQ2+eWAZoSfcJgELP2e6FZ3mKm9J8UYeg2VX7tH7wH
Lak5+9KcjIYeRiBUYFK+/2y8sZI7+NF+IeTO5M9wpvsEpqYFxuNU+XlEwY3FWwuY
dKAGBgOT4HxqezFv9EMe3k3vORltCNTayrg9T7zWuJ+wUzMg4vX7FsUAwI14aqPl
OfLQad4sAJ/6R9smySdU8bfVfokDFsFjHpnpg2bBIXwCI6Xz1FTKnnnYpFc+JwME
7Kp2/LzwrIlNrehdWmbmdAyHv4+hm3J7uA2Ho4sv7vodhOTNp3Yy83wi7tX73Uce
VLkAh7nNPmnG8N/Hnn8HUjh7RunROrF5Xkqr2Kmn/TunaK1p0RcPnQFjAOr874BR
y4pDaEusa4ym+RHnEgt1
=ur9y
-----END PGP SIGNATURE-----

--I45cNOPaBVaVSbwABGT0nQc1hn7xDsDvh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
