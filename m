From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Wed, 28 Jun 2017 10:49:00 -0400
Message-ID: <373E6A00-8505-468C-A974-DCDAC15A3B7B@oracle.com>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net> <20170620073236.GO17846@mtr-leonro.local> <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com> <20170620180348.GV17846@mtr-leonro.local> <C27E2410-44B7-451E-8069-DF1444048158@oracle.com> <20170620184046.GW17846@mtr-leonro.local> <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7@oracle.com> <16d52534-5564-8137-a8b3-6c66df6bb508@grimberg.me> <20170628095640.GB1248@mtr-leonro.local>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628095640.GB1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 28, 2017, at 5:56 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> On Tue, Jun 27, 2017 at 12:24:20PM +0300, Sagi Grimberg wrote:
>> 
>>>> It will be "marked" as UAPI and we won't be able to change it,
>>>> which IMHO bad for the debug. It also invites users to set it
>>>> and in perfect world, we should test our HCAs with this flag
>>>> on and off, because curious user can set it.
>>> 
>>> We have loads of legacy debugging interfaces.
>>> 
>>> And yes, ULP developers should be aware of it and test with
>>> both settings.
>>> 
>>> I'm not convinced any of this is a problem for this particular
>>> setting. However, I guess the thing for you to do is propose a
>>> patch.
>> 
>> Are you guys seriously still on this? Its simply a trivial
>> debug flag, whats all the fuss really about?
> 
> I hope that we are done.
> https://patchwork.kernel.org/patch/9808615/

Somehow this got by me.

The patch description says "exposed to regular users." The
force_mr option is not exposed to regular users. Module
parameters are visible only to system administrators.

Also, just looking at the patch, it's not obvious why "The
force_mr module parameter wasn't exposed ... from the
beginning". IMO an explanation of what has prevented
exposure is needed. Commit a060b5629ab0 got the fourth
parameter of module_param_named wrong. Maybe a Fixes:
tag is needed too.

But frankly there is no visible change from this patch.
Before the patch, force_mr is not visible, and after the
patch it is not visible. Why then is this change necessary?
It would be helpful to cite a policy about why removal is
preferred over fixing the incorrect parameter.

Therefore IMO the patch description is not adequate.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
