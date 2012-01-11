From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Wed, 11 Jan 2012 22:09:51 +0200
Message-ID: <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4F0D987B.4060206@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0D987B.4060206-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> [...] we've also tested a 3.0.15 mainline kernel with in-tree IB modules
> together with the OFED-1.5.4 user-space and this has much better IPoIB
> performance than the kernel stuff from OFED. So, we want to use them
> instead, but there is the same problem with the iSER debug messages and
> iSER doesn't work together with our Solaris 11 COMSTAR targets.

On the full part of the glass, its nice to hear the upstream has good
IPoIB performance, on the other part, I'll give 3.0.15 a try tomorrow,
however, the error you're getting "iser_drain_tx_cq:tx id
ffff88402391f898 status 4 vend_err 57" means that iser got local
protection error (=4) on the first buffer we used with IB (the
connection handshake buffers belong to the IB CM, not to the ULP)
which is the login request. Sounds like something is broken maybe dma
mapping wise, for this reason I think its likely that the problem
might not hit me on my testbed (but I will try, sure).

What environment you're running in - is that Dom0 for some hypervisor?
if yes, is it KVM which means plain Linux or Xen? it would help if you
send me your (compressed, please) .config  - send to my @mellanox
email. Also, please run with iser debug logs open, set debug_level=2
(lets discuss the extra verbosity later, please) and also the session
debug param for the libiscsi module. Is there a chance you can build
the latest kernel 3.2 for your environment and run with it once to see
if the problem happens there as well?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
