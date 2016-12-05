From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: I/O error on dd commands
Date: Mon, 5 Dec 2016 12:12:18 +0200
Message-ID: <05412e7f-b2e7-e799-c9d0-5053f5bde6ee@mellanox.com>
References: <b8b48041a15444bc9c62176d6807433a@TGXML382.toshiba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b8b48041a15444bc9c62176d6807433a-DqNMWkYM789gYsFYm0uEO7jjLBE8jN/0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/5/2016 7:41 AM, Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org wrote:
> Hi Moni,
>
> Does a rxe driver of vanilla 4.9-rc6 fine work?
> When the dd command is tested for a read and write, it'll be the following error.
>
> (read)
> # dd if=/dev/nvme0n1 of=<readfile>.bin bs=1024 count=10000 iflag=direct
>
> blk_update_request: I/O error, dev nvme0n1, sector 1860
> nvme nvme0: reconnecting in 10 seconds
> nvme nvme0: Successfully reconnected
>
> or
>
> nvme nvme0: failed nvme_keep_alive_end_io error=16391
> nvme nvme0: reconnecting in 10 seconds
> nvme nvme0: Successfully reconnected
>
> (write)
> # dd if=<writefile>.bin of=/dev/nvme0n1 bs=1024 count=10000 oflag=direct
>
> blk_update_request: I/O error, dev nvme0n1, sector 1860
> nvme nvme0: reconnecting in 10 seconds
> nvme nvme0: Successfully reconnected
>
> or
>
> nvme nvme0: failed nvme_keep_alive_end_io error=16391
> nvme nvme0: reconnecting in 10 seconds
> nvme nvme0: Successfully reconnected
>
> I'd like to investigate the root cause of this error, are there any ideas?

Hi Haruo,

can you try to repro it with iSER ?
what is your backing store device ?
is this happens in 1k bs only or in different bs as well ?

thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
