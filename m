From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: avoid 32-bit warning
Date: Wed, 21 Oct 2015 16:58:01 -0400
Message-ID: <5627FC59.4070502@redhat.com>
References: <17269152.DqJfCm1LOx@wuerfel>
 <56151BDF.8010504@dev.mellanox.co.il> <1444225608.3188.67.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vGVh9UHWecC3Tjq3gNNeWCLX8fc9OTDVC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444225608.3188.67.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vGVh9UHWecC3Tjq3gNNeWCLX8fc9OTDVC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/07/2015 09:46 AM, Yann Droneaud wrote:
> Hi,
>=20
> Le mercredi 07 octobre 2015 =C3=A0 16:19 +0300, Sagi Grimberg a =C3=A9c=
rit :
>> On 10/7/2015 3:29 PM, Arnd Bergmann wrote:
>>> The INIT_UDATA() macro requires a pointer or unsigned long argument
>>> for
>>> both input and output buffer, and all callers had a cast from when
>>> the code was merged until a recent restructuring, so now we get
>>>
>>> core/uverbs_cmd.c: In function 'ib_uverbs_create_cq':
>>> core/uverbs_cmd.c:1481:66: warning: cast to pointer from integer of
>>> different size [-Wint-to-pointer-cast]
>>>
>>> This makes the code behave as before by adding back the cast to
>>> unsigned long.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>>> Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")
>>>
>>> diff --git a/drivers/infiniband/core/uverbs_cmd.c
>>> b/drivers/infiniband/core/uverbs_cmd.c
>>> index be4cb9f04be3..88b3b78340f2 100644
>>> --- a/drivers/infiniband/core/uverbs_cmd.c
>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>>> @@ -1478,7 +1478,7 @@ ssize_t ib_uverbs_create_cq(struct
>>> ib_uverbs_file *file,
>>>   	if (copy_from_user(&cmd, buf, sizeof(cmd)))
>>>   		return -EFAULT;
>>>
>>> -	INIT_UDATA(&ucore, buf, cmd.response, sizeof(cmd),
>>> sizeof(resp));
>>> +	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response,
>>> sizeof(cmd), sizeof(resp));
>>
>> Would it make sense to cast inside INIT_UDATA() and not have callers
>> worry about it?
>=20
> It's ... complicated. See INIT_UDATA_BUF_OR_NULL().
>=20
> Awayway, I have patch to do the opposite, eg. explicitly cast u64 value=

> to (void __user *)(unsigned long) in the caller function instead, as it=

> allows some safer / new operations on the response buffer.
>=20
> Regards.
>=20

I haven't seen this oether patch that Yann is talking about, so I've
taken this one.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vGVh9UHWecC3Tjq3gNNeWCLX8fc9OTDVC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJ/xZAAoJELgmozMOVy/dQncP/iXM8RulFr59PCia8vnLPSIs
dj8p50TxrhJpSr2KXlXReTPq3VO61ZTV6AxFJWQqW/54H7piHhRu45GP+JeUWmbq
mkVGIjHkI+BwElDxaoT0R6lhg/qsVvmbS2EhqWMY+B3cO65zl9EHyLxvu/hNhkA9
VYf/ZGvNGiyVBhLqw+TESNfHB1AInRDPhP11L/agAmPy+y7Ga6bt1599ogGHKo9j
6qiREBH0T7UIYgp/ghmsymiPbZ3FE5XtFVDYrhHyGWFtCWdmZIbLoI+DH8JKcSZS
1SfHhiYQhOICKp6RqtXKTmoigbb48E1uRKPLkOvlKH6SMWDW+wuMvbCwRnRfGgSB
7xo6Dy8/3MdpXkyyPQ19565U96x4lLuMYKrsZN+czb30w/3y62VC0DqODMQORRdR
G/iDco4PUqo0uhPvjYXyxyDfI6Ae5836ePfOuDZuVmAZEbWdufRThyTNGuRg2lNG
lDu9W78jaRsjVq2Zw66lbfbdG8C7s6f6N2nauCZp2n9Cwe3ls0wPvgZyfnTQlziD
sMSqn76WT1YJI55gHcn6+YNthCbaef4ldsiOYr8nUp4/VM707dXYpWyTB97UtQ0g
GWGVZ92HTGs6UEkUfOI/+pmxaJ9wOKb7oUBEQpPJjjs7+XuiK5LhWu4dvqzOl9nS
gejwX1Pl1oC7/u+zZlxO
=X26F
-----END PGP SIGNATURE-----

--vGVh9UHWecC3Tjq3gNNeWCLX8fc9OTDVC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
