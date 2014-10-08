From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rsocket: Return ECONNRESET when socket in recv is
 disconnected
Date: Wed, 8 Oct 2014 17:28:27 -0600
Message-ID: <20141008232827.GA16102@obsidianresearch.com>
References: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412806773-23776-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 08, 2014 at 03:19:33PM -0700, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> The following behavior difference was reported between rsockets and
> sockets:
> 
> when remote end is suddenly closed, recv() waiting on it receives
> tcp/ip => ECONNRESET error
> rsockets => 0 value

That isn't the whole story though - you only get ECONNRESET in some
cases, and it is OS dependent.
 
stackoverflow suggets:

http://stackoverflow.com/questions/2974021/what-does-econnreset-mean-in-the-context-of-an-af-local-socket

Which looks reasonable to me and matches my experience with socket
programming on Linux. The Steven's book might have some authoritative
clarifications on the subject as well.

It certainly is not correct to unconditionally return ECONNRESET for
reads on far-end-closed sockets, they should typically return 0.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
