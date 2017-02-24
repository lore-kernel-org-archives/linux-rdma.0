From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/4] sunrpc: flag transports as using IETF approved
 congestion control protocols
Date: Fri, 24 Feb 2017 11:03:23 -0700
Message-ID: <20170224180323.GA22491@obsidianresearch.com>
References: <20170223170337.10686-2-jlayton@redhat.com>
 <2152dfdf-f847-2511-1600-6499b6ea9708@talpey.com>
 <1487880034.3448.8.camel@redhat.com>
 <65056db6-f30a-c44d-b01c-b549887c4895@talpey.com>
 <20170223201109.GC11882@fieldses.org>
 <20170223202609.GC26301@obsidianresearch.com>
 <18ef37c3-95db-9a2c-dbcb-f579672065d6@talpey.com>
 <20170223205502.GA29673@obsidianresearch.com>
 <4eb1da3d-2690-7647-2d85-cc574bc1d564@talpey.com>
 <1487956644.3314.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487956644.3314.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> I'd rather rely on those attributes instead of any sort of IETF
> approval anyway. Do all RDMA transports (RoCEv2, in particular) have
> those characteristics?

The NFS-RDMA driver only works with RDMA RC transports which are
defined to provide all those characteristics.

> In any case, for now I think we should just give all RDMA transports a
> pass, and clean that up later. I'm mostly interested in excluding UDP
> over IP for now -- being more strict with RDMA can come later.

Makes sense to me. At the end of the day I think everything supported
by NFS-RDMA should be permitted to use NFSv4, and we should ignore
sketchy spec language that suggests otherwise.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
