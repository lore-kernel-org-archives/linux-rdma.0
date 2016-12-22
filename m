From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Thu, 22 Dec 2016 16:38:32 -0500
Message-ID: <088eee62-e6e0-c54d-af34-636b4383f716@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221234014.GA13538@obsidianresearch.com>
 <0d77c962-607b-1e05-4fbf-41195446128d@redhat.com>
 <20161222173807.GA15461@obsidianresearch.com>
 <e300b2ab-c963-d755-895d-29c8a6dbdc94@redhat.com>
 <20161222202832.GA10732@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Plq0OWSBqdg219bt8Qo0MMM4JPf5s9v1I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222202832.GA10732-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Plq0OWSBqdg219bt8Qo0MMM4JPf5s9v1I
Content-Type: multipart/mixed; boundary="UBsONv3AM2atamfLHdrss7MVdEbkc5B9K";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <088eee62-e6e0-c54d-af34-636b4383f716-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
References: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161221234014.GA13538-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <0d77c962-607b-1e05-4fbf-41195446128d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222173807.GA15461-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <e300b2ab-c963-d755-895d-29c8a6dbdc94-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222202832.GA10732-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161222202832.GA10732-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--UBsONv3AM2atamfLHdrss7MVdEbkc5B9K
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 3:28 PM, Jason Gunthorpe wrote:
> On Thu, Dec 22, 2016 at 01:17:52PM -0500, Doug Ledford wrote:
>> On 12/22/2016 12:38 PM, Jason Gunthorpe wrote:
>>> On Thu, Dec 22, 2016 at 02:32:07AM -0500, Jarod Wilson wrote:
>>
>>> Yes.. Somehow libfabric is doing this:
>>>
>>> https://github.com/ofiwg/libfabric/releases
>>>
>>> It looks like they produced the .tar.gz by hand and then uploaded it
>>> again as an attached release file?
>>>
>>> Should we do this too, Doug?
>>
>> I was going to try changing the tag format on the next tag to get the
>> desired result.  So, instead of v12-rc4 or v12, rdma-core-12-rc4 or ju=
st
>> rdma-core-12.
>=20
> I don't know enough about github to comment..
>=20
> The advantage of the libfabric approach is that the tar.gz is produced
> once and never changed so we can provide the SHA2, while I'm not
> certain the github .tar.gz link is bit-for-bit content-stable?

Yeah, but the SHA hash of the git repo is, for all intents and purposes,
just as valid as a SHA for the tarball.  It's just verified in a
different way.  I can certainly see the benefit of the libfabric
approach for keeping the status quo happy though.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--UBsONv3AM2atamfLHdrss7MVdEbkc5B9K--

--Plq0OWSBqdg219bt8Qo0MMM4JPf5s9v1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXEfYAAoJELgmozMOVy/d+6kQAIQWENssEoCg7MBsnRKY2Xu9
kMBdE1feJ/bZ0o5DjHoE97i72LAZUOaRDHk4REu9xyETJH7uYwshL2Pz9AZioHah
QGCxj4fOAsr5+0RZF84j6JkHau35bzvl+DI5jktFPqIxsfv8717/erlA5IaRQYpI
73hm+QwUZ3BUa+Dq4et8GkHm+P5ja14m3F/dsf5giwmK7Hq9m5tasVrXI79+130w
3/yG5XMI0KpPLjI4MU2EsIamoGNbpozd63+4fnLAzvgBLJ/WlXfQJ9RTcGdQmhJz
RJ5RxQ0SrQCjM+j70Dj0Te6fFval64HN4QWf4LY2ee85r0Zir2c4NnGyepG10pgz
DsSgy/Ol4Mv4O1g/kHNeKL6rFnHymzd76+NF0mmDe1ZLpr2F1NnTopZfbNLRA9s/
mIKgUZR+vo72lnEsReiH1ID1VIx9dnfA/O6X29A8XtnmQjfDr4Tl5zJ5d1xuUC3X
4Ve0yydz9dAqxvUEzcdL7051fPI0GIBIgdDNBc0awEKj1YQFhie0iivzeoxqf1s+
GYJcMD4/IdOX8bw6JM0WtwYHjBaFBEhhjUEgOBaZx1Ya28LedIyZvdDaFs6undqu
QmCpsfjOVGtB0qYHFm0H6Fj8J95TBYV+4m9b+7sMzMRZWD3vKqywIR0Y4s5r3bGp
NuFokNQJCdi9bepwe79y
=NioP
-----END PGP SIGNATURE-----

--Plq0OWSBqdg219bt8Qo0MMM4JPf5s9v1I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
