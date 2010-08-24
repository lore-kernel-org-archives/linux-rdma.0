From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Tue, 24 Aug 2010 16:23:16 -0400
Message-ID: <1282681396.2425.10.camel@lap75545.ornl.gov>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
 <1282313740.7441.25.camel@lap75545.ornl.gov>
 <201008242147.50692.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008242147.50692.bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Cc: "general-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <general-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-24 at 15:47 -0400, Bernd Schubert wrote:
> On Friday, August 20, 2010, David Dillow wrote:
> > Currently, we limit sg_tablesize to 255 because we can only cache 255
> > indirect memory descriptors in the SRP_CMD message to the target. That's
> > due to the count being in an 8 bit field.
> 
> I think the magic is in srp_map_data(), but I do not find any 8-bit field 
> there? 

The SRP_CMD message is described in the SRP spec, and also by struct
srp_cmd in include/scsi/srp.h. The fields in question are
data_{in,out}_desc_cnt.

> While looking through the code, I also think I found a bug:
> 
> In srp_map_data() 
> 
> count = ib_dma_map_sg()
> 
> Now if something fails, count may become zero and that is not handled at all.

Yes, I think you are correct. I don't think it is possible to hit on any
system arch that one would use IB on, but I'll add to the list of things
I need to fix.

> > It does not have to be this way -- the spec defines that that indirect
> > descriptors in the message are just a cache, and the target should RDMA
> > any additional descriptors from the initiator, and then process those as
> > well. So we could easily take it higher, up to the size of a contiguous
> > allocation (or bigger, using FMR). However, to my knowledge, no vendor
> > implements this support.
> 
> I have no idea if DDN supports it or not, but I'm sure I could figure it out.

You don't; trust me on this. :)

> > We could make more descriptors fit in the SRP_CMD by using FMR to make
> > them virtually contiguous. The initiator currently tries to allocate 512
> > byte pages, but I think it ends up using 4K pages as I don't think any
> > HCA supports a smaller FMR page. That's OK -- I'm pretty sure that the
> > mid-layer isn't going to pass down an SG list of 512 byte sectors, it
> > would be in pages, but it something I'd have to check to be sure. You
> > could get ~255 MB request using this method, assuming you didn't run out
> > of FMR entries (that request would need up to 65,280 entries).
> 
> Hmm, there is already srp_map_frm() and if that fails it already uses an 
> idirect mapping? Or do I completely miss something?

Yes, that tries to use FMR to map the pages and we fall back to indirect
mappings if that fails. We could use FMR to reduce the number of S/G
entries, but we still would need a fallback before we could tell the
SCSI mid-layer that we can handle more than 255 entries.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
