From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] IB/core: Make device counter infrastructure dynamic
Date: Tue, 24 May 2016 18:01:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605241800290.18724@east.gentwo.org>
References: <ecc98d137bffc959e6459d9ffd0fe53da0d84c9d.1463760487.git.dledford@redhat.com> <20160524172551.GE8037@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524172551.GE8037-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 May 2016, Jason Gunthorpe wrote:

> > +	/* Guard against buggy edits of the names array */
> > +	BUILD_BUG_ON(ARRAY_SIZE(names) != NR_COUNTERS);
>
> Just drop NR_COUNTERS an use ARRAY_SIZE(names) in all places
> instead?

The NR_COUNTERS is needed to make sure the enum definition is in sync with
the names array. It also allows a reference to the number of items defined
in the enum where necessary.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
