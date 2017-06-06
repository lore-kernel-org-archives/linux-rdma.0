From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 15:25:58 +0000
Message-ID: <HE1PR0501MB2812A79B8C1A52EAC4E2D8FAB1CB0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org>
 <20170605170825.GP6868@mtr-leonro.local>
 <20170605171749.GA20477@obsidianresearch.com>
 <20170605174151.GR6868@mtr-leonro.local>
 <alpine.DEB.2.20.1706051705350.886@east.gentwo.org>
 <AM4PR0501MB1956B596450F3BC38806E775C4CB0@AM4PR0501MB1956.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB1956B596450F3BC38806E775C4CB0-dp/nxUn679ggcKT3UpMsY8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Ahmad Omary

>=20
> Note that the device memory does not necessary have to be mapped to the
> CPU.
> i.e. is not necessary accessible by PCI, and can only be accessed by RDMA=
.
> This is why we can't use MMAP for all cases  and a dedicated allocation a=
nd
> copy functions are needed.
>=20

You can also automate efficient copies, barriers, and flushes even when you=
 do map a BAR directly.

Note that we are holding a concall today (*) to further discuss this topic.
--Liran

* See concall details at: http://marc.info/?l=3Dlinux-rdma&m=3D149660439926=
108&w=3D2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
