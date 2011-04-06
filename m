From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Add man pages for dump2psl and
 dump2slvl
Date: Wed, 6 Apr 2011 12:12:20 -0600
Message-ID: <20110406181220.GA5924@obsidianresearch.com>
References: <4D9B6DEB.7060702@dev.mellanox.co.il>
 <20110406004057.GB4573@obsidianresearch.com>
 <4D9C4784.6010103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D9C4784.6010103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 06, 2011 at 06:59:16AM -0400, Hal Rosenstock wrote:
> On 4/5/2011 8:40 PM, Jason Gunthorpe wrote:
> > Since these are only used by ibdmchk it seems more appropriate to
> > bundle it in the ibutils package than in infiniband-diags?
> 
> No; the idea is that the files can be prepared for ibdmchk on a machine
> which does not include ibutils and moved to another machine there for
> checking. That's why these are being made part of infiniband-diags and
> not ibutils.

Your perl scripts don't run any infiniband-diags programs, they are
just text processing filters, so you can copy the input text files
to the machine with ibdmchk just as easily  as copying the output
text files.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
