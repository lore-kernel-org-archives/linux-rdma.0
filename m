From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib mad definitions
Date: Tue, 19 Oct 2010 15:29:26 -0600
Message-ID: <20101019212926.GH10362@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com> <AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com> <AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com> <20101019102244.21cd2b1e.weiny2@llnl.gov> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 19, 2010 at 11:50:46AM -0700, Hefty, Sean wrote:

> We start with a minimal set of definitions to umad and add/move
> other definitions later as needed, creating new header files where
> appropriate (umad_smi.h, umad_pm.h, etc.)
 
> If we can get some basic agreement on this, I'll start on the
> patches immediately.  In an ideal world, the new header files would
> work on any platform.

Can we at least agree on the usage of these structures first? Are the
constants going to be in host or network byte order?

Are you going to make something like the kernel where there is a
native structure and pack/unpack function set?

Something macro-based like foo = GET_MEMBER(*pr,preference)

Network byte order casting structures?

Host byte order casting structures? (my favorite)

bitfields?

For years now I've had a set of data files that describe all the IB
structures bitfield layouts. I think I can contribute the data files
but not the generator script.

Since they all have various merits, maybe the smartest thing is to just
codegen all of the above permutations from single data source?

ie
// network endian bitfield casting structure
struct MADHeader_NE x = {};
x.status = htons(1);

// host endian bitfield casting structure
struct MADHeader_HE x = {};
x.status = 1
to_network(&x,sizeof(x)); // x[i] = htonl(x[i]) for i in len/4

/* Non-bitfield macro access structure
   (using the 1 byte = 1 bit helper structure technique) */
struct MADHeader_M x = {}
SET_MEMBER(x,status,1);  

// Pack/unpack function structure
struct MADHeader_UP x = {};
x.status = htons(1);
pack_MADHeader(&x,mad_buf,sizeof(mad_buf));

I'd like to think we don't need the last one, but people seem to like
that scheme ..

I also like to codegen structure printing functions, that is
surprisingly useful - and implements a good chunk of madeye.
 
What do you think?

I've also very recently been thinking that I'd like python bindings
for MADs for some projects. I was planning on building it out with the
code gen scheme.

Ira, I think the cleanest answer is that OSM keeps its type file, and
umad gets a new one that is cleaner, more capable and probably
incompatible. I'd hate to see us stick to the OSM scheme for umad just
for code compatability.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
