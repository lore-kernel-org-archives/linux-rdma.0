From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Problem of changing the =?utf-8?Q?inli?=
 =?utf-8?Q?ne_mode_or_turning_on_the_encapsulation_support_of_Mellanox_NI?=
 =?utf-8?B?Q+KAmXM=?= eswitch
Date: Mon, 20 Nov 2017 10:02:41 +0200
Message-ID: <20171120080241.GB18825@mtr-leonro.local>
References: <HK2PR01MB0834534F555D6F532694DE5AF5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
 <20171120072351.GA18825@mtr-leonro.local>
 <HK2PR01MB083483A928DBF1EC8643BEA3F5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
 <83fb4706-2a4c-9e25-b5b6-92e433a7c746@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3tt15+HBgQgyptxg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <83fb4706-2a4c-9e25-b5b6-92e433a7c746-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Junxue ZHANG <jzhangcs-t+iU6Fs6CelnrVKH7T7RYw@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Byron Yi <yibairen1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3tt15+HBgQgyptxg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2017 at 09:28:53AM +0200, Mark Bloch wrote:
> >> NIC hardware model:
> >> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94
> >> ConnectX=C2=AE-4 EN network interface card, 40GbE dual-port QSFP28, PC=
Ie3.0
> >> x8, tall bracket, ROHS R6
> >>
>
> We don't support encap/decap with ConnectX-4.
> You should use ConnectX-4 LX or ConnectX-5.
> Note that on ConnectX-5 you don't need to turn inline support as it isn't=
 needed.

I spoke with Mark and it looks like documentation issue.

Thanks

--3tt15+HBgQgyptxg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloSjCEACgkQ5GN7iDZy
WKeh7Q//frJVRiuUgcpu0yU+rHLnZ2rTAZ1vd9fXaAbEzzwC4RITOxgEIlceHH6a
7CHDFoOutSc85HUd+TVhNZNNH3mJUustBTURE1ouiMlLxBrbqfafVmxWVdw5XVs7
m+tC2VEgtWDiyYEMraILEQa4skg8iD03SZSeodXS1AVpgonz4njbMM+xr7Hj7R8e
afq+pyHvnkTTdo1J6RTReRRCeQihz1bpfzjMGvcYyhJBnRXbViQJwS21Kc9IfXC0
5L/Za5fJ6CweBaoTMr42AG6oU2gTwpJQdR1i1Fzyl2abpY7m5RdV5/WcQALXWfmR
Q4s4lHD+vFystEiPRgm7Q1tWCRLZROmXqJGG0hygbR8LtS/fsGN/ZOqySzhvmd6M
SnVJASPPZXZPbaVoCd/M2eW48EYW7Yk86Sii0ZjFwpDEeY4IqmzB27dlm8OjJSGA
/3UPZty347UciuLmS6MkwTTLixivE1a90ePdqgO82VmJBYwe+NbGbAJoHxwhOsNq
elXFSPw8E2yJdSkXDTqWYNIDZn4SNA5D1KnqD6i2gflCIHUMZoyz2kbJSL3vePXG
WkgJuTmkjwS54TRAktOLVjIWytxacdjXJqKacK2btsFbEOVDvj9OiXSBxc4lbgQw
VTHZnG9xkECawMEj9fLQ9moOfGH0xE6SNJ5PeLsqArZxoTDH8p0=
=WbjL
-----END PGP SIGNATURE-----

--3tt15+HBgQgyptxg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
