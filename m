From: Selvin Xavier <selvin.xavier@broadcom.com>
Subject: Re: [PATCH] hw: Fix permissions for OCRDMA_RESET_STATS
Date: Tue, 19 Dec 2017 15:59:30 +0530
Message-ID: <CA+sbYW2FHpCH+=f_v6j7J6eQhw++wQeUp1GmX=h-CwVA2OSr4w@mail.gmail.com>
References: <1502207797-25589-1-git-send-email-vasilyev@ispras.ru> <20170815183158.GB24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170815183158.GB24282@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Anton Vasilyev <vasilyev@ispras.ru>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Michael Mera <dev@michaelmera.com>, linux-rdma@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 16, 2017 at 12:01 AM, Leon Romanovsky <leon@kernel.org> wrote:
> On Tue, Aug 08, 2017 at 06:56:37PM +0300, Anton Vasilyev wrote:
>> Debugfs file reset_stats is created with S_IRUSR permissions,
>> but ocrdma_dbgfs_ops_read() doesn't support OCRDMA_RESET_STATS,
>> whereas ocrdma_dbgfs_ops_write() supports only OCRDMA_RESET_STATS.
>>
>> The patch fixes misstype with permissions.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
>> ---
>>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
>> index 66056f9..d42c617 100644
>> --- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
>> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
>> @@ -834,7 +834,7 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
>>
>>       dev->reset_stats.type = OCRDMA_RESET_STATS;
>>       dev->reset_stats.dev = dev;
>> -     if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
>> +     if (!debugfs_create_file("reset_stats", S_IWUSR, dev->dir,
>>                               &dev->reset_stats, &ocrdma_dbg_ops))
>>               goto err;
>>
>
> If I didn't miss anything, the reset_stats knob wouldn't work.
>
> Any read of statistics from that debugfs will trigger the call to
> ocrdma_update_stats and it will call to ocrdma_mbx_rdma_stats(dev, false).
>
> For write operations to that "reset_stats", there is call
> to ocrdma_mbx_rdma_stats with second argument (reset) as true.
>
> But it doesn't do much with that "reset" argument, except update of reset_stats.
>
> git grep reset_stats drivers/infiniband/hw/ocrdma/* drivers/net/ethernet/emulex/
> drivers/infiniband/hw/ocrdma/ocrdma.h:  struct ocrdma_stats reset_stats;
> drivers/infiniband/hw/ocrdma/ocrdma_hw.c:               req->reset_stats = reset;

"reset" filed is passed down to the FW mailbox command to reset the
stats maintained by FW.
req is a pointer to dev->stats_mem.va and this is used to send down
the command to FW.
status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);


> drivers/infiniband/hw/ocrdma/ocrdma_sli.h:      u8 reset_stats;
> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    dev->reset_stats.type = OCRDMA_RESET_STATS;
> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    dev->reset_stats.dev = dev;
> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:                            &dev->reset_stats, &ocrdma_dbg_ops))
> drivers/net/ethernet/emulex/benet/be_cmds.c:    req->cmd_params.params.reset_stats = 0;
> drivers/net/ethernet/emulex/benet/be_cmds.h:    u8 reset_stats;
>
> Thanks

The patch looks good to me.
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>

Thanks
Selvin
