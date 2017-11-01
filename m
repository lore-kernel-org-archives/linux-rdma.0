From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Perftest fails when declaring support for MW_TYPE_2A
Date: Wed, 1 Nov 2017 15:59:50 +0000
Message-ID: <CY1PR0701MB20127EC91D843349616DE993885F0@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <CY1PR0701MB2012478CF41D9E2292887ABC885F0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <DB3PR0502MB401294BE74C3F399ABFC9064A95F0@DB3PR0502MB4012.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB3PR0502MB401294BE74C3F399ABFC9064A95F0-uKIzJYYTohOPJQcb9Mlg0cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Zohar,=20

Thanks for the quick response. I'm working on your git.
I don't think it was broken, more that perhaps it never worked over devices
that advertise MEM_WINDOW_TYPE_2A

>From a quick grep I see that the only ones that advertise TYPE_2A are mlx4 =
and only under certain
Conditions.=20

I'm currently adding support for MW_TYPE_2A for our qedr driver and that's =
how I=20
Got the perftest failure.=20

Ran ib_write_bw with all default values
Got the error:=20
Couldn't allocate MR
Failed to create mr
...=20

Thanks,
Michal

> -----Original Message-----
> From: Zohar Ben Aharon [mailto:zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Wednesday, November 01, 2017 5:47 PM
> To: Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Gil Rockah
> <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Ido Shamay
> <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>;
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: RE: Perftest fails when declaring support for MW_TYPE_2A
>=20
> Thanks Michal ,
>=20
> Could you provide the package you were using ?
> Case you working on our git , Do you know in which it was broken ?
>=20
> Could you also add more information regarding the driver and device you
> were using, and the command that you try to execute and caused that clash
> ?
>=20
>=20
>=20
> Thanks,
>=20
> Zohar
>=20
>=20
> -----Original Message-----
> From: Kalderon, Michal [mailto:Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, November 1, 2017 5:36 PM
> To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Gil Rockah
> <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Ido Shamay
> <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>;
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: Perftest fails when declaring support for MW_TYPE_2A
>=20
> Hi Mellanox/ Accelio,
>=20
> There is a very old commit in perftest 96050b8b that assumes bit 23 in de=
vice
> cap flags means there is driver support for contiguous buffer allocation =
of
> user data
>=20
> There is a clash with the following device capability defined in
> libibverbs/verbs.h:
> #define IBV_DEVICE_MEM_WINDOW_TYPE_2A =3D 1 << 23
>=20
> Once driver advertises memory window type 2a capability, the perftest
> application fails.
>=20
> I found that IB_DEVICE_MR_ALLOCATE is defined as bit 23 for freebsd git h=
ub
> and accelio github And then I saw there are a lot of clashes between ib_v=
erbs
> + upstream kernel
>=20
> Clash between the two needs to be resolved.
> Perftest wise: Perhaps an additional parameter to perftest ?
>=20
> Please advise,
> Thanks,
> Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
