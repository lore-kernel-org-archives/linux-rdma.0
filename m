From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 3/7] IB/core: Add idr based standard types
Date: Wed, 29 Mar 2017 21:09:52 +0300
Message-ID: <CAAKD3BAtakm+J6fTeeB8D9KTvj__m1XYc_FVX5W0Kg7AZ2-mYA@mail.gmail.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-4-git-send-email-matanb@mellanox.com> <20170329142853.GA2586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329142853.GA2586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 29, 2017 at 5:28 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Mar 19, 2017 at 05:59:01PM +0200, Matan Barak wrote:
>
>> +int ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
>> +                        struct ib_xrcd *xrcd,
>> +                        enum rdma_remove_reason why)
>>  {
>>       struct inode *inode;
>> +     int ret;
>>
>>       inode = xrcd->inode;
>>       if (inode && !atomic_dec_and_test(&xrcd->usecnt))
>> -             return;
>> +             return 0;
>>
>> -     ib_dealloc_xrcd(xrcd);
>> +     ret = ib_dealloc_xrcd(xrcd);
>>
>> -     if (inode)
>> +     if (why == RDMA_REMOVE_DESTROY && ret)
>> +             atomic_inc(&xrcd->usecnt);
>
> Is this suposed to be _inc? Might need a comment since every other
> dealloc has a dec?
>

Yeah, it should be an _inc as if ib_dealloc_xrcd fails, we should restore the
object's reference count. I agree that the right approach is to
encompass that in
ib_dealloc_xrcd, but this shouldn't be part of this patch-set.

> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
