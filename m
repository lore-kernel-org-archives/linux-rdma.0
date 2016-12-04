From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 0/2] Optimize RoCE address handle creation for userspace
Date: Sun,  4 Dec 2016 17:53:24 +0200
Message-ID: <1480866806-5052-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sending V1 to address a note coming from Jason re symbol versioning,
details below.

This patch set from Moni is the supplementary part of the kernel series that
was lastly sent upstream.

Creating a UD address handler when link layer is Ethernet requires resolving
the remote L3 address (GID) to a L2 address (MAC/VLAN).

Until now the way to resolve GID (which is the remote IP or a function of it)
to a MAC was with an interface supplied by libnl. The implementation of this
interface is heavy and fails on large load of requests to create an address
handle.

This series of patches enables user drivers that care for it to optimize the
resolution of L3 to L2 addresses with uverbs interface.

The series was tested successfully with CX4 in both kernel which doesn't have
this support and with a kernel which includes the above support.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/42

Yishai

Changes from v0:
ibv_cmd_create_ah symbol version was changed to a newer version to prevent
legacy providers from being loaded when they are working with new libibverbs.
This behavior is better than getting some random error upon calling to
ibv_cmd_create_ah from a legacy provider which is out of the consolidate rdma
tree.

Test results:
------------------------------------------------------------------------------
Upon testing the above use case the provider couldn't be loaded as expected,
"libibverbs: Warning: couldn't load driver 'libmlx5-rdmav2.so':
libmlx5-rdmav2.so: cannot open shared object file: No such file or directory"

Run with strace, can see that as part of the dynamic linking loader flow (i.e.
dlopen) libmlx5-rdmav2.so was opened successfully from its default location
(i.e. /usr/lib64/libibverbs/), however, it was just later closed, apparently as
of the missing symbol, as expected. Later on the linker looked for other
locations for same library (e.g. /lib64/tls/x86_64, /lib64/tls) but didn't
find, so the flow ended up with the above error message from libibverbs.

>From strace:
open("/usr/lib64/libibverbs/libmlx5-rdmav2.so", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20(\0\0\0\0\0\0"., 832)
     = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=555006, ...}) = 0
mmap(NULL, 2192400, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)
     = 0x7f910ba21000
mprotect(0x7f910ba38000, 2093056, PROT_NONE) = 0
mmap(0x7f910bc37000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
				MAP_DENYWRITE, 3, 0x16000) = 0x7f910bc37000
close(3)                                = 0
munmap(0x7f910ba21000, 2192400)         = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=143158, ...}) = 0
mmap(NULL, 143158, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f910e5d0000
close(3)                                = 0
open("/lib64/tls/x86_64/libmlx5-rdmav2.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT
     (No such file or directory)

...
-------------------------------------------------------------------------------

Moni Shoua (2):
  ibverbs: Allow vendor data response in create_ah command
  mlx5: Create and destroy address handle with kernel assistance

 libibverbs/cmd.c                | 11 ++++++-----
 libibverbs/driver.h             |  4 +++-
 libibverbs/libibverbs.map       |  6 +++++-
 providers/hfi1verbs/verbs.c     |  4 +++-
 providers/ipathverbs/verbs.c    |  4 +++-
 providers/mlx5/mlx5-abi.h       |  7 +++++++
 providers/mlx5/mlx5.h           |  2 ++
 providers/mlx5/verbs.c          | 28 +++++++++++++++++++++++-----
 providers/ocrdma/ocrdma_verbs.c |  4 +++-
 providers/rxe/rxe.c             |  4 +++-
 10 files changed, 58 insertions(+), 16 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
