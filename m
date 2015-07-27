From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Mon, 27 Jul 2015 11:57:46 -0400
Message-ID: <8A2BC019-1DC0-4531-9659-3181EE9A4B43@oracle.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-39-git-send-email-sagig@mellanox.com> <20150722170413.GE6443@infradead.org> <55AFD3DC.8070508@dev.mellanox.co.il> <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com> <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com> <20150724162657.GA21473@obsidianresearch.com> <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <903CDFB5-04FE-47B6-B044-E960E8A8BC4C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 24, 2015, at 1:46 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote=
:

> On Jul 24, 2015, at 12:26 PM, Jason Gunthorpe <jgunthorpe@obsidianres=
earch.com> wrote:
>=20
>> On Fri, Jul 24, 2015 at 10:36:07AM -0400, Chuck Lever wrote:
>>=20
>>> Unfinished, but operational:
>>>=20
>>> http://git.linux-nfs.org/?p=3Dcel/cel-2.6.git;a=3Dshortlog;h=3Drefs=
/heads/nfs-rdma-future
>>=20
>> Nice..
>>=20
>> Can you spend some time and reflect on how some of this could be
>> lowered into the core code?
>=20
> The point of the prototype is to start thinking about this with
> actual data. :-) So I=92m with you.
>=20
>=20
>> The FMR and FRWR side have many
>> similarities now..

IMO ib_unmap_fmr is a very different animal from LOCAL_INV WR.

ib_unmap_fmr is synchronous, provides no ordering guarantees with
send queue operations, and does not depend on a connected QP to
be available. You could emulate asynchronicity with a work queue
but that still does not provide SQ ordering. There are few if any
failure modes for ib_unmap_fmr.

LOCAL_INV WR is asynchronous, provides strong ordering with other
send queue operations, but does require a non-NULL QP in RTS to
work. The failure modes are complex: without a QP in RTS, the
post_send fails. If the QP leaves RTS while LOCAL_INV is in
flight, the LINV flushes. MRs can be left in a state where the
MR's rkey is not in sync with the HW, in which case a
synchronous operation may be required to recover the MR.

These are the reasons I elected to employ a synchronous
invalidation model in the RPC reply handler. This model can be
made to work adequately for both FMR and FRWR, provides
proper DMA unmap ordering guarantees for both, and hides wonky
transport disconnect recovery mechanics. The only downside
is the performance cost.

A generic MR invalidation API that buries underlying verb
activity and guarantees proper DMA unmap ordering I think would
have to be synchronous.

In the long run, two things will change: first, FMR will
eventually be deprecated; and second, ULPs will likely adopt
SEND_WITH_INV.

The complexion of MR invalidation could be vastly different in
a few years: handled entirely by the target-side, and only
verified by the initiator. Verification doesn't need to sleep,
and the slow path (the target failed to invalidate) can be
deferred.

All that would be necessary at that point would be a synchronous
invalidation API (synchronous in the sense that the invalidate
is complete if the API returns without error).


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
