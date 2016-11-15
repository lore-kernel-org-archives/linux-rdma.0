From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: suspicious rcu_dereference_protected() usage in mlx4 when tearing
 down an interface
Date: Tue, 15 Nov 2016 14:30:13 +0200
Message-ID: <52285420-40b9-afdb-cb29-7e0c939ece26@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Guys,

I just hit this with 4.9-rc4 on my test vm.
Didn't find any patches on the list so maybe this
is new?


[   12.392197] ===============================
[   12.392927] [ INFO: suspicious RCU usage. ]
[   12.393625] 4.9.0-rc4-e386eaffebc4-lb #25 Tainted: G           OE
[   12.394633] -------------------------------
[   12.395317] drivers/net/ethernet/mellanox/mlx4/en_rx.c:543 suspicious 
rcu_dereference_protected() usage!
[   12.396873]
                other info that might help us debug this:

[   12.398134]
                rcu_scheduler_active = 1, debug_locks = 0
[   12.399107] 1 lock held by rmmod/707:
[   12.399665]  #0:
[   12.399939]  (
[   12.400230] intf_mutex
[   12.400378] ){+.+.+.}
[   12.400805] , at:
[   12.401139] [<ffffffffc015e93d>] mlx4_unregister_interface+0x1d/0x70 
[mlx4_core]
[   12.402275]
                stack backtrace:
[   12.402926] CPU: 3 PID: 707 Comm: rmmod Tainted: G           OE 
4.9.0-rc4-e386eaffebc4-lb #25
[   12.404221] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   12.405619]  ffffb5fdc0fcfda0 ffffffffb6450643 ffff951f787b22c0 
0000000000000001
[   12.406793]  ffffb5fdc0fcfdd0 ffffffffb60e78f7 ffff951f73966000 
0000000000000400
[   12.407966]  ffff951f70430ad8 ffff951f73584800 ffffb5fdc0fcfe08 
ffffffffc020f77a
[   12.409069] Call Trace:
[   12.409437]  [<ffffffffb6450643>] dump_stack+0x85/0xc2
[   12.410151]  [<ffffffffb60e78f7>] lockdep_rcu_suspicious+0xd7/0x110
[   12.411024]  [<ffffffffc020f77a>] mlx4_en_destroy_rx_ring+0xba/0xc0 
[mlx4_en]
[   12.412032]  [<ffffffffc0215ec6>] mlx4_en_free_resources+0xb6/0xf0 
[mlx4_en]
[   12.413006]  [<ffffffffc021abe2>] mlx4_en_destroy_netdev+0xe2/0x1b0 
[mlx4_en]
[   12.413994]  [<ffffffffc020b105>] mlx4_en_remove+0xe5/0xf0 [mlx4_en]
[   12.414883]  [<ffffffffc015e903>] mlx4_remove_device+0x73/0x90 
[mlx4_core]
[   12.415844]  [<ffffffffc015e95e>] mlx4_unregister_interface+0x3e/0x70 
[mlx4_core]
[   12.416880]  [<ffffffffc021dd6b>] mlx4_en_cleanup+0x10/0x2a5 [mlx4_en]
[   12.417773]  [<ffffffffb613322a>] SyS_delete_module+0x1ba/0x220
[   12.418545]  [<ffffffffb68e3085>] entry_SYSCALL_64_fastpath+0x23/0xc6
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
