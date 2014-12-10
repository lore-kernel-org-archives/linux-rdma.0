From: Utz Bacher <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] DAPL support on s390x platform
Date: Wed, 10 Dec 2014 17:27:38 +0100
Message-ID: <OFA12CE4AE.0DA527AB-ONC1257DAA.0057DC75-C1257DAA.005A6BB7@de.ibm.com>
References: <1412933657-52641-1-git-send-email-aishchuk@linux.vnet.ibm.com> <OF2939B020.E253C5B0-ONC1257D87.0050AE0F-C1257D87.0052C3AA@de.ibm.com> <CAL1RGDVLeNCAXrrq8mEhKxcm_z_xwgLUfO_wzhQE9xJz8Lnq7g@mail.gmail.com> <546354D9.9050601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546354D9.9050601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, amira-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Gonzalo Muelas Serrano <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mschwid2-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland and Yishai,

Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote on 12.11.2014 13:38:49:
[...]
> On 11/12/2014 1:22 AM, Roland Dreier wrote:
> > On Wed, Nov 5, 2014 at 7:04 AM, Utz Bacher <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
wrote:
> >> (B) Status of patches
> >> 1. kernel code -- the new system call: reviewed, acked and accepted by
the
> >> s390x maintainer Martin Schwidefsky (2014/10/13), so we will have that
> >> system call in the s390x kernel.
> >> 2. libibverbs -- define barriers on s390x: Looking for your feedback.
We
> >> understand there have been no general objections so far.
> >> 3. libmlx4 -- provide MMIO abstraction: reviewed by the Mellanox
> >> maintainers and we understand they would apply this once you give the
go
> >> for the overall set.
> >> Previously, a patch to DAPL to build on s390x has been accepted
already
> >> (Arlin Davis, 2014/09/02).
[...]
> > If Mellanox is willing to take on the maintenance burden of changing
> > all MMIO access to an inline function, and if you're willing to take
> > on the burden of knowing that every new adapter you support means
> > tracking down and convincing the maintainer of the driver library,
> > then I'm OK with adding the simple barrier patch to libibverbs.  Could
> > you please send the latest version of that patch to me?
> >
>
> The libmlx4 patch should pass some performance regression before it can
> be approved, this task is in progress in our side.

so when the libmlx4 patch passed the performance regression runs
successfully, we would assume Roland and Yishai acknowledge the changes.
Can we correctly expect these patches (without further changes) appearing
in libmlx4 on top of 1.0.6 and libibverbs on top of 1.1.8?
Just checking before we talk to distribution partners, so that everyone
stays in sync with upstream. Martin Schwidefsky is applying the kernel
changes, too.

Thanks in advance,
Utz

:wq

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
