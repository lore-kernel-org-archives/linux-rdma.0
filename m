From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 11/11] IB/rxe: Handle NETDEV_CHANGE events
Date: Mon, 28 Aug 2017 09:37:08 -0400
Message-ID: <e426219f-a558-209b-350c-bd71c39e52eb@redhat.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-12-git-send-email-andrew.boyer@dell.com>
 <20170827103008.GA10391@yuvallap> <D5C986D7.1DF85%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ls3q8bv2TxifoiJMrNF1G86cA1NOnnl3x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D5C986D7.1DF85%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ls3q8bv2TxifoiJMrNF1G86cA1NOnnl3x
Content-Type: multipart/mixed; boundary="8n6QSc982eTMrx0tq1SjNVM6jfC0igkG1";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>,
 Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <e426219f-a558-209b-350c-bd71c39e52eb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 11/11] IB/rxe: Handle NETDEV_CHANGE events
References: <1500989968-30889-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <1503687956-7110-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <1503687956-7110-12-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <20170827103008.GA10391@yuvallap> <D5C986D7.1DF85%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
In-Reply-To: <D5C986D7.1DF85%Andrew.Boyer-mb1K0bWo544@public.gmane.org>

--8n6QSc982eTMrx0tq1SjNVM6jfC0igkG1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/28/2017 8:38 AM, Boyer, Andrew wrote:
>=20
> On 8/27/17, 6:30 AM, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>=20
>> On Fri, Aug 25, 2017 at 03:05:56PM -0400, Andrew Boyer wrote:
>>> Without this fix, ports configured on top of ixgbe miss link up
>>> notifications. ibv_query_port() will continue to return IBV_PORT_DOWN=

>>> even
>>> though the port is up and working.
>>>
>>> Fixes: 8700e3e7c485 ("Soft RoCE driver")
>>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>>> ---
>>>  drivers/infiniband/sw/rxe/rxe_net.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
>>> b/drivers/infiniband/sw/rxe/rxe_net.c
>>> index 3ba76e7..133c6c4 100644
>>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>>> @@ -651,8 +651,13 @@ static int rxe_notify(struct notifier_block
>>> *not_blk,
>>>  		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
>>>  		rxe_set_mtu(rxe, ndev->mtu);
>>>  		break;
>>> -	case NETDEV_REBOOT:
>>>  	case NETDEV_CHANGE:
>>> +		if (netif_running(ndev) && netif_carrier_ok(ndev))
>>> +			rxe_port_up(rxe, port_num);
>> On top of which branch/patch this patch is based on?
> Yikes, it relies on an internal patch that Doug wasn=C2=B9t interested =
in
> taking. Will respin.
>=20

I don't remember seeing a patch come through that added rxe_port_up(),
let alone turning it away...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--8n6QSc982eTMrx0tq1SjNVM6jfC0igkG1--

--ls3q8bv2TxifoiJMrNF1G86cA1NOnnl3x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZpByEAAoJELgmozMOVy/d26kP/2c1w1GopUiWPW/m4nP7w8gN
B/XSQ8bwSwdKMFgEKrCGxfTKPR419k6PX52jKE3YV9ShYQUUh2s9/OTqLazFLz/j
Gh3I2gv+wxymmfEqeX+46tuZtfbAuLD7kbN50Qsi/jrTSh+D//OCmUAERELJzvNe
C+cuPxseZywH1YfumJIHdz8PWZr/FlC8zrsfZIJaB1sQsWBC5mNo7ZJFYyqmJdVH
7zYJtmjFarba59H880zWwYpT3RCyaVdwd8lRIajKVvsTlLNJbNHXV2f6IdS+kT5P
j5VXGmqZzIs9vKcpMCVumZfxGiMhSQd9q6YLEqmy4uLiiTe1sQ0Ls18v0TIsg595
CpgQLEKJVCr4eR9QKAKpwT9ycW2RfWk/svOKoNCF9ftDzzUhXpLVDZ+RCgY7J+qF
3hdTGo0KWe3vKjhrc0EY3weLwlUNjscm8TEJK6lJ0LGoiFUaLb6tbiQWBT19ng78
akjqhDGGdjDkU9RyUAoSwcjzWaNqFwGj0gaSASPIm5HF/BAg+rClC/HQ9x6m7nJY
B5Uj0evb5GFTezW2KK1PYODqjr7sm5ABCtXPlPMyj/SR0CuQrkBhGoSEHV99ok7x
3hUQmG2DMfijTHOT3r5KZnG/XOt503l7s2QqMpBHTGnWCz2Z6W4npjSISxaxahDS
Ek8oa2BBry0H+Z43PZOd
=IoEe
-----END PGP SIGNATURE-----

--ls3q8bv2TxifoiJMrNF1G86cA1NOnnl3x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
