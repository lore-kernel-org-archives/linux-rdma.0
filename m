From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libmlx5 2/6] fix coverity buffer overrun warning
Date: Thu, 28 Jul 2016 16:12:02 -0400
Message-ID: <20160728201202.GR36313@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
 <1469647047-7544-3-git-send-email-jarod@redhat.com>
 <9ee81879-93c4-97ee-eebf-3300533e4efe@dev.mellanox.co.il>
 <20160728163714.GP36313@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160728163714.GP36313-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 28, 2016 at 12:37:14PM -0400, Jarod Wilson wrote:
> On Thu, Jul 28, 2016 at 05:46:16PM +0300, Yishai Hadas wrote:
> > On 7/27/2016 10:17 PM, Jarod Wilson wrote:
> > >In set_umr_data_seg, there's a union between a 16-byte struct and a
> > >64-byte array, named data. The code then makes a memset() call on the
> > >struct that is sizeof(array) - sizeof(struct) long, which results in
> > >writing 48 bytes to a 16 byte container. Technically, we know this is
> > >actually fine, because of the union, but to silence the warning, we can
> > >just do the memset on the array instead. Same address, same result, but no
> > >warning spew from coverity.
> > >
> > >CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >---
> > > src/qp.c | 2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > >diff --git a/src/qp.c b/src/qp.c
> > >index 51e1176..8bb66be 100644
> > >--- a/src/qp.c
> > >+++ b/src/qp.c
> > >@@ -426,7 +426,7 @@ static void set_umr_data_seg(struct mlx5_qp *qp, enum ibv_mw_type type,
> > > 	data->klm.mkey = htonl(bind_info->mr->lkey);
> > > 	data->klm.address = htonll(bind_info->addr);
> > >
> > >-	memset(&data->klm + 1, 0, sizeof(data->reserved) -
> > >+	memset(&data->reserved + 1, 0, sizeof(data->reserved) -
> > > 	       sizeof(data->klm));
> > 
> > As you pointed out this is false alarm, code is correct.
> > 
> > Your suggestion seems wrong as it skipped size of 'reserved' instead
> > of size of 'klm' (i.e. 16 bytes), isn't it ?
> 
> &data->klm + 1 and &data->reserved + 1 should point to the same location,
> no? Must admit, I'm a little hazy on how a union pointer works.
> 
> Regardless, I think this might be much more straight-forward if we did
> something like this:
> 
> From 43e845cc1055e4f86a2e9c78e5a3eae2c1e915c4 Mon Sep 17 00:00:00 2001
> From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date: Wed, 27 Jul 2016 11:35:02 -0400
> Subject: [PATCH v2 libmlx5 2/6] fix coverity buffer overrun warning
> 
> In set_umr_data_seg, there's a union between a 16-byte struct and a
> 64-byte array, named data. The code then makes a memset() call on the
> struct that is sizeof(array) - sizeof(struct) long, which results in
> writing 48 bytes to a 16 byte container. Technically, we know this is
> actually fine, because of the union, but to silence the warning and
> simplify the pointer math and union gymnastics, simply zero out the entire
> storage space before assigning klm bits.
> 
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  src/qp.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/src/qp.c b/src/qp.c
> index 51e1176..17f2c81 100644
> --- a/src/qp.c
> +++ b/src/qp.c
> @@ -422,13 +422,12 @@ static void set_umr_data_seg(struct mlx5_qp *qp, enum ibv_mw_type type,
>  		uint8_t				reserved[64];
>  	} *data = *seg;
>  
> +	memset(&data, 0, sizeof(*data));

Nope, this is wrong, should be just data, not &data, I think. Or perhaps
memset(&data->reserved, 0, sizeof(data->reserved));. Urgh, pointers...

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
