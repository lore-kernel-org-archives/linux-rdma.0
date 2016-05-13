From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: pass hw_stats by reference rather than by value
Date: Fri, 13 May 2016 15:53:28 -0400
Message-ID: <96853a47-1c90-cae2-6fe7-33fe84ba9050@redhat.com>
References: <1459163686-6455-1-git-send-email-colin.king@canonical.com>
 <20160328235737.GA5072@ctung-MOBL3>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eEHuIDQsx3FJRn2ootCjt9Odkw5Q9V0gV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160328235737.GA5072@ctung-MOBL3>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eEHuIDQsx3FJRn2ootCjt9Odkw5Q9V0gV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/28/2016 07:57 PM, Chien Tin Tung wrote:
> On Mon, Mar 28, 2016 at 12:14:46PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>>
>> passing hw_stats by value requires a 280 byte copy so instead
>> pass it by reference is much more efficient.
>>
>> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>=20
> Thank you for the patch Colin.
>=20
> Acked-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--eEHuIDQsx3FJRn2ootCjt9Odkw5Q9V0gV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNjC4AAoJELgmozMOVy/diuAP/3JEG/ryTVgFs9kOv6thmkqo
5euqfXWoBT5alRhg1GVosDucaXIYDs/4Kxb38QvIubketfujCbqDidQqb6nCpGLJ
k7ZlQLnWVlQb2PqF/mBA1e2zb3NyWSNHranQuzKcfosO1JEvFPQ7ISFlSl2r6X8Z
XHN0EEond9bYUImfZmZ4EILLujDp3ibLrDzH17l5CN3NwjUnpsWfn4xGvYKkD6J1
0JsfWIxJdFUFQMVHrIQAPx1iImmELcHjz2/BF75RBPtzpnJvjkvu/ogb9L9H9B44
TiFRk8S2BA971oVQsShaBwmLzxYl8D6a2d130DlTwLBFfZbRAhcOm2h7zIC6FhfU
JRuwr+Q1yLJr8aodTZwvOKZUVk5RbxQnS2u9m5De3aoCKvNMI9rIEqxBbJ7jL1sp
yLRlW5NMqs7jtCu4ehYo0UZIudepE6dRPonZlQBf0C3sOovzwZuigvhhBX653LQD
xy6x0IOmPaypHL04Z5wDJqZ2Hyj+x2i1oajl8Lxy9Pdqrqw/h64NbiiOJJVAC/1V
RcFmBO0jFPXCkTW4B9FOEJCUbclSBTCu2u+fdeR1isWAb19OB64tqsiOxwg3mlGh
azfgQG3MHv/Hmz2UsdfYg2/x6CoC2G8CNS6+xh36Nuk7MDOsujCEI5UiTcpd40NK
8hjTaFo6oy4VKJ82F9VW
=48ML
-----END PGP SIGNATURE-----

--eEHuIDQsx3FJRn2ootCjt9Odkw5Q9V0gV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
