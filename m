From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] libibverbs IB Device Memory support
Date: Thu, 8 Jun 2017 13:10:34 +0000
Message-ID: <HE1PR0501MB2812BC7D5A7824FFD77B4D75B1C90@HE1PR0501MB2812.eurprd05.prod.outlook.com>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org>
 <20170605170825.GP6868@mtr-leonro.local>
 <20170605171749.GA20477@obsidianresearch.com>
 <20170605174151.GR6868@mtr-leonro.local>
 <alpine.DEB.2.20.1706051705350.886@east.gentwo.org>
 <AM4PR0501MB1956B596450F3BC38806E775C4CB0@AM4PR0501MB1956.eurprd05.prod.outlook.com>
 <alpine.DEB.2.20.1706061022270.16819@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1706061022270.16819-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Christoph Lameter [mailto:cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, June 06, 2017 6:30 PM

Hi Chistoph,

> The OS needs to provide the protection if that is the case and then it pr=
obably is
> not a HPC device. We are talking about RDMA high end devices here. The de=
sign
> here is for performance and low latency. I dont know of any devices in us=
e in
> HPC or in HFT that have these tiny memory sizes.
> Mostly these devices are already engineeded for mmapping.
>=20
> Is this for some kind of embedded device?
>=20

In our case, this is the HCA.
Device memory could be a scarce resource, and even allocating a 4K page per=
 process could wasteful in some systems.
An allocation API allows allocations of any size.

> > Note that the device memory does not necessary have to be mapped to
> > the CPU=3D .
> > i.e. is not necessary accessible by PCI, and can only be accessed by RD=
MA.
> > This is why we can't use MMAP for all cases  and a dedicated
> > allocation and  copy functions are needed.
>=20
> Can we come up with some sort of ioctl API then to write to the devices
> inaccessible memory? There must be other drives outside of the RDMA tree =
that
> have similar requirements and that may already have implemented some
> version of it.
>=20
> This seems to be a very specialized application that may be device specif=
ic. ioctls
> are usually used then.

The host to dev memcopy is often a user-space only action, so ioctl() doesn=
't work for us.
The memcpy API allows efficient data transfer regardless of the implementat=
ion.

I also don't think that always mandating a direct mmap() is the solution.
First, not in all cases such a mapping exists.
Some devices have only limited BAR space, which can only be dynamically map=
ped to a small window at a time. In this case, you might need to move the w=
indow before the access.
Other device might not be able to map device memory to the CPU at all.

Even if a direct mapping is possible, you don't expose mmap()'d IO memory d=
irectly to the application.
There are details such as optimizing for write-combining, locking, and flus=
hing that the application shouldn't be aware of.
--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
