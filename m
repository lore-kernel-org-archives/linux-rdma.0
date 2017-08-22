From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Tue, 22 Aug 2017 10:30:07 -0600
Message-ID: <20170822163007.GB4922@obsidianresearch.com>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 22, 2017 at 11:36:42AM +0300, Yishai Hadas wrote:
> On 8/21/2017 6:22 PM, Jason Gunthorpe wrote:
> >Is there existing code out there that uses cq_out->uar and works
> >properly today? Yes or No?
> 
> No, only this fix enables that to work properly.

This is still bad reasoning.

rdma-core 14 does not support the 'uar' field, it may as well have
been marked reserved.

rdma-core 15 supports 'uar'.

This is an ABI change, and need to be handled properly to protect the
users against mixing incompatible libraries.

The fact that rdma-core 14 intended to support uar but screwed it up
doesn't really matter from the user perspective. All they care about
is that an app using using uar needs to be build against >= 15 or it
silently explodes at runtime.

This sorts of issues are exactly what we are supposed to be using
symbol versions to protect against, and largely why they exist at
all. If you do it properly then tools like RPM and the dynanmic linker
take care of everything for the end user.

You don't get to ignore sane shared library versioning rules just
because it is your company's library - part of the point of rdma-core
is to have a much stronger stance on ABI issues (our community has
done a terrible job over the years) and I do not like this weakening.

Particularly since a patch to do this with proper compatibility
exists, and there is no reason at all to take a shortcut.

Doug? This needs to be decided before you mark rdma-core 15 final.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
