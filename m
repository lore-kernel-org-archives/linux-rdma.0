From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Thu, 12 Jul 2018 21:01:19 +0300
Message-ID: <CAJ3xEMgfNDJ9K11FpLOsUmATaT+4ZMmXkpUktASQRk+ExoEkaA@mail.gmail.com>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me> <20180620184435.GA32326@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180620184435.GA32326@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 20, 2018 at 9:44 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 20, 2018 at 01:40:16PM +0300, Sagi Grimberg wrote:
>> Hey folks,
>>
>> Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
>> stable 4.14 kernel. I upgrated firmware but with no luck :(
>
> Did this work on older kernels?  If so, can you use 'git bisect' to
> track down the offending commit?

so... what was/is the resolution here?


Or.
