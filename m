From: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>
Subject: Re: hop weighted routing
Date: Mon, 12 Oct 2009 09:22:47 -0500
Message-ID: <20091012142247.GB19827@sgi.com>
References: <4AD3002B.2080901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD3002B.2080901-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nir Gal <nirg-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 12:08:43PM +0200, Eli Dorfman (Voltaire) wrote:
> Hi,
> 
> I have tried to use hop weighted routing and noticed that it is supported only for minhop.
> Is there a reason that this was not implemented for up-down as well?
> 
> Thanks,
> Eli

No, no particular reason.  Just didn't think extending it to up-down.
I assume that could be done.

-- 
Dale
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
