From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Thu, 12 Nov 2009 11:07:19 -0800
Message-ID: <ada1vk3ftp4.fsf@roland-alpha.cisco.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
	<adafx8kx41h.fsf@roland-alpha.cisco.com>
	<1257970050.992.317.camel@chromite.mv.qlogic.com>
	<adaaayswzrh.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
	<adaaaysvf69.fsf@roland-alpha.cisco.com>
	<1257981770.992.336.camel@chromite.mv.qlogic.com>
	<adaws1wtywk.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.0911112136110.24052@topaz.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.1.10.0911112136110.24052-vxnkQ4oxbxUi9g6yJnKVd0EOCMrvLtNR@public.gmane.org> (Dave
	Olson's message of "Wed, 11 Nov 2009 21:38:43 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > |  > While this is true for SLtoVL, we create other files which are
 > |  > device specific under the port directory too.
 > |  > It seems like we might need to introduce a callback into the driver to
 > |  > create the port specific sysfs files.
 > | 
 > | Umm, you could have said there were other things initially!
 > 
 > Those have been there "forever" in qib without requiring the change
 > in the core sysfs code.  It's only sysfs group entries that require
 > the patch to expose ib_port.

OK, I'm confused.  Ralph originally said:

 > It [struct ib_port] is used by the new ib_qib driver to expose the SL
 > to VL table since the user level MPI library (libpsm) constructs
 > packets including the IB header.

So if that's the only use, then I'd be in favor of just exposing the
standard, generic SL-to-VL table info for all IB devices.  If there are
other per-port device-specific things, then let's give a clean way for
devices to add per-port attributes without having to know the internals
of how the RDMA core implements sysfs stuff.

 > | Anyway, rather than a callback, I guess we could just add a place to
 > | attach a set of port attributes to the structure that gets passed into
 > | ib_register_device() maybe?
 > 
 > Seems like major overkill to have callbacks, when all we need is to
 > get the structure that "owns" (is the parent kobject of) the directory.

Yes, I agree that callbacks aren't really the best way.  I was
suggesting passing in the per-port attributes as part of the ib_device
structure in ib_register_device().

 > | And maybe we could clean up the existing code that does
 > | device_create_file() to use a list of device attributes also...
 > 
 > Seems to be a rather different issue, to me.

Yes, it's independent.  But if we're passing in per-port attributes, we
might as well take the opportunity to make the API rational and pass in
per-device attributes too.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
