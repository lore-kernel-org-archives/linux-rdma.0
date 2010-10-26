From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 04/10] drivers/infiniband: Remove unnecessary KERN_<level>
 uses
Date: Tue, 26 Oct 2010 06:29:04 -0500
Message-ID: <4CC6BB80.5020801@opengridcomputing.com>
References: <cover.1288059486.git.joe@perches.com> <a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 10/25/2010 9:44 PM, Joe Perches wrote:
> Signed-off-by: Joe Perches<joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>   drivers/infiniband/hw/amso1100/c2_intr.c |    4 ++--
>   drivers/infiniband/hw/cxgb3/iwch_cm.c    |    4 ++--
>   drivers/infiniband/hw/cxgb4/cm.c         |    4 ++--
>   3 files changed, 6 insertions(+), 6 deletions(-)
>

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
