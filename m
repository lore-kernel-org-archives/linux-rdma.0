From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Wed, 23 Aug 2017 08:06:36 -0600
Message-ID: <20170823140636.GA9407@obsidianresearch.com>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1b7e41dc-4873-7c0a-6cdb-bc499af70af2-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 03:13:38PM +0300, Yishai Hadas wrote:
> On 8/22/2017 7:30 PM, Jason Gunthorpe wrote:
> >On Tue, Aug 22, 2017 at 11:36:42AM +0300, Yishai Hadas wrote:
> >>On 8/21/2017 6:22 PM, Jason Gunthorpe wrote:
> >>>Is there existing code out there that uses cq_out->uar and works
> >>>properly today? Yes or No?
> >>
> >>No, only this fix enables that to work properly.
> 
> >Particularly since a patch to do this with proper compatibility
> >exists, and there is no reason at all to take a shortcut.
> 
> We are not looking for a shortcut but for a solution that will match
> majority users if not all.

It is a short cut.

> Changing the symbol version for this API will cause that applications that
> will be linked against this version won't be able to run at all on
> previous

Then provide the compat symbol too, as I said in the first place, easy
to do.

There is no excuse here.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
