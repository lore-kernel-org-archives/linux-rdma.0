From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Tue, 6 Dec 2016 11:31:14 +0530
Message-ID: <CA+sbYW1sUrv8CBHScMjU7ozBm709-tiVWaynDQK_Dq3AqAfggA@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com> <20161205165144.GB24852@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161205165144.GB24852-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

On Mon, Dec 5, 2016 at 10:21 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Dec 04, 2016 at 10:38:04PM -0800, Selvin Xavier wrote:
>>  drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h |   60 +
>
> This file probably needs to be in include/uapi/rdma like the others
>

Sure.. i will this include as a part of V2.

> Do you have a git tree someplace for this?
>
I assume you are referring to our uverbs library.  We have the
component ready but is not uploaded to external git yet. We will
publish it soon and let you know the pointers.

> Do you have the user space component ready for rdma-core as well?
>
This is not ready yet. Currently working on it.
> Jason

Thanks,
Selvin Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
