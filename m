From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 15:22:50 -0800
Message-ID: <1257981770.992.336.camel@chromite.mv.qlogic.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
	 <adafx8kx41h.fsf@roland-alpha.cisco.com>
	 <1257970050.992.317.camel@chromite.mv.qlogic.com>
	 <adaaayswzrh.fsf@roland-alpha.cisco.com>
	 <alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
	 <adaaaysvf69.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaaaysvf69.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2009-11-11 at 15:02 -0800, Roland Dreier wrote:
> > | Hmm, maybe we should just add a vls directory with sl0 ... sl15 or
>  > | something like that in generic code?  I don't see why this needs to be
>  > | driver-specific code.
>  > 
>  > No particular reason, it just didn't seem likely to be useful on other
>  > HCA drivers.   I can redo the patches that way, if people think it's
>  > the right thing to do.
> 
> To me it does seem like something generic.  SLtoVL table is required of
> all CAs, so we might as well create it for all IB devices... as I see it
> the advantages of having it core code are:
> 
>  - no need to expose internals of sysfs code port structure to low level
>    drivers (we could also avoid this layering violation by giving a
>    generic way for low-level drivers to add port attributes)
>  - IB-specified info is available for all IB devices with the same
>    format etc.  It may not be important for non-qlogic devices but there
>    is some utility in SL mapping for debugging etc.
> 
> the only disadvantage I see is that it adds the overhead of having those
> sysfs attributes for all systems with an RDMA devices, even if the
> qlogic driver is never loaded.  But that overhead is pretty much just a
> small amount of extra code that will never be run and a few sysfs
> structures that will never be touched, so it just takes up a little bit
> of memory.  For RDMA-using systems, I can't imagine it matters.
> 
>  - R.

While this is true for SLtoVL, we create other files which are
device specific under the port directory too.
It seems like we might need to introduce a callback into the driver to
create the port specific sysfs files.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
