From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Perftest fails when declaring support for MW_TYPE_2A
Date: Wed, 1 Nov 2017 15:35:54 +0000
Message-ID: <CY1PR0701MB2012478CF41D9E2292887ABC885F0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Mellanox/ Accelio,=20

There is a very old commit in perftest 96050b8b that assumes bit 23 in devi=
ce cap flags=20
means there is driver support for contiguous buffer allocation of user data

There is a clash with the following device capability defined in libibverbs=
/verbs.h:=20
#define IBV_DEVICE_MEM_WINDOW_TYPE_2A =3D 1 << 23

Once driver advertises memory window type 2a capability, the perftest appli=
cation fails.=20

I found that IB_DEVICE_MR_ALLOCATE is defined as bit 23 for freebsd git hub=
 and accelio github
And then I saw there are a lot of clashes between ib_verbs + upstream kerne=
l

Clash between the two needs to be resolved.=20
Perftest wise: Perhaps an additional parameter to perftest ?=20

Please advise,=20
Thanks,
Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
