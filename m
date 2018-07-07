From: Tomas Bortoli <tomasbortoli@gmail.com>
Subject: [PATCH] KASAN: use-after-free Read in rdma_listen
Date: Sat, 7 Jul 2018 03:41:30 +0200
Message-ID: <b7dd13a9-cb0d-7e10-beb2-3fb25214067a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: leon@kernel.org, parav@mellanox.com, roland@purestorage.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hi,

I spent some time debugging the Syzkaller's found issue at subject:

https://syzkaller.appspot.com/bug?id=3Db8febdb3c7c8c1f1b606fb903cee66b21b=
2fd02f

And I've backtracked the UAF to the fact that the cma_listen_on_all()
function adds "id_priv->list" to the global var "listen_any_list" but
then such element is not removed in the rdma_destroy_id() function
(though I've seen that the call to cma_release_dev() in
rdma_destroy_id() should do the removal but doesn't get executed).

Therefore, if a program allocates a "struct rdma_cm_id" (through
ucma_open + ucma_create_id), then executes cma_listen_on_all(), then
frees the struct and repeat, during the second execution of
cma_listen_on_all() the kernel will try to update the references of the
freed node, triggering the UAF. I was able to fix the UAF with this ugly
patch:

--- b/drivers/infiniband/core/cma.c=C2=A0=C2=A0 =C2=A02018-07-07 02:28:03=
=2E214589868 +0200
+++ a/drivers/infiniband/core/cma.c=C2=A0=C2=A0 =C2=A02018-07-07 03:35:44=
=2E325301216 +0200
@@ -1678,6 +1678,11 @@ void rdma_destroy_id(struct rdma_cm_id *
=C2=A0=C2=A0=C2=A0 =C2=A0mutex_lock(&id_priv->handler_mutex);
=C2=A0=C2=A0=C2=A0 =C2=A0mutex_unlock(&id_priv->handler_mutex);
=C2=A0
+=C2=A0=C2=A0 =C2=A0mutex_lock(&lock);
+=C2=A0=C2=A0 =C2=A0if(id_priv->list.next!=3D0 && id_priv->list.prev!=3D0=
)
+=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0list_del(&id_priv->list);
+=C2=A0=C2=A0 =C2=A0mutex_unlock(&lock);
+
=C2=A0=C2=A0=C2=A0 =C2=A0if (id_priv->cma_dev) {
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0rdma_restrack_del(&id_priv->r=
es);
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0if (rdma_cap_ib_cm(id_priv->i=
d.device, 1)) {

Note: I only tested this patch against the shortest reproducer for this
issue (not any other use of rdma_cm):

https://syzkaller.appspot.com/text?tag=3DReproC&x=3D1334f10f800000

I had to add that "if" in the patch because running the reproducer
(after several iterations) provoked a NULL-dereference in the added
list_del() call because for some reason I haven't cleared yet the next
and prev pointers of the list at issue gets zeroed, sometimes ( by what ?=
?).


Moreover, I noticed that running the reproducer for "long" time exhaust
all the available memory. To spot the memory leaks I recompiled with:

CONFIG_HAVE_DEBUG_KMEMLEAK=3Dy
CONFIG_DEBUG_KMEMLEAK=3Dy
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=3D10000

The reproducer induces, apparently, 2 memory leaks reported by kmemleak:

unreferenced object 0xffff880069f49d40 (size 512):
=C2=A0 comm "repro", pid 4263, jiffies 4294722196 (age 688.262s)
=C2=A0 hex dump (first 32 bytes):
=C2=A0=C2=A0=C2=A0 00 b8 13 5a 00 88 ff ff 40 9d f4 69 00 88 ff ff=C2=A0 =
=2E..Z....@..i....
=C2=A0=C2=A0=C2=A0 0a 00 98 a6 00 00 00 00 fe 80 00 00 00 00 00 00=C2=A0 =
=2E...............
=C2=A0 backtrace:
=C2=A0=C2=A0=C2=A0 [<0000000075a2f334>] kmem_cache_alloc_trace+0x1b2/0x3d=
0
=C2=A0=C2=A0=C2=A0 [<0000000075fd9fea>] rdma_resolve_ip+0xc0/0x6b0
=C2=A0=C2=A0=C2=A0 [<0000000033592b0b>] rdma_resolve_addr+0x490/0x2580
=C2=A0=C2=A0=C2=A0 [<00000000d6f2cd9d>] ucma_resolve_ip+0x193/0x260
=C2=A0=C2=A0=C2=A0 [<0000000068f1c2b7>] ucma_write+0x2ec/0x3f0
=C2=A0=C2=A0=C2=A0 [<00000000015692cc>] __vfs_write+0x107/0x920
=C2=A0=C2=A0=C2=A0 [<000000009528b010>] vfs_write+0x189/0x510
=C2=A0=C2=A0=C2=A0 [<000000001a5d169b>] ksys_write+0xfa/0x240
=C2=A0=C2=A0=C2=A0 [<00000000b747746a>] __x64_sys_write+0x73/0xb0
=C2=A0=C2=A0=C2=A0 [<0000000071590ffb>] do_syscall_64+0x18c/0x760
=C2=A0=C2=A0=C2=A0 [<000000003c31113f>] entry_SYSCALL_64_after_hwframe+0x=
49/0xbe
=C2=A0=C2=A0=C2=A0 [<0000000059247e9d>] 0xffffffffffffffff


unreferenced object 0xffff88006c0c0bc0 (size 576):
=C2=A0 comm "repro", pid 4261, jiffies 4294722191 (age 688.261s)
=C2=A0 hex dump (first 32 bytes):
=C2=A0=C2=A0=C2=A0 00 02 00 00 00 00 00 00 80 b8 07 6c 00 88 ff ff=C2=A0 =
=2E..........l....
=C2=A0=C2=A0=C2=A0 b0 7d 2c 6b 00 88 ff ff d8 0b 0c 6c 00 88 ff ff=C2=A0 =
=2E},k.......l....
=C2=A0 backtrace:
=C2=A0=C2=A0=C2=A0 [<0000000039511ef2>] kmem_cache_alloc+0x1b2/0x3d0
=C2=A0=C2=A0=C2=A0 [<00000000106bf668>] radix_tree_node_alloc.constprop.1=
8+0x5e/0x2e0
=C2=A0=C2=A0=C2=A0 [<000000005b2f026d>] idr_get_free+0x9f5/0x1000
=C2=A0=C2=A0=C2=A0 [<00000000445baa5a>] idr_alloc_u32+0x1bc/0x3d0
=C2=A0=C2=A0=C2=A0 [<000000007fd1b6f4>] idr_alloc+0xfd/0x190
=C2=A0=C2=A0=C2=A0 [<00000000d706389e>] cma_alloc_port+0xb0/0x170
=C2=A0=C2=A0=C2=A0 [<000000008f968f9e>] rdma_bind_addr+0x1252/0x1f00
=C2=A0=C2=A0=C2=A0 [<00000000e3361215>] rdma_resolve_addr+0x39e/0x2580
=C2=A0=C2=A0=C2=A0 [<00000000d6f2cd9d>] ucma_resolve_ip+0x193/0x260
=C2=A0=C2=A0=C2=A0 [<0000000068f1c2b7>] ucma_write+0x2ec/0x3f0
=C2=A0=C2=A0=C2=A0 [<00000000015692cc>] __vfs_write+0x107/0x920
=C2=A0=C2=A0=C2=A0 [<000000009528b010>] vfs_write+0x189/0x510
=C2=A0=C2=A0=C2=A0 [<000000001a5d169b>] ksys_write+0xfa/0x240
=C2=A0=C2=A0=C2=A0 [<00000000b747746a>] __x64_sys_write+0x73/0xb0
=C2=A0=C2=A0=C2=A0 [<0000000071590ffb>] do_syscall_64+0x18c/0x760
=C2=A0=C2=A0=C2=A0 [<000000003c31113f>] entry_SYSCALL_64_after_hwframe+0x=
49/0xbe

I don't have a background on usage or internals of the driver at issue
but I hope these clues will help in finding the proper fix.

Tomas
