From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: Make device counter infrastructure dynamic
Date: Thu, 19 May 2016 15:50:02 -0600
Message-ID: <20160519215002.GB2469@obsidianresearch.com>
References: <9ed44c11acf2de44f06ce5d88758ce8d732d1be2.1463693558.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9ed44c11acf2de44f06ce5d88758ce8d732d1be2.1463693558.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 05:35:13PM -0400, Doug Ledford wrote:

> +	return sprintf(buf, "%d msecs (rounded from jiffies), 0-10000 allowed "
> +		       "range\n", msecs);

sysfs files should not have usage commentary like that, just use the
%d

> +char *names[] = {

static const char * const names[] = {

For Kees

> +	[NR_COUNTERS] = NULL

Don't really need this, just use ARRAY_SIZE(names) in place of
NR_COUTNERS

> +       stats = kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64), GFP_KERNEL);

People have been switching the above pattern to use kcalloc

> +static char *names[] = {
> +	[TCPINSEGS] = "tcpInSegs",
> +	[TCPOUTSEGS] = "tcpOutSegs",
> +	[TCPRETRANSSEGS] = "tcpRetransSegs",
> +	[TCPOUTRSTS] = "tcpOutRsts",
> +	[NR_COUNTERS] = NULL
> +};

ditto

> +static char *i40iw_hw_stat_names[] = {

ditto

> +	[I40IW_HW_STAT_INDEX_MAX_64 + I40IW_HW_STAT_INDEX_MAX_32] = ""

Why an empty string?

> +	char		*dirname; /* Sysfs directory name */
> +	char		**name;   /* array of names of the counters in the
> +				   * sysfs dir

const char * const *name

Trailing comments are not the kdoc standard for structure members,
IIRC.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
