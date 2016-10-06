From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/{core,hw}: Add constant for node_desc
Date: Thu, 6 Oct 2016 07:46:13 +0300
Message-ID: <20161006044611.GA4327@yuval-lap.sg.oracle.com>
References: <1472147827-14609-1-git-send-email-yuval.shaia@oracle.com>
 <c39be0ef-d170-d40d-aac4-0c157fc843b7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c39be0ef-d170-d40d-aac4-0c157fc843b7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 26, 2016 at 09:57:06AM -0400, Doug Ledford wrote:
> On 8/25/2016 1:57 PM, Yuval Shaia wrote:
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > v0 -> v1:
> > 	* Exclude some files from commit based on Jason's comment
> > v1 -> v2:
> > 	* Re-include all the excluded files with BUILD_BUG_ON
> 
> v2 applied, thanks.

I have a bad feeling that this one slipped out.

> 
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
