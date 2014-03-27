From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] librdmacm: lazy initialization for ib devices]
Date: Thu, 27 Mar 2014 10:38:19 +0200
Message-ID: <5333E37B.5080202@mellanox.com>
References: <20140327082325.GA5006@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140327082325.GA5006@shamir-pc>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovith <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 27/03/2014 10:23, Shamir Rabinovith wrote:
> So what exact capability is under the spot here? and how it's related
> to a certain HCA driver and not to the kernel uverbs layer?
>
> ----- End forwarded message -----
>
> ibv_open_device fail when opening the hca many times.
sorry, but you didn't provide an answer to my question - why is 
ibv_open_device failing if called from N > M (what's
N and what's M) processes/threads.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
