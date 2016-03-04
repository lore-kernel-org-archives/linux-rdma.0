From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Fri, 4 Mar 2016 09:37:02 -0500
Message-ID: <56D99D8E.5020900@redhat.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-4-git-send-email-eli@mellanox.com>
 <20160301174401.GC25176@obsidianresearch.com>
 <20160301181742.GB19366@x-vnc01.mtx.labs.mlnx>
 <20160301183256.GB12495@obsidianresearch.com>
 <20160301190742.GC19366@x-vnc01.mtx.labs.mlnx>
 <20160301193153.GA25755@obsidianresearch.com>
 <20160301194608.GF19366@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XgOd9R12ex435K4HFV8XAoOAKR6p5udpm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301194608.GF19366-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XgOd9R12ex435K4HFV8XAoOAKR6p5udpm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/01/2016 02:46 PM, Eli Cohen wrote:
> On Tue, Mar 01, 2016 at 12:31:53PM -0700, Jason Gunthorpe wrote:
>>
>> I mean opensm supports the GUID Alias scheme for virtualization, this
>> new virtualization scheme is not compatible, and we shouldn't have the=

>> kernel drop support for existing working SMs, by, eg, replacing the
>> mlx4 guid alias scheme with this new scheme.
>>
>> I'm guessing a user controlled switch is going to be necessary here to=

>> pick GUID alias or port port virtualization.
>>
>=20
> The alias GUID mechanism remains and can be used with mlx4 devices.
> With this scheme the admin configures the port and node GUIDs using
> iprout2 which ends up in the hardware driver configuring the deivce. A
> virtualization aware SM can read this configuration through MADs.
>=20

If the alias GUID mechanism is to be retained, then we need another NDO
entry point for setting P_Keys on alias GUID VFs.  If we are going to
switch over to using iproute2, then the solution needs to be complete.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--XgOd9R12ex435K4HFV8XAoOAKR6p5udpm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2Z2OAAoJELgmozMOVy/d9AQQALhrEdhiMo6HmPKSBcoPblEN
J2ZAbtwYEpzzasC6b4bv1J/fYcc81VkefcTLM85Ek+Jcj/AiupYiYBISqALk9BK+
d9HrgnX0ChO5UCrJozv6+TPgauF6x1bfOITa/nO46wiswHLFq04MZZqmXQa0YNf4
j922f1Wz1beD6kaF78T2w1reb7MAt5/hjohGsgc8Y3tt/VvODh/6/r76x+23/77P
8ojCAbnRnFlP+Gj0oea0A70N9Re+4tzE6ow+t+jgHdKqb0fS4Dy9j3MQ9LRbGbUb
VMnx2SJOM0WUEzVHog01acgtXgU8vDX6iM88IjM7+ORIPhsSp+70JbtHx+rx+CTe
E6eZyvrbI7N13Q/a/JFh1XPWFfDLKSNAXOrgNCcJcIux00WBKTWaufPcKGmThnP7
O/70GH89bGC15s4FOnU34/ZGAHiGyTThKpNPpNu3CYtkTA0RHYZVIjNtsFO9/8oX
RoPZBUGstFMgSHkfb93IqKfg2kjTvKP7+tH4gjyQjINOZQdYvh6vJeadmkaW1H6E
LYdSEtHzW5LvCi6rri78LrpDxiMPjChQZpPtVA7TdgrzODAnYU9eBCrURyR+S9yg
R6WNYrCrTw8STq7HUz1JR/ZbN3S8ZFGiXdUoTlTNQEHxHURKcatgCEgeAWlrfmv3
Dvu+J6qwBF2XbWeTzqQg
=A3s/
-----END PGP SIGNATURE-----

--XgOd9R12ex435K4HFV8XAoOAKR6p5udpm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
