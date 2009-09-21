From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: How to handle illegal multicast addresses in IPoIB?
Date: Mon, 21 Sep 2009 11:08:48 -0600
Message-ID: <20090921170848.GI19540@obsidianresearch.com>
References: <4AB78040.9000606@Voltaire.COM> <4AB78EC9.7020805@Voltaire.com> <4AB7900F.2020406@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AB7900F.2020406-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 21, 2009 at 05:39:11PM +0300, Moni Shoua wrote:

> So there is only one question left. Do we also need the other patch?

Yes, we need something like the other patch to handle the case where
the SM is unwilling to create a group for some reason. Right now that
is exactly the same failure mode as an invalid MGID and wrecks ipoib
if it happens.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
