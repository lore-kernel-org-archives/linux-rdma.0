From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 15 Oct 2009 15:25:15 -0400
Message-ID: <1255634715.29829.9.camel@lap75545.ornl.gov>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
 <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
 <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com>
 <1255570760.13845.4.camel@obelisk.thedillows.org>
 <4AD74C88.8030604@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4AD74C88.8030604-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-10-15 at 09:23 -0700, Vu Pham wrote:
> David Dillow wrote:
> > And if I want to disable this completely?
> >   
> 
> Unless these patches are bad and affect the stability of the driver, why 
> do you want to disable it? If you don't use multipath/device-mapper and 
> use /dev/sd**, everything will be  same

I use multipath with ALUA, and I don't mind if the link flaps a bit. 60
seconds is near my SCSI timeout of 77 seconds, so it doesn't buy me
much. I'd rather multipath be delivering traffic to the backup path than
sitting on its thumbs for 60 seconds doing nothing.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
