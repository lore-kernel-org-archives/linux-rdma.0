From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings
 in GCC 7.1
Date: Thu, 13 Jul 2017 13:24:13 -0600
Message-ID: <20170713192413.GA6236@obsidianresearch.com>
References: <20170713133935.1206-1-leon@kernel.org>
 <20170713175122.GD11069@obsidianresearch.com>
 <1499968451.2740.14.camel@wdc.com>
 <20170713181536.GA4771@obsidianresearch.com>
 <20170713190829.GQ1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713190829.GQ1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 10:08:29PM +0300, Leon Romanovsky wrote:

> The thing which bothers me, why didn't we see this warning in Travis CI?
> We need to treat all compilation warnings as errors.

Travis does not have gcc 7 right now, the 6.x compiler does not
produce the warning by default.

I haven't looked lately if we can switch travis to 7 or not.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
