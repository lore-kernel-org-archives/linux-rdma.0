From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] RDMA/bnxt_re: Update the driver version
Date: Thu, 11 May 2017 10:52:31 +0530
Message-ID: <CA+sbYW2ObMdDOdhPL9GMe5YNk7P2MsG5q=f+Ke5e4MU6A=WV6w@mail.gmail.com>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-15-git-send-email-selvin.xavier@broadcom.com>
 <84d9a0ce-0e5c-fc50-237f-b7ad9d541324@intel.com> <20170510155430.GC1839@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510155430.GC1839-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Leon and Dennis for your comments.

The main intention of this patch is to easily map the upstream driver
to the level of supported features in the
internal code base. I understand the point you and others are
mentioning while porting to older kernels or during
the bug fixes/feature additions from other contributors. But, can we
consider it as just a number to enable vendors
to track their base branch?

If you still feel that this patch doesn't make sense, please let me
know. I will post a v2 after dropping the change.

Thanks,
Selvin

On Wed, May 10, 2017 at 9:24 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, May 10, 2017 at 11:06:31AM -0400, Dennis Dalessandro wrote:
>> On 5/10/2017 6:45 AM, Selvin Xavier wrote:
>> > Update the driver version to the scheme used in the internal
>> > development branches.
>>
>> See the feedback [1] we got from Greg KH on a similar patch.
>>
>> [1] https://patchwork.kernel.org/patch/7490321/
>
> Yeah, the things go worse when this driver ported to old kernel. This
> numbers are entirely useless.
>
>>
>> > Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> > ---
>> >  drivers/infiniband/hw/bnxt_re/bnxt_re.h | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
>> > index 30bff05..9041c23b 100644
>> > --- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
>> > +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
>> > @@ -40,7 +40,7 @@
>> >  #ifndef __BNXT_RE_H__
>> >  #define __BNXT_RE_H__
>> >  #define ROCE_DRV_MODULE_NAME               "bnxt_re"
>> > -#define ROCE_DRV_MODULE_VERSION            "1.0.0"
>> > +#define ROCE_DRV_MODULE_VERSION            "20.6.1.0u"
>> >
>> >  #define BNXT_RE_DESC       "Broadcom NetXtreme-C/E RoCE Driver"
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
