From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Wed, 12 Oct 2011 09:32:23 -0700
Message-ID: <CABgxfbEcYVF6LbmnJnx0UuYvn6-W+JiyNSNT2FAiuYZba65nsQ@mail.gmail.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
	<20111011173929.GH26965@obsidianresearch.com>
	<CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 12, 2011 at 3:41 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On Tue, Oct 11, 2011 at 7:39 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Tue, Oct 11, 2011 at 09:02:41AM -0500, Christoph Lameter wrote:
>>> Has XRC support not been merged? How can I build the OFED libraries
>>> against Linux 3.1? I'd really like to get rid of the OFED kernel tree
>>> nightmare.
>>
>> You have to use upstream libraries with upstream kernels. Be warned
>> that the OFED libraries of the same SONAME are not ABI compatible with
>> upstream libraries.
>
> Why is the OFED libibverbs library binary incompatible with the
> non-OFED libibverbs library ? Why hasn't XRC support been implemented
> in the OFED libibverbs library such that applications built against
> the upstream libibverbs headers also work with the latest OFED version
> of that library ?
>

I'm relatively new to OFED but happened to bump into a similar build
issue two weeks ago.

The OFED package itself does include XRC support. The issue here (my
guess) is that its build script needs to understand the running
system's kernel version to decide what should be pulled (from the
source). Linux 3.1 could be too new for OFED build script to make a
correct decision. Nevertheless, mix-matching OFED modules/libraries is
a *bad* idea.

It is difficult to love OFED build :) but it seems to work ok (so far
for me). Plus, I don't have a better proposal myself anyway .....

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
