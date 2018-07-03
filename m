From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] ib_srpt: Fix a use-after-free in __srpt_close_all_ch()
Date: Tue, 3 Jul 2018 14:17:46 -0600
Message-ID: <20180703201746.GD14418@ziepe.ca>
References: <20180702210845.9166-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180702210845.9166-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 02, 2018 at 02:08:45PM -0700, Bart Van Assche wrote:
> BUG: KASAN: use-after-free in srpt_set_enabled+0x1a9/0x1e0 [ib_srpt]
> Read of size 4 at addr ffff8801269d23f8 by task check/29726
> 
> CPU: 4 PID: 29726 Comm: check Not tainted 4.18.0-rc2-dbg+ #4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> Call Trace:
>  dump_stack+0xa4/0xf5
>  print_address_description+0x6f/0x270
>  kasan_report+0x241/0x360
>  __asan_load4+0x78/0x80
>  srpt_set_enabled+0x1a9/0x1e0 [ib_srpt]
>  srpt_tpg_enable_store+0xb8/0x120 [ib_srpt]
>  configfs_write_file+0x14e/0x1d0 [configfs]
>  __vfs_write+0xd2/0x3b0
>  vfs_write+0x101/0x270
>  ksys_write+0xab/0x120
>  __x64_sys_write+0x43/0x50
>  do_syscall_64+0x77/0x230
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7f235cfe6154
> 
> Fixes: aaf45bd83eba ("IB/srpt: Detect session shutdown reliably")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to for-next

Thanks,
Jason
