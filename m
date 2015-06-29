From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] mlx4, mlx5, mthca: Expose max_sge_rd correctly
Date: Mon, 29 Jun 2015 14:35:59 -0500
Message-ID: <00a701d0b2a2$d3270420$79750c60$@opengridcomputing.com>
References: <1435601564-10830-1-git-send-email-sagig@mellanox.com> <55918B1A.6030102@opengridcomputing.com> <20150629181710.GA32025@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150629181710.GA32025-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Eli Cohen' <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Monday, June 29, 2015 1:17 PM
> To: Steve Wise
> Cc: Sagi Grimberg; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Eli Cohen; Or Gerlitz
> Subject: Re: [PATCH] mlx4, mlx5, mthca: Expose max_sge_rd correctly
> 
> On Mon, Jun 29, 2015 at 01:14:50PM -0500, Steve Wise wrote:
> >
> > On 6/29/2015 1:12 PM, Sagi Grimberg wrote:
> > >Applications must not assume that max_sge and max_sge_rd
> > >are the same, Hence expose max_sge_rd correctly as well.
> > >
> > >Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > >Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > How about I pull this into my iSER series since the iSER changes
> > will depend on this?
> 
> We will need a trivial patch for ipath and qib as well
>

I'll add these.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
