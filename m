From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Thu, 25 Nov 2010 09:13:30 +0200
Message-ID: <AANLkTinN43YgQW3ftbng-4f2NiNe9_oXPVCX5LPzh7uG@mail.gmail.com>
References: <20101115140829.GA20355@mtldesk30>
	<ada62vxl046.fsf@cisco.com>
	<20101116180732.GB29132@mtldesk30>
	<ada1v6klwil.fsf@cisco.com>
	<20101117090134.GA20369@mtldesk30>
	<adasjyzkfyw.fsf@cisco.com>
	<20101118065142.GB20369@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101118065142.GB20369@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 18, 2010 at 8:51 AM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wro=
te:
> On Wed, Nov 17, 2010 at 09:38:47AM -0800, Roland Dreier wrote:
>> =C2=A0> > Where is the change in handling in the members_count field=
? =C2=A0In the firmware?
>> =C2=A0> >
>> =C2=A0> The firmware now distinguishes between differnet multicast a=
ddresses
>> =C2=A0> according to a protocol field located in the high MS byte wh=
ich
>> =C2=A0> previously was reserved. The patches that Alekseys will will=
 probably
>> =C2=A0> send later make use of this.
>>
>> OK, so what you seem to be saying is that this patch is not fixing
>> anything until we add Alekseys patches?
>>
> It only keeps the code and the PRM in sync.
> --

RAW_ETH patches cannot be applied without it, so we really need this ma=
sking.
In addition, Yevgeny's mlx SRIOV patches
(http://marc.info/?l=3Dlinux-rdma&m=3D127619666403521&w=3D2 ),
also using this field - there are changes in find_mgm function.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
