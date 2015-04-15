From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 15 Apr 2015 16:52:26 -0700
Message-ID: <CALCETrU9FEoXgWxV+XXwRdKTxUxYj7CD3ropnFb4Pq1cMkucaQ@mail.gmail.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <1429138212.1899.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429138212.1899.34.camel-xioobY1GIEhKttHedORAlB2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrj>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 15, 2015 at 3:50 PM, Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org> wrote:
> On Wed, 2015-04-15 at 13:42 -0700, Andy Lutomirski wrote:
>> On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org> wrote:
>>
>> > c) ivtv: the driver does not have the PCI space mapped out separately, and
>> > in fact it actually does not do the math for the framebuffer, instead it lets
>> > the device's own CPU do that and assume where its at, see
>> > ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
>> > but not a setter. Its not clear if the firmware would make a split easy.
>> > We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
>> >
>>
>> IMO this should be conceptually easy to split.  Once we get the
>> framebuffer address, just unmap it (or don't prematurely map it) and
>> then ioremap the thing.
>
> Not so easy.  The main ivtv driver has already set up the PCI device and
> done the mapping for the MPEG-2 decoder/video output engine.  The video
> decoder/output device nodes might already be open by user space calling
> into the main driver, before the ivtvfb module is even loaded.

Surely the MPEG-2 decoder/video engine won't overlap the framebuffer,
though.  Am I missing something?

--Andy

>
> This could be mitigated by integrating all the ivtvfb module code into
> the main ivtv module.  But even then not every PVR-350 owner wants to
> use the video output OSD as a framebuffer.  Users might just want an
> actual OSD overlaying their TV video playback.
>
> Regards,
> Andy
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
