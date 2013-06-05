From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: A possible solution for allowing arbitrary
 MTU values.
Date: Wed, 5 Jun 2013 18:23:50 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DD70@xmb-rcd-x01.cisco.com>
References: <1370437223-14171-1-git-send-email-jsquyres@cisco.com>
 <20130605164639.GA30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D690@xmb-rcd-x01.cisco.com>
 <20130605171916.GD30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DB61@xmb-rcd-x01.cisco.com>
 <20130605181122.GA1946@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605181122.GA1946-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <84F33736C7121B41A79F2291B38A3512-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 11:11 AM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> I won't say never, but this is what people want. Bumping the soname is
> seen as too difficult now.

Gotcha.  

Ok, so my patch is a non-starter.

>>> Thoughts:
>>> - 1024 and 3 both mean 1024, the library must accept both values,
>>>  it should only ever return 3 though.
>> 
>> Why?  If the caller can pass in 1024, it seems like 1024 should be
>> able to be passed out, too.
> 
> If the caller passes in 1024 then it is probably OK to return 1024,
> but you have to keep track of that specially. That seems more complex
> than just always returning 3. 3 is guarenteed compatible with all
> users.
> 
> Old users will test directly against 3.
> New users will call ibv_from_mtu which tests against 3 as well.


Ok.

I'll take a to-do to work up a new patch -- probably not until next week.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
