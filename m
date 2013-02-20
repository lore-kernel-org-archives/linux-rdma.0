From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH perftest] Support iwarp transports.
Date: Wed, 20 Feb 2013 10:54:26 -0600
Message-ID: <5124FFC2.8090602@opengridcomputing.com>
References: <20130220040941.31762.66644.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130220040941.31762.66644.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/19/2013 10:09 PM, Steve Wise wrote:
> - add transport type for making transport-specific decisions
> - rdma read sink mrs need REMOTE_WRITE access for iwarp transports
> - set initiator_depth and responder_resources based on device max values
> - add chelsio devices
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>

Hey Ido,

This patch gets Chelsio RNICs working with the various perftools apps.  
I'll also be working on adding multi-port and multi-qp support when 
using the rdmacm.

Lemme know your thoughts.

Thanks,

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
