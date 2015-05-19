From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Tue, 19 May 2015 13:00:31 -0600
Message-ID: <20150519190031.GN18675@obsidianresearch.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
 <1431869786-6308-10-git-send-email-ogerlitz@mellanox.com>
 <20150519185801.GM18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150519185801.GM18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 12:58:01PM -0600, Jason Gunthorpe wrote:
> On Sun, May 17, 2015 at 04:36:25PM +0300, Or Gerlitz wrote:
> > From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > mlx4 needs to report the number of supported timestamp
> > bits (mask) and the hca_core_clock frequency.
> 
> This is critical information to parse the timestamp, why is it hidden
> in vendor specific land?

Sorry, direct this toward the page offset in the next patch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
