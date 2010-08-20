From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Fri, 20 Aug 2010 10:15:40 -0400
Message-ID: <1282313740.7441.25.camel@lap75545.ornl.gov>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008200949.54595.bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Cc: general-G2znmakfqn7U1rindQTSdQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-08-20 at 09:49 +0200, Bernd Schubert wrote:
> In ib_srp.c sg_tablesize is defined as 255. With that value we see lots of IO 
> requests of size 1020. As I already wrote on linux-scsi, that is really sub-
> optimal for DDN storage, as lots of IO requests of size 1020 come up.
> 
> Now the question is if we can safely increase it. Is there somewhere a 
> definition what is the real hardware supported size? And shouldn't we increase 
> sg_tablesize, but also set the .dma_boundary value?

Currently, we limit sg_tablesize to 255 because we can only cache 255
indirect memory descriptors in the SRP_CMD message to the target. That's
due to the count being in an 8 bit field.

It does not have to be this way -- the spec defines that that indirect
descriptors in the message are just a cache, and the target should RDMA
any additional descriptors from the initiator, and then process those as
well. So we could easily take it higher, up to the size of a contiguous
allocation (or bigger, using FMR). However, to my knowledge, no vendor
implements this support.

We could make more descriptors fit in the SRP_CMD by using FMR to make
them virtually contiguous. The initiator currently tries to allocate 512
byte pages, but I think it ends up using 4K pages as I don't think any
HCA supports a smaller FMR page. That's OK -- I'm pretty sure that the
mid-layer isn't going to pass down an SG list of 512 byte sectors, it
would be in pages, but it something I'd have to check to be sure. You
could get ~255 MB request using this method, assuming you didn't run out
of FMR entries (that request would need up to 65,280 entries).

The problem with using FMR in this manner is the failure cases. We have
no way to tell the SCSI mid-layer that it needs to split the request up,
and even if we could there may be certain commands that must not be
split. We could return BUSY if we fail to allocate an FMR entry, but
then we have no guarantee of forward progress. This should be a rare
case, but it's not something we want in a storage system.

So, we would still want to be able to fall back to the RDMA of indirect
descriptors, even if it is very rarely used.

If you can get Cedric to add it to the target, I'll commit to writing
the initiator part. We'd love to have it, as would many of your other
customers.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
