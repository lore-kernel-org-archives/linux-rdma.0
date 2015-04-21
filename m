From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] IB/qib: use arch_phys_wc_add()
Date: Tue, 21 Apr 2015 14:14:53 -0700
Message-ID: <CAB=NE6UZBv0PMhpXCO7ZdY2J5uGH4KkfkuviDrsZWM5gMNZb6w@mail.gmail.com>
References: <1429648676-17755-1-git-send-email-mcgrof@do-not-panic.com>
 <1429648676-17755-3-git-send-email-mcgrof@do-not-panic.com>
 <20150421205716.GA474@obsidianresearch.com> <32E1700B9017364D9B60AED9960492BC256FB8E2@fmsmsx120.amr.corp.intel.com>
 <CAB=NE6U+xWZGmEo-k3XURnuqQP1HE3k7663w6XWD_i=GtqDR3w@mail.gmail.com> <CALCETrVOEkJ5kqSHRhK1bUQm=5k6oDex7eU5UtvZq_ik-H_KbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVOEkJ5kqSHRhK1bUQm=5k6oDex7eU5UtvZq_ik-H_KbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org" <cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas@gma>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 2:12 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, Apr 21, 2015 at 2:09 PM, Luis R. Rodriguez
> <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:
>> On Tue, Apr 21, 2015 at 1:59 PM, Marciniszyn, Mike
>> <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>> > This driver already makes use of ioremap_wc() on PIO buffers, so
>>>> > convert it to use arch_phys_wc_add().
>>>>
>>>> This is probably OK, but I think you should also remove the qib_wc_pat module
>>>> parameter.
>>>>
>>>> Jason
>>>
>>> Revise based on Jason's request and I will do some testing.
>>
>> I did thiink about this -- but removal of module parameters can often
>> times break users of the module parameter, I figured its best to leave
>> it to you guys to decide what to do with that, so this leaves it as a
>> no-op. Can this series be applied and then you can decide what to do
>> to not affect your users on top of this?
>
> As of a few kernel versions ago, unrecognized module parameters no
> longer cause the module to refuse to load.

Sexy, I'll respin the changes only to the qib driver. Can the changes
to ipath still be applied?

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
