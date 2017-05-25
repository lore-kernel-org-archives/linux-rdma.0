From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Thu, 25 May 2017 19:03:20 +0300
Message-ID: <CAJ3xEMhZsMxuxpYy8bd76XWe-SKefcXRV3z9Up-RLBznVC6nNA@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
 <CAANLjFqNkNVDiGr-yW9y6XCiWE_O7+OewmxWM+xmWHQ39n4wkw@mail.gmail.com>
 <CAANLjFpKGoruxvwhtHwF-fBH+dLT9RKqkd3POYwLVK856WEfFA@mail.gmail.com>
 <CAANLjFqhPUd=kyuv0CBR69KuAwGZzne8ZY3-1J6YiNHuWqZBZA@mail.gmail.com>
 <CAANLjFpHbMXjMnxO0B7sn9rRz2Sn3CEx-bEWKW5BrYj3itQ0HQ@mail.gmail.com>
 <20170524192550.GB25200@obsidianresearch.com> <CAANLjFpZU6GodD-HAaTtive+dQZs4Gfgpw=u-1=UgC4zDTryKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpZU6GodD-HAaTtive+dQZs4Gfgpw=u-1=UgC4zDTryKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 24, 2017 at 10:41 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
[...]
> I want to get the source address (iface.ipaddress) from the iface
> (eth0iser in this case) and pass that into iser_connect(). I'm just
> not sure how to do that and where the best place to do that is. That
> is what I need some help understanding. Any push in the right
> direction is appreciated. Is the iface info parsed by the base iscsi
> code and then put into a struct that I can query? I sure hope it is
> that easy, but I'm having difficulty locating that code.

If you get the source address into the iscsi initiator UAPI it would
be very simple kernel
code change to get that to iser_connect --> rdma_resolve_address as
you indicated.

Currently only the dst address is passed from user-space, to see it
clone [1] and look

$ vim usr/netlink.c +/ktransport_ep_connect

see  there

memcpy(setparam_buf + sizeof(*ev), dst_addr, addrlen);

for the kernel side of things look here

$ vim drivers/scsi/scsi_transport_iscsi.c +/ep_connect

see there

dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
ep = transport->ep_connect(shost, dst_addr, non_blocking);


Or.


[1] https://github.com/open-iscsi/open-iscsi.git
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
