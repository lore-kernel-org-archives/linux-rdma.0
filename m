From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Tue, 29 Nov 2016 08:35:52 +0200
Message-ID: <CAJ3xEMiC3UDujgSL5fwP7ee1=OjhorZ2aeB1k+ptGb9GWaUVkg@mail.gmail.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org> <20161128170056.GC28381@obsidianresearch.com>
 <CAJ3xEMiv6HCu-9fi12XtafxYWu-+gNPMbnfb-A4-+FrgR6KZNA@mail.gmail.com> <20161128222559.GB744@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161128222559.GB744-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 29, 2016 at 12:25 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Nov 28, 2016 at 10:57:00PM +0200, Or Gerlitz wrote:
>> On Mon, Nov 28, 2016 at 7:00 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

>> > Does the mlx drivers really register ports with different capabilities
>> > as the same ib_device? I'm not sure that should be allowed.

>> mlx4 yeah (practically for the last ~10 years) for instance Eth ports
>> don't support SMI -- this goes back to the fact that mlx4 devices are
>> single PCI function with potentially two ports and each port can be

> struct ib_device is not linked to a PCI device. AFAIK mlx4 created one
> ib_device for rocee ports and one for IB,

no, it doesn't

> or at least it should or things are already broken.

Can you elaborate what it broken with mlx4? I suspect we
even have down there some functionality which depends on that,
but again, I 1st would like to hear if/what is broken - I copied the maintainer.

>> set to different link layer. But this no more holds for mlx5, these
>> devices are function-per-port and hence IB device per port.

> Since it has nothing to do with pci devices, please do this properly.

again, mlx5 does this already.

Jason, patches 8-10 which carry the functional change I want to introduce
(allow mlx5 IB devices to be created when RoCE is not supported) stand
for themselves.

As I wrote, the stack is fully functional  (i.e no error in the IB
core etc) when
only these patches are put. E.g things behave in a similar manner to all
the upstream iWARP drivers that refuse to create any QP which is not RC.

I am okay to put aside patches 1-7 which I added per Doug request for
user-space
applications to be able and query what QPs are supports on a device,
or to get in
patches 1-7, whatever works better for Doug and ppl. I don't think
it's fair to ask
a re-write of the 10y old IB device-ing of things done by mlx4 just to be able
and introduce this reduced functionally (raw packet qp only) of mlx5 devices.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
