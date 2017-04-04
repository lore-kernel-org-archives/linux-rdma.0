From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Tue, 4 Apr 2017 14:14:08 -0600
Message-ID: <20170404201408.GA16818@obsidianresearch.com>
References: <20170404191732.31895-1-leon@kernel.org>
 <20170404194750.GC10780@obsidianresearch.com>
 <20170404195720.GA20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404195720.GA20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 04, 2017 at 10:57:20PM +0300, Leon Romanovsky wrote:
> > It would still have been nicer to isolate the 'default' implementation
> > so those functions did not touch ipoib_priv, but that is also
> > something that could be done in a followup..
> 
> Thanks, Jason

I think before merging it would also be good to see the benchmark
numbers - we all assume this is making things a lot faster..

Does it now exceed RC performance?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
