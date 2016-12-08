From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 03/11] IB/core: Change ah_attr.dlid from 16 to 32 bits
Date: Thu, 8 Dec 2016 16:17:36 -0700
Message-ID: <20161208231736.GA18314@obsidianresearch.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BCAD7@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BCAD7-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 08, 2016 at 09:12:54PM +0000, Hefty, Sean wrote:
> Example:
> 
> > -		if (rmpp_recv->slid == ah_attr.dlid) {
> > +		if (rmpp_recv->slid == (u16)ah_attr.dlid) {
> 
> >  struct ib_ah_attr {
> >  	struct ib_global_route	grh;
> > -	u16			dlid;
> > +	u32			dlid;
> 
> There are a bunch of places where the lid is simply cast back to a
> u16.  How is the code supposed to determine if a u16 cast is a safe
> operation or not?
> 
> I don?t like the overloading of the term 'lid' to sometimes mean a
> 16-bit value and other times a 32-bit value, with no way of
> distinguishing which one we have.  Maybe we need to call out a
> version (lidv2 = 32-bits) or carry the size.  I don't have a strong
> idea here.  But when looking at this patch, lid is re-defined to
> u32, then nearly everywhere cast back to u16, which looks
> questionable.

Yes, I also don't like this.

I would be much happier to see a proper tagged union introduced for
storing the unpacked AH and have that replace all of these hacky
places. That would help with rocee and iwarp too..

struct rdma_ah_data {
    enum rdma_ah_kind kind;
    union
    {
        struct ib_ah_attr ib;
        struct opa_ah_attr opa;
        struct rocev1_ah_attr rocev1;
        struct rocev2_ah_attr rocev2;
        struct iwarp_ah_attr iwarp;
    };
};

We really need to start tagging our data properly or we are going to
have a hard time maintaining this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
