From: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Mon, 16 Oct 2017 09:31:05 -0600
Message-ID: <CALvXFTe9kWHfp=B-TOP3G+U_1Zb_rd9szYr8akKtroA+xSkJFA@mail.gmail.com>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
 <20171016045054.GZ2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016045054.GZ2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 15, 2017 at 10:50 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Oct 11, 2017 at 01:00:24PM -0600, Nathan Hartwell wrote:
>> rxe_cfg does not always parse the output of ethtool and ifconfig correctly.
>>
>> Fix two items:
>> 1)  Parsing of ethtool's link speed field to always output a link speed.
>> 2)  Parsing of ifconfig's IP address / MTU fields with newer builds of
>> ifconfig that have a slightly different output format than in the
>> past.
>
> Can you please specify the version of ifconfig and OS?
>
> Thanks


OS: CentOS 7 / 4.14.0-rc3 kernel
ifconfig: net-tools 2.10-alpha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
