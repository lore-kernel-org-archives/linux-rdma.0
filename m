From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Thu, 29 Sep 2016 10:25:34 -0600
Message-ID: <20160929162534.GB774@obsidianresearch.com>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <57ED3128.4060509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57ED3128.4060509-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 11:20:08AM -0400, Doug Ledford wrote:
> > https://github.com/linux-rdma/rdma-core/pull/7
> 
> Merged, thanks.

FWIW, I updated the docker stuff in my preview tree to approximate
what travis does:

docker/do_docker.py pkg travis

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
