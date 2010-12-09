From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma_lat whos
Date: Thu, 9 Dec 2010 10:28:24 -0700
Message-ID: <20101209172824.GB11353@obsidianresearch.com>
References: <4CE3B455.4080003@Voltaire.com> <4CE3BCE3.7090107@Voltaire.com> <4CE50190.3080707@dev.mellanox.co.il> <4D00B066.80807@Voltaire.com> <4D00B1C4.3040804@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D00B1C4.3040804-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 09, 2010 at 12:39:00PM +0200, Or Gerlitz wrote:
> >>  local address: LID 0000 QPN 0x44004f PSN 0x6b567a
> >>  GID: 254:128:00:00:00:00:00:00:02:02:201:255:254:07:237:03
> 
> Also, it would be much easier to track/debug if the GID octets will be printed in hexadecimal, can you?

GIDs should be printed with inet_ntop(AF_INET6)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
