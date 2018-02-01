From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Regression: Connect-X5 doesn't connect with NVME-of
Date: Thu, 1 Feb 2018 10:56:17 -0700
Message-ID: <66a5332c-01ee-7a39-8224-189fa52a7298@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

We've experienced a regression with using nvme-of and two Connect-X5s. 
With v4.15 and v4.14.16 we see the following dmesgs when trying to 
connect to the target:

> [   43.732539] nvme nvme2: creating 16 I/O queues.
> [   44.072427] nvmet: adding queue 1 to ctrl 1.
> [   44.072553] nvmet: adding queue 2 to ctrl 1.
> [   44.072597] nvme nvme2: Connect command failed, error wo/DNR bit: -16402
> [   44.072609] nvme nvme2: failed to connect queue: 3 ret=-18
> [   44.075421] nvmet_rdma: freeing queue 2
> [   44.075792] nvmet_rdma: freeing queue 1
> [   44.264293] nvmet_rdma: freeing queue 3
> *snip*

(on v4.15 there is additional error panics likely do to some other 
nvme-of error handling bugs)

And nvme connect returns:

> Failed to write to /dev/nvme-fabrics: Invalid cross-device link

The two adapters are the same with the latest available firmware:

> 	transport:			InfiniBand (0)
> 	fw_ver:				16.21.2010
> 	vendor_id:			0x02c9
> 	vendor_part_id:			4119
> 	hw_ver:				0x0
> 	board_id:			MT_0000000010

We bisected to find the commit that broke our setup is:

05e0cc84e00c net/mlx5: Fix get vector affinity helper function

Thanks,

Logan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
