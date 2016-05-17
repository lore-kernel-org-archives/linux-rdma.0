From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CQ and RDMA READ/WRITE APIs
Date: Tue, 17 May 2016 13:32:21 -0400
Message-ID: <732fb772-2f21-3ac9-a35a-aa4383734df5@redhat.com>
References: <743399f9-10b7-6e62-2bf4-6a8656df8a55@redhat.com>
 <20160516114926.GA681@lst.de>
 <f6fdfc59-8193-18ed-0449-a16bba4601e0@redhat.com>
 <CA+55aFzq+4DJL46B8PXQQG-DpNpzZNzk=O6j+8U_NC6H6BwTdQ@mail.gmail.com>
 <6633ce02-7983-ad09-f95d-03cea6f54e31@redhat.com>
 <573B550D.5020008@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LF4tm5uWab6SvBouPHEciScxrNcFkSgU5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <573B550D.5020008-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LF4tm5uWab6SvBouPHEciScxrNcFkSgU5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/17/2016 01:29 PM, Bart Van Assche wrote:
> On 05/16/2016 11:23 AM, Doug Ledford wrote:
>> In this particular case, the dual license is used by the OpenFabrics
>> Alliance.  They strip the RDMA stack in the kernel down to just the RD=
MA
>> stack files and ship those separate from the rest of the kernel, along=

>> with the necessary user space stuff, and put the entire compilation
>> under the same dual GPL/BSD license.  That's what their OFED product i=
s.
>>
>> As I understand it, members of the OFA (Intel, Mellanox, Chelsio, etc.=
)
>> actually signed an agreement as part of their membership entry into OF=
A
>> that they would preserve that dual license when submitting code
>> upstream.  This was originally intended to make sure that the stack as=
 a
>> whole could be used upstream, in distros, on switches, etc.  The idea
>> being that a unified stack that could be copied around would enhance
>> interoperability or something like that.
>>
>> I can't speak to how actively used it is any more.  I think maybe on
>> switches or some other dedicated devices.  But, I was asked by the OFA=

>> to try and preserve it.
>>
>> In this particular case, Christoph wrote his code from scratch.  I'm n=
ot
>> concerned with it.  It was never dual licensed and need not be.  But h=
e
>> did submit patches that modified existing dual license drivers to use
>> his new code and removed their own implementation of the same thing in=

>> the process.  What used to be more or less functional drivers that cou=
ld
>> be copied and used elsewhere will no longer be able to be copied in th=
e
>> same way.  I'm just waiting for Sagi Grimberg to speak for iSER and fo=
r
>> Bart van Assche to speak for SRP and let me know that they are OK with=

>> the change.  I think a patch set that will essentially change the
>> licensing nature of their code should carry their explicit approval of=

>> the license change.
>=20
> (+linux-rdma)
>=20
> Hello Doug,
>=20
> As far as I know SanDisk, a Western Digital Company, is fine with
> changing the license of the code under drivers/infiniband/ulp/srpt from=

> dual licensed into GPL-only. However, if OFA members want that the
> entire RDMA core is dual licensed I think we will have to talk to Tejun=
:
>=20
> $ PAGER=3D git grep EXPORT_SYMBOL_GPL drivers/infiniband/
> drivers/infiniband/core/device.c:EXPORT_SYMBOL_GPL(ib_wq);
>=20
> $ git show f06267104dd9112f11586830d22501d0e26245ea
> commit f06267104dd9112f11586830d22501d0e26245ea
> Author: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date:   Tue Oct 19 15:24:36 2010 +0000
>=20
>     RDMA: Update workqueue usage
>=20
> [ ... ]
> +struct workqueue_struct *ib_wq;
> +EXPORT_SYMBOL_GPL(ib_wq);
> [ ... ]
>=20
> $ PAGER=3D git grep -lw ib_wq drivers/infiniband/
> drivers/infiniband/core/cache.c
> drivers/infiniband/core/device.c
> drivers/infiniband/core/roce_gid_mgmt.c
> drivers/infiniband/core/sa_query.c
> drivers/infiniband/core/umem.c
> drivers/infiniband/hw/qib/qib_iba7220.c
> drivers/infiniband/hw/qib/qib_iba7322.c
> drivers/infiniband/hw/qib/qib_init.c

Nice catch there Bart.  That was well before my role as maintainer and
so settles things well enough for me.  IOW, I don't feel I need to worry
about trying to maintain the dual license nature of the RDMA stack as it
was broken long before I took over.  Thanks for pointing that out.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--LF4tm5uWab6SvBouPHEciScxrNcFkSgU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXO1WlAAoJELgmozMOVy/dxoAQAKPRNRBOEptAvGnu4BggrG2L
E9s8mSHWoACkiQEa4N+3ObGRs76JG0s2LBIfj7yyu8RVO+QTSa267GsJpHTbTQ6w
qE4waTwGCliDKklF0F9F/9dllhupB6ZMWDfLiyvdLl7IbCLveTSgrhP+tr2NNGKT
RiRMFneYCuJ/tjWPvasMh93rE+eacZuPgQJOnUZGjWioOOl0g+aOvBG0Ez6AkF8d
FwxzN/rVE+gQELlRwQE/KhVBYMAjPbgM6r8SpHwPu2e3svW2YeZVxNXWm80fb+sH
QTrdrByFNBgHJXUwL73eHwyQx8KjRNrUkXTv9a13/10r331WUqQz8Q0mw76CUHVS
FKdmn5ggW5uPXxAYHkk5OrM4KQ5Lbtz0PCyAe8odER5w9w4o+FIcQ91QoS9jqoGy
jNBnLaozvJp5b8b/+z/R6CcbHV/dPZCdNqbZkmvJriMWoXTG7ecZraQ6I7FIs4DQ
MIGgAWYKWI1a12VDR5QKu1PbwY+QtB0W0Ej8vM8Mu6Qp4VU7XrUqY+qdsi3m3kcU
jHCjP9gey8pxeNyG2069vW/hhaejx8LbmMLfC1lQUA7ruTuAeNXHmkoyhiJ5K9fo
xeISAErIA9Up4kptioYuMTX1HyzQxNZxBDwh8TOTaQkQjd3MbMCF37RPmyIf0PMe
h8RgfjtIjmu5vT0C/gd0
=OPH+
-----END PGP SIGNATURE-----

--LF4tm5uWab6SvBouPHEciScxrNcFkSgU5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
