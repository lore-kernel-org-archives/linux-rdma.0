From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Add man pages for dump2psl and
 dump2slvl
Date: Tue, 5 Apr 2011 18:40:57 -0600
Message-ID: <20110406004057.GB4573@obsidianresearch.com>
References: <4D9B6DEB.7060702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D9B6DEB.7060702-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since these are only used by ibdmchk it seems more appropriate to
bundle it in the ibutils package than in infiniband-diags?

On Tue, Apr 05, 2011 at 03:30:51PM -0400, Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  Makefile.am     |    3 ++-
>  man/dump2psl.8  |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  man/dump2slvl.8 |   32 ++++++++++++++++++++++++++++++++
>  3 files changed, 83 insertions(+), 1 deletions(-)
>  create mode 100644 man/dump2psl.8
>  create mode 100644 man/dump2slvl.8
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
