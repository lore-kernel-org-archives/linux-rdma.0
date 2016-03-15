From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] Dynamically extendable device counter support
Date: Tue, 15 Mar 2016 10:54:41 -0500
Message-ID: <20160315155441.222586021@linux.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We currently have issues when we want to expose device counters to the
system because we have statically defined structures that define
these counters. Changing these requires a change in the ABI since
the counter structures are defined in ib_verbs.h.

Moreover it seems that these counter diverge in a device driver
specific way. Counters show up in sysfs that are not supported
by the device driver and that will always be zero.

The patches here change the ABI to avoid hardcoding counter
names to the ABI. Instead of populated counters in structure
predefined in ib_verbs.h we simply return a pointer to an array
of strings describing the pointers supported and an array of
values of these counters. That allows device drives to define
an arbitrary amount of counters as needed. Adding a counter
does not requrie changing ib_verbs.h.

IB device drivers can develop standard semantics for specific
counters that are supported by multiple device drives by using
the same names there. So software can just check if the device
supports a certain counter and then expect the same behavior
of that counter regardless of the device driver.

This patch also adds counters at a port level. A device driver
can support counters at the device level and then at the level
of each individual port supports.

This patch series modifies the Iwarp device drives to support
the new way of handling counters. It removes the
counters that these devices do not support and that have
never had a function.

The mlx4 implementatation provided provides basic counter
support based on a patch posted by Majd years ago.

The mlx5 implementation is just some sample code that
does not actually retrieve any counters. I hope that Mellanox
will fix up the last two patches to allow more counters
for mlx4 and provide the proper way of retrieving counters
for mlx5.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
