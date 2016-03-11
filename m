From: Asgeir Eiriksson <asgeir.eiriksson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA power failure write atomicity
Date: Thu, 10 Mar 2016 17:33:39 -0800
Message-ID: <0E25BAE6-9091-4B28-A2A9-2F41BD97145A@gmail.com>
References: <56E20734.4030208@vlnb.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E20734.4030208-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Vladislav,

This is an area of active R&D

You might be interested in the following (at ietf.org):

Title           : RDMA Durable Write Commit
        Authors         : Tom Talpey
                               Jim Pinkerton
                          <>
	Filename      : draft-talpey-rdma-commit-00.txt
	Pages          : 24
	Date            : 2016-02-19

Regards,

=91Asgeir


> On Mar 10, 2016, at 3:45 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wro=
te:
>=20
> Hello,
>=20
> I'm currently considering to use NVDIMM behind RDMA and wonder what i=
s RDMA power
> failure write atomicity? I mean, what is minimal size and alignment g=
uaranteed to be
> written atomically in face of power failure (or some other similar fa=
ilure), i.e.
> either written in full, or not written at all?
>=20
> For memory writes on Intel it is 8 bytes with 8 bytes alignment. Is t=
here anything like
> this for RDMA? Or different vendors/implementation have so different =
expectations and
> promises, so you can not assume anything >1 byte?
>=20
> I can't find such info anywhere.
>=20
> Thanks,
> Vlad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
