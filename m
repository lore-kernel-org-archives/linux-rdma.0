From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 10:15:32 -0700
Message-ID: <20091215171532.GA8288@obsidianresearch.com>
References: <20091214164334.064102f0.weiny2@llnl.gov> <20091215170317.GV5262@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091215170317.GV5262@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > However, I don't understand the comment "Only set HopLimit if going through a
> > router"?
> 
> This is from '#ifdef ROUTER_EXP' days - as far as I could understand
> HopLimit should be set to IB_HOPLIMIT_MAX for inter-subnet MADs.

If HopLimit is 0 then no GRH is required, if it is non 0 then the user
of that path needs to apply a GRH. IIRC there are already a few things
in the kernel that follow this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
