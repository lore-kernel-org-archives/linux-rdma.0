From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ucma: Fix theoretical user triggered use-after-free
Date: Fri, 14 Aug 2015 21:22:25 -0400
Message-ID: <55CE9451.3040803@redhat.com>
References: <20150804231332.GA22959@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A9023323@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tUhC4JJuPjwssRd0UhM5MfUqILwRG6DvM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9023323-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tUhC4JJuPjwssRd0UhM5MfUqILwRG6DvM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/06/2015 01:33 PM, Hefty, Sean wrote:
>> Something like this:
>>
>> CPU A                         CPU B
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ucma_destroy_id()
>>  wait_for_completion()
>>                               .. anything
>>                                 ucma_put_ctx()
>>                                   complete()
>>  .. continues ...
>>                               ucma_leave_multicast()
>>                                mutex_lock(mut)
>>                                  atomic_inc(ctx->ref)
>>                                mutex_unlock(mut)
>>  ucma_free_ctx()
>>   ucma_cleanup_multicast()
>>    mutex_lock(mut)
>>      kfree(mc)
>>                                rdma_leave_multicast(mc->ctx->cm_id,..
>>
>> Fix it by latching the ref at 0. Once it goes to 0 mc and ctx cannot
>> leave the mutex(mut) protection.
>>
>> The other atomic_inc in ucma_get_ctx is OK because mutex(mut) protects=

>> it from racing with ucma_destroy_id.
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
> Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This has been picked up.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tUhC4JJuPjwssRd0UhM5MfUqILwRG6DvM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzpRRAAoJELgmozMOVy/d/egP/3yv8juTVLPDt5ZeFHu39jmI
Rbtx7adqykWugmlE1H4s6/T79voebLimhD8ErvssSgWVQeX3fh4PLNsmW4FDZg7F
WFuMid4JGNVKMTluTV2znv3bWJE2gEZGZb6SvOyJ6Jii0HzQpCpetgY/GczZvJu5
CgsJImeTAdq5Bj+73HYNhkCz5huXkqa2Z3nz2ziHrXgh8x5S32/e1KpnCtDHVIz5
vN1Iw9VWWcC7BgJKod06MW15coGe5vydzw28ZQ7otduyGS7pGQ6D5KUo0lTq1ziE
BTuTFVv0nFrA7Ff23UNQmiO5UxruaIM47bkAvyTOm/D/RTHToVHkurFsvUq44ZiM
Tp62dCPxdUcriq4FMUrhVkyiwM+ClaeSr+eeVKJ9gEoxyDRv/rGfgQxitU2o7+11
jKA3GgCO68m6MCoVRK8FkGZmNhONIuxif1O9PZcOlKcvIwvAnWeuYI2o5iXZrPiy
zp0cUPZwCyLO0Fwx4w5eva5TNeMscxnubm3cfviro7J6obQWE/V95750nCCjfin3
+skE8ZmIgN3cg/XoBgyYnHJZAsW8f8bB6uiseWeKX28lx39jh/Z72+iGfqtif808
cW3EpqAg4L9zUnYXARdoQKLqPVSObjeCAKlEzbx5rq/EHfATIJup+s6a9Fxh9xqN
n4/6pRunzImORPulihkY
=iLUM
-----END PGP SIGNATURE-----

--tUhC4JJuPjwssRd0UhM5MfUqILwRG6DvM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
