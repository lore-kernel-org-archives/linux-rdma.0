From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 11/11] IB/rxe: Handle NETDEV_CHANGE events
Date: Mon, 28 Aug 2017 10:13:50 -0400
Message-ID: <198b45c2-6fb7-d43a-c95a-1ca61f583283@redhat.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-12-git-send-email-andrew.boyer@dell.com>
 <20170827103008.GA10391@yuvallap> <D5C986D7.1DF85%Andrew.Boyer@emc.com>
 <e426219f-a558-209b-350c-bd71c39e52eb@redhat.com>
 <D5C996DB.1DFB5%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OB2J7Dnn2oafaMRFgxC6LgsMjL33OKwvb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D5C996DB.1DFB5%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OB2J7Dnn2oafaMRFgxC6LgsMjL33OKwvb
Content-Type: multipart/mixed; boundary="ecUQsdg41T4Sxx0N46uTNRJa1i2Q0FVUA";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>,
 Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <198b45c2-6fb7-d43a-c95a-1ca61f583283-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 11/11] IB/rxe: Handle NETDEV_CHANGE events
References: <1500989968-30889-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <1503687956-7110-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <1503687956-7110-12-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <20170827103008.GA10391@yuvallap> <D5C986D7.1DF85%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
 <e426219f-a558-209b-350c-bd71c39e52eb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <D5C996DB.1DFB5%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
In-Reply-To: <D5C996DB.1DFB5%Andrew.Boyer-mb1K0bWo544@public.gmane.org>

--ecUQsdg41T4Sxx0N46uTNRJa1i2Q0FVUA
Content-Type: text/plain; charset=euc-kr
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/28/2017 9:47 AM, Boyer, Andrew wrote:
>=20
>=20
> On 8/28/17, 9:37 AM, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
>> On 8/28/2017 8:38 AM, Boyer, Andrew wrote:
>>>
>>> On 8/27/17, 6:30 AM, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> On Fri, Aug 25, 2017 at 03:05:56PM -0400, Andrew Boyer wrote:
>>>>> Without this fix, ports configured on top of ixgbe miss link up
>>>>> notifications. ibv_query_port() will continue to return IBV_PORT_DO=
WN
>>>>> even
>>>>> though the port is up and working.
>>>>>
>>>>> Fixes: 8700e3e7c485 ("Soft RoCE driver")
>>>>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>>>>> ---
>>>>>  drivers/infiniband/sw/rxe/rxe_net.c | 7 ++++++-
>>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
>>>>> b/drivers/infiniband/sw/rxe/rxe_net.c
>>>>> index 3ba76e7..133c6c4 100644
>>>>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>>>>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>>>>> @@ -651,8 +651,13 @@ static int rxe_notify(struct notifier_block
>>>>> *not_blk,
>>>>>  		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
>>>>>  		rxe_set_mtu(rxe, ndev->mtu);
>>>>>  		break;
>>>>> -	case NETDEV_REBOOT:
>>>>>  	case NETDEV_CHANGE:
>>>>> +		if (netif_running(ndev) && netif_carrier_ok(ndev))
>>>>> +			rxe_port_up(rxe, port_num);
>>>> On top of which branch/patch this patch is based on?
>>> Yikes, it relies on an internal patch that Doug wasn=A9=F6t intereste=
d in
>>> taking. Will respin.
>>>
>>
>> I don't remember seeing a patch come through that added rxe_port_up(),=

>> let alone turning it away...
>=20
> It=A1=AFs the port_num argument that doesn=A1=AFt exist upstream. We ad=
ded the
> ability for RXE to support a second port (to better mimic an mlx4) but =
you
> said it wasn=A1=AFt needed.

OK.  I still don't remember the event though ;-)

Anyway, I'll wait for you to send a fixed version of the code.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--ecUQsdg41T4Sxx0N46uTNRJa1i2Q0FVUA--

--OB2J7Dnn2oafaMRFgxC6LgsMjL33OKwvb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZpCUfAAoJELgmozMOVy/dMgkQAJJie37ulceFiEQZebIdWWq5
Fxw7lBTkE4CCYi4ERKzsOXuVvJt+c+yPPNoOy+h7g1TNehVP2uRxA1FCm1IFGAZZ
V3ofT5qeOJDiO9OP2gE3fkeWDFXxh2srUqxCXWIaYJ2bPnUBScVHIEj8L+VsjX0l
R6dowc1h1Pg41XRAfQDfYILkXEnjBiH3ttKOCfC2Yu9YEZfEFEBSyYxKkL4RACXn
hdpkKbF6xRDrydbWvkiljCuIg8OXkbv238a3F3LbUDEqzvwNkaE4BDu2xuQS4uSf
WpmnSaUjat/Iz/udm4GxLTCrZ9Xd0d4Fk6VJ8hUEubY6euI0RQ8o7VaMdu0D+ILe
I7g+Hi+n1m4/1pD7DN67Ppbp25zF4pL0y7KwMXAZDJfNbdX5LpcefID/a7C3YMGF
F07fSKF/h6PjtaaN/g2G1FDfZKjJepswF3un4lp46XlbMfdb6N5Dz3fTRiOXGLg8
gWLxYxwHcszL/RlohWV8JsCtjitxt04xO/1jUkCRP6sMG87jSJcs4DdzQHNFUWmi
Aag4GsQyw5bKyNSLo5KH5IhGyEcI17GJui/0C40cbd/OonEOxZ7rFJkw9Sk3Jlnq
0U+VzsvBtJAzvm7KLL7pTt8+D2fTGURu5Md+Z8gE5SmKvdeBfTKT55wFRFGGUCiR
9K7QMzr6e5i46gLYA393
=P/WT
-----END PGP SIGNATURE-----

--OB2J7Dnn2oafaMRFgxC6LgsMjL33OKwvb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
