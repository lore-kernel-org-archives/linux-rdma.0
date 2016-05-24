From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4] IB/core: Make device counter infrastructure dynamic
Date: Tue, 24 May 2016 11:25:51 -0600
Message-ID: <20160524172551.GE8037@obsidianresearch.com>
References: <ecc98d137bffc959e6459d9ffd0fe53da0d84c9d.1463760487.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ecc98d137bffc959e6459d9ffd0fe53da0d84c9d.1463760487.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 20, 2016 at 12:14:47PM -0400, Doug Ledford wrote:
> +static const char *names[] = {

What is wrong with

 static const char * const names[] = {

As I originally suggested? No reason for the array to be .data that I
can see.

> +	/* Guard against buggy edits of the names array */
> +	BUILD_BUG_ON(ARRAY_SIZE(names) != NR_COUNTERS);

Just drop NR_COUNTERS an use ARRAY_SIZE(names) in all places
instead?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
