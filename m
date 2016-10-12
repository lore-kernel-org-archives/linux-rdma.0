From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core release?
Date: Wed, 12 Oct 2016 14:15:27 -0400
Message-ID: <995642c1-ad77-a470-10d0-90bc60d50a53@redhat.com>
References: <20161012105103.GA30534@infradead.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174@infradead.org>
 <20161012164759.GB18838@obsidianresearch.com> <20161012173702.GW9282@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gic1dPFU6EcVD5hN8A30vKSLm3A7MIHpS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161012173702.GW9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gic1dPFU6EcVD5hN8A30vKSLm3A7MIHpS
Content-Type: multipart/mixed; boundary="g9faQ7CE6DCd5FEXP1kmc8O5Akx6jQQPI";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Message-ID: <995642c1-ad77-a470-10d0-90bc60d50a53-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core release?
References: <20161012105103.GA30534-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20161012164759.GB18838-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> <20161012173702.GW9282-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20161012173702.GW9282-2ukJVAZIZ/Y@public.gmane.org>

--g9faQ7CE6DCd5FEXP1kmc8O5Akx6jQQPI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/12/2016 1:37 PM, Leon Romanovsky wrote:
> On Wed, Oct 12, 2016 at 10:47:59AM -0600, Jason Gunthorpe wrote:
>> On Wed, Oct 12, 2016 at 09:31:49AM -0700, 'Christoph Hellwig' wrote:
>>> On Wed, Oct 12, 2016 at 09:43:08AM -0500, Steve Wise wrote:
>>>> I recommend we release something for OFED-4.8 to pull in.  That
>>>> might help flush out the release process earlier rather than
>>>> later.  Either way, though, I want the latest libcxgb4 in OFED-4.8
>>>> to support the new chelsio HW.  But we talked about the repo being
>>>> "always stable", so I guess the OFA could just pull the code and
>>>> use it?  Still would be nice to have it released...
>>>
>>> Yeah, I'd much prefer to release early, release often.  If people
>>> don't feel quite comfortable with the new bundle yet we can officiall=
y
>>> call it a pre-release.
>>
>> One of the best ways to get it tested is to get it to go through the
>> full OFED process.
>=20
> No problem, I'll grab all remaining patches from ML tomorrow and we wil=
l
> be ready for first release.

I wouldn't mind a pre-release, but I know for a fact that Jarod is
working on proper distro specific spec file(s), systemd units, etc.  So,
I wouldn't call it a release because until we sort out the specifics of
how we want the package to build/look/etc., it might change.  It would
be bad from for release 1 to have things packaged one way, and release 2
to totally revamp that.  We need to give Jarod time to sort through what
he's working on and post it to the list.

>>
>> Woody, what could we do to help make that happen? Do you know of any
>> blocker?
>>
>> I think this will be the best for everyone. I also predict that OFED
>> will be under pressure to quickly take up the new drivers that will
>> land in 4.9, and their user space will live in rdma-core.
>>
>> I also propose we give someone from the OFED team repo access and they=

>> can maintain a public branch for ofed-4.8 with any backported fixes.
>=20
> First of them, they need to express desire :)
> Let's start from pull request model and see if it is enough/not enough.=

>=20
>>
>> Jason


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--g9faQ7CE6DCd5FEXP1kmc8O5Akx6jQQPI--

--gic1dPFU6EcVD5hN8A30vKSLm3A7MIHpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX/n2/AAoJELgmozMOVy/d0iQQAIHfuAiG4fHk+uY5qrhk+o/z
kD9iqlNtvP4kOBoWY/tO9PC/lvklI26A00dbj8jXEkNMNkYvmrp7bH6LCN9Qd/Tt
J5PM2zf4XrqwtK+YAHyua0sQc1VYZ+hgmUzdVFLJokCZ9fjhgNC/zWm0zRTGNtAa
lkCRsphNKPQVaeOl058FG+4CweF26MStwfNO9td0RfKJIwfkKpOBcjbkVzV43j33
03Pc4tTzeS145qD4Hom51lTKqkxFGQc/F0LLqlCIWnA20b+y5469GppFf8EAD8pj
t9DdntGIDL2nDzWPpH7n4K8BGltuOoL4Mw+6/+ChQW7c5dozhyGe1QR1iK3YkQ1o
r24tUtnsGsZg933fxVM8oYKy3M1K9nK7AGAc3UJdPnOiFYs8YTzLuzq6hNZDCGfF
lhyZXrxP9h28GWQfANaugp757b5CIxSBIWRv46duOP7xz59Aci2zB1I4R0lCLC6d
96Tg8ASxPqUl5lvO7Xw4sCon67cYKKIdPuybz2c5/2iR7wQZ5dJBBtK+8Vva0XXV
8JIgGMMAE8mgDcQ50nXEpsX2XQhDN8KjoO4Fkxl8C9Zewv5IErzwts5vVncPDchf
/sR1U99ga2u2gukBIJQBAm/dxK+LY6xYBuCHsNnBLy+2s88jCYlBVuKHXOoUZpBF
D6vDkgxL3EMOOm4/mNRP
=VGPI
-----END PGP SIGNATURE-----

--gic1dPFU6EcVD5hN8A30vKSLm3A7MIHpS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
