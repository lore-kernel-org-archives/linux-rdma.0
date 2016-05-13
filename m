From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/mlx5: Use tasklet to decrease completions
 processing time in interrupts
Date: Fri, 13 May 2016 16:16:30 -0400
Message-ID: <a93b20ca-42bf-ca2b-2995-aa2837a1bafe@redhat.com>
References: <1460902121-5567-1-git-send-email-matanb@mellanox.com>
 <20160418130456.GA11508@infradead.org> <5714DF68.6040509@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oq2SHTsSdxmNqt7gQ62vL68v9Ue0eDpv5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5714DF68.6040509-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oq2SHTsSdxmNqt7gQ62vL68v9Ue0eDpv5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/18/2016 09:21 AM, Matan Barak (External) wrote:
> On 18/04/2016 16:04, Christoph Hellwig wrote:
>> On Sun, Apr 17, 2016 at 05:08:39PM +0300, Matan Barak wrote:
>>> Hi Doug,
>>>
>>> The mlx5 driver handles completion callbacks inside interrupts.
>>> These callbacks could be lengthy and thus cause hard lockups.
>>> In order to avoid these lockups, we introduce a tasklet mechanism.
>>> The mlx5_ib driver uses this mechanism in order to defer its
>>> completion callbacks processing to the tasklet.
>>>
>>> This follows the same mechanism we implemented for mlx4 that
>>> successfully decreased the processing time in interrupts.
>>
>> Just curious:  how much of this time is spent inside the mlx5 driver,
>> and how much is spent in the callbacks from the consumers?  We've now
>> more than half done with switch the kernel ULPs to the new CQ API
>> which will always offload the callbacks to softirq or workqueue contex=
t,
>> so if we can avoid a previous offload the completions would be a lot
>> more efficient.
>>
>=20
> In short, you could hit a situation where processing the completions in=

> the interrupt takes longer than the rate at which they arrive (lab case=
s
> that use one event queue, but still).
> I agree that going to softirqs/WQs (like the rest of the offloads) is a=

> good solution too - maybe even better than this one as the mechanism
> already exists, but why would it be a lot more efficient?
>=20

Given the amount of the kernel converted to the new CQ API, are you guys
still looking to have this included?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--oq2SHTsSdxmNqt7gQ62vL68v9Ue0eDpv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNjYeAAoJELgmozMOVy/dlh4QAJ+67DSgCe6uw3bbvLY5/NxZ
Nh/fBbr9FhzCrv9SScIy54FsT9rf5rBwMG0+VympB+xlim9NfXPEAPeK5Auvcr4m
jTq8oSvm4vKjmhhrHcUW1qHZ2ykF7P5Yhf+xsQsoQhh4I6GPhOScFv+RHNjz+UWW
0LmgOKRWQGZMhevF+Yk1GPU7kyLhYH0oD8/cExFY4RwGRMAyxNSpFHadpN25sHiv
8LdgipC1puLZophOj45xY7DLNzK9guhp7OKvOsPQnPqAYHF97AU/7wqruoS1W6ot
jO6rKwEBHCz881RoADwsJGBcIJ8XwrdAhl462Fj+j9mHUEn64V6x8ROEfXVe+ocm
ymyS/JH0Z+Yc0LZJr8IMP2QmIYU3jLMAnikeOM8z/AFXIh0Z5QLw43YdA2hFLpIx
HMw1QnPRUxpC4DtA4tReVdY6jGZgY6HhyEUYvm2nzv5dn6FlTc+X/o45l/WNijsz
f1AFjju3pBsuWU9mZczRv79uOdCNOQlqe+hIFrkt6WUDiUUypKpxKjIwHJyoRTld
iJLK2g8hg1VSQaviOhMbwYb/wjl7U/mLRcc+S1yQuWDf8jyDbTGGGXbvC7EhG+AB
F2+Rrkp+ISDvhAAqEYOmOqfTcjPeYqXs6Xu21IAtnbbbTWXIpJvibwpW2hqjuObO
DoZV1AYmFlJttwyUDW9L
=Al5m
-----END PGP SIGNATURE-----

--oq2SHTsSdxmNqt7gQ62vL68v9Ue0eDpv5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
