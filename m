From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Fri, 7 Oct 2016 15:00:38 -0600
Message-ID: <20161007210038.GA9810@obsidianresearch.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <20161007190224.GB27537@obsidianresearch.com>
 <c1901fd9-3620-50ec-0db3-9b271fd1e90b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c1901fd9-3620-50ec-0db3-9b271fd1e90b-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 07, 2016 at 01:51:59PM -0700, Bart Van Assche wrote:

> Do you think the names of the network interfaces to which the rdma_rxe
> driver should bind should be stored in a separate file? To me this looks
> like a suboptimal approach. Shouldn't we drop the /var/rxe/rxe file
> completely and add a new boolean to the files in which other network
> interface parameters are already stored, e.g.
> /etc/NetworkManager/system-connections/* ?

I honestly don't know much about how rxe works, I was just looking
at the bogus path.

In today's world this should probably be handled by adding systemd unit
files to set up rxe.. ??

Something with network manager also seems to make some kind of sense
on the surface.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
