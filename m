From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 12:52:02 -0800
Message-ID: <adaaayswzrh.fsf@roland-alpha.cisco.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
	<adafx8kx41h.fsf@roland-alpha.cisco.com>
	<1257970050.992.317.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1257970050.992.317.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Wed, 11 Nov 2009 12:07:30 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > It is used by the new ib_qib driver to expose the SL to VL table
 > since the user level MPI library (libpsm) constructs packets including
 > the IB header. After the driver calls ib_register_device(),
 > it calls device_create_file() to create the files in
 > /sys/class/infiniband/qib0/. Then it uses struct ib_device->port_list
 > to get the pointer to ib_port to add a directory similar to "gids"
 > and "pkeys" for each SL.

Hmm, maybe we should just add a vls directory with sl0 ... sl15 or
something like that in generic code?  I don't see why this needs to be
driver-specific code.

 > Yes, this is what I'm working on.
 > The patch is the only change outside of the hw/qib/ directory.
 > Do you want to see a preview of the sysfs code?

I think the earlier you can post the whole driver, the sooner you'll get
it upstream.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
