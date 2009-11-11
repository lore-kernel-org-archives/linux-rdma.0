From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 12:07:30 -0800
Message-ID: <1257970050.992.317.camel@chromite.mv.qlogic.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
	 <adafx8kx41h.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafx8kx41h.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2009-11-11 at 11:19 -0800, Roland Dreier wrote:
> > This patch moves the definition of struct ib_port from
>  > sysfs.c to ib_verbs.h so that HCAs can create files in
>  > /sys/class/infiniband/<hca>/ports/<N>/
> 
> um, maybe, but we need to see how it gets used first.  How do you get
> the to struct ib_port in driver code?  Maybe it would make more sense to
> add a way for low-level drivers to pass in port attributes that get
> added when the port structure gets created?

It is used by the new ib_qib driver to expose the SL to VL table
since the user level MPI library (libpsm) constructs packets including
the IB header. After the driver calls ib_register_device(),
it calls device_create_file() to create the files in
/sys/class/infiniband/qib0/. Then it uses struct ib_device->port_list
to get the pointer to ib_port to add a directory similar to "gids"
and "pkeys" for each SL.

> By the way, any plans to resume working on the upstream driver for
> qlogic HCAs?  Do you still plan to deprecate ib_ipath and add a new
> driver for new devices?

Yes, this is what I'm working on.
The patch is the only change outside of the hw/qib/ directory.
Do you want to see a preview of the sysfs code?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
