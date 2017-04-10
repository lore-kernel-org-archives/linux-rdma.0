From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Mon, 10 Apr 2017 09:40:39 -0600
Message-ID: <20170410154039.GA7056@obsidianresearch.com>
References: <20170404191732.31895-1-leon@kernel.org>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0@CRSMSX101.amr.corp.intel.com>
 <20170404200335.GB20443@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8DAB7@CRSMSX101.amr.corp.intel.com>
 <20170406052820.GB2269@mtr-leonro.local>
 <20170406151014.GA173962@knc-06.sc.intel.com>
 <20170410080228.GP2269@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170410080228.GP2269-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 10, 2017 at 11:02:28AM +0300, Leon Romanovsky wrote:

> I just want to be sure that once any vendor in this susbsystem
> will use the same magic sentence "it gives best performance for our
> hardware and future devices will come". There will be no questions about
> interoperability between various devices, no more questions about
> standards, no more requests to implement for other drivers (hardware and
> software).

Don't be absurd..

I repeatedly chewed out intel for having their driver act like a
subsystem in of itself, keeping user-facing code that is not linked to
hardware out of driver is the right thing to do.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
