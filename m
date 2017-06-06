From: Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 11:51:18 +0000
Message-ID: <AM4PR0501MB1956B596450F3BC38806E775C4CB0@AM4PR0501MB1956.eurprd05.prod.outlook.com>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org>
 <20170605170825.GP6868@mtr-leonro.local>
 <20170605171749.GA20477@obsidianresearch.com>
 <20170605174151.GR6868@mtr-leonro.local>
 <alpine.DEB.2.20.1706051705350.886@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1706051705350.886-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Christoph Lameter [mailto:cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, June 06, 2017 1:11 AM
> To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; ahmad omary
> <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ahmad Omary
> <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Tzahi
> Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [RFC] libibverbs IB Device Memory support
>=20
> On Mon, 5 Jun 2017, Leon Romanovsky wrote:
>=20
> > It is rough calculation for 1MB, when I asked Ahmad about this
> > limitation (4K) he explained to me that exposed device memory is less
> > than 1MB.

Some of the devices supports less than 1MB internal device memory (256KB).=
=20
=20
> Still doesnt that mean more than 256 MPI instances or so per node?
>

In the above use case device, we can have only 64 processes per node which
Is critical for HPC.
=20
> The use case for a semaphore indicates that a 4k page would be shared
> between multiple processes? Therefore there is even less of a need of
> multiple pages.
>=20
> You may not be able to avoid the 4k page since page protection works only
> on a 4k level. The kernel futexes rely on 4k page protection tricks.
>=20

Vendor driver still allocates and map 4KB pages granularity. But in case th=
e
HW device supports less than 4KB, then the HW must provide the required pro=
tection.

> Please come up with a reasonable use case here.... We do not run MPI but
> our use cases work fine with mmapped 4k pages. There are some who
> actually would like 2M pages for that use case since some of the adapters
> have quite a bit of memory available.
>=20
> A small object allocator with the need to go through an intermediate laye=
r
> seems to be not very productive.
>=20

Note that the device memory does not necessary have to be mapped to the CPU=
.
i.e. is not necessary accessible by PCI, and can only be accessed by RDMA.
This is why we can't use MMAP for all cases  and a dedicated allocation and
 copy functions are needed.

Ahmad Omary

=20




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
