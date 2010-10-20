From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib mad definitions
Date: Wed, 20 Oct 2010 09:06:54 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F651@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
 <AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
 <AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
 <20101019102244.21cd2b1e.weiny2@llnl.gov>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
 <20101019212926.GH10362@obsidianresearch.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393@orsmsx501.amr.corp.intel.com>
 <20101019181256.d0a15afe.weiny2@llnl.gov>
 <20101020032818.GC413@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020032818.GC413-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Right now there are 3 headers I find path record in.
> 
> > libibverbs: sa.h
> 
> This isn't a MAD path record, this is the kernel version, which is
> unpacked. What we really needs is MAD 2 kernel and vice versa
> conversion in a library. I already have code that does this in
> several places :(

This contains both.  A wire structure was added to libibverbs to support librdmacm, which doesn't depend on umad.  There are probably only a few of structures that make sense as part of ibverbs - path record and maybe multicast record.  But, we'd have to get agreement that umad should depend on ibverbs, or we'll always have duplicate definitions.

Jason, can you share a portion of the final output looks like for your codegen?

Currently, I'd be happy just starting by having things like the mgmt classes, methods, attribute IDs, status values, common mad header, rmpp header, and sa header listed in a single place.  Eventually, I need the CM MADs defined, which aren't available AFAICT.

ib_types uses a lot of typedefs and #defines, so we may be able to use those to provide backwards compatability.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
