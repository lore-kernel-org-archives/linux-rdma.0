From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 15:38:51 -0800
Message-ID: <adaws1wtywk.fsf@roland-alpha.cisco.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
	<adafx8kx41h.fsf@roland-alpha.cisco.com>
	<1257970050.992.317.camel@chromite.mv.qlogic.com>
	<adaaayswzrh.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
	<adaaaysvf69.fsf@roland-alpha.cisco.com>
	<1257981770.992.336.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1257981770.992.336.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Wed, 11 Nov 2009 15:22:50 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > While this is true for SLtoVL, we create other files which are
 > device specific under the port directory too.
 > It seems like we might need to introduce a callback into the driver to
 > create the port specific sysfs files.

Umm, you could have said there were other things initially!

Anyway, rather than a callback, I guess we could just add a place to
attach a set of port attributes to the structure that gets passed into
ib_register_device() maybe?

And maybe we could clean up the existing code that does
device_create_file() to use a list of device attributes also...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
