From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [BUG] mellanox IB driver fails to load on large config
Date: Tue, 14 Jul 2015 23:06:26 +0300
Message-ID: <CAJ3xEMig=GzROAea7qe0YO11DM6pc4wXyG8VB=kq5Hf5uw2ZXQ@mail.gmail.com>
References: <20150710191506.GA52396@asylum.americas.sgi.com>
	<CAJ3xEMj82OtHcs+kDG_xrQZ4+x3Eih=YSNFR4+W-AoPNA=4jTw@mail.gmail.com>
	<20150714182234.GD17920@asylum.americas.sgi.com>
	<20150714184820.GB58053@asylum.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150714184820.GB58053@asylum.americas.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: andrew banman <abanman@sgi.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Or Gerlitz <ogerlitz@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Roland Dreier <roland@purestorage.com>, Matan Barak <matanb@mellanox.com>, Moni Shoua <monis@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Yishai Hadas <yishaih@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 9:48 PM, Alex Thorlton <athorlton@sgi.com> wrote:
> On Tue, Jul 14, 2015 at 01:22:34PM -0500, andrew banman wrote:
>> On Sat, Jul 11, 2015 at 11:20:19PM +0300, Or Gerlitz wrote:
>> > On Fri, Jul 10, 2015 at 10:15 PM, andrew banman <abanman@sgi.com> wrote:
>> > > I'm seeing a large number of allocation errors originating from the Mellanox IB
>> > > driver when booting the 4.2-rc1 kernel on a 4096cpu 32TB memory system:
>> >
>> > Just to make sure, mlx4 works fine on this small (...) system with 4.1
>> > and 4.2-rc1 breaks, or 4.2-rc1 is the 1st time you're trying that
>> > config?
>>
>> I'll let Alex comment on that, he did some testing on that.
>
> I started seeing this on a 4.1-rc8 kernel, so it's been around for a
> little while.  It may have been around before 4.1-rc8, but I haven't run
> any kernels older than that on the big machine for some time.

To make sure I am correctly following, on 4.1-rc8  you also see
something, right? are these the same messages or different ones? if
the latter send to us.

Or.
