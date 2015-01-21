From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: consistency in the face of concurrent accesses
Date: Wed, 21 Jan 2015 16:28:12 -0500
Message-ID: <CADPSxAiVjYFm54qAuhA_JaLhKdTbLH3i4PGO8SDTcCv8j0N4-A@mail.gmail.com>
References: <loom.20150121T212810-619@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20150121T212810-619-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Erfan.

On Wed, Jan 21, 2015 at 3:32 PM, floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>
> Hello All,
>
> My question has to do with consistency in the face of concurrent acce=
sses.
> Specifically, I=E2=80=99d like to find the answers for the following =
questions:
>
> 1- Machine A submits an atomic operation to machine B=E2=80=99s memor=
y.
> Meanwhile, machine B=E2=80=99s CPU modifies the same memory region of=
 its local main
> memory (the modification is either in CPU cache or directly to the ma=
in memory).
> Can these two operations interfere with each other? for example, can =
they cause
> that region in the memory to end up corrupted.


A HCA's atomic operations are NOT atomic with respect to the attached
processor. For example, if both the processor and the RDMA NIC do an
atomic fetch-and-add on the same memory integer, the integer may not
get incremented by 2.

>
> 2- Machine A submits an RDMA READ operation to machine B=E2=80=99s me=
mory.
> Meanwhile, machine B=E2=80=99s CPU modifies the same memory region (a=
nd hence the
> changes are still in the cache).
> Is the remote RDMA READ coming from machine A able to see the changes=
 made
> by B=E2=80=99s local CPU?
> In other words, does RDMA READ flush out the remote CPU cache before
> reading the remote memory region? If not, this might result in some d=
irty reads.
>

RDMA reads use the CPU's cache coherence protocol (via the PCIe
controller) to get the most recent values. A caveat here is that PCIe
reads do not necessarily proceed in left-to-right address order, but
PCIe writes do. This is useful when using RDMA reads for consistency.

>
> 3- Do multiple operations from multiple HCA cards on a single machine=
 interfere
> with each other?
> For example, machine A has 2 HCA cards, and it receives two concurren=
t atomic
> operations, one from each of its HCA cards. Can they interfere with e=
ach other?
>

I'd expect that in the case of different PCIe cards, atomic operations
from one HCA are completely independent from another HCA. So they will
indeed interfere with each other.

Some useful papers about this (atomicity, RDMA staleness and ordering):
* https://www.usenix.org/conference/atc13/technical-sessions/presentati=
on/mitchell
* https://www.usenix.org/system/files/conference/nsdi14/nsdi14-paper-dr=
agojevic.pdf
* https://www.cs.cmu.edu/~akalia/doc/herd_readable.pdf

On Wed, Jan 21, 2015 at 3:32 PM, floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> Hello All,
>
> My question has to do with consistency in the face of concurrent acce=
sses.
> Specifically, I=E2=80=99d like to find the answers for the following =
questions:
>
> 1- Machine A submits an atomic operation to machine B=E2=80=99s memor=
y.
> Meanwhile, machine B=E2=80=99s CPU modifies the same memory region of=
 its local main
> memory (the modification is either in CPU cache or directly to the ma=
in memory).
> Can these two operations interfere with each other? for example, can =
they cause
> that region in the memory to end up corrupted?
>
> 2- Machine A submits an RDMA READ operation to machine B=E2=80=99s me=
mory.
> Meanwhile, machine B=E2=80=99s CPU modifies the same memory region (a=
nd hence the
> changes are still in the cache).
> Is the remote RDMA READ coming from machine A able to see the changes=
 made
> by B=E2=80=99s local CPU?
> In other words, does RDMA READ flush out the remote CPU cache before
> reading the remote memory region? If not, this might result in some d=
irty reads.
>
> 3- Do multiple operations from multiple HCA cards on a single machine=
 interfere
> with each other?
> For example, machine A has 2 HCA cards, and it receives two concurren=
t atomic
> operations, one from each of its HCA cards. Can they interfere with e=
ach other?
>
> Thank you in advance for your time.
> Cheers,
> Erfan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
