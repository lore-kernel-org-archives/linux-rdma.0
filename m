From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: rdma_cm segfaults on RoCE with ConnectX-4 [WAS: Re: rping
 segfault with 4.9.28 on CentOS 7.3]
Date: Thu, 18 May 2017 09:59:02 -0600
Message-ID: <CAANLjFqFEbV3ZNi9bvq0nf2bi+fx8iKXRL_ZdQoC13Pbz_5nhw@mail.gmail.com>
References: <CAANLjFp3PWJBiVabMGksarwg9BTM7Cg4mPrBsXY+mYh_zBbsgA@mail.gmail.com>
 <20170518050745.GZ3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518050745.GZ3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 17, 2017 at 11:07 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, May 17, 2017 at 12:14:18PM -0600, Robert LeBlanc wrote:
>> Since I have a connectX-3 card in this same box, I set it up as
>> Infiniband. I can run all the tests (udaddy, rping, ib_send_bw with -R
>> or -z) using the Infiniband link, but the RoCE ConnectX-4 LX segfault
>> on any rdma_cm communications.
>>
>> I put the ConnectX-3 into Ethernet mode and ran the tests again and it
>> passed all of them while the ConnectX-4 LX cards still failed. We have
>> some ConnectX-4 EN 100 Gb cards in other boxes that have the same
>> problem.
>>
>> It really looks like this problem is specific to ConnectX-4 (mlx5
>> driver) when running in RoCE. I _don't_ have ConnectX-4 IB cards to
>> test. We are also seeing the problem with the Mellanox drivers. I
>> can't find http://www.mellanox.com/page/custom_firmware_table to build
>> a new OEM firmware for my SuperMicro branded cards to test the latest
>> firmware.
>
> Robert,
>
> Please avoid top-posting, It is unreadable.
>
> In regards to your issue, the best way to move forward is to open
> customer issue request and leverage established procedures to get
> proper and prompt customer channel support.
>
> Thanks

Are you saying to open a case with Mellanox? I performed all my tests
with the in-box drivers, which I thought the community would be
interested in. I _also_ ran my tests on the Mellanox OFED driver to
see if it was something specific to the in-box drivers or consistent
across both as an additional point of information to help with
resolving the problem. The problem shows up in the in-box driver and
the Mellanox OFED although a little different.

Thanks

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
