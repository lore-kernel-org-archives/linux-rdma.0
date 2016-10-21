From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] build: Fix build script to use correct cmake cmd
Date: Fri, 21 Oct 2016 13:30:34 -0600
Message-ID: <20161021193034.GA616@obsidianresearch.com>
References: <20161021172728.27367.86783.stgit@scvm10.sc.intel.com>
 <20161021180523.GA554@obsidianresearch.com>
 <9745f6c7-8d09-8bed-d04c-78f610330ead@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9745f6c7-8d09-8bed-d04c-78f610330ead-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 21, 2016 at 03:03:23PM -0400, Doug Ledford wrote:
> According to github, this change broke the travis CI build on your pull
> request when the previous patches all worked.  However, travis is down
> right now, so I suspect this didn't *actually* break it, that the travis
> CI was down anyway and github logged a failure.

Yes, travis does not use build.sh

Maybe this is a good time to ask if anyone is interested in the docker
stuff I have - eg should I make it pushable? It is easy to use, but
you need to have docker installed.

There are several other container/chroot/docker based toolkits out
there for doing this sort of work, but I haven't studied that area in
a while to see if there is something workable.

The docker script is able to run almost-travis locally, as well as do
clean package builds for all distros.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
