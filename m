From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibverbs/doc: clarify selective signaling (Re: using
 IBV_SEND_SIGNALED)
Date: Wed, 01 Dec 2010 10:17:10 +0200
Message-ID: <4CF60486.1030702@voltaire.com>
References: <alpine.LNX.2.00.1011291128190.31687@postal.iol.unh.edu>	<4CF3DDF0.2070907@opengridcomputing.com>	<alpine.LNX.2.00.1011291233540.5810@postal.iol.unh.edu>	<4CF3E5FA.6010308@opengridcomputing.com> <4CF4E65D.4070205@Voltaire.com> <20101130185744.GK16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130185744.GK16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/30/2010 8:57 PM, Jason Gunthorpe wrote:
> I think the subtly here is that remote completion of a local WR does 
> not indiciate local completion. This is the only operational case I 
> can think of that might break the rules.

The point you're bringing is sure valid and actually I can change the 
patch to address both issues, the one raised on the original thread (see 
"using IBV_SEND_SIGNALED in ewg from this week),  where Robert says 
"However, as soon as I call ibv_post_send() more than max_send_wr 
times,  it fails" so 1st we need to clarify that without posting a 
signaled WR the HCA will fail, and 2nd that the application can't 
consume back the resources associated with a send WR until a "later" WR 
completes.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
