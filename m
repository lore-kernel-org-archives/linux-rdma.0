From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Fri, 30 Sep 2016 09:51:18 -0700
Message-ID: <036dafb3-4fd0-f748-f7e4-54c7dd6def9e@sandisk.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-9-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/29/2016 01:47 PM, Jason Gunthorpe wrote:
> For a long time now endian.h has defined sane fixed with conversion
> macros, so lets just use them instead of rolling our own.
>
> Also, htonll is defined in this source tree under infiniband/arch.h,
> so all users of that macro can just use the header.
>
> Someday we should also get rid of all the endless wrappers..
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/linux/osd.h                    |  8 +-------
>  libcxgb3/src/cxio_wr.h               | 10 +++-------
>  libcxgb4/src/t4.h                    | 11 ++++-------
>  libi40iw/src/i40iw_umain.h           | 18 ++----------------
>  libibumad/src/sysfs.c                |  8 +-------
>  libibverbs/include/infiniband/arch.h | 15 ++++++---------
>  libnes/src/nes_umain.h               | 17 ++---------------
>  libocrdma/src/ocrdma_verbs.c         | 32 ++++----------------------------
>  librdmacm/examples/common.h          | 11 +++--------
>  librdmacm/src/cma.h                  |  9 +--------
>  srp_daemon/srp_daemon/srp_daemon.h   | 17 +----------------
>  11 files changed, 28 insertions(+), 128 deletions(-)

For the srp_daemon changes:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
