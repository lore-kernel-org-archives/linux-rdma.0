From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Fri, 22 Feb 2019 12:51:55 -0500
Message-ID: <C7922E85-CA43-479A-8021-DADD59FF5BE7@redhat.com>
References: <20190217170909.1178575-1-haakon.bugge@oracle.com>
 <20190222163637.GA9819@ziepe.ca>
 <afadc799-b547-5c20-64d2-75fa0f64cd9e@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: multipart/signed;
        boundary="Apple-Mail=_4BA6C486-80C9-4C0B-91AD-B21308731512";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <afadc799-b547-5c20-64d2-75fa0f64cd9e@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_4BA6C486-80C9-4C0B-91AD-B21308731512
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Feb 22, 2019, at 12:14 PM, Steve Wise <swise@opengridcomputing.com> =
wrote:
>=20
>=20
> On 2/22/2019 10:36 AM, Jason Gunthorpe wrote:
>> On Sun, Feb 17, 2019 at 06:09:09PM +0100, H=C3=A5kon Bugge wrote:
>>> During certain workloads, the default CM response timeout is too
>>> short, leading to excessive retries. Hence, make it configurable
>>> through sysctl. While at it, also make number of CM retries
>>> configurable.
>>>=20
>>> The defaults are not changed.
>>>=20
>>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>>> drivers/infiniband/core/cma.c | 51 =
++++++++++++++++++++++++++++++-----
>>> 1 file changed, 44 insertions(+), 7 deletions(-)
>>>=20
>>> diff --git a/drivers/infiniband/core/cma.c =
b/drivers/infiniband/core/cma.c
>>> index c43512752b8a..ce99e1cd1029 100644
>>> +++ b/drivers/infiniband/core/cma.c
>>> @@ -43,6 +43,7 @@
>>> #include <linux/inetdevice.h>
>>> #include <linux/slab.h>
>>> #include <linux/module.h>
>>> +#include <linux/sysctl.h>
>>> #include <net/route.h>
>>>=20
>>> #include <net/net_namespace.h>
>>> @@ -68,13 +69,46 @@ MODULE_AUTHOR("Sean Hefty");
>>> MODULE_DESCRIPTION("Generic RDMA CM Agent");
>>> MODULE_LICENSE("Dual BSD/GPL");
>>>=20
>>> -#define CMA_CM_RESPONSE_TIMEOUT 20
>>> #define CMA_QUERY_CLASSPORT_INFO_TIMEOUT 3000
>>> -#define CMA_MAX_CM_RETRIES 15
>>> #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
>>> #define CMA_IBOE_PACKET_LIFETIME 18
>>> #define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
>>>=20
>>> +#define CMA_DFLT_CM_RESPONSE_TIMEOUT 20
>>> +static int cma_cm_response_timeout =3D =
CMA_DFLT_CM_RESPONSE_TIMEOUT;
>>> +static int cma_cm_response_timeout_min =3D 8;
>>> +static int cma_cm_response_timeout_max =3D 31;
>>> +#undef CMA_DFLT_CM_RESPONSE_TIMEOUT
>>> +
>>> +#define CMA_DFLT_MAX_CM_RETRIES 15
>>> +static int cma_max_cm_retries =3D CMA_DFLT_MAX_CM_RETRIES;
>>> +static int cma_max_cm_retries_min =3D 1;
>>> +static int cma_max_cm_retries_max =3D 100;
>>> +#undef CMA_DFLT_MAX_CM_RETRIES
>>> +
>>> +static struct ctl_table_header *cma_ctl_table_hdr;
>>> +static struct ctl_table cma_ctl_table[] =3D {
>>> +	{
>>> +		.procname	=3D "cma_cm_response_timeout",
>>> +		.data		=3D &cma_cm_response_timeout,
>>> +		.maxlen		=3D sizeof(cma_cm_response_timeout),
>>> +		.mode		=3D 0644,
>>> +		.proc_handler	=3D proc_dointvec_minmax,
>>> +		.extra1		=3D &cma_cm_response_timeout_min,
>>> +		.extra2		=3D &cma_cm_response_timeout_max,
>>> +	},
>>> +	{
>>> +		.procname	=3D "cma_max_cm_retries",
>>> +		.data		=3D &cma_max_cm_retries,
>>> +		.maxlen		=3D sizeof(cma_max_cm_retries),
>>> +		.mode		=3D 0644,
>>> +		.proc_handler	=3D proc_dointvec_minmax,
>>> +		.extra1		=3D &cma_max_cm_retries_min,
>>> +		.extra2		=3D &cma_max_cm_retries_max,
>>> +	},
>>> +	{ }
>>> +};
>> Is sysctl the right approach here? Should it be rdma tool instead?
>>=20
>> Jason
>=20
> There are other rdma sysctls currently:  net.rdma_ucm.max_backlog and
> net.iw_cm.default_backlog.  The core network stack seems to use sysctl
> and not ip tool to set basically globals.
>=20
> To use rdma tool, we'd have to have some concept of a "module" object, =
I
> guess.  IE there's dev, link, and resource rdma tool objects =
currently.
> But these cma timeout settings are really not per dev, link, nor a
> resource.   Maybe we have just a "core" object:  rdma core set
> cma_max_cm_retries min 8 max 30.

I don=E2=80=99t know, I think you make a fairly good argument for =
leaving it as a sysctl.  We have infrastructure in place for admins to =
set persistent sysctl settings.  The per device/link settings need =
something different because link names and such can change.  Since these =
are globals, I=E2=80=99d leave them where they are.

--
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 =
2FDD








--Apple-Mail=_4BA6C486-80C9-4C0B-91AD-B21308731512
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxwNrsACgkQuCajMw5X
L91MUQ/+MjIJrwP4Fk2DhC51GXAluuZm6ZQzT0syjc9g9mhA3XFMc2Tba1vLbxxB
0TXfg9cKfk5thLnkJOCKAmT/ozabScXSUbN+wfc1ulD9BakRAjqvlgrRmVOf0yzP
fXSWZutRLthmFYi4QlHm2c4umGFV7D/YAaDXjGCNLP17haYulKpwm+ucKq0+ZYLP
QhQPwsHystna5RtDxFGAlDqZEF+PcBwMyu6z2n/mAf/t5EPqiP8U48s6DyaE9mWj
6Xb40Kf3YilGqLaOumetu8Q/gZtDoszH8YHaQ2UE1ie7V7qnltMEcBJjr5St+pul
y127TUBdLQEh8lyCxfxPqWAKvquhxZ1jynG5cnOeVXgGjeSAPe4mGFVw0XAuGFTP
gUavNDUm5ZrtMpZaqB3L6H83/VdWoHi1pCJhmkSE17aM6q2bBe4SmFzrazBstoQ4
loQrzIiChmuQRKvl8UV+YYIkMtix6tipNb9GQPDO78JWKYG58h/S5nY7hkVlhSG8
rQjq9JaapXpRZ0784e5603QM0OzD7QCwxxhupw/CwOsmAi4LoXSogteAljQTnaku
chYzJ7xZMEKYMx3SJH6RMfO32+rxKgxlqAOs6kn7dF6/N0IQ0NZ1+2r0IeO6ZPOI
jPWTZlG0JfiNp+s91OjdaXJvf+g+nue5QQABQB3BcAZUnjzDCcg=
=lEPj
-----END PGP SIGNATURE-----

--Apple-Mail=_4BA6C486-80C9-4C0B-91AD-B21308731512--
