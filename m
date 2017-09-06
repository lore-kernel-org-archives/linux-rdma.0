From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] [RESEND] IB/uverbs: fix gcc-7 type warning
Date: Wed, 6 Sep 2017 22:43:47 +0200
Message-ID: <CAK8P3a2GjtSX2WLf93Rn8rhEG_UVoeCsRr9WLjQzR=Ykh88-gQ@mail.gmail.com>
References: <20170906134558.3279199-1-arnd@arndb.de> <20170906135812.GA1213@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906135812.GA1213-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 6, 2017 at 3:58 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Wed, Sep 06, 2017 at 03:45:31PM +0200, Arnd Bergmann wrote:
>> We get a harmless warning about the fact that we use the result of a
>> multiplication as a condition:
>
> Please just turn the thing into a function while you're at it.
> I'm not even sure it needs to be inline..

Ok, the patch gets quite big once I also modify INIT_UDATA the same way,
but it seems like a good cleanup anyway. INIT_UDATA (renamed to
ib_uverbs_init_udata()) should definitely remain inline, so I'm leaving
both that way.

        Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
