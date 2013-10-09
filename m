From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: OpenSM 3.3.16 at 100% CPU load, "console off"
Date: Wed, 09 Oct 2013 09:30:45 -0400
Message-ID: <1381325445.27365.4.camel@haswell.thedillows.org>
References: <525539A4.8090700@profitbricks.com>
	 <52555A04.8080606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52555A04.8080606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-10-09 at 09:28 -0400, Hal Rosenstock wrote:
> >>From strace:
> > poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
> > read(0, "", 4096)                       = 0
> > poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
> > read(0, "", 4096)                       = 0
> > poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
> > read(0, "", 4096)                       = 0
> 
> So this doesn't block for 1 second and that's why the CPU is 100% ?

Looks like it is spinning on a closed socket (or stdin) -- calling
poll() on such will return immediately...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
