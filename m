From: Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING in cma_exit_net
Date: Mon, 1 Apr 2019 21:29:23 +0300
Message-ID: <20190401182923.GK3201@mtr-leonro.mtl.com>
References: <0000000000008096f305857b74d1@google.com>
 <20190401174554.GE6209@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5cSRzy0VGBWAML+b"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190401174554.GE6209@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: syzbot <syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com>, Matthew Wilcox <willy@infradead.org>, danielj@mellanox.com, danitg@mellanox.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org


--5cSRzy0VGBWAML+b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 01, 2019 at 02:45:54PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 01, 2019 at 10:36:05AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    e3ecb83e Add linux-next specific files for 20190401
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13bc36cd200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=db6c9f2bfeb91a99
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2e3e485d5697ea610460
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com
> >
> > WARNING: CPU: 1 PID: 7 at drivers/infiniband/core/cma.c:4674
> > cma_exit_net+0x327/0x390 drivers/infiniband/core/cma.c:4674
> > Kernel panic - not syncing: panic_on_warn set ...
>
> Matt: This is why the WARN_ON(!xa_empty()) is so valuable. Magically
> syzkaller can find something in this code is buggy.
>
> Mellanox is also showing a different testing failure over the weekend
> (use after free or something) from your 'cma: Convert portspace IDRs
> to XArray'

This is what I see in my environment.

[   72.725596]
==================================================================
[   72.726017] BUG: KASAN: use-after-free in cma_check_port+0x86a/0xa20 [rdma_cm]
[   72.726263] Read of size 8 at addr ffff888069fde998 by task ucmatose/387
[   72.726460]
[   72.726550] CPU: 3 PID: 387 Comm: ucmatose Not tainted 5.1.0-rc2+ #253
[   72.726751] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
[   72.727119] Call Trace:
[   72.727210]  dump_stack+0x7c/0xc0
[   72.727342]  print_address_description+0x6c/0x23c
[   72.727505]  ? cma_check_port+0x86a/0xa20 [rdma_cm]
[   72.727666]  kasan_report.cold.3+0x1c/0x35
[   72.727805]  ? cma_check_port+0x86a/0xa20 [rdma_cm]
[   72.727977]  ? cma_check_port+0x86a/0xa20 [rdma_cm]
[   72.728138]  cma_check_port+0x86a/0xa20 [rdma_cm]
[   72.728306]  rdma_bind_addr+0x11bc/0x1b00 [rdma_cm]
[   72.728465]  ? find_held_lock+0x33/0x1c0
[   72.728597]  ? cma_ndev_work_handler+0x180/0x180 [rdma_cm]
[   72.728756]  ? wait_for_completion+0x3d0/0x3d0
[   72.728928]  ucma_bind+0x120/0x160 [rdma_ucm]
[   72.729089]  ? ucma_resolve_addr+0x1a0/0x1a0 [rdma_ucm]
[   72.729256]  ucma_write+0x1f8/0x2b0 [rdma_ucm]
[   72.729409]  ? ucma_open+0x260/0x260 [rdma_ucm]
[   72.729571]  vfs_write+0x157/0x460
[   72.729688]  ksys_write+0xb8/0x170
[   72.729828]  ? __ia32_sys_read+0xb0/0xb0
[   72.729954]  ? trace_hardirqs_off_caller+0x5b/0x160
[   72.730107]  ? do_syscall_64+0x18/0x3c0
[   72.730243]  do_syscall_64+0x95/0x3c0
[   72.730363]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   72.730508] RIP: 0033:0x7f6f1758fff8
[   72.730624] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00
00 f3 0f 1e fa 48 8d 05 25 77 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f
05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4
 55
 [   72.731146] RSP: 002b:00007fff99f99088 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 [   72.731365] RAX: ffffffffffffffda RBX: 00007fff99f99090 RCX: 00007f6f1758fff8
 [   72.731579] RDX: 0000000000000090 RSI: 00007fff99f99090 RDI: 0000000000000003
 [   72.731814] RBP: 0000564942bd8ec0 R08: 0000564942bd9180 R09: 0000000000000000
 [   72.732043] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 [   72.732262] R13: 0000000000000001 R14: 0000000000000000 R15: 00005649413cc470
 [   72.732494]
 [   72.732572] Allocated by task 381:
 [   72.732692]  __kasan_kmalloc.constprop.5+0xc1/0xd0
 [   72.732857]  cma_alloc_port+0x4d/0x160 [rdma_cm]
 [   72.733006]  rdma_bind_addr+0x14e7/0x1b00 [rdma_cm]
 [   72.733153]  ucma_bind+0x120/0x160 [rdma_ucm]
 [   72.733299]  ucma_write+0x1f8/0x2b0 [rdma_ucm]
 [   72.733452]  vfs_write+0x157/0x460
 [   72.733569]  ksys_write+0xb8/0x170
 [   72.733675]  do_syscall_64+0x95/0x3c0
 [   72.733800]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 [   72.733956]
 [   72.734029] Freed by task 381:
 [   72.734133]  __kasan_slab_free+0x12e/0x180
 [   72.734284]  kfree+0xed/0x290
 [   72.734399]  rdma_destroy_id+0x6b6/0x9e0 [rdma_cm]
 [   72.734559]  ucma_close+0x110/0x300 [rdma_ucm]
 [   72.734701]  __fput+0x25a/0x740
 [   72.734832]  task_work_run+0x10e/0x190
 [   72.734959]  do_exit+0x85e/0x29e0
 [   72.735071]  do_group_exit+0xf0/0x2e0
 [   72.735182]  get_signal+0x2e0/0x17e0
 [   72.735304]  do_signal+0x94/0x1570
 [   72.735424]  exit_to_usermode_loop+0xfa/0x130
 [   72.735612]  do_syscall_64+0x327/0x3c0
 [   72.735756]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 [   72.735941]
 [   72.736033] The buggy address belongs to the object at ffff888069fde990
 [   72.736033]  which belongs to the cache kmalloc-32 of size 32
 [   72.736414] The buggy address is located 8 bytes inside of
 [   72.736414]  32-byte region [ffff888069fde990, ffff888069fde9b0)
 [   72.736777] The buggy address belongs to the page:
 [   72.736940] page:ffffea0001a7f780 count:1 mapcount:0 mapping:ffff88806bc03980 index:0x0
 [   72.737171] flags: 0x4000000000000200(slab)
 [   72.737295] raw: 4000000000000200 dead000000000100 dead000000000200 ffff88806bc03980
 [   72.737525] raw: 0000000000000000 0000000000550055 00000001ffffffff 0000000000000000
 [   72.737786] page dumped because: kasan: bad access detected
 [   72.737948]
 [   72.738019] Memory state around the buggy address:
 [   72.738164]  ffff888069fde880: fb fb fc fc fb fb fb fb fc fc fb fb  fb fb fc fc
 [   72.738396]  ffff888069fde900: fb fb fb fb fc fc fb fb fb fb fc fc  fb fb fb fb
 [   72.738627] >ffff888069fde980: fc fc fb fb fb fb fc fc fb fb fb fb  fc fc fb fb
 [   72.738869]                             ^
 [   72.738999]  ffff888069fdea00: fb fb fc fc fb fb fb fb fc fc fb fb  fb fb fc fc
 [   72.739213]  ffff888069fdea80: fb fb fb fb fc fc fb fb fb fb fc fc fb fb fb fb
 [   72.739431]
 ==================================================================
 [   72.739667] Disabling lock debugging due to kernel taint




>
> If you seem something obvious wrong in that patch please speak
> up.. Below is what I applied.
>
> Thanks,
> Jason
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 68c997be242930..a8b9c66c85252b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -39,7 +39,7 @@
>  #include <linux/mutex.h>
>  #include <linux/random.h>
>  #include <linux/igmp.h>
> -#include <linux/idr.h>
> +#include <linux/xarray.h>
>  #include <linux/inetdevice.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> @@ -191,10 +191,10 @@ static struct workqueue_struct *cma_wq;
>  static unsigned int cma_pernet_id;
>
>  struct cma_pernet {
> -	struct idr tcp_ps;
> -	struct idr udp_ps;
> -	struct idr ipoib_ps;
> -	struct idr ib_ps;
> +	struct xarray tcp_ps;
> +	struct xarray udp_ps;
> +	struct xarray ipoib_ps;
> +	struct xarray ib_ps;
>  };
>
>  static struct cma_pernet *cma_pernet(struct net *net)
> @@ -202,7 +202,8 @@ static struct cma_pernet *cma_pernet(struct net *net)
>  	return net_generic(net, cma_pernet_id);
>  }
>
> -static struct idr *cma_pernet_idr(struct net *net, enum rdma_ucm_port_space ps)
> +static
> +struct xarray *cma_pernet_xa(struct net *net, enum rdma_ucm_port_space ps)
>  {
>  	struct cma_pernet *pernet = cma_pernet(net);
>
> @@ -247,25 +248,25 @@ struct class_port_info_context {
>  static int cma_ps_alloc(struct net *net, enum rdma_ucm_port_space ps,
>  			struct rdma_bind_list *bind_list, int snum)
>  {
> -	struct idr *idr = cma_pernet_idr(net, ps);
> +	struct xarray *xa = cma_pernet_xa(net, ps);
>
> -	return idr_alloc(idr, bind_list, snum, snum + 1, GFP_KERNEL);
> +	return xa_insert(xa, snum, bind_list, GFP_KERNEL);
>  }
>
>  static struct rdma_bind_list *cma_ps_find(struct net *net,
>  					  enum rdma_ucm_port_space ps, int snum)
>  {
> -	struct idr *idr = cma_pernet_idr(net, ps);
> +	struct xarray *xa = cma_pernet_xa(net, ps);
>
> -	return idr_find(idr, snum);
> +	return xa_load(xa, snum);
>  }
>
>  static void cma_ps_remove(struct net *net, enum rdma_ucm_port_space ps,
>  			  int snum)
>  {
> -	struct idr *idr = cma_pernet_idr(net, ps);
> +	struct xarray *xa = cma_pernet_xa(net, ps);
>
> -	idr_remove(idr, snum);
> +	xa_erase(xa, snum);
>  }
>
>  enum {
> @@ -4655,10 +4656,10 @@ static int cma_init_net(struct net *net)
>  {
>  	struct cma_pernet *pernet = cma_pernet(net);
>
> -	idr_init(&pernet->tcp_ps);
> -	idr_init(&pernet->udp_ps);
> -	idr_init(&pernet->ipoib_ps);
> -	idr_init(&pernet->ib_ps);
> +	xa_init(&pernet->tcp_ps);
> +	xa_init(&pernet->udp_ps);
> +	xa_init(&pernet->ipoib_ps);
> +	xa_init(&pernet->ib_ps);
>
>  	return 0;
>  }
> @@ -4667,10 +4668,10 @@ static void cma_exit_net(struct net *net)
>  {
>  	struct cma_pernet *pernet = cma_pernet(net);
>
> -	idr_destroy(&pernet->tcp_ps);
> -	idr_destroy(&pernet->udp_ps);
> -	idr_destroy(&pernet->ipoib_ps);
> -	idr_destroy(&pernet->ib_ps);
> +	WARN_ON(!xa_empty(&pernet->tcp_ps));
> +	WARN_ON(!xa_empty(&pernet->udp_ps));
> +	WARN_ON(!xa_empty(&pernet->ipoib_ps));
> +	WARN_ON(!xa_empty(&pernet->ib_ps));
>  }
>
>  static struct pernet_operations cma_pernet_operations = {
>

--5cSRzy0VGBWAML+b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcoliDAAoJEORje4g2clin/roQAIL59bkz48T0sQK8KVHutFi7
qt8jGpMHhigxP2Ujis+4F9fXYJihVwPZZLV/8BogCS6GtL2UJJZo3ww+c8AIjCcA
LnMNtdtDQoVjeS0wdjqVhE8TigCxIzHq5akpTOvnKmc2Hlt/JdOrG14LSg7elbRJ
5wW79AevJ3/VuSYpkreBOsqDOrW/vmU5uOS0sb8KS+Ln+9pZ0J6db1tJP5NVfghw
B8e1dWmcqQ6Zkl9nGGwmnGUHfXmtIulL3yC7ZCx05oY0r9SMQd02CsLrlDea1h3F
FPic91/Hg3F4tZAf8FHsykA0rE5Tr/akQTAEY9PfSF9Ghjefy4Qj0eBqojyuh6wd
/5XVzsJMm3AQJ7L2jb2FTUJ5M2Hq0I+uRmDfo9fYQ3gRGdK2ZG2BJwUCFlFItDP5
/3QnEmC2RV65wTepFt9UtrA4r5wl8czz67YF+0CE88lLE5tQqvu9SCpZT/MOgh84
cXJnxIa3fRJK4CAeY9ya/z1rMaZ4hjHJANhvi/OVUGDQy314iCLGFOKct8t12/0L
sppZeq0gNt2BZ/6k8Qgs8XSuvqdi2gC5u//hm2NeJvGliEO/1ozHJO7zv0p8u9nr
mmr16idaF538jBaotADEkB1zqvnqJK8lgmtywM5vyPQLDd2uQK/oox4iNdqiFpcz
06alg/h/D9wM/DZL9yR+
=TmCW
-----END PGP SIGNATURE-----

--5cSRzy0VGBWAML+b--
