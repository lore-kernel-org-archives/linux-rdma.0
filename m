From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband/ulp/ipoib: remove pkey_mutex
Date: Thu, 12 May 2016 14:57:20 -0400
Message-ID: <259b14ef-493c-8596-b281-68cc80fdf49e@redhat.com>
References: <1462961049-11026-1-git-send-email-bigeasy@linutronix.de>
 <57336505.6070801@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ST5O4aCdkLQvFUrNCpv6VOKem5Dlv7GXt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57336505.6070801-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ST5O4aCdkLQvFUrNCpv6VOKem5Dlv7GXt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/11/2016 12:59 PM, Bart Van Assche wrote:
> On 05/11/2016 03:04 AM, Sebastian Andrzej Siewior wrote:
>> The last user of pkey_mutex was removed in db84f8803759 ("IB/ipoib: Us=
e
>> P_Key change event instead of P_Key polling mechanism") but the lock
>> remained. This patch removes it.
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ST5O4aCdkLQvFUrNCpv6VOKem5Dlv7GXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNNIQAAoJELgmozMOVy/d9BQQAIGvJq6e94NG7uRsRRQkH40j
xRc2AXVwQDa50jvNK5mv5CkWBfnmVj8uZHkEaPJNsGzYAYFjH+YDehMXyBxXjWaZ
/9C1WX3kpI8tuhAcR7eBbYrEKx3uvKKOjZln+wP84RqjYGblwZq3iQn8JqvyBtG8
w1pHpIJFdnm6r4x7jkB1vvhq1ywyWUjWqpHGjW+Aw0/tmitSIDXwvMvSwb2HulJW
WIbiD+XObWe+TGf3uV6uapgP8xzZPkZbMozswnfzfCl5gcnzagO2aDSGBVX7eVvw
5T+uhmVRvplz5tsYC96n8nD0Xypi1KE9t7rgdhxa3ozibSwLX+Q2lE5jclbrvPNd
J/9PT4uLbCdDBRxy1c3T2Gb0i16dZPKEMj6JkCtPvEyEaJ/3F3wccpkLm/YsGr4q
rdVCl+GwBjFdedEcJX3nygdSBNGsiu3Bp7usm2BiOgHQp5YyxSlZ11dusuufT08j
VUcfosw1k0ePGsua0IDIt9w4uEMoW3y1Z9hYsFQSl04Vk2oAI8WJugRKWtX78zIC
TcCk/u+FKc539D5PvH2hWljY/5Trnws3YbRR3t/7ENUNlQAXQZIMtpoEfNJOc/Sb
5KJ5mKNg519DNjvk8c9nDP0TKMvgsXmZd+qFN51aW5FzOmbLc7HC98zFKia7mgTf
4qX9zkoS9651BtQLaP0S
=qXTN
-----END PGP SIGNATURE-----

--ST5O4aCdkLQvFUrNCpv6VOKem5Dlv7GXt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
