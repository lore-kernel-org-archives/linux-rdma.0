From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Sat, 16 Jan 2010 21:36:03 +0200
Message-ID: <20100116193603.GX574@me>
References: <20090823120609.GG9547@me>
 <20090826164026.8dcce4b2.weiny2@llnl.gov>
 <20091023234349.GK5764@me>
 <20091220121406.GF5262@me>
 <20091220182809.f7e17fae.weiny2@llnl.gov>
 <20091221073550.GB18524@me>
 <20091228092251.GR26940@me>
 <f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76@mail.gmail.com>
 <20100112093145.GF26089@me>
 <f0e08f231001131211y64489a51nd2621cefdb27ad25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001131211y64489a51nd2621cefdb27ad25-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:11 Wed 13 Jan     , Hal Rosenstock wrote:
> >
> > In my tests I found that '8' is more optimal number (the tool works
> > faster and without drops) than '4' used in OpenSM.
> >
> > Of course it would be helpful to run this over bigger cluster than
> > what I have to see that the results are consistent.
> 
> This is exactly my concern. Not only cluster size but use cases
> including concurrent diag discover and SM operation where SMPs are
> heavily in use.

Was it investigated? What was a conclusions?

> There already have been a number of reports of dropped SMPs on this
> list with the current diags and this change will only make things
> worse IMO.
>
> Also, the OpenSM default should be at least as large as the diags for this.

I don't know where concurrent MADs are used in the current "diags", do
you?

This utility is not 'diags' at all. It is placed in ibsim/tests and I
wrote it for test purpose.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
