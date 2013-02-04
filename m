From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 27/62] infiniband/ipath: convert to idr_alloc()
Date: Mon, 4 Feb 2013 16:15:52 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D58DDB2@FMSMSX108.amr.corp.intel.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-28-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359854463-2538-28-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org" <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org" <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I tried the branch you indicated in the initial patch cover.

When run with a qib driver, and ipoib ping of another system produces:

Feb  4 11:05:39 phemb007 kernel: ------------[ cut here ]------------
Feb  4 11:05:39 phemb007 kernel: WARNING: at lib/idr.c:374 idr_preload+0xa9/0xc0()
Feb  4 11:05:39 phemb007 kernel: Hardware name: Relion 1751
Feb  4 11:05:39 phemb007 kernel: Modules linked in: autofs4 sunrpc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support sg coretemp hwmon kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 i2c_core lpc_ich mfd_core ioatdma i7core_edac edac_core ib_qib ib_mad ib_core igb dca ptp pps_core ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif ahci libahci [last unloaded: speedstep_lib]
Feb  4 11:05:39 phemb007 kernel: Pid: 322, comm: kworker/u:5 Not tainted 3.8.0-rc4idr+ #1
Feb  4 11:05:39 phemb007 kernel: Call Trace:
Feb  4 11:05:39 phemb007 kernel: <IRQ>  [<ffffffff810553cf>] warn_slowpath_common+0x7f/0xc0
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8105542a>] warn_slowpath_null+0x1a/0x20
Feb  4 11:05:39 phemb007 kernel: [<ffffffff81263679>] idr_preload+0xa9/0xc0
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa026e25d>] send_mad+0x2d/0xf0 [ib_sa]
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa026ed03>] ib_sa_path_rec_get+0x173/0x1e0 [ib_sa]
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa033edae>] path_rec_start+0x9e/0x110 [ib_ipoib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa03401b0>] ? ipoib_set_mode+0xe0/0xe0 [ib_ipoib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa033fcb5>] unicast_arp_send+0x185/0x240 [ib_ipoib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa0340db6>] ipoib_start_xmit+0x116/0x220 [ib_ipoib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffff814742f2>] dev_hard_start_xmit+0x122/0x570
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8149252a>] sch_direct_xmit+0xfa/0x1d0
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8147488b>] dev_queue_xmit+0x14b/0x3e0
Feb  4 11:05:39 phemb007 kernel: [<ffffffff814db1d8>] arp_xmit+0x58/0x60
Feb  4 11:05:39 phemb007 kernel: [<ffffffff814db223>] arp_send+0x43/0x50
Feb  4 11:05:39 phemb007 kernel: [<ffffffff814dbcfe>] arp_process+0x5ee/0x630
Feb  4 11:05:39 phemb007 kernel: [<ffffffff811298c5>] ? put_page+0x25/0x40
Feb  4 11:05:39 phemb007 kernel: [<ffffffff814670cd>] ? __pskb_pull_tail+0x25d/0x340
Feb  4 11:05:39 phemb007 kernel: [<ffffffff814da9ed>] arp_rcv+0x10d/0x150
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8147595e>] __netif_receive_skb+0x55e/0x770
Feb  4 11:05:39 phemb007 kernel: [<ffffffff81475d8d>] netif_receive_skb+0x2d/0x90
Feb  4 11:05:39 phemb007 kernel: [<ffffffff81476818>] napi_gro_receive+0x118/0x160
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa0342fe4>] ipoib_ib_handle_rx_wc+0x184/0x2f0 [ib_ipoib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa03433cb>] ipoib_poll+0x15b/0x190 [ib_ipoib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffff81476473>] net_rx_action+0x103/0x280
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8105dc37>] __do_softirq+0xd7/0x240
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8154585c>] call_softirq+0x1c/0x30
Feb  4 11:05:39 phemb007 kernel: <EOI>  [<ffffffff81016465>] do_softirq+0x65/0xa0
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8105dad4>] local_bh_enable+0x94/0xa0
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa0109267>] send_complete+0x37/0x50 [ib_qib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffff81072487>] process_one_work+0x177/0x430
Feb  4 11:05:39 phemb007 kernel: [<ffffffffa0109230>] ? qib_destroy_cq+0x90/0x90 [ib_qib]
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8107441e>] worker_thread+0x12e/0x380
Feb  4 11:05:39 phemb007 kernel: [<ffffffff810742f0>] ? manage_workers+0x180/0x180
Feb  4 11:05:39 phemb007 kernel: [<ffffffff8107968e>] kthread+0xce/0xe0
Feb  4 11:05:39 phemb007 kernel: [<ffffffff810795c0>] ? kthread_freezable_should_stop+0x70/0x70
Feb  4 11:05:39 phemb007 kernel: [<ffffffff815444ac>] ret_from_fork+0x7c/0xb0
Feb  4 11:05:39 phemb007 kernel: [<ffffffff810795c0>] ? kthread_freezable_should_stop+0x70/0x70
Feb  4 11:05:39 phemb007 kernel: ---[ end trace 440364ae99db88da ]---

Looks like this is tripping during the arp/neighbour path resolution:

void idr_preload(gfp_t gfp_mask)
{
    /*
     * Consuming preload buffer from non-process context breaks preload
     * allocation guarantee.  Disallow usage from those contexts.
     */
    WARN_ON_ONCE(in_interrupt()); <------------------------

Any ideas Roland?

Mike


> -----Original Message-----
> From: Tejun Heo [mailto:htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Tejun Heo
> Sent: Saturday, February 02, 2013 8:20 PM
> To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org;
> skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org; ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org; jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org;
> axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org; Tejun Heo; infinipath; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH 27/62] infiniband/ipath: convert to idr_alloc()
> 
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> This patch depends on an earlier idr changes and I think it would be best to
> route these together through -mm.  Please holler if there's any objection.
> Thanks.
> 
>  drivers/infiniband/hw/ipath/ipath_driver.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c
> b/drivers/infiniband/hw/ipath/ipath_driver.c
> index 7b371f5..fcdaeea 100644
> --- a/drivers/infiniband/hw/ipath/ipath_driver.c
> +++ b/drivers/infiniband/hw/ipath/ipath_driver.c
> @@ -194,11 +194,6 @@ static struct ipath_devdata
> *ipath_alloc_devdata(struct pci_dev *pdev)
>  	struct ipath_devdata *dd;
>  	int ret;
> 
> -	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
> -		dd = ERR_PTR(-ENOMEM);
> -		goto bail;
> -	}
> -
>  	dd = vzalloc(sizeof(*dd));
>  	if (!dd) {
>  		dd = ERR_PTR(-ENOMEM);
> @@ -206,9 +201,10 @@ static struct ipath_devdata
> *ipath_alloc_devdata(struct pci_dev *pdev)
>  	}
>  	dd->ipath_unit = -1;
> 
> +	idr_preload(GFP_KERNEL);
>  	spin_lock_irqsave(&ipath_devs_lock, flags);
> 
> -	ret = idr_get_new(&unit_table, dd, &dd->ipath_unit);
> +	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_KERNEL);
>  	if (ret < 0) {
>  		printk(KERN_ERR IPATH_DRV_NAME
>  		       ": Could not allocate unit ID: error %d\n", -ret); @@ -216,6
> +212,7 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev
> *pdev)
>  		dd = ERR_PTR(ret);
>  		goto bail_unlock;
>  	}
> +	dd->ipath_unit = ret;
> 
>  	dd->pcidev = pdev;
>  	pci_set_drvdata(pdev, dd);
> @@ -224,7 +221,7 @@ static struct ipath_devdata *ipath_alloc_devdata(struct
> pci_dev *pdev)
> 
>  bail_unlock:
>  	spin_unlock_irqrestore(&ipath_devs_lock, flags);
> -
> +	idr_preload_end();
>  bail:
>  	return dd;
>  }
> @@ -2503,11 +2500,6 @@ static int __init infinipath_init(void)
>  	 * the PCI subsystem.
>  	 */
>  	idr_init(&unit_table);
> -	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
> -		printk(KERN_ERR IPATH_DRV_NAME ": idr_pre_get()
> failed\n");
> -		ret = -ENOMEM;
> -		goto bail;
> -	}
> 
>  	ret = pci_register_driver(&ipath_driver);
>  	if (ret < 0) {
> --
> 1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
