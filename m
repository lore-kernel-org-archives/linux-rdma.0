From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: librdmacm in rdma-core build warnings
Date: Mon, 2 Oct 2017 11:54:31 -0600
Message-ID: <20171002175431.GB13149@obsidianresearch.com>
References: <20171002061532.GJ2031@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB199DAC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB199DAC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 02, 2017 at 04:11:01PM +0000, Hefty, Sean wrote:
> > [26/189] Building C object
> > librdmacm/CMakeFiles/rspreload.dir/preload.c.o
> > ../librdmacm/preload.c:818:9: warning: no previous prototype for
> > ???readv??? [-Wmissing-prototypes]  ssize_t readv(int socket, const struct
> > iovec *iov, int iovcnt)
> >          ^~~~~
> > ../librdmacm/preload.c:857:9: warning: no previous prototype for
> > ???writev??? [-Wmissing-prototypes]  ssize_t writev(int socket, const
> > struct iovec *iov, int iovcnt)
> 
> Does including sys/uio.h fix this?

Something like that is the right solution, probably caused by glibc
changes not gcc changes...

The prototype must come from glibc headers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
