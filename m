From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Wed, 25 Oct 2017 15:17:28 -0400
Message-ID: <1508959048.3325.58.camel@redhat.com>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
         <20171024144152.GH16127@mtr-leonro.local>
         <14063C7AD467DE4B82DEDB5C278E8663875E153D@FMSMSX108.amr.corp.intel.com>
         <20171024151958.GI16127@mtr-leonro.local>
         <14063C7AD467DE4B82DEDB5C278E8663875E15AD@FMSMSX108.amr.corp.intel.com>
         <1508957840.3325.54.camel@redhat.com>
         <20171025190608.GX16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025190608.GX16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-10-25 at 22:06 +0300, Leon Romanovsky wrote:
> > I agree with Michael that tweaking this code to be optimal versus
> > plainly failsafe is a patch for another day.  I've taken this one.
> > Thanks Michael.
> 
> Too bad, you actually suggested very good solution, it is unclear who
> will now implement it.

I may do it myself.  I've been looking at the code and I don't like the
if construct because I don't feel it conveys the purpose of the code
clearly.  Implicit in the if construct is embedded knowledge about
which providers do what.  I'd rather have a switch construct on the
index with the flow split to those that have only .dump, those that
have only .doit, and those that have both.  The current if doesn't make
it clear that this is how the netlink services are structured.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
