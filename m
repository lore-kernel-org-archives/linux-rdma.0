From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: IB atomic operations
Date: Fri, 25 Feb 2011 09:57:48 -0600
Message-ID: <4D67D17C.7000405@systemfabricworks.com>
References: <00b701cbd4bd$e271fe20$a755fa60$@edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00b701cbd4bd$e271fe20$a755fa60$@edu>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/25/2011 01:30 AM, Bharath Ramesh wrote:
> Hi,
> 	I am trying to use IB atomic operations, specifically fetch and add.
> I tried a small example but I am unable to get it to work. The WC status is
> IBV_WC_REM_INV_REQ_ERR. My sample code is as follows:

Did you register your memory with IBV_ACCESS_REMOTE_ATOMIC ?

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
