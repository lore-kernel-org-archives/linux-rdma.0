From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 21:38:43 -0800
Message-ID: <alpine.LFD.1.10.0911112136110.24052@topaz.mv.qlogic.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com> <adafx8kx41h.fsf@roland-alpha.cisco.com> <1257970050.992.317.camel@chromite.mv.qlogic.com> <adaaayswzrh.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
 <adaaaysvf69.fsf@roland-alpha.cisco.com> <1257981770.992.336.camel@chromite.mv.qlogic.com> <adaws1wtywk.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaws1wtywk.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 11 Nov 2009, Roland Dreier wrote:

| 
|  > While this is true for SLtoVL, we create other files which are
|  > device specific under the port directory too.
|  > It seems like we might need to introduce a callback into the driver to
|  > create the port specific sysfs files.
| 
| Umm, you could have said there were other things initially!

Those have been there "forever" in qib without requiring the change
in the core sysfs code.  It's only sysfs group entries that require
the patch to expose ib_port.

| Anyway, rather than a callback, I guess we could just add a place to
| attach a set of port attributes to the structure that gets passed into
| ib_register_device() maybe?

Seems like major overkill to have callbacks, when all we need is to
get the structure that "owns" (is the parent kobject of) the directory.

| And maybe we could clean up the existing code that does
| device_create_file() to use a list of device attributes also...

Seems to be a rather different issue, to me.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
