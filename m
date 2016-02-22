From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix missed clean call in registration path
Date: Mon, 22 Feb 2016 11:12:46 +0200
Message-ID: <CAJ3xEMjVPQ6yiy4PHp2DDeygk9nBgvQJTB5EZ49ac0HUSgUdcw@mail.gmail.com>
References: <1456071146-28101-1-git-send-email-leonro@mellanox.com>
	<20160222011334.GA24657@phlsvsds.ph.intel.com>
	<20160222085327.GO30450@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160222085327.GO30450-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 22, 2016 at 10:53 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Sun, Feb 21, 2016 at 08:13:36PM -0500, ira.weiny wrote:
>> On Sun, Feb 21, 2016 at 06:12:26PM +0200, Leon Romanovsky wrote:
>> > In case of failure returned from query function in
>> > IB device registration, we need to clean IB cache which
>> > was missed.
>> >
>> > This change fixes it.
>> >
>> > Fixes: 3e153a93a1c1 ('IB/core: Save the device attributes on the device
>> > structure')
>> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>
> Thanks Ira and Sagi,
> Do you see the need to push this fix to -stable too?

$ git tag --contains 3e153a93a1c1
v4.5-rc1
v4.5-rc2
v4.5-rc3
v4.5-rc4
v4.5-rc5
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
