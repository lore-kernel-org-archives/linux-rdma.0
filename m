From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Building rdma-core with -Wcast-qual
Date: Thu, 13 Jul 2017 16:29:59 -0600
Message-ID: <20170713222959.GB10088@obsidianresearch.com>
References: <ed258438-d585-d0ee-6c56-0178c589406b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ed258438-d585-d0ee-6c56-0178c589406b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 03:45:16PM +0300, Sagi Grimberg wrote:
> Hi all,
> 
> When I compile rdma-core with -Wcast-qual I get all sorts of warnings
> on non following const on casts.
> 
> Does/should anyone care?

I looked at this once.. It gets really hard to do const correctness in
C..

Eg, how do you handle this:

#define container_of(ptr, type, member) \
	((type *) ((uint8_t *)(ptr) - offsetof(type, member)))

if ptr is a const then it has to be:

#define container_of(ptr, type, member) \
	((const type *) ((const uint8_t *)(ptr) - offsetof(type, member)))

Similar issue for the ccan list macros.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
