From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Tue, 26 Apr 2016 09:18:04 -0400
Message-ID: <571F6A8C.9080100@redhat.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB045101@ORSMSX109.amr.corp.intel.com>
 <20160425181953.GC7675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B7V1MS5lqp4jWWLcC4dIv23chF6ruwlN8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425181953.GC7675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B7V1MS5lqp4jWWLcC4dIv23chF6ruwlN8
Content-Type: multipart/mixed; boundary="FVtD7ruB2FDxRn0mMFJpP4fXuocxe7VTA"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <571F6A8C.9080100-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Further thoughts on uAPI
References: <20160420012526.GA25508-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB044043-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20160421172428.GA5102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB045101-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20160425181953.GC7675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160425181953.GC7675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--FVtD7ruB2FDxRn0mMFJpP4fXuocxe7VTA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/25/2016 2:19 PM, Jason Gunthorpe wrote:

> There has been a lot of talk of using a structure like netlink with a
> linked list of binary attributes and an optional/mandatory flag. For
> the lower speed stuff that seems reasonable, though it is certainly
> over-engineered for some commands.
>=20
> So, a sketch would look like this:
>=20
> struct msg
> {
>    uint16_t length;
>    uint16_t class_id;
>    uint32_t object_id; // in/out
>    struct qp_base_attr
>    {
>        uint16_t length;
>        uint16_t attribute_id;
>=20
>        uint16_t qpn;  //in/out
>        uint16_t qp_flags;
>        uint16_t max_send_wr,max_recv_qr,max_send_sge,////
>    };
>    // Option to piggy back what ibv_modify_qp does:
>    struct qp_addr_ib
>    {
>        uint16_t length;
>        uint16_t attribute_id;
>=20
>        uint16_t dlid,slid,sl,pkey,etc;
>    }
> }
>=20
> msg.length =3D sizeof(msg);
> msg.class_id =3D RDMA_OBJ_QP_UD;
> msg.base.legnth =3D sizeof(msg.base);
> msg.base.attribute_id =3D RDMA_ATTR_QP_BASE;
> msg.base.qp_flags =3D XX
> [..]
> ioctl(fd,RDMA_CREATE_OBJECT,&msg);
> [..]
> ioctl(fd,RDMA_MODIFY_OBJECT,&msg2);

I think I would do it slightly differently.  In this example, the
class_id covers the entire list of commands.  It might be more desirable
if each command in the linked list was fully self-contained and
complete.  For the example of the cmtime program that's part of
librdamcm, when you run it with 1000s of connections as the test, being
able to pipeline 10, or 50, or 100 different commands would be useful to
the test.  Likewise, a verbs 2.0 application might want to build up a
chain of commands and pass the whole chain down in one ioctl.



--FVtD7ruB2FDxRn0mMFJpP4fXuocxe7VTA--

--B7V1MS5lqp4jWWLcC4dIv23chF6ruwlN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXH2qMAAoJELgmozMOVy/d0KQP/RX9fFJ4lE09NXm4mmzIZpgy
8GT+eW1DGl5emgciyqrEV0ChdmvqOzdAT+3TkpY/HwRBkTV7pqJH5ouhWzKSq0iz
E7Cjv395QbXxaf4quV/cONFvHTkMVz15AyfPv/0LdXkhl50tAlVcNNxftuWzsMzu
qltICXv8NF8glZVhPwL0jTlVpiJ1fJp3G3U6HKDcVcPofY5CE1jF7lw9hCc6h+Zn
FbM3W8/u3sUHlcHOECTt7QxiO7FFYiVpMhH2zsudEA2O7MYH0b+d3YJb3u1CVwLb
IoYQAdJR33/ZJZJKxU2P+Wb6kx+bX8FAuigHAq3DD3HYnkQjePiD4hlFGI+0VhDn
EW95QogA8Mq4p0t76qaW4GAICHW3t0cxg5qYG+6+Y1n/Kv4PTl7ah6mjC76RVt7Q
S1g0MEER8REFSZFi8V2uhXWfz+2LhPAMxPnDiXLY/BjUNDVHl2svdUqTKpBCrZ3U
67dFnrBywzdE5YxFFePnhBYVCubq+qU3XXfKG0TmYBRo0rA24wK9yzIOvJX6RJoP
o6OY7gpb2eHtdWeRALUtfmSWAzzSCKiYk0JftBBx/NEMLcp1BXCKE00lwpiawT+N
U+++f/+xNSMjHtYkSukuRpuDLU8vVUAxJz5r+TLUlRH6OM3zfkgq4pXCA6ro4zAl
OKyg3rvYJxr9Nl/SVlUE
=WWxV
-----END PGP SIGNATURE-----

--B7V1MS5lqp4jWWLcC4dIv23chF6ruwlN8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
