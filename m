From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] fix return value error
Date: Wed, 14 Oct 2015 16:55:32 +0300
Message-ID: <561E5ED4.8000401@mellanox.com>
References: <1444810679-30592-1-git-send-email-os@iscas.ac.cn>
 <CALq1K=+s8pD6GEV0TUwsRN1gE75xP6PWAeoicQ8W6dLnNGipRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALq1K=+s8pD6GEV0TUwsRN1gE75xP6PWAeoicQ8W6dLnNGipRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Heloise NH <os-Xj+kWLifKvnM1kAEIRd3EQ@public.gmane.org>
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/14/2015 2:59 PM, Leon Romanovsky wrote:
> On Wed, Oct 14, 2015 at 11:17 AM, Heloise NH<os-Xj+kWLifKvnM1kAEIRd3EQ@public.gmane.org>  wrote:
>> >Signed-off-by: Heloise NH<os-Xj+kWLifKvnM1kAEIRd3EQ@public.gmane.org>
> The patch is a correct one, however can you update the subject and
> description to be more informative?
> Please add that new_inode() function can fail for allocation only.
>
>> >---
>> >  drivers/infiniband/hw/ipath/ipath_fs.c | 2 +-
>> >  drivers/infiniband/hw/qib/qib_fs.c     | 2 +-

NO... the ipath driver has moved to staging as part of its EOL process, 
it's now under drivers/staging/rdma/ipath
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
