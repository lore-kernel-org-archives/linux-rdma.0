From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 13:06:20 -0800
Message-ID: <alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com> <adafx8kx41h.fsf@roland-alpha.cisco.com> <1257970050.992.317.camel@chromite.mv.qlogic.com> <adaaayswzrh.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaaayswzrh.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 11 Nov 2009, Roland Dreier wrote:
|  > It is used by the new ib_qib driver to expose the SL to VL table
|  > since the user level MPI library (libpsm) constructs packets including
|  > the IB header. After the driver calls ib_register_device(),
|  > it calls device_create_file() to create the files in
|  > /sys/class/infiniband/qib0/. Then it uses struct ib_device->port_list
|  > to get the pointer to ib_port to add a directory similar to "gids"
|  > and "pkeys" for each SL.
| 
| Hmm, maybe we should just add a vls directory with sl0 ... sl15 or
| something like that in generic code?  I don't see why this needs to be
| driver-specific code.

No particular reason, it just didn't seem likely to be useful on other
HCA drivers.   I can redo the patches that way, if people think it's
the right thing to do.

|  > Yes, this is what I'm working on.
|  > The patch is the only change outside of the hw/qib/ directory.
|  > Do you want to see a preview of the sysfs code?
| 
| I think the earlier you can post the whole driver, the sooner you'll get
| it upstream.

Yeah, we know...   Schedule and people conflicts have slowed this down.
We want to do it, and soon.

And yes, the ib_ipath is being fully deprecated.  The "full set" of
patches that adds ib_qib upstream will include a subset that drops
ib_ipath.   All the bug fixes and feature work have been done for ib_qib

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
