From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch infiniband-diags:perfquery] Loop through all local HCAs/ports
Date: Sat, 30 Jul 2011 10:11:16 -0400
Message-ID: <4E341104.90105@redhat.com>
References: <4E332CE5.3010706@redhat.com> <20110729220912.GL18090@obsidianresearch.com> <4E3330AF.9050208@redhat.com> <20110729222612.GM18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF3E65854D79B56448A389B5B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110729222612.GM18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3E65854D79B56448A389B5B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 7/29/2011 6:26 PM, Jason Gunthorpe wrote:
>>> Not sure what I think of this, is dumping counters on all local HCA
>>> ports really that interesting? Would this be better done by doing
>>> something fancy with nodeGUID so at least all ports on remote HCAs ca=
n
>>> be dumped too?
>>
>> The request came in from one of our partners who wanted it for
>> tracking performance stats specifically on the local machine.
>=20
> Well, I think it would be best to make this work generally which is
> fairly hard, unfortunately.
>  - If the destination is the local HCA then you have to iterate over
>    all local ports with matching node GUIDs by opening devices
>  - If the destination is a remote HCA then you have to query the SA
>    for all nodes with a matching GUID and iterate over them. Ira has
>    been working on some common code for this..
>  - Maybe you want to cross product and try to query the SA attached to
>    all local end ports to try and find all ports. That would actually b=
e
>    very useful for many situations I know of...
>=20
> Could you make your patch just do #1 and continue to misbehave for
> the other cases?

Well, it sort of already does.  The patch looks bigger than it is
because I had to re-indent in order to put the main functional code
inside of a loop.  For the most part, the loop is unchanged.  Just apply
the patch then look at what we do when all_hcas is non-0 right before
the do { and right before the } while (ibd_ca);  It iterates over all
the hca names that libibumad gives us, and then loops over all the ports
as returned by libibumad's umad_get_ca().


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigF3E65854D79B56448A389B5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk40EQoACgkQQ9aEs6Ims9hTggCg94iFRwMtUnGLmVNhNjYrW5ap
qF8AoLX0rJsMVR/a9BLXfLfppfyyQBNB
=FYjX
-----END PGP SIGNATURE-----

--------------enigF3E65854D79B56448A389B5B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
