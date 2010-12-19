From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Sun, 19 Dec 2010 16:36:22 +0200
Message-ID: <1292769382.2369.2145.camel@nirm-desktop>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
	 <1292257370-24391-6-git-send-email-nirm@voltaire.com>
	 <20101214183458.GD2506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214183458.GD2506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-12-14 at 11:34 -0700, Jason Gunthorpe wrote:
> On Mon, Dec 13, 2010 at 06:22:49PM +0200, Nir Muchtar wrote:
> > Save owning PID to id-priv when creating id's/accepting connections.
> 
> This should be called creator_pid, not owner - to avoid confusion.
> 

But it's meant to be the owner and not necessarily the creator.
That's why its value is replaced in rdma_accept.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
