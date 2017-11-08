From: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Subject: Re: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Wed, 08 Nov 2017 14:16:25 -0600
Message-ID: <20171108141625.Horde.KGzDIfS83FFw-l2cUJ_EO95@gator4166.hostgator.com>
References: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
 <20171107144517.GA25631@embeddedor.com>
 <20171107145018.GJ18825@mtr-leonro.local>
 <20171107085637.Horde.qFzN3uJQkHeQUTyEgZzV4mv@gator4166.hostgator.com>
 <20171107162804.GM18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107162804.GM18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:

> On Tue, Nov 07, 2017 at 08:56:37AM -0600, Gustavo A. R. Silva wrote:
>>
>> Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>>
>> > On Tue, Nov 07, 2017 at 08:45:17AM -0600, Gustavo A. R. Silva wrote:
>> > > Check on return value and goto label mbx_err are unnecessary.
>> > >
>> > > Addresses-Coverity-ID: 1268780
>> > > Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
>> > > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> > > ---
>> > > Changes in v2:
>> > >  Remove assignment from "int status = -ENOMEM" as suggested by Leon
>> > > Romanovsky.
>> > >
>> > >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ++----
>> > >  1 file changed, 2 insertions(+), 4 deletions(-)
>> >
>> > Please use git send-email to send patches and not reply to the  
>> conversation.
>> >
>>
>> I'm using mutt.
>> What would be the advantage of using git send-email in this case?
>
> New mail headers, so it won't appear as Reply-To and will be presented
> correctly in mutt's threaded mode.
>

Oh I actually did that on purpose.

So the preferred way to do this is to send the vN of the patch as a  
reply to the first patch?
or as a new thread?

Thanks
--
Gustavo A. R. Silva





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
