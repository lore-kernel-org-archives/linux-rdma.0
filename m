From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/8] RXE improvements
Date: Mon, 12 Dec 2016 16:40:30 -0500
Message-ID: <a6237f62-b434-f6bc-1236-910c5dccb7dc@redhat.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
 <CAG9sBKMkoCbeCO6SgPZrW-x0rBNTQUaar+wAqeVDTLeoT8HfHw@mail.gmail.com>
 <D46ADB9D.7D50%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6WtMTMijew5AiFVFRrVFuRbPg3VLlVcoh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D46ADB9D.7D50%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6WtMTMijew5AiFVFRrVFuRbPg3VLlVcoh
Content-Type: multipart/mixed; boundary="FL6vp8w83r4KwDa5Xl3JPRR0hJ1EC7PDP";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Message-ID: <a6237f62-b434-f6bc-1236-910c5dccb7dc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/8] RXE improvements
References: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <CAG9sBKMkoCbeCO6SgPZrW-x0rBNTQUaar+wAqeVDTLeoT8HfHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <D46ADB9D.7D50%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
In-Reply-To: <D46ADB9D.7D50%Andrew.Boyer-mb1K0bWo544@public.gmane.org>

--FL6vp8w83r4KwDa5Xl3JPRR0hJ1EC7PDP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/5/2016 8:58 AM, Boyer, Andrew wrote:
> On 11/23/16, 12:59 PM, "monisonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org on behalf of Moni Shoua"=

> <monisonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org on behalf of monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
>>> Andrew Boyer (8):
>>>   IB/rxe: Remove buffer used for printing IP address
>>>   IB/rxe: Advance the consumer pointer before posting the CQE
>>>   IB/rxe: Don't update the response PSN unless it's going forwards
>>>   IB/rxe: Unblock loopback by moving skb_out increment
>>>   IB/rxe: Add support for zero-byte operations
>>>   IB/rxe: Add support for IB_CQ_REPORT_MISSED_EVENTS
>>>   IB/rxe: Fix ref leak in rxe_create_qp()
>>>   IB/rxe: Fix ref leak in duplicate_request()
>>
>> Thanks for the series.
>>
>> Please see comment in response for the first patch but except that
>>
>> Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> for everything else
>=20
> Hello Moni,
> I saw the comment from Bart in response to the first patch, but I prefe=
r
> it this way because of how much other code is required to take advantag=
e
> of %pIS. If you want it changed to %pIS, we can do that, though. What
> would you prefer?

Hi Andrew,

I took these as they are.  If someone wants to update the code to use
%pIS, it will need to be as an incremental patch.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--FL6vp8w83r4KwDa5Xl3JPRR0hJ1EC7PDP--

--6WtMTMijew5AiFVFRrVFuRbPg3VLlVcoh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTxlOAAoJELgmozMOVy/dO38P/2Wt8cWCjA/DnGMN1j6c+qVR
GJdioDLbUjICqDTIY2ZVv7zK41/PJSDM4Cy3n1PyoCc0F2BzQAa+9ksk7KGTFta0
pCp07sIwd8gA1gj3NC2m7PXEKzFv4yna1dOJTyrVnIRQKEDFHav8O3obSF3U+pSp
MAKxWSm0pnQld+h9+YpgPbmUB4ohATcU80As2GTzBzD4aagjEUPdNXmADPywAL4M
BGyD3SDYYXnvD2sR7NG57EJHHtjbHkW+q6kE1NJdsJ60LFs7Ss1ggCK5Giz4kmYk
tOn0mO9ufsZebkDVr+r2vNyTwp/lKqgpp9Qq27mgZ4dPB4EVO+mXovns5GA+FQB0
zYRCkZcLVYHww8XPCSccdZ6nYXCWt2Me8OpcuCdOybSvEPXLaxKANfQKHVuEGn5V
2YLIYPIHu6ZffKYQAj6VE6w6T+TlOoeRnMjIZvD1JzyAgzY/N9hvlTLNYx5bJCRu
VGsd0jefY84p1ngvM7RJNv8I+OaC6rNE2SCWxWTGaZFchaKbx5AbP4WztdecHFPR
XXI495ScgQSCjh+uZi0xq+vkdCWBvSyRTDiFzFcxyZXvjpXuAQ09sG6HaF4s5/A1
YdfWciM5sUoRwGapH72NCpTX3YXgQ1qhByEeMaSFLlF8XFtIIH5aIukI1BGYD8Dj
12BmuP4a1eBbvHfhpFqR
=YS8B
-----END PGP SIGNATURE-----

--6WtMTMijew5AiFVFRrVFuRbPg3VLlVcoh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
