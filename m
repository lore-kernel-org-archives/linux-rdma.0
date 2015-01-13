From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 05/10] svcrdma: Find rmsgp more reliably
Date: Tue, 13 Jan 2015 12:07:07 +0200
Message-ID: <54B4EE4B.9050500@dev.mellanox.co.il>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192237.4901.92644.stgit@klimt.1015granger.net> <54B2B4E0.5060901@dev.mellanox.co.il> <3C09A798-2BA9-46A1-AA60-122C2274974C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3C09A798-2BA9-46A1-AA60-122C2274974C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2015 2:30 AM, Chuck Lever wrote:
> Hi Sagi-
>
> Thanks for the review.
>
> On Jan 11, 2015, at 12:37 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>
>> On 1/9/2015 9:22 PM, Chuck Lever wrote:
>>> xdr_start() can return the wrong rmsgp address if an assumption
>>> about how the xdr_buf was constructed changes.  When it gets it
>>> wrong, the client receives a reply that has gibberish in the
>>> RPC/RDMA header, preventing it from matching a waiting RPC request.
>>>
>>> Instead, make (and document) just one assumption: that the RDMA
>>> header for the client's RPC call is at the start of the first page
>>> in rq_pages.
>>
>> Would it make more sense to add another pointer assigned at req
>> initialization (maybe in the RDMA request context) instead of hard
>> coding this assumption? I may be completely wrong here though...
>
> I considered this. I couldn=92t find an appropriate place to add
> such a pointer.
>
> I think that=92s why xdr_start() was there in the first place: there
> is no convenient place to save a pointer to the request=92s RDMA
> header.
>
> Bruce might have other thoughts about this.

Yep, I didn't find any nice place to put that also, thought you might
have an idea...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
