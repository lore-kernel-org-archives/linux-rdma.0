From: Tim Wright <tim.wright-c+vHNXOUHMmEK/hMebVsMw@public.gmane.org>
Subject: =?iso-8859-1?Q?Na=EFve_question_wrt_ibv=5Freg=5Fmr(),_pinned_pages_and_Li?=
 =?iso-8859-1?Q?nux_VM?=
Date: Fri, 12 Mar 2010 21:36:48 -0500
Message-ID: <C7C03A40.9C2%tim.wright@rnanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello everybody,
I have a question regarding behavior of the memory pinning using
ibv_reg_mr() on RHEL/Centos 5.3/OFED-1.4.1. This may be more a Linux
feature/issue, and I apologize if that is the case. Here is the scenari=
o

1. An application runs which allocates a significant fraction of the sy=
stem
memory as RDMA buffers (e.g. 3GB of ram on a 4GB system). These are set=
up
using ibv_reg_mr(). It is clear that the pages are pinned from the kern=
el
perspective. With just this program running, the resident set size of t=
he
program approaches the allocation size.
2. If other memory-intensive processes are now started, the resident se=
t
size of the RDMA-using program shrinks dramatically.
3. Even if the other memory-intensive programs are stopped, and the
RDMA-using program is forced to read its memory, the resident set never
grows to a =B3reasonable=B2 size again.

My potentially foolish assumptions are/were that:
i) Since the memory is pinned anyway, it would be locked into the proce=
ss
address space, and
ii) even if that were not the case, that the process would be able to r=
egain
a large RSS when any competing processes stopped.

=46or ii), it almost seems that the VM doesn=B9t realize that the pages=
 it would
be grabbing back are already resident and therefore won=B9t actually ta=
ke any
more memory.

Clearly, I can use mlock() to avoid the issue, but I was wondering if I=
 have
missed something obvious here. Any clues/brickbats gratefully received!

Regards,

Tim Wright

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
