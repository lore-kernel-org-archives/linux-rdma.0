From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Mon, 5 Feb 2018 11:09:04 -0700
Message-ID: <20180205180904.GB11446@mellanox.com>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517840992-29813-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 05, 2018 at 04:29:51PM +0200, Max Gurtovoy wrote:
> Currently the async EQ has 256 entries only. It might not be big enough
> for the SW to handle all the needed pending events. For example, in case
> of many QPs (let's say 1024) connected to a SRQ created using NVMeOF target
> and the target goes down, the FW will raise 1024 "last WQE reached" events
> and may cause EQ overrun. Increase the EQ to more reasonable size, that beyond
> it the FW should be able to delay the event and raise it later on using internal
> backpressure mechanism.

If the firmware has an internal backpressure meachanism then why
would we get a EQ overrun?

Do we need to block adding too many QPs to a SRQ as well or something
like that?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
