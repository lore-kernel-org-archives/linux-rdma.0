From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 8/9] IB/mlx4: Support extended create_cq and
 query_device uverbs
Date: Wed, 3 Jun 2015 10:31:46 -0600
Message-ID: <20150603163146.GD12073@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433074457-26437-9-git-send-email-ogerlitz@mellanox.com>
 <20150601165649.GC14391@obsidianresearch.com>
 <CAAKD3BBsTFYKwOBK+6u04x6deRYzjYESJzbpyy83UtoChZhpOA@mail.gmail.com>
 <20150602170736.GA17776@obsidianresearch.com>
 <CAAKD3BARPocK1zZ2nYV0xWHqEASJTYbp1aQxwymi-TYTyK_vGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BARPocK1zZ2nYV0xWHqEASJTYbp1aQxwymi-TYTyK_vGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 03, 2015 at 11:57:12AM +0300, Matan Barak wrote:
> That's a general comment regarding the extension mechanism.

Yes, but it is also a specific comment about patch #4 which adds,
ib_uverbs_ex_create_cq.

Based on the implementation of create_cq, it is pretty clear that
every driver supports ib_uverbs_ex_create_cq, so patch #4 should just
force the flag in the device register function so it is globally
enabled.

query_device looks like it is the same, passing in the original
structure length will always work on any device. So Mellanox should
send a bugfix patch for that as well, unrelated to this series.

> > An extended command that doesn't use any extended features should
> > transparently degrade to the normal command as often as possible.
> 
> That means that uverbs_ex_cmd_mask should only be used on extended commands that
> are user-space specific.

The bit should only be clear on commands that can never return
anything but ENOSYS. Ie the kernel has no support for the command at
all, or for some reason the driver cannot handle the call.

The latter case should be rare, it would be the case if we added a new
command that was not extending an existing command, for instance.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
