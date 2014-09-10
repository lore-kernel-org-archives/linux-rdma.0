From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
Date: Wed, 10 Sep 2014 11:51:47 +0300
Message-ID: <54101123.2080208@mellanox.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com> <5405D2D8.1040700@mellanox.com> <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com> <CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com> <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com> <540F0CD8.9070002@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540F0CD8.9070002-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Latchesar Ionkov <lionkov-YOWKrPYUwWM@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/09/2014 17:21, Haggai Eran wrote:
> On 04/09/2014 00:15, Roland Dreier wrote:
>> Have you done any review or testing of these changes?  If so can you
>> share the results?
>=20
> We have tested this feature thoroughly inside Mellanox. We ran random
> tests that performed MR registrations, memory mappings and unmappings=
,
> calls to madvise with MADV_DONTNEED for invalidations, sending and
> receiving of data, and RDMA operations. The test validated the integr=
ity
> of the data, and we verified the integrity of kernel memory by runnin=
g
> the tests under a debugging kernel.

We wanted to add regarding performance testing of these patches, we hav=
e
tested ODP on several setups, including low-level RDMA micro-benchmarks=
,
MPI applications, and iSER. In all cases, ODP delivers the *same*
bare-metal performance as obtained with standard MRs, in terms of both
BW and latency. In addition, performance of standard MRs is not affecte=
d
by the presence of ODP applications.

The main benefits of ODP is the simplified programming model, simplifie=
d
management, and avoiding worst-case memory commitment.
=46or example, we were able to run multiple concurrent instances of iSE=
R
targets, allowing over-commitment that otherwise wouldn=E2=80=99t be po=
ssible.
In the MPI case, both IMB (Pallas) and applications achieved the same
performance as the pin-down cache, with minimal memory locking
privileges while avoiding any glibc hooks for detecting invalidations.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
