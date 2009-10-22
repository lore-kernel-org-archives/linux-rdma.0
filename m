From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 22 Oct 2009 19:38:12 -0400
Message-ID: <1256254692.1579.89.camel@lap75545.ornl.gov>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
 <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
 <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com>
 <1255570760.13845.4.camel@obelisk.thedillows.org>
 <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov>
 <20091015213512.GW5191@obsidianresearch.com> <4AE0E71E.20309@mellanox.com>
 <1256254394.1579.86.camel@lap75545.ornl.gov>
 <1256254459.1579.87.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1256254459.1579.87.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-10-22 at 19:34 -0400, David Dillow wrote:
> On Thu, 2009-10-22 at 19:33 -0400, David Dillow wrote:
> > On Thu, 2009-10-22 at 19:13 -0400, Vu Pham wrote:
> > > Jason Gunthorpe wrote:
> > > > On Thu, Oct 15, 2009 at 03:25:15PM -0400, David Dillow wrote:
> > > >> I use multipath with ALUA, and I don't mind if the link flaps a bit. 60
> > > >> seconds is near my SCSI timeout of 77 seconds, so it doesn't buy me
> > > >> much. I'd rather multipath be delivering traffic to the backup path than
> > > >> sitting on its thumbs for 60 seconds doing nothing.
> > 
> > > > Certainly an enforced lower limit in the kernel is silly, and a
> > > > per-device setting does make some sense.
> > 
> > > Here is the updated patch which implement the device_loss_timeout for 
> > > each target instead of module parameter. It also reflects changes from 
> > > previous feedbacks. Please review
> > 
> > Please put your patches inline for ease of reply...
> > 
> > You still seem to have a 30 second minimum timeout, and no way to
> > disable it altogether.
> 
> And if I could read a patch, I'd notice that that was not a minimum, but
> a default. Still, I have to have a 1 second timeout with no way to
> disable entirely. Better, but...

Last time I reply to myself tonight, I promise... :/

You also don't seem to use the user supplied setting, but hard code the
time to 5 seconds?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
