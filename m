From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
	revert setting of init failure on QoS initialization failures
Date: Mon, 28 Dec 2009 11:08:56 -0500
Message-ID: <f0e08f230912280808s31c09d46ndeb3586007507e40@mail.gmail.com>
References: <20091224112036.GA32559@comcast.net> <20091224125601.GK26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091224125601.GK26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org, celine.bourde-6ktuUTfB/bM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2009 at 7:56 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Hal,
>
> On 06:20 Thu 24 Dec =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> There are unexplained cases of status 0x1c that have been observed
>> for SL to VL mapping table setting as documented in "Re: qos on serv=
ice-id"
>> http://article.gmane.org/gmane.linux.drivers.rdma/1464
>>
>> A subsequent patch will reintroduce this checking based on an additi=
onal
>> option which will default to not do this.
>
> I think that addition of such sort of options (eg "--workaround-bugX"=
)
> should be avoided unless it is absolutely necessary.

I was thinking something like --qos-init-error with a description.

> And even then more generic stuff would be better.
>
> In this specific case more generic option like:
> '--resweep-on-failed-attr=3D11,15' (with reasonable default) will be =
more
> useful for dealing with this and maybe another potential issues.

Where else do you see this as being useful ?

Is such flexibility really needed or is this more "just in case" ?

-- Hal

>
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
