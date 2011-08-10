From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibsim: fix size of slid/dlid fields in sim_request
 structure
Date: Wed, 10 Aug 2011 13:37:52 -0600
Message-ID: <20110810193752.GB12482@obsidianresearch.com>
References: <E1QpTpl-00026F-D6@rvml.edm.orcorp.ca>
 <20110809150723.GC2056@calypso.mtl.com>
 <4E42BD69.6070608@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E42BD69.6070608-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 10, 2011 at 11:18:33AM -0600, Rolf Manderscheid wrote:
> Hi Alex,
> >There are more places where lids defined as integer. Why did you choose to
> >change only these two?
> 
> This structure defines what request packets look like on the wire to
> the simulator.  The motivation for the change is a simulator client
> for python-rdma, and this issue shows up when creating the structure
> format strings for the request packets.

Also that

uint32_t x = htons(y)

Simply doesn't work when you mix big and little endian. So, the
choices are: switch the type to uint16, or switch to htonl. This is the
reason only this struct was changed - because it is the only place
where htons is being applied incorrectly, while finding all the wrong
htons is a bit harder.

python cares because it cannot easily construct something so malformed :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
