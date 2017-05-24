From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Wed, 24 May 2017 13:41:25 -0600
Message-ID: <CAANLjFpZU6GodD-HAaTtive+dQZs4Gfgpw=u-1=UgC4zDTryKQ@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
 <CAANLjFqNkNVDiGr-yW9y6XCiWE_O7+OewmxWM+xmWHQ39n4wkw@mail.gmail.com>
 <CAANLjFpKGoruxvwhtHwF-fBH+dLT9RKqkd3POYwLVK856WEfFA@mail.gmail.com>
 <CAANLjFqhPUd=kyuv0CBR69KuAwGZzne8ZY3-1J6YiNHuWqZBZA@mail.gmail.com>
 <CAANLjFpHbMXjMnxO0B7sn9rRz2Sn3CEx-bEWKW5BrYj3itQ0HQ@mail.gmail.com> <20170524192550.GB25200@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170524192550.GB25200-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 24, 2017 at 1:25 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, May 24, 2017 at 12:14:53PM -0600, Robert LeBlanc wrote:
>> On Tue, May 23, 2017 at 5:17 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> > I could not replicate ping6 working today without passing the -I
>> > parameter. I created https://github.com/linux-rdma/rdma-core/pull/136
>
> It shouldn't have worked, the route cache probably needed flushing
> after configuring policy routing.

What I'm thinking happened is I tried the test too quickly after
modifing the route tables, so something was cached that made it work.

>> Hard coding the source IP address allows the connection to work fine.
>> It seems for some reason, it is not using the information from the
>> iface that we configured.
>
> Only information provided by the user can be used for route lookup.

I'm trying to provide this information through iscsiadm ifaces, but
iSER completely ignores it.

# iscsiadm -m iface -I eth0iser -o new
# iscsiadm -m iface -I eth0iser -o update -n iface.ipaddress -v 192.168.13.14
# iscsiadm -m iface -I eth0iser -o update -n iface.transport_name -v iser
# iscsiadm -m discovery -t st -p 192.168.13.13 -I eth0iser

My routing information:

# ip route
default via 10.64.0.1 dev eno1 proto static metric 100
10.64.0.0/10 dev eno1 proto kernel scope link src 10.91.0.14 metric 100

# ip rule
0:      from all lookup local
32765:  from 192.168.13.14 lookup r0
32766:  from all lookup main
32767:  from all lookup default

# ip route show table r0
192.168.13.0/24 dev eth0 scope link

The target has the IP 192.168.13.13 and the route in the default
routing table (automatic entries not modified by me for simplicity).

If I take out the hardcoded 'NULL' in iser_connect() and put in a
hardcoded source IP address, just to test, then the connection is set
up properly. That tells me that iser_connect() knows what to do and
how to do it, it just never tries to use a source address if supplied
through the iface configuration.

> Do not try an extract a source address from some other information..

I want to get the source address (iface.ipaddress) from the iface
(eth0iser in this case) and pass that into iser_connect(). I'm just
not sure how to do that and where the best place to do that is. That
is what I need some help understanding. Any push in the right
direction is appreciated. Is the iface info parsed by the base iscsi
code and then put into a struct that I can query? I sure hope it is
that easy, but I'm having difficulty locating that code.

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
