From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] DAPL support on s390x platform
Date: Tue, 11 Nov 2014 15:22:20 -0800
Message-ID: <CAL1RGDVLeNCAXrrq8mEhKxcm_z_xwgLUfO_wzhQE9xJz8Lnq7g@mail.gmail.com>
References: <1412933657-52641-1-git-send-email-aishchuk@linux.vnet.ibm.com> <OF2939B020.E253C5B0-ONC1257D87.0050AE0F-C1257D87.0052C3AA@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF2939B020.E253C5B0-ONC1257D87.0050AE0F-C1257D87.0052C3AA-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Utz Bacher <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Gonzalo Muelas Serrano <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mschwid2-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 5, 2014 at 7:04 AM, Utz Bacher <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> (B) Status of patches
> 1. kernel code -- the new system call: reviewed, acked and accepted by the
> s390x maintainer Martin Schwidefsky (2014/10/13), so we will have that
> system call in the s390x kernel.
> 2. libibverbs -- define barriers on s390x: Looking for your feedback. We
> understand there have been no general objections so far.
> 3. libmlx4 -- provide MMIO abstraction: reviewed by the Mellanox
> maintainers and we understand they would apply this once you give the go
> for the overall set.
> Previously, a patch to DAPL to build on s390x has been accepted already
> (Arlin Davis, 2014/09/02).
>
>   We gave your concern on MMIO handling on s390x serious consideration from
> various angles, but the page fault handler does not appear workable. OTOH,
> Mellanox is fine with the MMIO abstraction in libmlx4, and we didn't hear
> of significant other concerns. With that, could you please consider the
> patch set again to add s390x to the list of supported platforms? Happy to
> repost the patches for convenience.

If Mellanox is willing to take on the maintenance burden of changing
all MMIO access to an inline function, and if you're willing to take
on the burden of knowing that every new adapter you support means
tracking down and convincing the maintainer of the driver library,
then I'm OK with adding the simple barrier patch to libibverbs.  Could
you please send the latest version of that patch to me?

It does seem a little strange to be adding a new system call to
simulate kernel bypass, but I guess you do what you gotta do...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
