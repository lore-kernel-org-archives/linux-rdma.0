From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/opensm] Fix SANodeRecord.nodeInfo.localPortNum
Date: Sun, 13 Mar 2011 17:59:04 +0200
Message-ID: <20110313155904.GC14371@calypso.voltaire.com>
References: <20110302002941.GA22729@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110302002941.GA22729-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:29 Tue 01 Mar     , Jason Gunthorpe wrote:
> This value must match the portGUID, so it needs to vary on a per port
> basis like portGUID and not simply reflect the value opensm acquired
> during the sweep.
> 
> Prior to this patch opensm returns the same value for localPortNum for
> all ports on a HCA, now it returns the correct localPortNum for the
> portGUID.
> 
> Also fixes query matching in the same way
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
