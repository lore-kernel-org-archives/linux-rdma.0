From: Kevin J Moran <kmoran-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [Users] Software IB switch/router
Date: Wed, 13 Apr 2016 19:17:30 -0500
Message-ID: <570EE19A.4040301@systemfabricworks.com>
References: <CAANLjFqg7mCp+-4efWjZyUNULfiR0+gJ12-V9UZiLCKD+kLPZw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0416C3@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0416C3-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There were some presentations that discussed IB Routing and the 
challenges/availability at the recent Open Fabrics Workshop in 
Monterey.  Here is a link to a site that has both the slides and the 
videos (some chose not to allow video) from the workshop 
http://insidehpc.com/2016-open-fabrics-workshop-video-gallery/

Regards,

Kevin


On 4/13/16 6:18 PM, Hefty, Sean wrote:
>> If I wanted to do something stupid and create a white-box Infiniband
>> switch/router, is there some software that does that? Is it even
>> possible?
> I'm not aware of any open source software to do this.
>
> IB routers are not defined by the IB specification.  You may be able to cobble something together, but you would need to define much of the behavior yourself.
>
> You might be able to create a switch, but you would need an HCA that can disable offloaded transport processing (e.g. Truescale HCAs handle transport processing on the host).
>
> - Sean
> _______________________________________________
> Users mailing list
> Users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/mailman/listinfo/users

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
