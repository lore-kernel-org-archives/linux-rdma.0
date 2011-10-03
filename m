From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 4/4] RDMA/nes: Adds support for MPA frame Version 2
Date: Mon, 03 Oct 2011 14:28:05 -0500
Message-ID: <4E8A0CC5.6030705@opengridcomputing.com>
References: <1316962066-28701-1-git-send-email-kumaras@chelsio.com> <1316962066-28701-5-git-send-email-kumaras@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316962066-28701-5-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/25/2011 09:47 AM, Kumar Sanghvi wrote:
> From: Tatyana<Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> MPA V2 changes are based on a IETF STORM Draft, which will update RFC5043 and RFC5044.
> MPA V2 extends the configuration negotiation for RDMA connection establishment.
> For backwards compatibility, MPA V2 enabled driver reverts to MPA V1,
> if the remote node doesn't support MPA V2
>
> Signed-off-by: Tatyana Nikolova<Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif<Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
