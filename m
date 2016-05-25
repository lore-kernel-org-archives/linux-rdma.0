From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next,V3] IB/IPoIB: Allow setting the device address
Date: Wed, 25 May 2016 15:45:32 -0400
Message-ID: <d24ab05a-cd35-42b4-73a8-2fb52ef1a643@redhat.com>
References: <1463578963-14956-1-git-send-email-markb@mellanox.com>
 <VI1PR05MB139136EF3C46570069764F35D2400@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <dca48241-291a-e13c-4e26-ed332c26c612@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="17rLFNrjejHGKa6ClTXaD7L5gvK3Dw1ti"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dca48241-291a-e13c-4e26-ed332c26c612-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--17rLFNrjejHGKa6ClTXaD7L5gvK3Dw1ti
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/25/2016 01:59 PM, Doug Ledford wrote:
> On 05/25/2016 09:15 AM, Mark Bloch wrote:
>> Hi Doug,
>>
>> Are you planning to take this one? Do you have issues I need to addres=
s?
>>
>> I've fixed Jason's comments, but no further input
>> was given besides that.
>=20
> I was just waiting on the final version of the SendOnly mcast join
> series as that's IPoIB related too and I was going to pull them togethe=
r
> into an IPoIB topic branch.
>=20
>=20

I've pulled this in now.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--17rLFNrjejHGKa6ClTXaD7L5gvK3Dw1ti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRgDcAAoJELgmozMOVy/dPAUQAIcRiqJ7r3MVWacXwBv9/C2t
pZbLO/iBOZVZJOdZFe+gf9xJRRW0YmH+swdkFWKcV2AQMzc+ExYOd3H8v5N9IKbM
qvh6Va1Sh6mF26HQAPsYcoM88XfHRgYFkRhDq5lLwL9zo5zuil8iAicwwvpqHDe9
ryFxSTBdiDBOPFmodJCDRLt5dht7Da0VrhSnb34qITNc9jputzt2fvZPh5tJAj2x
Ip1Z0u/MwxBdtp3QMwPdd7Lc9l0CGyC/YZME3KfP+tMBTZBW/xhYSB3nhkqDkCPu
EFHw7NObntRHXhJh9UQASIBROsSZbbDcq4l0GsOBPTJRC0nr/V+LyJZoYyVo4RMe
GGAI2+jgnkG3fSCPwgE46MiGKE9nEAXqEC+OZ2MhkdVOjwSQ/yaKpz/HDyydWnEg
bXhsku9/nEHeAFGK8FROx/uFGFZLBr+G9VdB/OLC0dM/KM4te/uMJhNZm74Yuvkp
I1vCuDHGLpjuWtW3XanQOYH0IZBT2GfIOBqC/uaPcSAk56wjPFMvegB++fHfGu1V
kSEIO6vKXnqa4d8ZCiVTjsK3vaILRixgPuRzrs9cUYTUVroPVSHE08m5wi1DB+uc
4usR/9XDfA02dakkTS9bpQ8ptzUxg5TwLnp70aIiyPaMHom36z2hKuS54zhZ38TF
7EirPlOoiZ0U78J56AGF
=6KK4
-----END PGP SIGNATURE-----

--17rLFNrjejHGKa6ClTXaD7L5gvK3Dw1ti--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
