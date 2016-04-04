From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH for kernel v4.6] IB/srpt: Revert "Convert to percpu_ida
 tag allocation"
Date: Mon, 04 Apr 2016 11:34:03 -0700
Message-ID: <1459794843.10124.3.camel@haakon3.risingtidesystems.com>
References: <56FDBA63.7010804@sandisk.com> <20160401030322.GH2670@leon.nu>
	 <56FDE739.9090801@sandisk.com>
	 <1459655763.13184.45.camel@haakon3.risingtidesystems.com>
	 <570116E0.3010401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570116E0.3010401-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-04-03 at 16:13 +0300, sagig wrote:
> > Like I said two months ago, there is no reason why ib_srpt needs special
> > pre-allocation for descriptors containing se_cmd, when every other
> > single driver in the tree already uses common percpu_ida code for it.
> 
> It kinda makes sense that ib_srpt would align to what all the rest are
> doing. I think that fixing the regression with specific assignments
> would've made more sense than a complete revert...

The bug-fix is here:

http://marc.info/?l=linux-rdma&m=145979454519746&w=2

I need to dig up some ConnectX-3 ports that aren't running in Ethernet
mode to verify with over the next days, so any testing of this patch for
those folks who have IB handy would be appreciated.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
