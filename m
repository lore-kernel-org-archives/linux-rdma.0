From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Mon, 29 Jun 2015 15:48:47 -0600
Message-ID: <20150629214847.GA15888@obsidianresearch.com>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com>
 <1434984438-21733-2-git-send-email-yishaih@mellanox.com>
 <20150624175738.GC21033@obsidianresearch.com>
 <558BE9FA.9060402@dev.mellanox.co.il>
 <20150625175228.GF21033@obsidianresearch.com>
 <559005A0.4070800@dev.mellanox.co.il>
 <20150629174038.GB2755@obsidianresearch.com>
 <5591B6FA.4000400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5591B6FA.4000400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 12:22:02AM +0300, Yishai Hadas wrote:
> It should be:
> kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_event_file)
> instead of:
> kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_file);

Right

> Please note that in that approach we duplicate above line as it appears here
> and in below err_put_refs label as uverbs_file->async_file is really
> ev_file.

Well, sort of. Yes, it is the same value, but no, it isn't the same
kref.

Just like locking always works on data, not code, krefs should always
be applied to the pointer not to the pointed data. The kref
manipulation should always be near the pointer value change it is
working for, and have a clear relation to the pointer it is krefing.

> In my patch we used one line instead of those duplicated lines, however as
> you think that it clarifies things will go with your suggestion after fixing
> above note, thanks.

You shouldn't think of them as duplicates, they are for different
things, even if the actual functionality is the same. It is
*documentation*

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
