From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Sun, 10 Apr 2016 16:30:11 +0300
Message-ID: <570A5563.5060104@mellanox.com>
References: <5702A46F.5070109@grimberg.me> <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org> <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org> <570548AB.4090802@grimberg.me>
 <20160406231658.GB11588@infradead.org> <570608C9.1070805@grimberg.me>
 <570623B9.8040108@mellanox.com> <570679B6.10409@grimberg.me>
 <20160407221359.GA16686@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407221359.GA16686-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/8/2016 1:13 AM, Christoph Hellwig wrote:
> The patch below fixes the issue for me.  But for SRP I'm still seeing
> lots of these failures even with the equivalent patch applied:
>
> [ 426.027905] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053203] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053265] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053270] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053273] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053276] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053279] scsi host8: ib_srp: Failed to map data (-12)
>
> It seems the actual reproducer is xfs_repair as run by xfstests.
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 60b169a..3ac4755 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3205,6 +3205,7 @@ static ssize_t srp_create_target(struct device *dev,
>   	target_host->max_id      = 1;
>   	target_host->max_lun     = -1LL;
>   	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
> +	target_host->max_segment_size = PAGE_SIZE;
>
>   	target = host_to_target(target_host);

Hi Christoph,
did you add similar assignment in iser code or only used the scsi patches ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
