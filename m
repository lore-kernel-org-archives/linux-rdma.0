From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Tue, 30 Apr 2013 14:27:51 -0600
Message-ID: <20130430202751.GB12684@obsidianresearch.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
 <CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
 <CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
 <20130425201255.GB31863@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
 <20130425204357.GD31863@obsidianresearch.com>
 <CAJZOPZK8hcfm2OCnsJkhCiRNxOFXOB0xc9i7tmB4qEnkXrXC0Q@mail.gmail.com>
 <20130425214058.GF31863@obsidianresearch.com>
 <CAJZOPZL9Zrd+5z+pN8UNPwYFu5fg2x5=3hyNDO_EekA+4QQQNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZL9Zrd+5z+pN8UNPwYFu5fg2x5=3hyNDO_EekA+4QQQNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2013 at 11:08:19PM +0300, Or Gerlitz wrote:
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
>     For the TSS case, I'd say just allocate normal QPs and provide
>     something like ibv_override_ud_src_qpn(). This is very general and
>     broadly useful for any application using UD QPs.
> 
> I've lost you, how you suggest to implement ibv_override_ud_src_qpn(), is that
> for future HW or you have a method to get work today.

I meant as a user space API alternative to the parent/child group API
for transmit. It would require some level of driver/FW/HW support of
course.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
