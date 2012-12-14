From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/srp: Avoid endless SCSI error handling loop
Date: Fri, 14 Dec 2012 17:30:42 +0100
Message-ID: <50CB5432.8040204@acm.org>
References: <50CB46A4.4050300@acm.org> <50CB47E7.2060308@acm.org>  <1355500552.18309.11.camel@frustration.ornl.gov> <50CB4FEB.3080104@acm.org> <1355501996.18309.16.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355501996.18309.16.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/14/12 17:19, David Dillow wrote:
> On Fri, 2012-12-14 at 17:12 +0100, Bart Van Assche wrote:
>> On 12/14/12 16:55, David Dillow wrote:
>>> This is much more than your original patch that Alex claimed fixed his
>>> issues; are you not merging two separate issues?
>>   >
>>> Also, there's no reason to invoke srp_send_tsk_mgmt() if we're not
>>> connected or the QP is in error -- for those cases, it makes sense to
>>> just abort the command directly. Similarly, we should probably be
>>> checking the status of srp_send_tsk_mgmt() and failing -- or checking
>>> qp_in_error/connected again and directly aborting if we have problems.
>>
>> Thanks for the quick reply. You might have missed Vu's message though.
>> Vu Pham reported that v1 of this patch did not fix the endless error
>> handling loop (see e.g.
>> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg13713.html).
>
> I saw that, but I also saw your message asking if he was sure he was
> running with your patch, and I never saw a public reply to clarify.
>
> I saw a message from him yesterday that running your fixes branch did
> work, but with no posting of updated patches I assumed that was v1 still
> -- was he testing v2?

Hello Dave,

There has been some off-list communication too in which Vu explained me 
that v1 was not sufficient but that v2 did help.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
