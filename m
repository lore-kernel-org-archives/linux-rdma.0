From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state for multicast
Date: Mon, 2 May 2016 10:26:27 +0300
Message-ID: <CAAk-MO8Zo2cHo8hiyYdbiSoRG2tgdxcSZPhCDWRUm6KrHCE8EQ@mail.gmail.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
	<1461070287-13469-4-git-send-email-erezsh@mellanox.com>
	<alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
	<1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB045BD0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 26, 2016 at 11:57 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > +* There are 4 types of join states:
>> > +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
>> > +*/
>> > +enum {
>> > +   FULLMEMBER_JOIN,
>> > +   NONMEMBER_JOIN,
>> > +   SENDONLY_NONMEBER_JOIN,
>> > +   SENDONLY_FULLMEMBER_JOIN,
>> > +   NUM_JOIN_MEMBERSHIP_TYPES = 4
>
> These seem better suited as flags -- fullmember (y/n), sendonly (y/n)

The ib_core tracks over the number of members for each join types, in
order not to double join from specific port to specific join type.
It keeps the numbers of members in special array, entry for each join type.
So, the meaning of the enum is to define the size of the that array
and not to define a bit mask.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
