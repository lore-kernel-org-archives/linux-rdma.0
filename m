From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 04/10] IB/core: Support accessing SA in
 virtualized environment
Date: Thu, 10 Mar 2016 16:52:53 -0700
Message-ID: <20160310235253.GD18897@obsidianresearch.com>
References: <1457384940-11951-1-git-send-email-eli@mellanox.com>
 <1457384940-11951-5-git-send-email-eli@mellanox.com>
 <20160307220434.GB6706@obsidianresearch.com>
 <20160307222908.GC33629@x-vnc01.mtx.labs.mlnx>
 <20160308175411.GC10805@obsidianresearch.com>
 <20160310214807.GA39681@x-vnc01.mtx.labs.mlnx>
 <20160310232620.GA18092@obsidianresearch.com>
 <20160310234542.GB39681@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160310234542.GB39681-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2016 at 01:45:42AM +0200, Eli Cohen wrote:
> On Thu, Mar 10, 2016 at 04:26:20PM -0700, Jason Gunthorpe wrote:
> > 
> > I don't know that another OUI is necessary, setting the local bit is
> > probably OK, that is what IPv6 has done.
> > 
> 
> So defining the well known SA GUID to be 0x200000000000002 makes the
> address locally administered in which case we don't need to provide a
> valid OUI.
> I can roll another set with that and the alignment fix.

It is in line with IPv6 (eg IPv6 defines would use ::1, but the local
bit is inverted, unlike IB).

Of course, IBTA should sign off on this plan.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
