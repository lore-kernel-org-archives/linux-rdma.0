From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 3/9] xprtrdma: Introduce ro_unmap_sync method
Date: Tue, 24 Nov 2015 09:39:33 -0500
Message-ID: <4B2D7C66-31AC-44F3-A8CC-22CC7136015C@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net> <20151123221414.32702.87638.stgit@manet.1015granger.net> <20151124064556.GA29141@infradead.org> <565442F5.7080400@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565442F5.7080400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 5:59 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>=20
>=20
>=20
> On 24/11/2015 08:45, Christoph Hellwig wrote:
>> On Mon, Nov 23, 2015 at 05:14:14PM -0500, Chuck Lever wrote:
>>> In the current xprtrdma implementation, some memreg strategies
>>> implement ro_unmap synchronously (the MR is knocked down before the
>>> method returns) and some asynchonously (the MR will be knocked down
>>> and returned to the pool in the background).
>>>=20
>>> To guarantee the MR is truly invalid before the RPC consumer is
>>> allowed to resume execution, we need an unmap method that is
>>> always synchronous, invoked from the RPC/RDMA reply handler.
>>>=20
>>> The new method unmaps all MRs for an RPC. The existing ro_unmap
>>> method unmaps only one MR at a time.
>>=20
>> Do we really want to go down that road?  It seems like we've decided
>> in general that while the protocol specs say MR must be unmapped bef=
ore
>> proceeding with the data that is painful enough to ignore this
>> requirement.  E.g. iser for example only does the local invalidate
>> just before reusing the MR.

That leaves the MR exposed to the remote indefinitely. If
the MR is registered for remote write, that seems hazardous.


> It is painful, too painful. The entire value proposition of RDMA is
> low-latency and waiting for the extra HW round-trip for a local
> invalidation to complete is unacceptable, moreover it adds a huge loa=
ds
> of extra interrupts and cache-line pollutions.

The killer is the extra context switches, I=92ve found.


> As I see it, if we don't wait for local-invalidate to complete before
> unmap and IO completion (and no one does) then local invalidate befor=
e
> re-use is only marginally worse. For iSER, remote invalidate solves t=
his (patches submitted!) and I'd say we should push for all the
> storage standards to include remote invalidate.

I agree: the right answer is to use remote invalidation,
and to ensure the order is always:

  1. invalidate the MR
  2. unmap the MR
  3. wake up the consumer

And that is exactly my strategy for NFS/RDMA. I don=92t have
a choice: as Tom observed yesterday, krb5i is meaningless
unless the integrity of the data is guaranteed by fencing
the server before the client performs checksumming. I
expect the same is true for T10-PI.


> There is the question
> of multi-rkey transactions, which is why I stated in the past that
> arbitrary sg registration is important (which will be submitted soon
> for ConnectX-4).
>=20
> Waiting for local invalidate to complete would be a really big
> sacrifice for our storage ULPs.

I=92ve noticed only a marginal loss of performance on modern
hardware.


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
