From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/7] IB/core: Refactor idr to be per uverbs_file
Date: Wed, 15 Feb 2017 15:41:04 +0200
Message-ID: <CAAKD3BDZr7PNiszRyn7=XW+M5_j=RkirSqYy5mpjbVt9g2G-6Q@mail.gmail.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-2-git-send-email-matanb@mellanox.com> <20170210175320.GA4335@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210175320.GA4335-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 10, 2017 at 7:53 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Feb 01, 2017 at 02:38:59PM +0200, Matan Barak wrote:
>>  static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
>>  {
>> -     return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
>> +     return idr_read_obj(pd_handle, context, 0);
>>  }
>
> As a note: At this point in the series we loose the type checking on
> the IDR handles. Eg at this moment idr_read_obj() could return
> something that is not a PD and resulting ugliness..
>
> Since that is ultimately fixed as we go through the series I'm not
> sure it is worth addressing.
>

Agreed

>>
>>       ucontext->device = ib_dev;
>> +     /* ufile is required when some objects are released */
>> +     ucontext->ufile = file;
>
> Hurm. This reads weirdly, but it is OK..
>
> Overall this is starting to really look weird. ucontext has a pointer
> to ufile and ufile has a pointer to ucontext. That tells me they
> should be in the same allocation. To make this saner you'd have to
> embed ib_ucontext into ib_uverbs_file and use a ->priv for the driver
> data instead of sticking at the end of the ib_ucontext allocation.
>
> Probably too big for this patch series but keep it in mind...
>

Yeah, that could come as a later cleanup.

> Otherwise the patch, in context, seems fine to me..
>

May I add your Reviewed-by to later submissions of this patch?

> Jason

Thanks for reviewing.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
