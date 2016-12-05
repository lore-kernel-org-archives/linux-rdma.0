From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Mon, 5 Dec 2016 09:51:44 -0700
Message-ID: <20161205165144.GB24852@obsidianresearch.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 04, 2016 at 10:38:04PM -0800, Selvin Xavier wrote:
>  drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h |   60 +

This file probably needs to be in include/uapi/rdma like the others

Do you have a git tree someplace for this?

Do you have the user space component ready for rdma-core as well?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
