From: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Subject: Re: [PATCH rdma/wip/jgg-for-next] RDMA/netlink: Hide unimplemented
 NLDEV commands
Date: Tue, 30 Jan 2018 19:18:14 +0100
Message-ID: <20180130181814.GD14797@nanopsycho>
References: <20180130150716.16372-1-leon@kernel.org>
 <20180130155706.GC14797@nanopsycho>
 <20180130160337.GD17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130160337.GD17053-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tue, Jan 30, 2018 at 05:03:37PM CET, jgg-uk2M96/98Pc@public.gmane.org wrote:
>On Tue, Jan 30, 2018 at 04:57:06PM +0100, Jiri Pirko wrote:
>> Tue, Jan 30, 2018 at 04:07:16PM CET, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >
>> >The nldev was implemented by following devlink implementation,
>> >including SET/DEL/NEW commands. However these commands were not
>> >implemented and hence don't need to be exposed.
>> >
>> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> > include/uapi/rdma/rdma_netlink.h | 14 ++++++--------
>> > 1 file changed, 6 insertions(+), 8 deletions(-)
>> >
>> >diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
>> >index 17e59bec169e..4c77e2a7b07e 100644
>> >+++ b/include/uapi/rdma/rdma_netlink.h
>> >@@ -227,16 +227,14 @@ enum rdma_nldev_command {
>> > 	RDMA_NLDEV_CMD_UNSPEC,
>> >
>> > 	RDMA_NLDEV_CMD_GET, /* can dump */
>> >-	RDMA_NLDEV_CMD_SET,
>> >-	RDMA_NLDEV_CMD_NEW,
>> >-	RDMA_NLDEV_CMD_DEL,
>> >
>> >-	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
>> >-	RDMA_NLDEV_CMD_PORT_SET,
>> >-	RDMA_NLDEV_CMD_PORT_NEW,
>> >-	RDMA_NLDEV_CMD_PORT_DEL,
>> >+	/* 2 - 4 are free to use */
>> >
>> >-	RDMA_NLDEV_CMD_RES_GET, /* can dump */
>> >+	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
>> >+
>> >+	/* 6 - 8 are free to use */
>> 
>> I don't see reason for the wholes.
>
>We are stuck with the holes, it is fixed uABI at this point, can't
>change the constants we actually implemented.

If it is realeased already, we can't remove the defines either.


>
>> Also, Don't you use *_NEW for replies to *_GET, as it is common for
>> Netlink?
>
>It appears not..
>
>IMHO that convention makes the most sense when there is a GET/NEW pair
>with the idea the NEW is formed to be echoed back to the kernel -
>these case are all GET only..
>
>Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
