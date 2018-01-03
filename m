From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 00/28] IB/srp and IB/srpt patches
Date: Wed, 3 Jan 2018 14:51:30 -0700
Message-ID: <20180103215130.GN11348@ziepe.ca>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 01:39:10PM -0800, Bart Van Assche wrote:
> Hello Jason,
> 
> This patch series adds RDMA/CM support to the SRP initiator and target drivers
> and also includes a series of bug fixes for the SRPT driver. Please consider
> at least the SRPT bug fixes for kernel v4.16 since one of these fixes is a
> security fix.

Bart, this is really big for the rc6 timeframe.. This might make it if
there is a rc8 this cycle.

I'll grab the two patches marked for stable to for-rc, they look
trivial.

I'm with the DaveM school of thought here that patch series should be
10-15 at most, and have a clear purpose, even if that purpose is just
'assorted one patch fixes'.. If you resend it can you split the series?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
