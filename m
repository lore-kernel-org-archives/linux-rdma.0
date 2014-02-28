From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Fri, 28 Feb 2014 14:26:37 -0800
Message-ID: <CABgxfbHg0B02c2zpYdCB4pUZZhhA4aKRuyh4Kx=NE1yAisFLLQ@mail.gmail.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
	<53110287.9000400@talpey.com>
	<CABgxfbHwo13ma=-Xn+S36WwD8LVNLdw6UHztFe8EkCA_=NBenw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbHwo13ma=-Xn+S36WwD8LVNLdw6UHztFe8EkCA_=NBenw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 28, 2014 at 2:20 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> ni i...On Fri, Feb 28, 2014 at 1:41 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On 2/26/2014 8:44 AM, Chuck Lever wrote:
>>>
>>> Hi-
>>>
>>> Shirley Ma and I are reviving work on the NFS/RDMA client code base in
>>> the Linux kernel.  So far we've built and run functional tests to determine
>>> what is working and what is broken.
>>>
>>> [snip]
>
>
>>>
>>> ALLPHYSICAL - Usually fast, but not safe as it exposes client memory.
>>> All HCAs support this mode.
>>
>>
>> Not safe is an understatement. It exposes all of client physical
>> memory to the peer, for both read and write. A simple pointer error
>> on the server will silently corrupt the client. This mode was
>> intended only for testing, and in experimental deployments.

(sorry, resend .. previous reply bounced back due to gmail html format)

Please keep "ALLPHYSICAL" for now  - as our embedded system needs it.

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
