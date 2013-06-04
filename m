From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH libibverbs v6 6/7] libibverbs: Add man page for ibv_open_qp
Date: Tue, 04 Jun 2013 14:02:30 -0500
Message-ID: <51AE39C6.3080205@opengridcomputing.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com> <1370371791-15018-7-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370371791-15018-7-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 6/4/2013 1:49 PM, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   man/ibv_open_qp.3 |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 50 insertions(+), 0 deletions(-)
>   create mode 100644 man/ibv_open_qp.3

Udate Makefile.am so this gets installed.

There should also be man pages for the other new verbs.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
