From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 4/4] IB/ipoib: Support SendOnlyFullMember MCG
 for SendOnly join
Date: Thu, 21 Apr 2016 11:32:19 -0600
Message-ID: <20160421173219.GA5814@obsidianresearch.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-5-git-send-email-erezsh@mellanox.com>
 <571771FB.90908@dev.mellanox.co.il>
 <CAAk-MO_24actZ4FJqOjk0ztR=Z6toSfB-xuyFKeUvtZ8h0Xv3A@mail.gmail.com>
 <5717843B.7020501@dev.mellanox.co.il>
 <CAAk-MO9sie_pFH7wSDhhuEd2uApnz5dMF6E9u6Vgkyimc+1xWA@mail.gmail.com>
 <5718D497.70306@dev.mellanox.co.il>
 <CAAk-MO9W-sdi4D+xT6C_TB7uWNMPV8++RRtyoLmJ23HFq11+iw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO9W-sdi4D+xT6C_TB7uWNMPV8++RRtyoLmJ23HFq11+iw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 21, 2016 at 05:11:42PM +0300, Erez Shitrit wrote:

> > This will minimize storm of joins and PR queries at SA on client reregister.
> 
> OK, will change that accordingly.

If you check before joining the broadcast group that should be
enough. The broadcast group must always be joined first and is always
re-joined if the SM changes substantially.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
