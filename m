From: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Tue, 31 Jan 2017 18:37:58 +0000
Message-ID: <A4803088-726E-4B88-B421-CE1969B6E25B@ccn-mail.lanl.gov>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126202330.GX6005@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB0E15AD@ORSMSX109.amr.corp.intel.com>
 <20170127010452.GA7826@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0E1609@ORSMSX109.amr.corp.intel.com>
 <41e74ed7-fd8d-89cf-2c79-b99a8d786fac@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <41e74ed7-fd8d-89cf-2c79-b99a8d786fac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <BCCE55A8A3F295459433F7BA8DA92033-r1tBtT6b1V2fRvmTrFJqzg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jan 27, 2017, at 7:32 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> On 1/26/2017 8:17 PM, Hefty, Sean wrote:
>>> - Ship libibverbs.rpm with the updated driver and matched libibverbs
>>>  This is pretty easy, I probably would recommend this.
>> 
>> This has issues if there are multiple providers present.  Maybe that doesn't happen in non-testing environments.  I wonder if the distros would agree with this approach.
> 
> I don't know how much I would rely on the belief that mixed environments
> don't happen outside of testing.  In particular, the structure of Lustre
> filesystems or the need to gateway from a fabric that one brand of
> storage server doesn't support to another one would both seem to be
> times when mixed hardware might exist.  For that matter, the typical
> stock trading RDMA environment mixes IB and Ethernet, maybe in the
> future it will have OPA in there too?

This is happening now - not in the future.
LANL and other DOE labs already have OPA and IB/mlnx on the same host.


>  I think you are right that it is
> the most common, but I don't think we can rely on it being that way all
> the time.
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>    GPG Key ID: B826A3330E572FDD
>    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> 

==================================================
Susan Coulter / HPC-DES
Network Capability Lead
(505) 667-8425
“Once in a while you get shown the light
    In the strangest of places if you look at it right”  Robert Hunter
==================================================







--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
