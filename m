From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/4] IB/core: Check mad_agent in ib_unregister_mad_agent
 before dereferencing it
Date: Sun, 1 Feb 2015 13:28:56 +0200
Message-ID: <54CE0DF8.7070901@mellanox.com>
References: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
 <1422522871-11216-3-git-send-email-ogerlitz@mellanox.com>
 <20150129174221.GE11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129174221.GE11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/29/2015 7:42 PM, Jason Gunthorpe wrote:
> If there is a bug, then it is at a call site, not in the unregister.

Agree, will drop this patch and dig in our regression data-base to find 
the offending caller and fix it up, if it's not already fixed by now. 
Majd - looking into the mlx4 IB driver, I see calls to 
ib_unregister_mad_agent in the error flow of mlx4_ib_mad_init which 
looks suspicions...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
