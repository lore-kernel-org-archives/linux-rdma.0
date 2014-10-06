From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/9] Peer-Direct support
Date: Mon, 06 Oct 2014 10:12:09 -0500
Message-ID: <5432B149.7060202@opengridcomputing.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412602019-30659-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2014 8:26 AM, Yishai Hadas wrote:
> The following set of patches implements Peer-Direct support over RDMA
> stack.
>      
> Peer-Direct technology allows RDMA operations to directly target
> memory in external hardware devices, such as GPU cards, SSD based
> storage, dedicated ASIC accelerators, etc.
>      
> This technology allows RDMA-based (over InfiniBand/RoCE) application
> to avoid unneeded data copying when sharing data between peer hardware
> devices.

Does this also work over iWARP devices?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
