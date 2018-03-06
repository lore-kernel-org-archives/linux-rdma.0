From: Oliver <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Tue, 6 Mar 2018 21:40:51 +1100
Message-ID: <CAOSf1CG3jdx9RdhCgq+d0fdYLLByhknsXfkUYwigzQzZM0xfGw@mail.gmail.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
 <CAOSf1CHvaz0QTCkptQwsdyPp6uvvHqtM51N0MfrO9RqYf9W0tg@mail.gmail.com>
 <416d8d27-200f-befb-1c30-14544fffcba0@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <416d8d27-200f-befb-1c30-14544fffcba0-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 6, 2018 at 12:14 PM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>
> On 05/03/18 05:49 PM, Oliver wrote:
>>
>> It's in arch/powerpc/kernel/io.c as _memcpy_toio() and it has two full
>> barriers!
>>
>> Awesome!
>>
>> Our io.h indicates that our iomem accessors are designed to provide x86ish
>> strong ordering of accesses to MMIO space. The git log indicates
>> arch/powerpc/kernel/io.c has barely been touched in the last decade so
>> odds are most of that code was written in the elder days when people
>> were less aware of ordering issues. It might just be overly conservative
>> by today's standards, but maybe not (see below).
>
>
> Yes, that seems overly conservative.
>
>> (I'm not going to suggest ditching the lwsync trick. mpe is not going
>> to take that patch
>> without a really good reason)
>
>
> Well, that's pretty gross. Is this not exactly the situation mmiowb() is
> meant to solve? See [1].

Yep, mmiowb() is supposed to be used in this situation. According to BenH,
author of that io_sync hack, we implement the stronger semantics
so that we don't break existing drivers that assume spin_unlock() does
order i/o even though it's not supposed to. At a guess the x86 version of
spin_unlock() happens to do that so the rest of us need to either live
with it or fix all the bugs :)

> Though, you're right in principle. Even if power was similar to other
> systems in this way, it's still a risk that if these pages get passed
> somewhere in the kernel that uses a spin lock like that without an mmiowb()
> call, then it's going to have a bug. For now, the risk is pretty low as we
> know exactly where all the p2pmem pages will be used but if it gets into
> other places, all bets are off.

Yeah this was my main concern with the whole approach. For ioremap()ed
memory we have the __iomem annotation to help with tracking when we
need to be careful, but we'd lose that entirely here.

> I did do some work trying to make a safe
> version of io-pages and also trying to change from pages to pfn_t in large
> areas but neither approach seemed likely to get any traction in the
> community, at least not in the near term.

It's a tricky problem. HMM with DEVICE_PRIVATE might be more
palatable than the pfn_t conversion since there would still be struct pages
backing the device memory. That said, there are probably other issues with
device private memory not being part of the linear mapping, but HMM
provides some assistance there.

Oliver
