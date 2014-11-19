From: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 0/2] DAPL support on s390x platform
Date: Wed, 19 Nov 2014 11:17:17 +0100
Message-ID: <1416392239-10282-1-git-send-email-aishchuk@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains the changes to user space libraries required
to provide support for the DAPL API on s390x platform. The corresponding
kernel patch is on the features branch of linux-s390 for the next merge
window.
The current implementation of Infiniband verbs uses mapped memory areas to
directly access the device UAR and Blueflame pages, which are located in
the PCI I/O memory, from user space. On the s390x platform the PCI I/O
memory can be accessed only using special privileged CPU instructions that
cannot be used directly in user space programs. This restricts the usage of
mapped memory areas to access the PCI I/O memory on s390x platform.
There are 2 patches for the DAPL API libibverbs and libmlx4 user space
components in this patch series. The patches for the perftest and dapl
packages are not included into this series because those changes have been
already applied to corresponding packages by the maintainers.
	[PATCH 1/2] libibverbs: add support for the s390x plaform
This patch contains the changes to the libibverbs user space library to
provide support of the s390x platform.
	[PATCH 2/2] libmlx4: add support for the s390x platform
This patch contains the changes to the libmlx4 user space library intended
to provide the PCI I/O memory access on the s390x platform. The direct
access to mapped memory areas is replaced by appropriate system call
invocation.
All maintainers have stated general agreement with the patches previously,
this is to provide a clean and up-to-date patch set for consideration for
inclusion.

Alexey Ishchuk (2):
  libibverbs: add s390x platform support
  libmlx4: add s390x platform support
-- 
1.8.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
