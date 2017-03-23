From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 11:02:28 -0600
Message-ID: <20170323170228.GG29811@obsidianresearch.com>
References: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
 <20170323161017.GB29811@obsidianresearch.com>
 <100aafc9-21a6-8aed-47c3-220f0feb82b1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <100aafc9-21a6-8aed-47c3-220f0feb82b1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 23, 2017 at 12:57:37PM -0400, Jarod Wilson wrote:
> Not sure. From rpm's perspective, I'm trying arch s390x, but maybe gcc is
> actually calling it s390.

The output from build/CMakeFiles/CMakeError.log might help

As well as this output:

$ gcc -dM -E - < /dev/null

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
