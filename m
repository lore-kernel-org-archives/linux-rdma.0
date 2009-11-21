From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: ib_post_send in drivers
Date: Sat, 21 Nov 2009 12:17:32 +0100
Message-ID: <e2e108260911210317t323adfe0k4aa3e821d3a1c63c@mail.gmail.com>
References: <4B06C0EA.2070501@systemfabricworks.com>
	 <e2e108260911201126o5233ea3v94163083fe3d26fc@mail.gmail.com>
	 <E102E8F5252B43318544B660CF6B78F7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E102E8F5252B43318544B660CF6B78F7-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2009 at 9:08 PM, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>>mlx4/qp.c: mlx4_ib_post_send()
>>* when passing a list containing more than one item to
>>mlx4_ib_post_send(), and sending the second or later item fails (e.g.
>>because of QP overflow), the preceding items are sent anyway. This
>>behavior makes it almost impossible to get error recovery right for
>>block device implementations that use ib_post_send() (e.g. the SRPT
>>target implementation).
>
> Yes - this is the correct behavior. =A0The bad_wr pointer should refe=
rence the WR
> that failed, with all WRs in the list passed that point being returne=
d
> unprocessed. =A0This is the reason for having the bad_wr in the call.=
 =A0Error
> recovery shouldn't be any more difficult than posting one WR at a tim=
e.
>
>>If my interpretation of the section about verbs in the InfiniBand
>>Architecture Specification is correct, either all work requests shoul=
d
>>be processed or none. A quote from section 11.4.1.1, Post Send Reques=
t
>>(page 622 in volume 1 of release 1.2.1):
>
> The IB spec does not define an API. =A0For performance reasons, you d=
on't want the
> implementation to walk through the WR list multiple times - once to c=
heck it,
> then a second time to actually post the requests to the hardware.

Thanks for the feedback. I have two further questions:
- Where can IB driver developers find detailed specifications of the
verbs API they should implement ? I learned about the details of the
behavior of the ib_post_send() call by reading the mlx4 source code.
Shouldn't this behavior be documented in include/rdma/ib_verbs.h
instead ?
- Does walking twice over the WR list always result in inferior
performance compared to walking once over this list ? Both the iSER
protocol and the SRP protocol allow to send large sg lists (e.g.
containing 128 elements) at once over the wire. When using
asynchronous (buffered) I/O, this maximum is often reached. One
interesting performance optimization is to send all 128 sg elements at
once using one ib_post_send() call and to request a completion
notification for the last WR only. But if the ib_post_send() call
returns an immediate error and has sent part of the WR list, no
completion notification will be received. So code that calls
ib_post_send() has to request a completion notification for each WR,
which has a negative performance impact. My opinion is that the
current behavior makes ib_post_send() easier to implement, while the
behavior specified in the IBAS is more interesting for applications
that use the verbs API.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
