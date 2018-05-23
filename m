From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Wed, 23 May 2018 08:03:44 -0700
Message-ID: <CAKgT0UeZRZ8O3PQWSz2Wod8HNjwc_bcuqqb70A7qypPn5kzW+Q@mail.gmail.com>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
 <20180522205612.GD7502@mellanox.com> <079ceee3bc8cd0ea50dd7ddc12b27512ca5ac49e.camel@intel.com>
 <20180523061922.GA4753@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523061922.GA4753@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Sindhu Devale <sindhu.devale@intel.com>, Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, Neil Horman <nhorman@redhat.com>, Stefan Assmann <sassmann@redhat.com>, John Greene <jogreene@redhat.com>, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 22, 2018 at 11:19 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, May 22, 2018 at 02:04:06PM -0700, Jeff Kirsher wrote:
>> > Why would you want to do this? The rdma driver is non-functional
>> > without the ethernet driver, so why on earth would we want to defeat
>> > the module dependency mechanism?
>>
>> This change is driven by the OSV's like Red Hat, where customer's were
>> updating the i40e driver, which in turn broke i40iw.
>
> Doctor it hurts when I do this..
>
> There is no reason to make a mess of our drivers because people are
> doing things they should haver never done and that aren't supported
> in Linux.
>
> If Intel didn;t offer any out of tree drivers I'm pretty sure no
> customer would even attempt this.  So fix this where the problem is.

Are you serious? You are never going to see out-of-tree drivers go
away. They exist for the simple reason that most customers/OSVs are
slow to upgrade their kernels so we have people running on a 3.10
something kernel on their RHEL 7.X and want to use the latest greatest
hardware.

I find it ridiculous that you expect us to support a product with
in-kernel only and it is pretty short sighted to insist that that is
the only way to support a product.

With that said it probably wouldn't hurt to throw a WARN_ONCE in here
somewhere that basically informs the user they are doing something
stupid and essentially disabling the i40iw driver if they remove i40e.

- Alex
