From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Wed, 28 Oct 2009 11:09:18 -0400
Message-ID: <1256742558.14929.17.camel@lap75545.ornl.gov>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
 <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
 <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com>
 <1255570760.13845.4.camel@obelisk.thedillows.org>
 <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov>
 <20091015213512.GW5191@obsidianresearch.com> <4AE0E71E.20309@mellanox.com>
 <1256254394.1579.86.camel@lap75545.ornl.gov>
 <1256254459.1579.87.camel@lap75545.ornl.gov>
 <1256254692.1579.89.camel@lap75545.ornl.gov> <4AE0F309.5040201@mellanox.com>
 <1256256984.1579.105.camel@lap75545.ornl.gov> <4AE0F7DA.20100@mellanox.com>
 <1256258049.1598.8.camel@lap75545.ornl.gov> <4AE1DEEF.5070205@mellanox.com>
 <1256335698.10273.62.camel@lap75545.ornl.gov> <4AE2AE54.5020004@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4AE2AE54.5020004-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2009-10-24 at 03:35 -0400, Vu Pham wrote:
> It's a big improvement from 3-5 minutes cutting down to 1s and now you
> talk about device_loss_timeout=0. I'll look at the trade-off to have
> it; however, to receive and process the async event (port error)
> already cost you a fair amount of cycles.

I agree that it is a great improvement over just sending packets blindly
to the link, and waiting for SCSI to time them out -- I've been using
the variant of the patches from OFED -- but it is harder to change
things once they are in the mainstream kernel, so I'd like to see it
done better.

And hey, maybe I'm just overly touchy about this. These should be rare
events, and there's nothing we can do about the commands sent prior to
being told about the link error. It's just that I don't want my file
system to stall the petaflop simulation platforms if I can avoid it --
and there's no reason to send any command down the wire once we've been
told there is no link or the target is not there. Maybe we don't need to
destroy the link immediately, but we need to let the SCSI mid-layer know
that things are failing.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
