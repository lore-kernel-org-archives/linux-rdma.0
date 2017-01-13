From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v1 00/22] convert NFS server to new rdma_rw API
Date: Fri, 13 Jan 2017 12:08:49 -0500
Message-ID: <20170113170849.GF24709@fieldses.org>
References: <20170107170258.14126.8503.stgit@klimt.1015granger.net>
 <20170113164208.GD24709@fieldses.org>
 <33FF9D08-075A-4153-ADDA-C460C1A4D93B@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <33FF9D08-075A-4153-ADDA-C460C1A4D93B-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 13, 2017 at 11:54:01AM -0500, Chuck Lever wrote:
> Hi Bruce-
> 
> 
> > On Jan 13, 2017, at 11:42 AM, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org wrote:
> > 
> > Can you summarize the motivation for the change, for someone (like me)
> > that doesn't know much about RDMA?  Or does "significant cleanups" cover
> > it?
> 
> Last year, Sagi and Christoph introduced a new set of APIs to the
> RDMA core that enable ULPs like iSER and NFS/RDMA to leave the details
> of certain aspects of operation to the core, instead of all the ULPs
> having to implement the details themselves. Kind of a code refactoring /
> de-duplication.
> 
> Then, going forward, fixes and improvements made to the logic behind
> this new API will be available to all ULPs that use the new API.
> 
> This series converts the server-side RPC-over-RDMA implementation
> to use the new API.
> 
> 
> > Are there any regressions?  For example, will it still support all the
> > same hardware?  Is there any change that will be noticeable to NFS/RDMA
> > users?
> 
> All the same hardware is supported. The standing policy for ULPs is
> that they must work with all in-tree HCA drivers and devices.
> 
> The goal of this work is that there is no user-visible change in
> functionality or performance.
> 
> I know it's a lot to consider, and I'm happy to split up the series
> or individual patches to help review.

Eh, I'll try to do a little, but realistically I'm mainly trusting you
and Christoph, so it's more important that the process work for you.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
