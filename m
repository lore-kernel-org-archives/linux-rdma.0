From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofw] [PATCH] typeof() not supported in Windows WDK compiler
Date: Thu, 1 Oct 2009 20:04:40 -0600
Message-ID: <20091002020440.GD22310@obsidianresearch.com>
References: <DB05C7E7F5BE4BE585F311B2437350A5@amr.corp.intel.com> <2A3759D0AB7F46D59DF8820EFCFAF1F8@amr.corp.intel.com> <20091001234701.GD5191@obsidianresearch.com> <3F6F638B8D880340AB536D29CD4C1E1912C86E8C4A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C86E8C4A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2009 at 05:29:45PM -0700, Smith, Stan wrote:

> Do the Sun guys use gcc?

gcc is commonly available on Solaris and it would be a pretty
pointless waste of time to compile opensm with sun studio :)

> > #define cl_item_obj(item_ptr, obj_ptr, item_field) (typeof(obj_ptr)) \
> >   (void *)((uint8_t*)item_ptr - ((uintptr_t)(&(obj_ptr)->item_field) -
> >   ((uintptr_t)&(obj_ptr))))
> > #endif
> 
> Interesting, worth a try.
> 
> >
> > And rely on the C implicit cast from void* to an object type, and rely
> > on compiles with gcc to do the extra type checking.
> 
> 'compiles with gcc' ?

The use of typeof in cl_item_obj (and typically container_of too) is
just a correctness checking feature.
  struct bar *foo = cl_item_obj(..);
Does not compile if 'struct bar' is the wrong type, deduced
automatically from the arguments. By changing it to not use typeof the
runtime functionality is the same but you loose the static
checking. This is a poor mans way to implement C++ templates :)

So 'relying on compiles with gcc' means you rely on builds with gcc to
do the check and detect incorrect code. Since VS C cannot implement
typeof it cannot provide the check, so lets just toss out the
functionality. No big deal.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
