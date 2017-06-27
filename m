From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 27 Jun 2017 12:24:20 +0300
Message-ID: <16d52534-5564-8137-a8b3-6c66df6bb508@grimberg.me>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net>
 <20170620073236.GO17846@mtr-leonro.local>
 <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com>
 <20170620180348.GV17846@mtr-leonro.local>
 <C27E2410-44B7-451E-8069-DF1444048158@oracle.com>
 <20170620184046.GW17846@mtr-leonro.local>
 <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> It will be "marked" as UAPI and we won't be able to change it,
>> which IMHO bad for the debug. It also invites users to set it
>> and in perfect world, we should test our HCAs with this flag
>> on and off, because curious user can set it.
> 
> We have loads of legacy debugging interfaces.
> 
> And yes, ULP developers should be aware of it and test with
> both settings.
> 
> I'm not convinced any of this is a problem for this particular
> setting. However, I guess the thing for you to do is propose a
> patch.

Are you guys seriously still on this? Its simply a trivial
debug flag, whats all the fuss really about?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
