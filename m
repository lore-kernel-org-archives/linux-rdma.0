From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Mark the QP in error before disabling the
 Q in the firmware
Date: Fri, 28 Oct 2011 08:56:29 -0500
Message-ID: <4EAAB48D.1000100@opengridcomputing.com>
References: <1319540910-443-1-git-send-email-kumaras@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319540910-443-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/25/2011 06:08 AM, Kumar Sanghvi wrote:
> From: Tom Tucker<tom-/Yg/VP3ZvrM@public.gmane.org>
>
> The QP needs to be moved to error before telling the firwmare
> to shutdown the queue. Otherwise, the application can submit
> WR that will never get fetched by the hardware and never
> flushed by the driver.
>
> Signed-off-by: Kumar Sanghvi<kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Acked-by: Steve Wise <swsie-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
