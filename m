From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC] IB/core, cma: Nice log-friendly string helpers
Date: Sun, 10 May 2015 15:04:21 +0300
Message-ID: <554F4945.8080000@mellanox.com>
References: <1431252274-27739-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431252274-27739-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/10/2015 1:04 PM, Sagi Grimberg wrote:
> Some of us keep revisiting the code to decode IB/RDMA_CM enumerations
> that appear in our logs. Let's borrow the nice logging helpers xprtrdma
> has for CMA events, IB events and WC statuses. Also, have srp, iser and
> isert be early adopters.
>
> Signed-off-by: Sagi Grimberg<sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> I have been using this patch for some time now so I thought
> it would be nice to get it out.
>
>   drivers/infiniband/ulp/iser/iser_verbs.c |   25 +++++---
>   drivers/infiniband/ulp/srp/ib_srp.c      |   15 +++--
>   include/rdma/ib_verbs.h                  |   55 ++++++++++++++++++
>   include/rdma/rdma_cm.h                   |   23 ++++++++
>   net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------------------
>   5 files changed, 106 insertions(+), 102 deletions(-)

Nice initiative (was on my Q for years...), please make sure to plug 
into the RDS code into this party, that isre-use their 
RDS_IB_EVENT_STRING, RDS_CM_EVENT_STRING and such to avoid us declaring 
the same strings over and over.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
