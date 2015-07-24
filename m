From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx5: Expose correct page_size_cap in device attributes
Date: Fri, 24 Jul 2015 10:34:51 -0400
Message-ID: <55B24D0B.7080203@redhat.com>
References: <1437478812-9650-1-git-send-email-sagig@mellanox.com>
 <55B15F92.6070604@redhat.com> <20150723214832.GA16756@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hOuMMpj6IIvbNUu02HGaJ9mdKHfedWvQQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723214832.GA16756-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hOuMMpj6IIvbNUu02HGaJ9mdKHfedWvQQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/23/2015 05:48 PM, Jason Gunthorpe wrote:
> On Thu, Jul 23, 2015 at 05:41:38PM -0400, Doug Ledford wrote:
>=20
>> I assume this prevents the driver from working at all on certain arche=
s
>> (like ppc with 64k page size)?
>=20
> Nothing uses page_size_cap correctly, so it has no impact.

OK, then I'm going to skip this for 4.2-rc and bump it on out to 4.3.

> Sagi, that is a good point, your generic code for the cleanup series
> really should check that PAGE_SIZE is in page_size_cap and at least
> fail the mr allocation if it isn't...
>=20
> Maybe that would be enough to drop SRP's bogus usage of it...
>=20
> Jason
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hOuMMpj6IIvbNUu02HGaJ9mdKHfedWvQQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVsk0LAAoJELgmozMOVy/doCEQAJpDWzbJJiMu0RaV6hNkfr3M
kep28vOo77f4aDsMWfQhkHnRu2sQSON06iiDyiGqt5Yxo6bmM56aLkvCjan3zGDb
EDJ39D5bmOoizl6jCvh65Olfk9Z2/dzR4XkRTaavlfwf2ctpvCjJpkXiYJGVPyI7
wEC05Kvhso2lOtUEZvwunps/29IWUSk8jhoHGsVOK9ogLyl13sDo2WlGpfP+Mc/G
I53LyjgNDZBUCK7gCi1HPVZVthNGRbjn5EggGhzoNzfoR0TTB34Io5gl17oJrrwp
pF7uP3sSJWnPlI6IUVfEh7uKky74hPJCAOyRjI7AYhBU1HWc8JbQYVH7s0NI0zcS
kjCtGNM8xHXvQxnHeCz71pdW0wfIjwFB2iij8VvQN/bDc/rwemFYFtI045mB9Dw/
DKsBoogKjLuJNtB7Im7uTUVqs1ztc8v0uNE2hHuOoK1oLtxfPJpcw0JOV9XdH/Av
+G0mBZfo1KJ75qKshvyr45TQ9zmKNTUmxNGFVL18cZ9R8GOjPLNUw1GvTKv85cQ4
uG4jdkcFXoDIOTXdqNR3iv89jyqzvQU5Pu0NPltRyIQBgSaW2fIfvdBIpDeq1BFX
I4j7FH78dmMEJZ8lUXUqHVOFBOwk69zm2ohiWTlbvfCNekBR1F/SgRwNzMJLIWmH
q9Hhq4hJ/OEElKABstPQ
=49M+
-----END PGP SIGNATURE-----

--hOuMMpj6IIvbNUu02HGaJ9mdKHfedWvQQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
