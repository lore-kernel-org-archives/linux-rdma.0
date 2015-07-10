From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v1 5/5] svcrdma: Boost NFS READ/WRITE payload size maximum
Date: Fri, 10 Jul 2015 10:18:46 -0400
Message-ID: <20150710141846.GB31121@fieldses.org>
References: <20150709204230.8481.45457.stgit@klimt.1015granger.net>
 <20150709204546.8481.65857.stgit@klimt.1015granger.net>
 <20150710141814.GA31121@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150710141814.GA31121-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 10:18:14AM -0400, J. Bruce Fields wrote:
> On Thu, Jul 09, 2015 at 04:45:47PM -0400, Chuck Lever wrote:
> > Increased to 1 megabyte.
> 
> Why not more or less?
> 
> Why do we even have this constant, why shouldn't we just use
> RPCSVC_MAXPAYLOAD?

(That one question aside these look fine, I'll apply unless I hear
otherwise.)

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
