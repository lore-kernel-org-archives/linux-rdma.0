From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
Date: Fri, 20 Jan 2012 00:23:52 -0800
Message-ID: <CAL1RGDVWDsNhHywkmzaGWxZ5ERYatXVh4fGFC_tmOkkLt3Dg+w@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
 <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
 <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
 <CAL1RGDX9P7tmGTkByEid17FrSFwdAW+4=mb9eUxc_uHvmFOeSg@mail.gmail.com>
 <CALfB72CAwzRe3u2+yQ15+coY9kNgFTZ_Be-b-+aMe6QvbZy-HA@mail.gmail.com>
 <CALfB72CLZMrS+gTR3=0QcGry4vA3wKmgbhjp9Lc06UZtVcxzZg@mail.gmail.com> <CALfB72A+A9UDieFtYOMLB9c+XHO8nt8Lr-2pkikaqM=0fJ4OAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72A+A9UDieFtYOMLB9c+XHO8nt8Lr-2pkikaqM=0fJ4OAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2012 at 12:57 AM, Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Just checking up on this issue. Is there any further testing or
> information we can provide to help make a fix happen?

I'm not likely to be much help on VT-d issues, but maybe it
would be useful to dump all the values in the BUG_ON if its
going to trigger, ie just before

       BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1)
>> addr_width);

add

       if (addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1) >> addr_width)
           pr_err("VT-d BUG! addr_width %d < %d (iov_pfn 0x%lx
nr_pages %ld)\n", addr_width, BITS_PER_LONG, iov_pfn, nr_pages);

and report what that prints.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
