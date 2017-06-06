From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core out-of-tree user library
Date: Tue, 6 Jun 2017 10:24:00 -0600
Message-ID: <20170606162400.GB8671@obsidianresearch.com>
References: <BN3PR07MB25781554943206E577DFC714F8CB0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB25781554943206E577DFC714F8CB0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 06, 2017 at 12:49:21PM +0000, Amrani, Ram wrote:
> Hi Jason, Leon, Doug, All,

> A provider's out-of-tree user library cannot be built against
> rdma-core, because the API is hidden to out-of-tree libraries. This
> was due to a decision taken months back.  The distros have adopted
> this approach as-is and it is going to be part of the next
> releases. While this approach ensures all of the components are
> in-sync, it has its disadvantages.
> 
> There is typically a gap of several months between two inbox
> releases.  New features and fixes are delivered to the next inbox
> releases, but we would like to have the ability to supply an outbox
> user library to customers in between. It may also happen that
> customers can only adopt the new inbox version with a delay, or even
> worse, if they cannot adopt it at all due to various reasons.

Two options,

1) The 'ofed' approach: just use the latest rdma-core. We want
   rdma-core to run on any kernel version and any distro release, so
   this should not be a major problem
2) For each targetted distro release back port the changes you want
   into the exact distro rdma-core source and distribute your driver
   binary from that build. This keeps everything very much the same
   but upgrades that driver.

> How are other providers handling this?

Most things I've seen have followed an OFED like approach because they
also want to ship an updated kernel component. Historically we have
not seen that much churn in the user space provider that is not linked
to kernel changes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
