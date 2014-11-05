From: Utz Bacher <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] DAPL support on s390x platform
Date: Wed, 5 Nov 2014 16:04:00 +0100
Message-ID: <OF2939B020.E253C5B0-ONC1257D87.0050AE0F-C1257D87.0052C3AA@de.ibm.com>
References: <1412933657-52641-1-git-send-email-aishchuk@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412933657-52641-1-git-send-email-aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Gonzalo Muelas Serrano <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mschwid2-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 10.10.2014 11:34:14:
> This patch series contains the changes to kernel and users pace libraries
> required to provide support for the DAPL API on s390x platform.
[...]
>    [PATCH 1/3] s390/kernel: add system calls for access PCI memory
> This patch contains the new system call implementation required for the
PCI
> I/O memory access from user space programs on s390x platform.
>    [PATCH 2/3] libibverbs: add support for the s390x plaform
> This patch contains the changes to the libibverbs user space library to
> provide support of the s390x platform.
>    [PATCH 3/3] libmlx4: add support for the s390x platform
> This patch contains the changes to the libmlx4 user space library
intended
> to provide the PCI I/O memory access on the s390x platform. The direct
> access to mapped memory areas is replaced by appropriate system call
> invocation.

  we have continued to work on this and every player seems to be willing to
proceed if you nod as the last piece in the chain for the overall patch
set, too. Let me wrap up motivation of this approach (A) and status of the
individual patchs (B):

(A) Motivation
  PCI-Express support has been added to System z (s390x) a while ago. This
is an implementation according to all the standards, but the memory
subsystem does not implement real MMIO with arbitrary memory writes
triggering PCI activity. Instead, a privileged instruction needs to be used
to write to mapped memory.
  Emulating MMIO via a page fault handler is something we discussed for a
while, but eventually, a correct implementation is very expensive: System z
has got a rich instruction set (CISC) with ~1000 instructions and over a
third of those touch memory, and some of them very much live up to the C in
CISC. To have a correct implementation, all instructions touching memory
would have to be emulated in case of a page fault, even if in *most* cases,
just a few will be used. And we keep changing the code as the platform
evolves.
  The intention is to keep any changes as minimal intrusive and clean as
possible. Therefore small helper functions ("static inline long mmio_writel
()") in libmlx4 provide an abstraction of MMIO access (similar to the
kernel approach). These functions are no change (even in the binary) on
most platforms, but work against a system call on s390x. BTW, for system
integrity reasons, z firmware makes only whitelisted PCI devices available
to the Operating System level. Therefore, the Mellanox RoCE adapter is the
only NIC currently supported by System z, and this is the reason we only
touch libmlx4 with the mmio abstraction.


(B) Status of patches
1. kernel code -- the new system call: reviewed, acked and accepted by the
s390x maintainer Martin Schwidefsky (2014/10/13), so we will have that
system call in the s390x kernel.
2. libibverbs -- define barriers on s390x: Looking for your feedback. We
understand there have been no general objections so far.
3. libmlx4 -- provide MMIO abstraction: reviewed by the Mellanox
maintainers and we understand they would apply this once you give the go
for the overall set.
Previously, a patch to DAPL to build on s390x has been accepted already
(Arlin Davis, 2014/09/02).

  We gave your concern on MMIO handling on s390x serious consideration from
various angles, but the page fault handler does not appear workable. OTOH,
Mellanox is fine with the MMIO abstraction in libmlx4, and we didn't hear
of significant other concerns. With that, could you please consider the
patch set again to add s390x to the list of supported platforms? Happy to
repost the patches for convenience.

Thanks,
Utz

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
