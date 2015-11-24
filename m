From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 3/9] xprtrdma: Introduce ro_unmap_sync method
Date: Tue, 24 Nov 2015 10:20:10 -0500
Message-ID: <0632A14B-5391-4AAC-8F05-1809A092F04B@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net> <20151123221414.32702.87638.stgit@manet.1015granger.net> <20151124064556.GA29141@infradead.org> <565442F5.7080400@dev.mellanox.co.il> <4B2D7C66-31AC-44F3-A8CC-22CC7136015C@oracle.com> <565477CC.5070309@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565477CC.5070309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 9:44 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>=20
> Hey Chuck,
>=20
>>=20
>>> It is painful, too painful. The entire value proposition of RDMA is
>>> low-latency and waiting for the extra HW round-trip for a local
>>> invalidation to complete is unacceptable, moreover it adds a huge l=
oads
>>> of extra interrupts and cache-line pollutions.
>>=20
>> The killer is the extra context switches, I=92ve found.
>=20
> That too...
>=20
>> I=92ve noticed only a marginal loss of performance on modern
>> hardware.
>=20
> Would you mind sharing your observations?

I=92m testing with CX-3 Pro on FDR.

NFS READ and WRITE round trip latency, which includes the cost
of registration and now invalidation, is not noticeably longer.
dbench and fio results are marginally slower (in the neighborhood
of 5%).

=46or NFS, the cost of invalidation is probably not significant
compared to other bottlenecks in our stack (lock contention and
scheduling overhead are likely the largest contributors).

Notice that xprtrdma chains together all the LOCAL_INV WRs for
an RPC, and only signals the final one. Before, every LOCAL_INV
WR was signaled. So this patch actually reduces the send
completion rate.

The main benefit for NFS of waiting for invalidation to complete
is better send queue accounting. Even without the data integrity
issue, we have to ensure the WQEs consumed by invalidation
requests are released before dispatching another RPC. Otherwise
the send queue can be overrun.


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
