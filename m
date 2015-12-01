From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add ro_unmap_sync method for FMR
Date: Tue, 1 Dec 2015 10:33:18 -0500
Message-ID: <AE86B182-6000-4437-8502-9D2C5EC3B09D@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net> <20151123221430.32702.86114.stgit@manet.1015granger.net> <5653B606.3070700@talpey.com> <20151124065225.GB29141@infradead.org> <20151124071215.GC23597@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124071215.GC23597-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 2:12 AM, Jason Gunthorpe <jgunthorpe@obsidianrese=
arch.com> wrote:
>=20
> On Mon, Nov 23, 2015 at 10:52:26PM -0800, Christoph Hellwig wrote:
>>=20
>> So at lest for 4.5 we're unlikely to be able to get rid of it alone
>> due to the RDS issue.  We'll then need performance numbers for mlx4,
>> and figure out how much we care about mthca.
>=20
> mthca is unfortunately very popular in the used market, it is very
> easy to get cards, build a cheap test cluster, etc. :(

Oracle recently announced Sonoma, which is a SPARC CPU with
an on-chip IB HCA. Oracle plans to publish an open-source
GPL device driver that enables this HCA in Linux for SPARC.
We=E2=80=99d eventually like to contribute it to the upstream
Linux kernel.

At the moment, the device and driver support only FMR. As
you might expect, Oracle needs it to work at least with
in-kernel RDS. Thus we hope to see the life of in-kernel
=46MR extended for a bit to accommodate this new device.


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
