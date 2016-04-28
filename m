From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 17:05:35 -0400
Message-ID: <57227B1F.5070306@redhat.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com> <20160419183830.GB1211@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pTlo6ltI2DSXrQiHhAt4xNgOlo8pdErWa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160419183830.GB1211-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pTlo6ltI2DSXrQiHhAt4xNgOlo8pdErWa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/19/2016 02:38 PM, Christoph Hellwig wrote:
> On Tue, Apr 19, 2016 at 11:30:32AM -0600, Jason Gunthorpe wrote:
>> Right, this was done because rdma_protocol_iwarp takes a port number.
>>
>> I think we discussed this once, the core code doesn't actually support=

>> different protocols on different ports, so the port_num argument to
>> rdma_protocol_iwarp is redundant.
>>
>> This all starts to look really goofy when multi-port APM is used and
>> the QP's port number changes dynamically at runtime. (I have some
>> experimental patches that do that), I'd rather see all the port_num
>> stuff in this series go away. :(
>=20
> Reall, I would _love_ to kill all that port_num crap.  But until
> we get agreement from Doug and all the core maintainers that we
> can kill it from the core, and that multi-protocol devices are
> indeed as silly as they seem I can't..
>=20

No worries, the patchset (and the subsequent series you promised a few
emails later in this thread) can proceed ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--pTlo6ltI2DSXrQiHhAt4xNgOlo8pdErWa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXInsfAAoJELgmozMOVy/dAqEP/iamAoaqge9LQE0fRzNJKB/G
Ua8j7/E9o6ge9WsMUSoFwVw9fDyUiw6Zg8OQ2G525HyDcA08/wMYYT7iuCHs56Hr
QH8DVqaFgolYsHtSEd9dSK7mRyKYxJJJ1wEjyN9Sjlcf2j5oBoV5c8y3gZSjqTFq
JcW9oVpUF4owHhAgD5KzQyL2gP9MBJmMRtX6AH0VQeA1wKW856ZjH9dLuivnVUY0
97dBZqIaT/TKK/fmevduKZUh1kfvFYedJNwgEuxEZC2dGIp+pvQAbRC9q6n2ISh8
EJ7FWNp2V3wpavEGIu7JSkMMBHifhHmBGITVNtpbJJmoalsWn38061PhY0YJA0AA
Dg/JuJdmyXwaAh+hDrz8gDSLH5KapEE39B0KYjV0RBItOniFNnd2ntgbkWubkg4U
Z5iQBJOaGp0vTPPa9g3zy66x0K44RcUY67RU2ILHTnYGGNHwGfTPzH206KyMAXqs
09ryLYybnYG5PWGWyWqL2M0bUorB5h1rtKFZpkJAhcwQw2iQMph8Kum8uxBjwwiv
d/E9+HamTqyH3oTL2Z8oBzlyDoiKDRSviJYyphYsoQ+pV2zkY/tQnXdrogiJt34e
FO/tKDliXHY6aPjbpUgQz++JhRQlPUnf1o0R9I8ogh5RAGYOMFgtd3LVyKnBtS3S
0eLe1PwLIBCq9LUMyohv
=3NJB
-----END PGP SIGNATURE-----

--pTlo6ltI2DSXrQiHhAt4xNgOlo8pdErWa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
