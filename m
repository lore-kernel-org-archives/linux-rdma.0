From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH iproute2-next 08/10] rdma: Add QP resource tracking
 information
Date: Mon, 5 Feb 2018 09:21:31 -0700
Message-ID: <3d519b76-7be8-5db5-7343-c293bdfdea7e@gmail.com>
References: <20180131081156.19607-1-leon@kernel.org>
 <20180131081156.19607-9-leon@kernel.org>
 <017501d39b97$f5931360$e0b93a20$@opengridcomputing.com>
 <20180205132231.GD2567@mtr-leonro.local>
 <20180205140037.GF2567@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205140037.GF2567-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Stephen Hemminger' <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/5/18 7:00 AM, Leon Romanovsky wrote:
> 
> Stephen, David,
> 
> How do you want me to proceed?
> 

Since the RDMA code is in Linus' tree for 4.16, I think the patches
should go through Stephen's tree and the master branch. Stephen needs to
decide about the fixup.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
