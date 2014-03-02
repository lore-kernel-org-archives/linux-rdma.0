From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Sun, 2 Mar 2014 17:28:57 -0500
Message-ID: <58CE3CFB-287B-4A59-82B8-6A0640101379@oracle.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com> <53110287.9000400@talpey.com> <CABgxfbHwo13ma=-Xn+S36WwD8LVNLdw6UHztFe8EkCA_=NBenw@mail.gmail.com> <CABgxfbHg0B02c2zpYdCB4pUZZhhA4aKRuyh4Kx=NE1yAisFLLQ@mail.gmail.com> <B83B4DA6-E9CF-4DF3-9227-5EF9B4D25F4D@oracle.com> <53125125.9010709@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53125125.9010709-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mar 1, 2014, at 4:29 PM, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrot=
e:

> Hi Chuck,
>=20
> I have a patch for the server side that simplifies the memory registr=
ation and fixes a bug where the server ignores the FRMR hardware limits=
=2E This bug is actually upstream now.
>=20
> I have been sitting on it because it's a big patch and will require a=
 lot of testing/review to get it upstream. This is Just an FYI in case =
there is someone on your team who has the bandwidth to take this work a=
nd finish it up.

Why not post what you have, and then we can see what can be done.


>=20
> Thanks,
> Tom
>=20
> On 2/28/14 8:59 PM, Chuck Lever wrote:
>> Hi Wendy-
>>=20
>> On Feb 28, 2014, at 5:26 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>=20
>>> On Fri, Feb 28, 2014 at 2:20 PM, Wendy Cheng <s.wendy.cheng@gmail.c=
om> wrote:
>>>> ni i...On Fri, Feb 28, 2014 at 1:41 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org=
> wrote:
>>>>> On 2/26/2014 8:44 AM, Chuck Lever wrote:
>>>>>> Hi-
>>>>>>=20
>>>>>> Shirley Ma and I are reviving work on the NFS/RDMA client code b=
ase in
>>>>>> the Linux kernel.  So far we've built and run functional tests t=
o determine
>>>>>> what is working and what is broken.
>>>>>>=20
>>>>>> [snip]
>>>>=20
>>>>>> ALLPHYSICAL - Usually fast, but not safe as it exposes client me=
mory.
>>>>>> All HCAs support this mode.
>>>>>=20
>>>>> Not safe is an understatement. It exposes all of client physical
>>>>> memory to the peer, for both read and write. A simple pointer err=
or
>>>>> on the server will silently corrupt the client. This mode was
>>>>> intended only for testing, and in experimental deployments.
>>> (sorry, resend .. previous reply bounced back due to gmail html for=
mat)
>>>=20
>>> Please keep "ALLPHYSICAL" for now  - as our embedded system needs i=
t.
>> This is just the client side.  Confirming that you still need suppor=
t for the ALLPHYSICAL memory registration mode in the NFS/RDMA client.
>>=20
>> Do you have plans to move to a mode that is less risky?  If not, can=
 we depend on you to perform regular testing with ALLPHYSICAL as we upd=
ate the client code?  Do you have any bug fixes you=92d like to merge u=
pstream?
>>=20
>> --
>> Chuck Lever
>> chuck[dot]lever[at]oracle[dot]com
>>=20
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
