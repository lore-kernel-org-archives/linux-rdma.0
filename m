From: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FW: [PATCH for-next v1 0/2] Advertise atomic operations support
 in mlx5
Date: Wed, 23 Dec 2015 19:05:57 +0200
Message-ID: <CAKHjkjkcr5pH5+HeBSVq0c5Vp8xypNeSvWSAjnw1_joPj4Tx6A@mail.gmail.com>
References: <1450103650-16857-1-git-send-email-eranbe@mellanox.com>
	<567AC682.1020601@redhat.com>
	<AM3PR05MB1331CF3889813C3975A62A6CBAE60@AM3PR05MB1331.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM3PR05MB1331CF3889813C3975A62A6CBAE60-LOZWmgKjnYi+m2m0k9VVTdqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>
>> If the firmware supports host endianness, try to configure the
>> hardware to work this way, and on success propagate this capability to
>> the upper layers, otherwise advertise that atomic operations aren't supported.
>
> If you are not going to allow any support except for host endian, then why bother with all of the BE stuff, can't you just list it as supported or not?

The HW default state is BE reply, need to change it's mode internally.
The user will never know about this, it do listed as supported/not.

>
>> Thanks, Eran
>>
>> Changes from v0:
>>       - Rewrite the commit message of the second patch in the series
>>
>>
>> Eran Ben Elisha (2):
>>   net/mlx5_core: Configure HW to support atomic request in host
>>     endianness
>
> I can fix this up, but generally try to keep your subject of patches short enough to fit in the generally accepted length.

Sure, will keep this in mind for next time.

>
>>   IB/mlx5: Advertise atomic capabilities in query device
>>
>>  drivers/infiniband/hw/mlx5/main.c              | 28 ++++++++++++-
>>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 57 +++++++++++++++++++++++++-
>>  include/linux/mlx5/driver.h                    |  5 +++
>>  include/linux/mlx5/mlx5_ifc.h                  | 22 ++++++----
>>  4 files changed, 102 insertions(+), 10 deletions(-)
>>
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
