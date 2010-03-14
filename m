From: Tim Wright <tim.wright-c+vHNXOUHMmEK/hMebVsMw@public.gmane.org>
Subject: =?iso-8859-1?Q?Re:_Na=EFve_question_wrt_ibv=5Freg=5Fmr(),_pinned_pages_an?=
 =?iso-8859-1?Q?d_Linux_VM?=
Date: Sun, 14 Mar 2010 15:56:46 -0400
Message-ID: <C7C28D8C.10DE%tim.wright@rnanetworks.com>
References: <20100314102239.GA23358@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100314102239.GA23358-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Content-Language: en
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,
Thank you for replying. Yes the call succeeds and the memory is clearly
pinned at least from the perspective of the kernel, and the RDMA operat=
ions
do happen on the correct memory. The problem is that the pages get stol=
en
from the resident set of the program, which is inefficient, and doesn=B9=
t seem
to make a lot of sense since it doesn=B9t free much of anything since t=
he
memory is locked. What does seem to happen under load is that the proce=
ss
page tables can get kicked out making access to the pinned memory very =
slow.
Of course other parts of the application are also subject to paging, so
mlock() is really necessary anyway if my goal is to avoid paging, but I=
 was
surprised that the memory was only pinned into physical memory and not =
also
locked into the calling process=B9 address space.

=46or my purposes, it seems mlockall() is the solution, and it appears =
to
interact just fine with the underlying get_user_pages() operations.

Regards,

Tim



On 3/14/10 3:22 AM, "Eli Cohen" <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Tim,
> the memory you register using ibv_reg_mr() is pinned and the pages
> cannot be used for anything else until you release them through a
> call to ibv_dereg_mr() (or the process terminates). There is no need
> to use mlock.
> Did you check that the call to ibv_reg_mr() succedded?
>=20
> On Fri, Mar 12, 2010 at 09:36:48PM -0500, Tim Wright wrote:
>> Hello everybody,
>> I have a question regarding behavior of the memory pinning using
>> ibv_reg_mr() on RHEL/Centos 5.3/OFED-1.4.1. This may be more a Linux
>> feature/issue, and I apologize if that is the case. Here is the scen=
ario
>>=20
>> 1. An application runs which allocates a significant fraction of the=
 system
>> memory as RDMA buffers (e.g. 3GB of ram on a 4GB system). These are =
setup
>> using ibv_reg_mr(). It is clear that the pages are pinned from the k=
ernel
>> perspective. With just this program running, the resident set size o=
f the
>> program approaches the allocation size.
>> 2. If other memory-intensive processes are now started, the resident=
 set
>> size of the RDMA-using program shrinks dramatically.
>> 3. Even if the other memory-intensive programs are stopped, and the
>> RDMA-using program is forced to read its memory, the resident set ne=
ver
>> grows to a =B3reasonable=B2 size again.
>>=20
>> My potentially foolish assumptions are/were that:
>> i) Since the memory is pinned anyway, it would be locked into the pr=
ocess
>> address space, and
>> ii) even if that were not the case, that the process would be able t=
o regain
>> a large RSS when any competing processes stopped.
>>=20
>> For ii), it almost seems that the VM doesn=B9t realize that the page=
s it would
>> be grabbing back are already resident and therefore won=B9t actually=
 take any
>> more memory.
>>=20
>> Clearly, I can use mlock() to avoid the issue, but I was wondering i=
f I have
>> missed something obvious here. Any clues/brickbats gratefully receiv=
ed!
>>=20
>> Regards,
>>=20
>> Tim Wright
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
