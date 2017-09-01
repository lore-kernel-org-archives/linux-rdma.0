From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for
 local
Date: Fri, 1 Sep 2017 11:46:02 +0200
Message-ID: <dfa51066-0d39-5d31-c7e6-b2af1a6089a5@suse.de>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170901045632.GJ10539@mtr-leonro.local>
 <e10f536a-bad3-55b4-f3ef-207404209c89@suse.de>
 <20170901093553.GK10539@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170901093553.GK10539-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 01/09/2017 à 11:35, Leon Romanovsky a écrit :
> On Fri, Sep 01, 2017 at 09:00:01AM +0200, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 01/09/2017 à 06:56, Leon Romanovsky a écrit :
>>> On Thu, Aug 31, 2017 at 02:50:56PM -0600, Jason Gunthorpe wrote:
>>>> To avoid clashing with user variables.
>>>>
>>>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>>> ---
>>>>  util/util.h | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/util/util.h b/util/util.h
>>>> index cbf0deca2dde7b..30d32ee6b51e24 100644
>>>> --- a/util/util.h
>>>> +++ b/util/util.h
>>>> @@ -8,8 +8,8 @@
>>>>   * error */
>>>>  #define check_snprintf(buf, len, fmt, ...)                                     \
>>>>  	({                                                                     \
>>>> -		int rc = snprintf(buf, len, fmt, ##__VA_ARGS__);               \
>>>> -		(rc < len && rc >= 0);                                         \
>>>> +		int __rc__ = snprintf(buf, len, fmt, ##__VA_ARGS__);           \
>>> It can't clash, because it is declared in the scope {..} of that define and
>>> it is local to check_snprintf macro.
>> It does if any of the va-args is called rc.
>> This is "valid" C although not sure what printfs does print here (probably random stack value)
>> {
>>  int i = printf("i = %d\n", i);
>> }
> So how does this rename solve the issue?
> Now, we can clash with __rc__ variable.
>
> Thanks

There is no safe way to handle that. It can be detected with -Wshadow though.
But rc is quite a common name (39 definitions in the code base), __rc__ much less (unused... yet)


If you want some real fun, try writing macros with local variables that can be called recursively ;)

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
