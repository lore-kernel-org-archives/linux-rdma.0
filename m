From: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 0/5] DAPL support on s390x platform prototype
Date: Wed, 27 Aug 2014 12:24:35 +0200
Message-ID: <1409135080-44991-1-git-send-email-aishchuk@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains the re-architected changes to kernel and
userspace libraries required to provide support for the DAPL API on s390x
platform. Those patches are are a prototype of proposed changes. It is not
requested to include this version of changes into kernel source code and
the patches are posted only to receive comments from the community on this
changes concept.
The current implementation of Infiniband verbs uses mapped memory areas to
directly access the device UAR and Blueflame pages, which are located in
the PCI I/O memory, from userspace. On the s390x platform the PCI I/O
memory can be accessed only using special privileged CPU instructions that
cannot be used directly in user space programs. This restricts the usage of
mapped memory areas to access the PCI I/O memory on s390x platform.
In the previous attempt of DAPL support on s390x platform implementation a
new Infinband verb command was introduced and the changes to kernel modules
and user space libraries were provided but that version of changes was
rejected by community.
The new version of changes introduces new kernel system calls which allow
to execute the privileged CPU instructions in kernel space on request from
user space programs. One system call allows the user space programs to
write data to a PCI I/O memory page and the second one can be used to read
data from PCI I/O memory to userspace program buffer using mapped memory
area addresses as arguments.
This approach of the DAPL API support on s390x platform has the following
advantages:
	* the current Infiniband and mlx4 support modules remain unchanged;
	* the changes are separated into the special kernel platform
	  specific directory;
	* no conditional compilation directives are used in the kernel
	  source code;
	* no changes required to the kernel virtual memory management;
	* only minor changes are required in the user space DAPL API
	  components.
The only disadvantage of this approach is that it is still necessary to
modify existing userspace library libmlx4 to replace the direct access to
mapped memory areas intended for the PCI I/O memory access with the
appropriate new system call invocation. The changes to the other user space
DAPL component code are required only to provide the support of the s390x
platform.
There are 1 patch for the Linux kernel and 4 patches for the DAPL API user
space components.
	[PATCH 1/5] s390/kernel: add system calls for access PCI memory
This patch contains the new system call implementation required for the PCI
I/O memory access from userspace programs on s390x platform.
	[PATCH 2/5] libibverbs: add support for the s390x plaform
This patch contains the changes to the libibverbs user space library to
provide support of the s390x platform.
	[PATCH 3/5] libmlx4: add support for the s390x platform
This patch contains the changes to the libmlx4 user space library intended
to provide the PCI I/O memory access on the s390x platform. The direct
access to mapped memory areas is replaced by appropriate system call
invocation.
	[PATCH 4/5] dapl: add support for the s390x platform
This patch contains the code which is needed to be added to dapl package
to allow the dapl libraries to be used on s390x platform. There is no
changes added to this patch since the previous post and it is included only
for refrence.
	[PATCH 5/5] perftest: add support for the s390x platform
This patch contains the code which is neeed to be added to the perftest
package applications to allow their execution on the s390x platform. There
is no changes in this patch since the previous post and it is included only
for refrence.

Alexey Ishchuk (5):
  s390/kernel: add system calls for access PCI memory
  libibverbs: add support for s390x platform
  libmlx4: add support for s390x platform
  dapl: add support for s390x platform
  perftest: add support for s390x platform
-- 
1.8.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
