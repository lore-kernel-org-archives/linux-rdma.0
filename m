From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/libmlx4] Fix generation of IBV_WC_GRH
Date: Tue, 8 Mar 2011 23:51:59 -0800
Message-ID: <AANLkTikBZa8Jz--oUrL0jsjKygSbYbVbNZdfPLzN5m37@mail.gmail.com>
References: <20110305024546.GA29147@obsidianresearch.com> <AANLkTimu6dGc1NcsgP60iPqNmzGR+cmtwGHjsU_c=LWz@mail.gmail.com>
 <4D7730C4.2000109@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D7730C4.2000109-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 8, 2011 at 11:48 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> I see now that the below commit of yours dropped the ntohl around the=
 GRH
> flag setting which was added by jack in commit
> b2b26f8a73108f971ade988fac3eb9d0446bbbb6

I think the changelog, which you quoted, explains what is going
on with the byte-swapping perfectly:

>> commit e6a3ccdffb36f94ee72b2bc97944a50777ff72e0
>> Author: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>> Date: =A0 Thu Jan 3 19:59:05 2008 -0800
>>
>> =A0 =A0Micro-optimize mlx4_poll_one()
>>
>> =A0 =A0Rather than byte-swapping cqe->g_mlpath_rqpn each time we ext=
ract a
>> =A0 =A0field from it, byte-swap it once into a temporary variable. =A0=
This
>> =A0 =A0results in smaller, better code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
