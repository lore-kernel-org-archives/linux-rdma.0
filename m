From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: variable length array in qib
Date: Wed, 2 Jun 2010 16:01:19 -0700
Message-ID: <1275519679.32179.9.camel@chromite.mv.qlogic.com>
References: <adar5kpqfpb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adar5kpqfpb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sure. I will work on a patch.

On Wed, 2010-06-02 at 14:37 -0700, Roland Dreier wrote:
> qib has the code
> 
> 	void qib_disarm_piobufs_set(struct qib_devdata *dd, unsigned long *mask,
> 				    unsigned cnt)
> 	{
> 		struct qib_pportdata *ppd, *pppd[dd->num_pports];
> 
> it would probably be safer to avoid the variable length array pppd[] on
> the kernel stack here... could this code be easily refactored to avoid
> doing that?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
