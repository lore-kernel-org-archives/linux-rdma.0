From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Thu, 8 Sep 2016 18:24:14 +0300
Message-ID: <CAJ3xEMjO4350uZgZDRW1P+41zXOpnjXNJT3-cMPgmhf=E9zw0A@mail.gmail.com>
References: <1473232990-22766-1-git-send-email-dchang@suse.com> <20160908140752.GN18398@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160908140752.GN18398-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: David Chang <dchang-IBi9RG/b67k@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 8, 2016 at 5:07 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Wed, Sep 07, 2016 at 03:23:10PM +0800, David Chang wrote:
>> When using MAD_IFC command, we should also consider avoiding in
>> ISSI > 0 mode, otherwise most of the MAD_IFC command features
>> are deprecated and cannot be used.
>>
>> Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
>> Reported-by: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>
>> Signed-off-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
>
> NAK,
> It is wrong, the deprecation is removed from programming manual.

The rdma programing manual is not open to the community, there's no
point to comment
here if X is there or not.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
