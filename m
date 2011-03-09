From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/opensm] Fix SANodeRecord.nodeInfo.localPortNum
Date: Wed, 9 Mar 2011 11:34:42 -0700
Message-ID: <20110309183441.GB25229@obsidianresearch.com>
References: <20110302002941.GA22729@obsidianresearch.com>
 <20110309154744.GV5577@calypso.voltaire.com>
 <20110309171126.GB15419@obsidianresearch.com>
 <AANLkTimu0RxDbbjiRsni4gdmanvp_eaWA=xFoH9P8qZP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimu0RxDbbjiRsni4gdmanvp_eaWA=xFoH9P8qZP-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2011 at 01:26:26PM -0500, Hal Rosenstock wrote:

> > I don't think there is really any free interpretation here. For
> > everything but a switch localPortNum must always reflect the port that
> > portGUID is associated with.
> 
> Unfortunately, this is not always true due to the funky cross (CA and
> router) port PortInfo queries (but I don't think that query style is
> used by OpenSM for CA or router ports but allowed in IBA)...

What part of the spec are you referring to here?

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
