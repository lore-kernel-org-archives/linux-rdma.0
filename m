From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Add man pages for dump2psl and dump2slvl
Date: Wed, 06 Apr 2011 06:59:16 -0400
Message-ID: <4D9C4784.6010103@dev.mellanox.co.il>
References: <4D9B6DEB.7060702@dev.mellanox.co.il> <20110406004057.GB4573@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110406004057.GB4573-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/5/2011 8:40 PM, Jason Gunthorpe wrote:
> Since these are only used by ibdmchk it seems more appropriate to
> bundle it in the ibutils package than in infiniband-diags?

No; the idea is that the files can be prepared for ibdmchk on a machine
which does not include ibutils and moved to another machine there for
checking. That's why these are being made part of infiniband-diags and
not ibutils.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
