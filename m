From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib mad definitions
Date: Tue, 19 Oct 2010 18:00:51 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
 <AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
 <AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
 <20101019102244.21cd2b1e.weiny2@llnl.gov>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
 <20101019212926.GH10362@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101019212926.GH10362-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Can we at least agree on the usage of these structures first? Are the
> constants going to be in host or network byte order?

I was simply suggesting to 'move' some of the existing structures and defines.

> Are you going to make something like the kernel where there is a
> native structure and pack/unpack function set?

This would not be my preference.

> Something macro-based like foo = GET_MEMBER(*pr,preference)
> 
> Network byte order casting structures?
> 
> Host byte order casting structures? (my favorite)
> 
> bitfields?

again - not my preference

> Ira, I think the cleanest answer is that OSM keeps its type file, and
> umad gets a new one that is cleaner, more capable and probably
> incompatible. I'd hate to see us stick to the OSM scheme for umad just
> for code compatability.

Whatever is done must fit within the windows development framework that we use.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
