From: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Perftest fails when declaring support for MW_TYPE_2A
Date: Wed, 1 Nov 2017 15:46:50 +0000
Message-ID: <DB3PR0502MB401294BE74C3F399ABFC9064A95F0@DB3PR0502MB4012.eurprd05.prod.outlook.com>
References: <CY1PR0701MB2012478CF41D9E2292887ABC885F0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB2012478CF41D9E2292887ABC885F0-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Michal ,

Could you provide the package you were using ?=20
Case you working on our git , Do you know in which it was broken ?=20

Could you also add more information regarding the driver and device you wer=
e using, and the command that you try to execute and caused that clash ?=20



Thanks,=20

Zohar=20


-----Original Message-----
From: Kalderon, Michal [mailto:Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org]=20
Sent: Wednesday, November 1, 2017 5:36 PM
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;=
 lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; leon=
@kernel.org; Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Perftest fails when declaring support for MW_TYPE_2A

Hi Mellanox/ Accelio,=20

There is a very old commit in perftest 96050b8b that assumes bit 23 in devi=
ce cap flags means there is driver support for contiguous buffer allocation=
 of user data

There is a clash with the following device capability defined in libibverbs=
/verbs.h:=20
#define IBV_DEVICE_MEM_WINDOW_TYPE_2A =3D 1 << 23

Once driver advertises memory window type 2a capability, the perftest appli=
cation fails.=20

I found that IB_DEVICE_MR_ALLOCATE is defined as bit 23 for freebsd git hub=
 and accelio github And then I saw there are a lot of clashes between ib_ve=
rbs + upstream kernel

Clash between the two needs to be resolved.=20
Perftest wise: Perhaps an additional parameter to perftest ?=20

Please advise,
Thanks,
Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
