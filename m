From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: Ping: [PATCH 1/1] Fix deadlock when running
 run_iter_bw_infinitely
Date: Wed, 9 Dec 2015 10:52:45 +0200
Message-ID: <20151209085245.GA8662@leon.nu>
References: <1447849673-30034-1-git-send-email-hans.westgaard.ry@oracle.com>
 <5667E747.2070006@oracle.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5667E747.2070006-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gil Rockah <gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 09:33:11AM +0100, Hans Westgaard Ry wrote:
> Any comments on this patch ?
> 
> 
> 
> On 11/18/2015 01:27 PM, Hans Westgaard Ry wrote:
> >The test uses a signal-handler to periodically print a line of report.
> >+		if (trig_print_report_bw) {
> >+			duration_param->tcompleted[0] =et_cycles();
> >+			print_report_bw(duration_param,NULL);
> >+			duration_param->iters =;
Excuse me, what did you mean by the line above?

> >+			alarm(duration_param->duration);
> >+			duration_param->tposted[0] =et_cycles();
> >+			trig_print_report_bw =;
And this line too.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
