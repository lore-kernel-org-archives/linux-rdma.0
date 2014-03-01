From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Sat, 01 Mar 2014 15:29:09 -0600
Message-ID: <53125125.9010709@opengridcomputing.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com> <53110287.9000400@talpey.com> <CABgxfbHwo13ma=-Xn+S36WwD8LVNLdw6UHztFe8EkCA_=NBenw@mail.gmail.com> <CABgxfbHg0B02c2zpYdCB4pUZZhhA4aKRuyh4Kx=NE1yAisFLLQ@mail.gmail.com> <B83B4DA6-E9CF-4DF3-9227-5EF9B4D25F4D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B83B4DA6-E9CF-4DF3-9227-5EF9B4D25F4D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

I have a patch for the server side that simplifies the memory registrat=
ion=20
and fixes a bug where the server ignores the FRMR hardware limits. This=
=20
bug is actually upstream now.

I have been sitting on it because it's a big patch and will require a l=
ot=20
of testing/review to get it upstream. This is Just an FYI in case there=
 is=20
someone on your team who has the bandwidth to take this work and finish=
 it up.

Thanks,
Tom

On 2/28/14 8:59 PM, Chuck Lever wrote:
> Hi Wendy-
>
> On Feb 28, 2014, at 5:26 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>
>> On Fri, Feb 28, 2014 at 2:20 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>> ni i...On Fri, Feb 28, 2014 at 1:41 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>>> On 2/26/2014 8:44 AM, Chuck Lever wrote:
>>>>> Hi-
>>>>>
>>>>> Shirley Ma and I are reviving work on the NFS/RDMA client code ba=
se in
>>>>> the Linux kernel.  So far we've built and run functional tests to=
 determine
>>>>> what is working and what is broken.
>>>>>
>>>>> [snip]
>>>
>>>>> ALLPHYSICAL - Usually fast, but not safe as it exposes client mem=
ory.
>>>>> All HCAs support this mode.
>>>>
>>>> Not safe is an understatement. It exposes all of client physical
>>>> memory to the peer, for both read and write. A simple pointer erro=
r
>>>> on the server will silently corrupt the client. This mode was
>>>> intended only for testing, and in experimental deployments.
>> (sorry, resend .. previous reply bounced back due to gmail html form=
at)
>>
>> Please keep "ALLPHYSICAL" for now  - as our embedded system needs it=
=2E
> This is just the client side.  Confirming that you still need support=
 for the ALLPHYSICAL memory registration mode in the NFS/RDMA client.
>
> Do you have plans to move to a mode that is less risky?  If not, can =
we depend on you to perform regular testing with ALLPHYSICAL as we upda=
te the client code?  Do you have any bug fixes you=92d like to merge up=
stream?
>
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
