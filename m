From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join flags
Date: Mon, 4 Jul 2016 15:32:52 +0300
Message-ID: <CAJ3xEMjf+_Zb+PZoUFh_EGsFG9YaJLWU58yFzsJvuqaBGGgp-Q@mail.gmail.com>
References: <1467550074-24061-1-git-send-email-leon@kernel.org>
 <1467550074-24061-3-git-send-email-leon@kernel.org> <CAJ3xEMitNu8HACD3EZ1kQGU4o-VyDphWFUN7qn94+LpBSV4E=w@mail.gmail.com>
 <20160704053554.GC5289@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704053554.GC5289-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 4, 2016 at 8:35 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Jul 04, 2016 at 12:46:31AM +0300, Or Gerlitz wrote:

>> to use the above defines, or the code added by this patch to use the
>> enum Erez added, or both code pieces to be re-written and use some
>> shared enum/define?

> Good point,

indeed, avoid it in your V2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
