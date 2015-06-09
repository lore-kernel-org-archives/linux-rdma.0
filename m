From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Tue, 9 Jun 2015 11:06:25 -0400
Message-ID: <E8ADF079-90BC-4F2E-965D-C4BA78F43C0B@oracle.com>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com> <20150608132254.GA14773@infradead.org> <55759B0B.8050805@mellanox.com> <20150608135151.GA14021@infradead.org> <5575A9C7.7000409@dev.mellanox.co.il> <20150609062054.GA13011@infradead.org> <5576A760.4090004@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5576A760.4090004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jun 9, 2015, at 4:44 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:

> On 6/9/2015 9:20 AM, Christoph Hellwig wrote:
>> On Mon, Jun 08, 2015 at 05:42:15PM +0300, Sagi Grimberg wrote:
>>> I wouldn't say this is about offloading bounce buffering to silicon=
=2E
>>> The RDMA stack always imposed the alignment limitation as we can on=
ly
>>> give a page lists to the devices. Other drivers (qlogic/emulex FC
>>> drivers for example), use an _arbitrary_ SG lists where each elemen=
t can
>>> point to any {addr, len}.
>>=20
>> Those are drivers for protocols that support real SG lists.   It see=
ms
>> only Infiniband and NVMe expose this silly limit.
>=20
> I agree this is indeed a limitation and that's why SG_GAPS was added
> in the first place. I think the next gen of nvme devices will support=
 real SG lists. This feature enables existing Infiniband devices that c=
an handle SG lists to receive them via the RDMA stack (ib_core).
>=20
> If the memory registration process wasn't such a big fiasco in the
> first place, wouldn't this way makes the most sense?
>=20
>>=20
>>>> So please fix it in the proper layers
>>>> first,
>>>=20
>>> I agree that we can take care of bounce buffering in the block laye=
r
>>> (or scsi for SG_IO) if the driver doesn't want to see any type of
>>> unaligned SG lists.
>>>=20
>>> But do you think that it should come before the stack can support t=
his?
>>=20
>> Yes, absolutely.  The other thing that needs to come first is a prop=
er
>> abstraction for MRs instead of hacking another type into all drivers=
=2E
>>=20
>=20
> I'm very much open to the idea of consolidating the memory registrati=
on
> code instead of doing it in every ULP (srp, iser, xprtrdma, svcrdma,
> rds, more to come...) using a general memory registration API. The ma=
in
> challenge is to abstract the different methods (and considerations) o=
f
> memory registration behind an API. Do we completely mask out the way =
we
> are doing it? I'm worried that we might end up either compromising on
> performance or trying to understand too much what the caller is tryin=
g
> to achieve.

The point of an API like this is to flatten the developer=92s learning
curve at the cost of adding another layer of abstraction. For
in-kernel storage ULPs, I=92m not convinced that=92s a good trade-off.

The other major issue is dealing with multiple registration methods.
Having new ULPs stick with just one or two seems like it could take
care of that without fuss. HCA vendors seem to be settling on FRMR.

But FRMR has some limitations, some of which I discuss below. IMO it
would be better to think about improving existing limitations with
=46RMR before building a shim over it. That could help both the
learning curve and the complexity issues.

On with the pre-caffeine musings:

> For example:
> - frwr requires a queue-pair for the post (and it must be the ULP
>  queue-pair to ensure the registration is done before the data-transf=
er
>  begins).

The QP does guarantee ordering between registration and use in an RDMA
transfer, but it comes at a cost.

And not just a QP is required, but a QP in RTS (ie, connected). Without
a connected QP, AIUI you can=92t invalidate registered FRMRs, you have =
to
destroy them.

So, for RPC, if the server is down and there are pending RPCs, any FRMR=
s
associated with that transport are pinned (can=92t be re-used or invali=
dated)
until the server comes back. If an RPC is killed or times out while the
server is down, the associated FRMRs are in limbo.

Registration via WR also means the ULP has to handle the registration a=
nd
invalidation completions (or decide to leave them unsignaled, but then
it has to worry about send queue wrapping).

All transport connect operations must be serialized with posting to ens=
ure
that ib_post_send() has a valid (not NULL) QP and ID handle. And, if a =
QP
or ID handle is used during completion handling, you have to be careful
there too.

(Not to say any of this is impossible to deal with. Obviously RPC/RDMA
works today.)

> While fmrs does not need the queue-pair.

> - the ULP would probably always initiate data transfer after the
>  registration (send a request or do the rdma r/w). It is useful to
>  link the frwr post with the next wr in a single post_send call.
>  I wander how would an API allow such a thing (while other registrati=
on
>  methods don't use work request interface).

rkey management is also important. Registration is done before use so
the ULP can send the rkey for that FRMR to the remote to initiate the
remote DMA operation.

However, after a transport disconnect, the rkey in the FRMR may not be
the same one the hardware knows about. Recovery in this case means the
=46RMR has to be destroyed. Invalidating the FRMR also requires the ULP
to know the hardware rkey, so it doesn=92t work in this case.

What all this means is that significant extra complexity is required to
deal with transport disconnection, which is very rare compared to norma=
l
data transfer operations.

=46MR, for instance, has much less of an issue here because the map and
unmap verbs are synchronous, do not rely on having a QP, and do not
generate send completions. But FMR has other problems.

> - There is the fmr_pool API which tries to tackle the disadvantages o=
f
>  fmrs (very slow unmap) by delaying the fmr unmap until some dirty
>  watermark of remapping is met. I'm not sure how this can be done.

I wonder if FMR should be considered at all for a simplified API. Sure,
there are some older cards that do not support FRMR, but seems like FMR
is going to be abandoned sooner or later.

> - How would the API choose the method to register memory?

Based on the capabilities of the HCA, I would think.

> - If there is an alignment issue, do we fail? do we bounce?
>=20
> - There is the whole T10-DIF support=85

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
