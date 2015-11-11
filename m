From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Wed, 11 Nov 2015 15:50:48 -0500
Message-ID: <51EFCA05-7CA4-44AA-8AAF-21D1853C143D@oracle.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com> <1447152255-28231-3-git-send-email-sagig@mellanox.com> <20151110114145.GA2810@infradead.org> <5641D920.5000409@mellanox.com> <20151110120432.GA8230@infradead.org> <20151110182546.GI12667@obsidianresearch.com> <56425AFB.30202@talpey.com> <20151110211716.GA21631@obsidianresearch.com> <564261EF.4000008@talpey.com> <54CF0111-E9C4-4196-BF92-7E134A6A329A@oracle.com> <56430A20.6040600@dev.mellanox.co.il> <D4228973-6DFA-4181-9848-41BFE8E75200@oracle.com> <56436CDB.6090305@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56436CDB.6090305-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 11, 2015, at 11:29 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>=20
>=20
>=20
>> An alternate explanation is that the provider is not setting
>> device->max_sge_rd properly. rdma_read_chunks_lcl() seems to
>> be the only thing in my copy of the kernel tree that relies on
>> that value.
>>=20
>> I=92ve reproduced the local length errors with CX-2 and CX-3
>> Pro, which both set that field to 32. If I artificially
>> set that field to 30, I don=92t see any issue.
>>=20
>> Is commit 18ebd40773bf correct?
>=20
> See my latest patchset "Handle mlx4 max_sge_rd correctly" (v2).
>=20
> It fixes exactly this.
> Now you will be able to add your "Tested-by:" tag  ;)

Confirmed that the current value (32) does not work, and
that the proposed replacement (30) does work, in an NFS
server that uses the _lcl path with mlx4.


> It on Doug to take it...

Noted that the NFS server=92s _lcl path is the only
kernel consumer of this value.

Because the current NFS server does not use the _lcl
path with mlx4 devices, maybe this fix is not needed in
stable, unless the max_sge_rd field is visible to user
space.

However no future changes to the NFS server=92s reader
selection logic should be made until this fix, or one
like it, is merged. And I recommend adding a
"Fixes: 18ebd40773bf" tag.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
