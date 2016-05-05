From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 13:20:24 -0600
Message-ID: <20160505192024.GA17249@obsidianresearch.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <72645a3b-5945-419a-d7af-1c065080e415@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <72645a3b-5945-419a-d7af-1c065080e415-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 05, 2016 at 02:57:01PM -0400, Doug Ledford wrote:
 
> and the eeprom is written with the new data.  If you need to do special
> things, like Mellanox, in terms of recovering burned data like GIDs
> or

The 'eeprom' and device firmware are very different things. hfi1 has
both, and uses request_firmware too.

I've never heard of a driver using ethtool eeprom to deal with nv
firmware like mlx has. AFAIK there is no kernel convention for that
stuff. It is more common for storage than network drivers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
