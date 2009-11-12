From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Thu, 12 Nov 2009 11:29:41 -0800
Message-ID: <alpine.LFD.1.10.0911121116560.25952@topaz.mv.qlogic.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com> <adafx8kx41h.fsf@roland-alpha.cisco.com> <1257970050.992.317.camel@chromite.mv.qlogic.com> <adaaayswzrh.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
 <adaaaysvf69.fsf@roland-alpha.cisco.com> <1257981770.992.336.camel@chromite.mv.qlogic.com> <adaws1wtywk.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.0911112136110.24052@topaz.mv.qlogic.com> <ada1vk3ftp4.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada1vk3ftp4.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Nov 2009, Roland Dreier wrote:

| 
|  > |  > While this is true for SLtoVL, we create other files which are
|  > |  > device specific under the port directory too.
|  > |  > It seems like we might need to introduce a callback into the driver to
|  > |  > create the port specific sysfs files.
|  > | 
|  > | Umm, you could have said there were other things initially!
|  > 
|  > Those have been there "forever" in qib without requiring the change
|  > in the core sysfs code.  It's only sysfs group entries that require
|  > the patch to expose ib_port.
| 
| OK, I'm confused.  Ralph originally said:
| 
|  > It [struct ib_port] is used by the new ib_qib driver to expose the SL
|  > to VL table since the user level MPI library (libpsm) constructs
|  > packets including the IB header.
| 
| So if that's the only use, then I'd be in favor of just exposing the
| standard, generic SL-to-VL table info for all IB devices.  If there are
| other per-port device-specific things, then let's give a clean way for
| devices to add per-port attributes without having to know the internals
| of how the RDMA core implements sysfs stuff.

The other per-port stuff doesn't require ib_port, because it's not
using the same parent kobject.   They are separate directories with
separate files, not groups attached to the port kobject.

Ralph is correct, but the answer is somewhat misleading, in his response to
your reply.  The new SL2VL table is the only thing in the HCA driver
that needs ib_port to be exposed so far, and "likely" to be the only
thing ever.

| Yes, I agree that callbacks aren't really the best way.  I was
| suggesting passing in the per-port attributes as part of the ib_device
| structure in ib_register_device().

For us, that would be inconvenient, although we could probably make
it work.   And it's not just an attribute list, we'd then have to
export functions somehow (via a pointer table, presumably).  It all
seems pretty inflexible, and a lot more work, for no real gain.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
