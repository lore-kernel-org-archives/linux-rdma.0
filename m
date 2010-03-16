From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ipoib: Fix lockup of the tx queue
Date: Tue, 16 Mar 2010 09:27:47 -0700
Message-ID: <a72123c41003160927g580dcfdfof99cc7bd5322b247@mail.gmail.com>
References: <20100303122752.GA29784@mtldesk030.lab.mtl.com>
	 <adaiq92czdt.fsf@roland-alpha.cisco.com>
	 <20100314065238.GA23263@mtldesk030.lab.mtl.com>
	 <a72123c41003150925t173815e6lc1e94c999be45357@mail.gmail.com>
	 <20100316063323.GA1887@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100316063323.GA1887-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 15, 2010 at 11:33 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:
> On Mon, Mar 15, 2010 at 08:25:51AM -0800, Josh England wrote:
>> Everything has MT264328 ConnectX cards using the mlx4_ib driver.
>> Boot/file servers are using an HP OEM 2.7.000 firmware. =A0Compute n=
odes
>> have cards using Sun OEM 2.6.200 FW.
>>
>
> You probably mean MT26428?

Yeah...threw an extra digit in there...

> Anyway, do you still see the post send
> failed messages? If you do, could you apply this patch so we'll have
> better insight as for the reason?
> http://patchwork.kernel.org/patch/83593/

I'll throw the patch in and try to get some datagram-mode testing in
soon.  I haven't gone back since the CM code fix.

-JE
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
