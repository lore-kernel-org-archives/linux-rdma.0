From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] librdmacm: lazy initialization for ib devices
Date: Tue, 25 Mar 2014 09:24:45 +0200
Message-ID: <53312F3D.90800@mellanox.com>
References: <20140325065839.GA3794@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140325065839.GA3794@shamir-pc>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 25/03/2014 08:58, Shamir Rabinovitch wrote:
> There was a request by teams in Oracle to decouple the HCA limited ability to open device context and the rising amount of processes that run on the servers. It appear that the lowest capable HCA become the limit to all the processes that attempt to use the library.

So what exact capability is under the spot here? and how it's related to 
a certain HCA driver and not to the kernel uverbs layer?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
