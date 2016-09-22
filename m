From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Thu, 22 Sep 2016 19:55:05 +0530
Message-ID: <CANjDDBg=LLZOBD3FRJ5a==59pJRE5BTcbW5pdTjaVQrQVMFB4w@mail.gmail.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
 <1467548899-21923-2-git-send-email-leon@kernel.org> <1470162706.18081.27.camel@redhat.com>
 <CALq1K=LUb+bvx5+3JYLQw+OnhzP5MuqmuydMS8G7eS8Kvyb9Ow@mail.gmail.com>
 <20160802192647.GB20709@obsidianresearch.com> <1470192194.18081.49.camel@redhat.com>
 <20160803051832.GD27667@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160803051832.GD27667-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason et al.

I could not respond to this mail chain. I was quite busy somewhere
else and did not had any bandwidth at all to get back to this one.
Thanks for taking care of this issue. I would try to see If I could
confirm that the fix works for ocrdma.

-Regards

On Wed, Aug 3, 2016 at 10:48 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Aug 02, 2016 at 10:43:14PM -0400, Doug Ledford wrote:
>> On Tue, 2016-08-02 at 13:26 -0600, Jason Gunthorpe wrote:
>> > On Tue, Aug 02, 2016 at 09:50:14PM +0300, Leon Romanovsky wrote:
>> > >
>> > > >
>> > > > The only reason I hadn't taken this patch before is because Jason
>> > > > said
>> > > > it was totally untested and someone (Devesh in this case) needed
>> > > > to
>> > > > test it to make sure it resolved their problem.  I don't see a
>> > > > test-by
>> > > > line here, so has this happened?
>> > >
>> > > I can't say about Devesh, but we verified it as part of our
>> > > verification phase.
>> > > Do you need anything special except Yishai's SOB?
>> >
>> > I was hoping to see Devesh confirm that the race he was able to
>> > reproduce is in fact closed, unless Mellanox did the reproduction?
>> >
>> > At least your testing shows it doesn't make things worse, so it is
>> > probably OK to go ahead if Devesh does not respond soon.
>> >
>> > Jason
>>
>> I'm not sure what Devesh is off doing now a days, so I went ahead and
>> took this.  With the fact that Mellanox tested it, I'd rather have it
>> in than out.
>
> Thanks
>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
