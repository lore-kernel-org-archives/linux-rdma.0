From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Wed, 13 Jan 2010 15:11:44 -0500
Message-ID: <f0e08f231001131211y64489a51nd2621cefdb27ad25@mail.gmail.com>
References: <20090816110200.GS25501@me> <20090823120609.GG9547@me>
	 <20090826164026.8dcce4b2.weiny2@llnl.gov> <20091023234349.GK5764@me>
	 <20091220121406.GF5262@me> <20091220182809.f7e17fae.weiny2@llnl.gov>
	 <20091221073550.GB18524@me> <20091228092251.GR26940@me>
	 <f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76@mail.gmail.com>
	 <20100112093145.GF26089@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112093145.GF26089@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Tue, Jan 12, 2010 at 4:31 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Hi Hal,
>
> On 08:56 Mon 11 Jan     , Hal Rosenstock wrote:
>> >
>> > diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
>> > index 7f8a85c..42e7aee 100644
>> > --- a/tests/subnet_discover.c
>> > +++ b/tests/subnet_discover.c
>> > @@ -40,6 +40,7 @@ static struct node *node_array[32 * 1024];
>> >  static unsigned node_count = 0;
>> >  static unsigned trid_cnt = 0;
>> >  static unsigned outstanding = 0;
>> > +static unsigned max_outstanding = 8;
>>
>> Any reason why this default is different from the one which OpenSM
>> uses ? Seems to me it should be the same (or less).
>
> In my tests I found that '8' is more optimal number (the tool works
> faster and without drops) than '4' used in OpenSM.
>
> Of course it would be helpful to run this over bigger cluster than
> what I have to see that the results are consistent.

This is exactly my concern. Not only cluster size but use cases
including concurrent diag discover and SM operation where SMPs are
heavily in use.

There already have been a number of reports of dropped SMPs on this
list with the current diags and this change will only make things
worse IMO.

Also, the OpenSM default should be at least as large as the diags for this.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
