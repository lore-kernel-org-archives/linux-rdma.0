From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Date: Tue, 7 Jul 2015 09:03:06 +0200
Message-ID: <20150707070306.GB9784@gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com>
 <20150625173847.GH3005@wotan.suse.de>
 <20150626084546.GD26303@gmail.com>
 <1435322161.2713.10.camel@localhost>
 <20150629065505.GB17509@gmail.com>
 <57337D5A-7486-4D01-8316-DFAF4CAF3DA7@md.metrocast.net>
 <20150707004417.GM7021@wotan.suse.de>
 <CAB=NE6WzpSLREPkLt0k1_42V5DGKYQx3cqMnGeOFwv1-wkxVhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB=NE6WzpSLREPkLt0k1_42V5DGKYQx3cqMnGeOFwv1-wkxVhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>, Andy Walls <andy-JCKMKWeByS3xr+NhZqW+5SMd26UNKDXL@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Hyong-Youb Kim <hkim-Z0sFnEBmPCA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


* Luis R. Rodriguez <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:

> On Mon, Jul 6, 2015 at 5:44 PM, Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org> wrote:
> > If we really wanted to we could consider arch_phys_wc_add()
> 
> I mean adding a __arch_phys_wc_add() which does not check for pat_enabled().
> 
> > and
> > deal with that this will not check for pat_enabled() and forces MTRR...
> > I think Andy Luto won't like that very much though ? I at least don't
> > like it since we did all this work to finally leave only 1 piece of
> > code with direct MTRR access... Seems a bit sad. Since ipath will
> > be removed we'd have only ivtv driver using this API, I am not sure if
> > its worth it.
> 
> Since ipath is going away soon we'd just have one driver with the icky
> #ifdef code. I'd rather see that and then require semantics / grammer
> rules to require ioremap_wc() when used with arch_phys_wc_add(). I don't think 
> ivtv is worth to consider breaking the semantics and requirements.

Ok, let's keep your original approach with the warning then.

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
