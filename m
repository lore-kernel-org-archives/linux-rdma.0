From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM: reporting traps 129, 130, 131
Date: Fri, 13 Nov 2009 09:42:12 -0500
Message-ID: <f0e08f230911130642j6640b80oda5ae32bf051c0a9@mail.gmail.com>
References: <4AF6D78E.6080600@dev.mellanox.co.il>
	 <f0e08f230911120546q5aa0ed72oc6811cbd2471bc44@mail.gmail.com>
	 <20091112154213.GH7192@me>
	 <f0e08f230911120838w2f824a4dnc6b51a68b25bbffd@mail.gmail.com>
	 <20091112203604.GS7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112203604.GS7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2009 at 3:36 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:38 Thu 12 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> We've cared for several years now (babbling port policy was introduc=
ed
>> into the master on 7/6/07) but this issue still persists. Are you
>> saying no reports for these traps until the trap rate is obeyed ?
>
> If existing trap rate filtering in OpenSM is sufficient we can add
> reporting (if somebody needs this).

Right but the key is whether it is sufficient or not and trap
reporting can be expensive so I was thinking it could be based on the
existing babbling_port_policy being off so it's not a new option but
further use of an existing one.

> I just don't think that we need to introduce temporary options.

I think we're past the point of temporary on this.

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
