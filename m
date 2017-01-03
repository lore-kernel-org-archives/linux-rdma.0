From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB: Fix incorrect structure packing for booleans
Date: Tue, 3 Jan 2017 12:46:10 -0700
Message-ID: <20170103194610.GE26706@obsidianresearch.com>
References: <20161223010752.GA20676@obsidianresearch.com>
 <02392b22-10dc-be83-d4de-c9c2db416cc1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02392b22-10dc-be83-d4de-c9c2db416cc1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 03, 2017 at 02:16:42PM -0500, Hal Rosenstock wrote:
> On 12/22/2016 8:07 PM, Jason Gunthorpe wrote:
> > Crucially this means the kernel has never, set reversible
> > correctly in the path record request. It has always asked for
> > irreversible paths even if the ULP requests otherwise.
> 
> Issuing path record query with reversible bit set to 0 means that any
> path (reversible or not) can be returned by SA. It is not requesting an
> irreversible path. In the response, the reversible bit indicates whether
> the path is reversible or not.

'asked for' == 'indicated it would accept'.

> > When the kernel is used with a SM that supports this feature, it
> > completely breaks communication management if reversible paths are
> > not properly requested.
> > 
> > The only reason this ever worked is because opensm ignores the
> > reversible bit.
> 
> OpenSM supports reversible PR queries. I tested all 3 cases (comp mask
> bit not set, comp mask bit set and reversible set to 1, and comp mask
> bit set and reversible set to 0) in a single subnet.

The purpose of the statement to elaborate why the bug has gone
undetected for so long.

opensm ignores the reversible bit in the sense that opensm *only*
supports reversible paths internally and every PR response it
generates has a reversible DLID/SLID/SL tuple, no matter what the
reversible response bit might claim. (AFAIK this outcome is baked into
the lid routers)

If this was not the case then this bug would have been discovered long
ago because the kernel RDMA CM simply *does not work* if a PR response
contains an irreversible DLID/SLID/SL tuple.

> Otherwise, please elaborate/provide more details on the issue you are
> seeing with OpenSM.

There is no issue with OpenSM. It simply does not make use of an
optional spec feature in way that would expose this kernel bug.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
