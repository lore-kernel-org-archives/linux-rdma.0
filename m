From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Wed, 24 May 2017 13:25:50 -0600
Message-ID: <20170524192550.GB25200@obsidianresearch.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
 <CAANLjFqNkNVDiGr-yW9y6XCiWE_O7+OewmxWM+xmWHQ39n4wkw@mail.gmail.com>
 <CAANLjFpKGoruxvwhtHwF-fBH+dLT9RKqkd3POYwLVK856WEfFA@mail.gmail.com>
 <CAANLjFqhPUd=kyuv0CBR69KuAwGZzne8ZY3-1J6YiNHuWqZBZA@mail.gmail.com>
 <CAANLjFpHbMXjMnxO0B7sn9rRz2Sn3CEx-bEWKW5BrYj3itQ0HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFpHbMXjMnxO0B7sn9rRz2Sn3CEx-bEWKW5BrYj3itQ0HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 24, 2017 at 12:14:53PM -0600, Robert LeBlanc wrote:
> On Tue, May 23, 2017 at 5:17 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> > I could not replicate ping6 working today without passing the -I
> > parameter. I created https://github.com/linux-rdma/rdma-core/pull/136

It shouldn't have worked, the route cache probably needed flushing
after configuring policy routing.

> Hard coding the source IP address allows the connection to work fine.
> It seems for some reason, it is not using the information from the
> iface that we configured.

Only information provided by the user can be used for route lookup.

Do not try an extract a source address from some other information..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
