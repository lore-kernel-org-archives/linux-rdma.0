From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Tue, 20 Oct 2015 18:00:18 +0300
Message-ID: <56265702.1030209@dev.mellanox.co.il>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
 <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de>
 <56262CF9.1040509@dev.mellanox.co.il>
 <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
 <56263CE6.5010005@dev.mellanox.co.il>
 <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/20/2015 5:08 PM, Or Gerlitz wrote:
> On Tue, Oct 20, 2015 at 4:08 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>> I think this is very useful to have and I'd love having it in 4.4,
>>>> does anyone have any other comments on this patch?
>
>>> Were we ever presented with performance gains achieved using the patch?
>
>> Can you explain what you mean by performance gains? My understanding is
>> that this patch is not performance critical. It just replaces each and
>> every ULP device attributes caching.
>
> oops, sorry, I was referring to the patch that deals with
> re-structuring of struct ib_wc, so...
>
> (1) did we even got performance gains achieved using **that** patch?

I don't know if we'd see noticeable performance gains from **that**
patch either.. The benefit is mostly stack relief as usually ULPs keep
the work request structure on the stack.

>
> (2) re this one, as I wrote in the past, I am in favor of simple
> caching of struct
> ib_device_attr on struct ib_device (best with pointer) and not adding
> 333 fields
> to struct ib_device, I don't see the benefit from this patch.
>

Christoph commented on that:

"I'm strongly against this.  As the reviews show the move is highly
confusing.  The attributes don't change and there is no need to 'cache'
or 'query' them.  Just merge them into the device, follow years of
experience with how every other Linux subsystem does it and be done
with it."

If the attributes are automatically a part of the ib_device then it
does seem a bit redundant keeping the structure around...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
