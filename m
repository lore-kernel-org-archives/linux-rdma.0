From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 15:26:21 -0700
Message-ID: <55AD758D.1080000@talpey.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <55AD5B48.3010906@talpey.com> <20150720210544.GA9655@obsidianresearch.com>
 <015101d0c331$69e31d10$3da95730$@opengridcomputing.com>
 <55AD7065.8040809@talpey.com> <20150720221703.GB11356@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720221703.GB11356-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/20/2015 3:17 PM, Jason Gunthorpe wrote:
> On Mon, Jul 20, 2015 at 03:04:21PM -0700, Tom Talpey wrote:
>> B) why bother to check? Are machines with <4GB interesting, and worth
>> supporting a special optimization?
>
> mainline drivers shouldn't silently malfunction.

I meant why bother to check, just always return failure. It's more
honest, and robust. Someone might test with 2GB, conclude it worked,
then deploy with 8GB and boom.

Also, what about hotplug RAM? Same situation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
