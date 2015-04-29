From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] IB/ipath: use arch_phys_wc_add() and require PAT disabled
Date: Wed, 29 Apr 2015 09:01:30 -0700
Message-ID: <CAB=NE6Xe1GxDRdXHBu_rk6HScebNwFWoCPQe1CMH5gDC=ESfEg@mail.gmail.com>
References: <1429730795-6721-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6UHnEuMHfFaXBNr4F=RcDcEC3z6rX8-B_10Sbpr7kHkiA@mail.gmail.com> <1430159932.44548.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430159932.44548.20.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 27, 2015 at 11:38 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2015-04-27 at 09:46 -0700, Luis R. Rodriguez wrote:
>> On Wed, Apr 22, 2015 at 12:26 PM, Luis R. Rodriguez
>> <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:
>> > From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
>> >
>> > We are burrying direct access to MTRR code support on
>> > x86 in order to take advantage of PAT. In the future we
>> > also want to make the default behaviour of ioremap_nocache()
>> > to use strong UC, use of mtrr_add() on those systems
>> > would make write-combining void.
>> >
>> > In order to help both enable us to later make strong
>> > UC default and in order to phase out direct MTRR access
>> > code port the driver over to arch_phys_wc_add() and
>> > annotate that the device driver requires systems to
>> > boot with PAT disabled, with the nopat kernel parameter.
>> >
>> > This is a worthy compromise given that the ipath device
>> > driver powers the old HTX bus cards that only work in
>> > AMD systems, while the newer IB/qib device driver
>> > powers all PCI-e cards. The ipath device driver is
>> > obsolete, hardware hard to find and because of this
>> > this its a reasonable compromise to make to require
>> > users of ipath to boot with nopat.
>>
>> Hey folks, I realize its being discussed whether or not to remove the
>> driver entirely from the kernel but in the meantime, is this a
>> reasonable compromise ?
>
> [ trimmed Cc: list to probably the only people that care ]
>
> I would think so.

OK great, can this be merged then? I am waiting for this patch to help
move forward with deprecating MTRR upstream.

> I think we might as well mark this driver as
> deprecated and put a tentative date on removal while we are at it.

OK great, that can be done as a separate patch.

> Mike, any specific input here?  I would suggest mark it deprecated with
> a planned removal sometime in late 2015/early 2016.

I will note that feature-removal file was removed from Linux so if we
want to deprecate something now we just do it.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
