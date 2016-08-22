From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix possible memory leak in
 cma_resolve_iboe_route()
Date: Mon, 22 Aug 2016 14:10:52 -0400
Message-ID: <985a4286-5454-4a37-9fc0-ee01c0e1d658@redhat.com>
References: <1470404809-16658-1-git-send-email-weiyj.lk@gmail.com>
 <0fe65631-0776-720e-a399-033f13e6f351@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L9wiQQahxSx97x7E4KXL7sdNbQ9CNWvD2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0fe65631-0776-720e-a399-033f13e6f351-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L9wiQQahxSx97x7E4KXL7sdNbQ9CNWvD2
Content-Type: multipart/mixed; boundary="rJam4axKMAtxkfdT7d7bpqSpvnGDL7DRP"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock
 <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>,
 Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <985a4286-5454-4a37-9fc0-ee01c0e1d658-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix possible memory leak in
 cma_resolve_iboe_route()
References: <1470404809-16658-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <0fe65631-0776-720e-a399-033f13e6f351-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <0fe65631-0776-720e-a399-033f13e6f351-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--rJam4axKMAtxkfdT7d7bpqSpvnGDL7DRP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/7/2016 12:49 AM, Haggai Eran wrote:
> On 8/5/2016 4:46 PM, Wei Yongjun wrote:
>> 'work' and 'route->path_rec' are malloced in cma_resolve_iboe_route()
>> and should be freed before leaving from the error handling cases,
>> otherwise it will cause memory leak.
>>
>> Fixes: 200298326b27 ('IB/core: Validate route when we init ah')
>> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

> By the way, what happens when someone moves the get_netdev() device to
> network namespace other than init_net? I don't think that would work
> correctly.

I suspect you're right.  The entire RDMA stack will need an audit for
init_net misuses before containers are a real item I think.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--rJam4axKMAtxkfdT7d7bpqSpvnGDL7DRP--

--L9wiQQahxSx97x7E4KXL7sdNbQ9CNWvD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0AsAAoJELgmozMOVy/dgXoP/3x+xfUG8d6OkNHmYorbmwGa
my/ZqYu8yQgJYFPTMYNkO8JcFsnI927jJUdKzSrJ+XjkprwCHGWuDZuF2zJahwQk
w4GqUqW22qUftE6ZkJ8DarntSnK9fHvWWG7e0ornIRwfeqFuu2GVl/FZ7mT2xcRG
aTao19lxZQKRW6guBffUwjpphnH45PTyidlYWI5dNOXrlrqDCWmwde0VXFWtQUfQ
rMJMqudJ9O5ou70UzJX8+3RaqvUkzvPJCS8ZRn76ZrJW5dLGMZf4MDDKdtAbNSVq
nvnfrbthmrhjSvGmGayty9XEG1MJQStTPb4dbUlahwR4s7Iq/zGm7ZdCeOEPzog0
iNLEc5rDKsj+kMS6y+0n6o9csfPvcvbgzyCruC19dLd3Xcx/fBeCULj7GHOjTpSh
r5RCsJg92zvTLHlt1Ka+fUKIph1DZvkKnKPbdticc021mQK/A1OreQQwcjdK9l57
JbioJCUkar08X/uSpy5vMdPlOgCWa2NLXGxdIPVtOevHkjKzFA7qa9D2XPrke9HV
uaNwLan6dnbvdOE8ERYmLyO6V5zKJyhIG8CTTPlJhbpBfBmnymB5W40XxjwJpNQ9
Gn3IES4GgoeC5lsY5mDpnhCPvKFvwXs7lMOaGw/4jgYUoqK9hUecVWmnspZv5Ojt
Hg4Vj+EMMLyXCWwA5LE7
=Bv04
-----END PGP SIGNATURE-----

--L9wiQQahxSx97x7E4KXL7sdNbQ9CNWvD2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
