From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] add new verb command support
Date: Mon, 14 Apr 2014 19:01:04 +0200
Message-ID: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current implementation of the userspace Infiniband verbs uses mapped
memory areas to directly access from userspace device UAR and Blueflame
page, which are located in the PCI I/O memory, to initiate I/O operations.
On the s390x platform the PCI I/O memory can be accessed only using
special privileged CPU instructions and those instructions cannot be used
from userspace programs. This restricts the usage of memory mapped areas
to access the PCI I/O memory from userspace on the s390x platform and
because of that existing Infiniband verbs cannot be used on the s390x
platform without modification.
There are two approaches could be implemented to solve this problem:
	* using a page fault handler to intercept mapped memory area
	  access errors, and handle them in the handler by issuing the
	  appropriate privileged CPU instructions;
	* modification of the existing verbs to avoid the mapped memory
	  areas usage on the s390x platform.
The page fault handler solution is the most complex one because it requires
not only modifcation of the virtual memory handling in Linux kernel but
also makes the developer to provide code for all the CPU instrutions which
work with memory program interpretation. This approcach requires lots of
lines of code and noticable overhead during the program execution.
The modification of the existing verbs solution is much simpler and more
realible. It requires modification of the libraries provided in the DAPL
support packages to replace the usage of mapped memory areas used to
access the device UAR and Blueflame page with the device driver write
primitive calls supplying a special verb command to kernelspace.
The new verb command kernel handler processes the verb command and
executes the special privileged CPU instructions to pass the data to
the device PCI I/O memory. The only disadvantage of this approach is the
need to modify the userspace libraries and kernelspace device driver to
add support for the new verb command. The modification of the DAPL
applications is not required.
The modification of the existing verbs solution has been choosen for
implementation.
This patch series contains the changes to the kernelspace modules and
the userspace libraries required to provide support for the DAPL API
on the s390x platform. Each patch file contains changes to corresponding
OFED stack 3.12 package. The patches can be applied to appropriate
packages in any order.
There are 1 patch for the Linux kernel and 4 patches for the DAPL API
userspace components.
	[PATCH 1/5] IB/core/mlx4: add new verb command support
This patch contains changes to the Linux kernel required to provide
support for the new Infiniband verb command IB_USER_VERBS_CMD_KWRITE_MMIO
which is used to allow the userspace DAPL libraries to write the data to
the device UAR and BlueFlame page located in the PCI I/O memory.
	[PATCH 2/5] libibverbs: add new verb command support
This patch contaings the changes that need to be applied to the libibverbs
userspace library to provide support for the new
IB_USER_VERBS_CMD_KWRITE_MMIO verb command which is used to allow the
userspace applications to write data to the device UAR and Blueflame page
located in the PCI I/O memory.
	[PATCH 3/5] libmlx4: add new verb command support
This patch contains the changes that need to be applied to the libmlx4
userspace library to provide support for the new Infiniband verb command
IB_USER_VERBS_CMD_KWRITE_MMIO to allow writing the data from userspace to
PCI I/O memory to initiate I/O operations.
	[PATCH 4/5] dapl: add support for the s390x platform
This patch contains the code which is needed to be added to dapl package
to allow the dapl libraries to be used on s390x platform.
	[PATCH 5/5] perftest: add support for the s390x platform
This patch contains the code which is neeed to be added to the perftest
package applications to allow their execution on the s390x platform.

Alexey Ishchuk (5):
  IB/core/mlx4: add new verb command support
  libibverbs: add new verb command support
  libmlx4: add new verb command support
  dapl: add support for the s390x platform
  perftest: add support for the s390x platform
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
