From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/usnic: Expose flows via debugfs
Date: Tue, 14 Jan 2014 00:13:10 +0000
Message-ID: <4AD15059-2671-48C8-ABCC-B90C4B3EF0DF@cisco.com>
References: <6F4F8D2C-F10F-4697-ABD5-552D2E696361@cisco.com>
 <52B6BDAF.6030407@mellanox.com>
 <BC780FB0-731D-42FA-B003-E61B473B23E2@cisco.com>
 <52CD16CE.7080804@mellanox.com>
 <BDC9DBAD-3303-4A61-85C6-4F49957E693E@cisco.com>
 <52D26147.4010709@mellanox.com>
 <9D597492-61CB-4C2D-9853-87EEFEA64BEA@cisco.com>
 <CAJZOPZK9K+kxZ5NuBtir30uOwVciSEVtpxJX6HxZ+xhi9M7whA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK9K+kxZ5NuBtir30uOwVciSEVtpxJX6HxZ+xhi9M7whA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <BA3A37527497C14B80121072BB6B7D50-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Understanding what's missing is important.

It doesn't require prototyping netlink statistics in ib subsystem.  Latest Cisco VIC adapters only report rx byte/pkt counts on flows.  Users expect networking statistics to report both tx and rx counts.  If a tx or rx counter is 0 or missing altogether it is *assumed* that counter is 0.  Because Cisco VIC adapters only reports rx byte/pkt counts, these statistics confuse/mislead the user if exposed through a standard interface.  Hence, we do not wish to report these through any tools easily accessible to the user.  The statistics being exposed are for developers, who understand the caveats, for debugging and the most apt interface for this purpose is debugfs.

Upinder

On Jan 13, 2014, at 3:39 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 wrote:

> On Tue, Jan 14, 2014 at 12:14 AM, Upinder Malhi (umalhi)
> <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>> We are happy to use netlink if it makes sense.  What you are saying is: Netlink is used all over the kernel.  Bc it is used all over the kernel, it must be the right answer for all userspace/kernel interactions.  Therefore, if something doesn't use netlink, it must be wrong (ex. procfs, sysfs, debugfs).
>> 
>> We want to put the rx byte/packet count in debug fs because it is intended for developers.  We do not want to put these in a common infrastructure bc as we have found internally, lacking tx statistics confuses users.  We are being asked to write the ib core statistics infrastructure, that if it was available today, we would not use.  So unless someone else jumps in here, we are going to keep these in the debug fs.
> 
> What wrong with exposing the the flow tuples from netlink and then see
> what's missing that justified debugfs?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
