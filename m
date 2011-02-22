From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IB equivalent of virtual IP address ?
Date: Tue, 22 Feb 2011 10:47:29 -0700
Message-ID: <20110222174729.GA10273@obsidianresearch.com>
References: <AANLkTinTwygiSzBC3-AJjt070RTz_B=qYqcm9AayPwPn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinTwygiSzBC3-AJjt070RTz_B=qYqcm9AayPwPn-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 20, 2011 at 02:33:01PM +0100, Bart Van Assche wrote:
> Hello,
> 
> A convenient way to provide high availability when using fail-over
> between two IPv4 iSCSI servers is to configure the HA software such
> that a secondary IPv4 address is only assigned to the active server.
> I'd like to build a HA SRP setup using a similar approach. This leads
> me to the following question: does there exist an equivalent of
> virtual IP addresses for IB ? As far as I can see in the IBTA specs a
> subnet manager can assign a secondary GID to an IB HCA port
> dynamically.
> 
> Does any of the existing IB switches support this ? If so, how does
> communication between HA software and IB switch happen ?
> 
> Does OpenSM support assigning secondary GIDs to a HCA port ?

Unfortunately this is an area where the IB spec has quite a lot of
richness but AFAIK it doesn't get used too much..

I don't think IP like GID migration is appropriate for IB, GUIDs
should be fabric unique. I'd suggest you should look at supporting
multiple GIDs registered for a single service ID and use those GIDs as
the set of fail over end ports. Supporting setting up APM as well
would be great. ;)

In IB if a port falls off the subnet the SM will not return paths for
it, so you can tell quickly that a service record is dead without
incuring a timeout. Essentially the SM takes the roll of the HA
software you see in IP land.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
