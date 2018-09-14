From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 10:15:48 -0700
Message-ID: <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
References: <20180914002514.27571-1-qing.huang@oracle.com>
 <20180914044314.GC5257@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914044314.GC5257@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

The FW version is actually a very crucial piece of information and only 
printed once here
when the driver is loaded. People tend to get confused when switching 
multiple FW files
back and forth without running separate utility tools, especially at 
customer sites.
IMHO, this information is very useful and only takes up very little log 
file space. :-)

I was also thinking of doing something slightly differently. Maybe we 
just trim down the
output string, and add something like this?
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2208,6 +2208,11 @@ static int mlx4_init_fw(struct mlx4_dev *dev)
                         return err;
                 }

+               mlx4_info(dev, "Installed FW version is %d.%d.%03d.\n",
+                         (int) (dev->caps.fw_ver >> 32),
+                         (int) (dev->caps.fw_ver >> 16) & 0xffff,
+                         (int) dev->caps.fw_ver & 0xffff);
+
                 err = mlx4_load_fw(dev);
                 if (err) {
                         mlx4_err(dev, "Failed to start FW, aborting\n");

Thanks,
Qing

On 9/13/2018 9:43 PM, Leon Romanovsky wrote:
> On Thu, Sep 13, 2018 at 05:25:14PM -0700, Qing Huang wrote:
>> When debugging firmware related issues, it's very helpful to have
>        ^^^^^^^^^^ exactly, this is why we set this print as mlx4_dbg and
>        not mlx4_info.
>
>> the installed FW version info in the kernel log when the driver is
>> loaded. It's easier to match error/warning messages with different
>> FW versions in the log other than running a separate tool to get
>> the information back and forth.
>>
>> Signed-off-by: Qing Huang <qing.huang@oracle.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/fw.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
>> index babcfd9..e1c5218 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/fw.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
>> @@ -1686,11 +1686,11 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
>>   	MLX4_GET(lg, outbox, QUERY_FW_MAX_CMD_OFFSET);
>>   	cmd->max_cmds = 1 << lg;
>>
>> -	mlx4_dbg(dev, "FW version %d.%d.%03d (cmd intf rev %d), max commands %d\n",
>> -		 (int) (dev->caps.fw_ver >> 32),
>> -		 (int) (dev->caps.fw_ver >> 16) & 0xffff,
>> -		 (int) dev->caps.fw_ver & 0xffff,
>> -		 cmd_if_rev, cmd->max_cmds);
>> +	mlx4_info(dev, "FW version %d.%d.%03d (cmd intf rev %d), max commands %d\n",
>> +		  (int)(dev->caps.fw_ver >> 32),
>> +		  (int)(dev->caps.fw_ver >> 16) & 0xffff,
>> +		  (int)dev->caps.fw_ver & 0xffff,
>> +		  cmd_if_rev, cmd->max_cmds);
>>
>>   	MLX4_GET(fw->catas_offset, outbox, QUERY_FW_ERR_START_OFFSET);
>>   	MLX4_GET(fw->catas_size,   outbox, QUERY_FW_ERR_SIZE_OFFSET);
>> --
>> 2.9.3
>>
