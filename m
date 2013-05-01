From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Use autoreconf in autogen.sh
Date: Wed, 01 May 2013 11:30:09 -0400
Message-ID: <51813501.8060106@redhat.com>
References: <1366652516-9547-1-git-send-email-jsquyres@cisco.com> <EF66BBEB19BADC41AC8CCF5F684F07FC44050FB1@xmb-rcd-x01.cisco.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4B1CD802@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4B1CD802-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/30/2013 10:29 AM, Jeff Squyres (jsquyres) wrote:
> Bump bump.  :-)

This is fine with me, however, I think you also need to bump the
autotools version to the latest upstream.  The automated checkers in our
build environment is spitting out errors about a number of upstream
packages where the autotools used to configure the package does not
include proper arm support.  The latest autotools bring in all of the
forthcoming arm variants.  So I would like to see both of these things done.

> On Apr 25, 2013, at 11:38 AM, Jeff Squyres (jsquyres) <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Bump.
>>
>> On Apr 22, 2013, at 1:41 PM, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> The old sequence of Autotools commands listed in autogen.sh is no
>>> longer correct.  Instead, just use the single "autoreconf" command,
>>> which will invoke all the Right Autotools commands in the correct
>>> order.
>>>
>>> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>>> ---
>>> autogen.sh | 6 +-----
>>> 1 file changed, 1 insertion(+), 5 deletions(-)
>>>
>>> diff --git a/autogen.sh b/autogen.sh
>>> index fd47839..6c9233e 100755
>>> --- a/autogen.sh
>>> +++ b/autogen.sh
>>> @@ -1,8 +1,4 @@
>>> #! /bin/sh
>>>
>>> set -x
>>> -aclocal -I config
>>> -libtoolize --force --copy
>>> -autoheader
>>> -automake --foreign --add-missing --copy
>>> -autoconf
>>> +autoreconf -ifv -I config
>>> -- 
>>> 1.8.1.1
>>>
>>
>>
>> -- 
>> Jeff Squyres
>> jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
>> For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
