From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 11:00:18 -0600
Message-ID: <20170731170018.GA19061@obsidianresearch.com>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
 <20170731164705.GB28204@obsidianresearch.com>
 <20170731165453.GD13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731165453.GD13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2017 at 07:54:53PM +0300, Leon Romanovsky wrote:
> I want to take RDMA one step more,
> https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
> 
> I called the topic name "persistent", but the right name is "predictable".

Once renaming is possible then having udev rework the names isn't a
big step anymore.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
