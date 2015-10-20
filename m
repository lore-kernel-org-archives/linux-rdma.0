From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Use inner P_Key to determine netdev
Date: Tue, 20 Oct 2015 09:45:27 +0300
Message-ID: <5625E307.4090105@mellanox.com>
References: <56252F7B.4000300@mellanox.com>
 <1445278165-18442-1-git-send-email-haggaie@mellanox.com>
 <20151019181953.GA19665@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151019181953.GA19665-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/10/2015 21:19, Jason Gunthorpe wrote:
> On Mon, Oct 19, 2015 at 09:09:25PM +0300, Haggai Eran wrote:
>> When discussing the patches to demux ids in rdma_cm instead of ib_cm, it
>> was decided that it is best to use the P_Key value in the packet headers
>> [1]. However, some drivers are currently unable to send correct P_Key in
>> GMP headers.
> 
> You should explicitly describe the broken drivers in the commit text.
These are mlx5 and ipath. I'll add them to the commit message.

> I thought mlx5 was fixed for receive already? I'm confused why we need
> this.
mlx5 had two issues related to GSI pkeys. The issue that was fixed was
that it treated the pkey value returned by the hardware in receive
completions as a pkey_index. The remaining issue is that it doesn't
respect the ib_send_wr.ud.pkey_index field when sending.

With the current state of things, cma will try to look for an ipoib net
dev matching the BTH pkey of the request, but if the sender is mlx5 or
ipath, the BTH pkey would be the default pkey. If the request was
intended for a different pkey, cma won't find a matching netdev and will
throw away the request.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
