From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [bug report] IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage
Date: Fri, 10 Nov 2017 23:12:09 +0100
Message-ID: <CAK8P3a124Yxt781xqh70EE3dFhSoOaHJo5o1tds-383X29CC0A@mail.gmail.com>
References: <20171002101309.dpxylk77ud5gsr2i@mwanda> <CAK8P3a1t6zyQXtfov6HguOb9V7E4i54pK8+y8BjPqGqvsc9mpQ@mail.gmail.com>
 <1510336682.3735.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510336682.3735.3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 10, 2017 at 6:58 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2017-10-02 at 13:00 +0200, Arnd Bergmann wrote:
>> On Mon, Oct 2, 2017 at 12:13 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>  static int uverbs_create_cq_handler(struct ib_device *ib_dev,
>>
> Arnd, can you send this as a proper patch with attribution and a Signed-
> off-by: please.
>

Submitted now as "infiniband: avoid uninitialized variable warning in
create_udata",
Message-Id: <20171110221053.3549147-1-arnd-r2nGTMty4D4@public.gmane.org>.

       Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
