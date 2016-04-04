From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Mon, 4 Apr 2016 08:10:31 -0700
Message-ID: <20160404151031.GA30729@infradead.org>
References: <20160404134656.GA30269@infradead.org>
 <57027D48.4000500@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57027D48.4000500-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

LIO target running either 4.5 or 4.6-rc2 backed by an NVMe device on the
other side.  The systems are connected using Connect-X 3 and 4 devices,
and based on the IP address used it should be routed to the Connect-X 3
ones on either side.

I did a mkfs.xfs on the device (works) and then started a run of the
"quick" xfstests group, which didn't even start output for the first
test - based on that it happened very early during mount.

FYI, FRs didn't look much better either a few tests into the xfstests
run:

[  343.062657] iser: iser_prepare_read_cmd: Failed to set up Data-IN RDMA
[  343.070861] iser: iser_send_command: conn ffff8804a4682328 failed task->itt 6 err -22
[  343.086357] iser: iser_fast_reg_mr: failed to map sg (68/69)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
