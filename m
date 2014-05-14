From: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 RFC 2/3] svcrdma: Recvfrom changes
Date: Wed, 14 May 2014 10:39:47 -0400
Message-ID: <2AEECADA-4A40-4BF2-866E-7F178D016DDE@gmail.com>
References: <20140506174621.18208.24242.stgit@build.ogc.int> <20140506174632.18208.28160.stgit@build.ogc.int> <F997E138-FB04-4149-811D-CE68608E8D6B@gmail.com> <00f901cf6eeb$2ff1f630$8fd5e290$@opengridcomputing.com> <3DAF95F3-22D5-4FC5-8C98-5A440E54DC2F@gmail.com> <53737D15.6020902@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53737D15.6020902-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 14, 2014, at 10:26 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

> On 5/13/2014 4:44 PM, Chuck Lever wrote:
>>=20
>>> I'm not sure what "segment count=94 you are talking about?
>> AFAICT a chunk is a list of segments. Thus one chunk can reference
>> many pages, one per segment.
>=20
> Ok yes.  rdma_read_chunk_frmr()/rdma_read_chunk_lcl() walk the segmen=
ts creating rdma read work requests to pull the data for this chunk.
>=20
>> If you print ch_count, it is 2 for NFS WRITEs from a Linux client,
>> no matter how large the write payload is. Therefore I think the chec=
k
>> as it is written is not particularly useful.
>=20
> Why are there 2?

The first chunk lists the pages the server is to read, and the second
chunk has the zero pad for XDR alignment.

If pad optimization is enabled on the client, there is just 1 chunk in
the RPC=92s Read list.

>=20
>> The returned ch_count here is not used beyond that check, after the
>> refactoring patch is applied. The returned byte_count includes all
>> chunks in the passed-in chunk list, whereas I think it should count
>> only the first chunk in the list.
>=20
> So I'll investigate this more with the goal of only grabbing the firs=
t chunk.

[ . . . snipped . . . ]

>>>>=20
>>>> What I'm asking is:
>>>>=20
>>>> Do you agree the server should be changed to comply with section 4=
 of 5667?
>>>>=20
>>> I think it is complying and you are misinterpreting.  But I could b=
e misinterpreting it
>>> too :)
>>>=20
>>> But we should fix the pad thing.
>> That may be enough to support a client that does not send the
>> pad bytes in a separate chunk. However, I wonder how such a
>> server would behave with the current client.
>>=20
>> True, this isn=92t a regression, per se. The server is already
>> behaving incorrectly without the refactoring patch.
>>=20
>> However, Tom=92s refactoring rewrites all this logic anyway, and
>> it wouldn=92t be much of a stretch to make the server comply with
>> RFC 5667, at this point.
>=20
> Can we defer this until the refactor patch is in, then I'll work on a=
 new patch for the pad stuff.

Yes, we can defer it.

A bug has been filed to track this issue:

 https://bugzilla.linux-nfs.org/show_bug.cgi?id=3D246

--
Chuck Lever
chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
