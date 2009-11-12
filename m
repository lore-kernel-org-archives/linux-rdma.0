From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM: reporting traps 129, 130, 131
Date: Thu, 12 Nov 2009 08:46:32 -0500
Message-ID: <f0e08f230911120546q5aa0ed72oc6811cbd2471bc44@mail.gmail.com>
References: <4AF6D78E.6080600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF6D78E.6080600-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 8, 2009 at 9:37 AM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Hi Sasha,
>
> I noticed that OpenSM doesn't send InformInfo on traps 129/130/131.
> This is what osm_trap_rcv.c is doing:
>
> 322: static void trap_rcv_process_request(IN osm_sm_t * sm,
> 323: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const osm_madw_t * p_m=
adw)
> ...
> 435: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ib_notice_is_generi=
c(p_ntci) &&
> 436: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(p_ntci->=
g_or_v.generic.trap_num =3D=3D CL_HTON16(129) ||
> 437: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_ntci->=
g_or_v.generic.trap_num =3D=3D CL_HTON16(130) ||
> 438: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_ntci->=
g_or_v.generic.trap_num =3D=3D CL_HTON16(131))) {
> 439: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/* If this is a trap 129, 130, or 131 - then this is
> a
> 440: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * trap signaling a change on a physical port.
> 441: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * Mark the physp_change_trap flag as TRUE.
> 442: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 */
> 443: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0physp_change_trap =3D TRUE;
> ...
>
> 539: =C2=A0 =C2=A0/* If we reached here due to trap 129/130/131 - do =
not need to do
> 540: =C2=A0 =C2=A0 =C2=A0 the notice report. Just goto exit. We know =
this is the case
> 541: =C2=A0 =C2=A0 =C2=A0 if physp_change_trap is TRUE. */
> 542: =C2=A0 =C2=A0if (physp_change_trap =3D=3D TRUE)
> 543: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto Exit;
>
>
> Any particular reason why there's no reporting of these traps?

AFAIK it's been this way for at least the last 5 or 6 years.

A practical consideration in changing this is that these traps are the
ones for which babbling port was implemented since they do not obey
the trap rate so there's a large downside to adding the reports for
these. If that is to be done, then perhaps this should be done based
on some option.

-- Hal

>
> -- Yevgeny
>
>
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
