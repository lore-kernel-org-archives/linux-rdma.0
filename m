From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Odd build failure in el7 mock
Date: Wed, 22 Mar 2017 15:06:16 -0600
Message-ID: <20170322210616.GA21000@obsidianresearch.com>
References: <16cf8400-4920-c7ae-e0e5-c77a65a71460@redhat.com>
 <20170322162245.GA18200@obsidianresearch.com>
 <1afb222d-5553-90d1-e18b-437e62012fff@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1afb222d-5553-90d1-e18b-437e62012fff-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 22, 2017 at 04:43:38PM -0400, Jarod Wilson wrote:

> The addition of 'relpath' in that commit means that python is now a
> BuildRequires of the rdma-core package. Once I added that, the package built
> in mock just fine. Will send a patch for it shortly.

Ah, yes..

I've also realized that execute_process does not abort cmake if it
fails, which is why this was hard for you to observe. That should be
fixed also..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
