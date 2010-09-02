From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Thu, 2 Sep 2010 08:56:48 -0400
Message-ID: <AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 2, 2010 at 8:34 AM, Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> Hello,
>
> We installed 1.5.1 and are having problems getting the IB fabric
> working. ibv_devinfo shows the HCAs ports are ok and ibdiagnet report=
s
> no errors. However, ibchecknet shows that the switch ports are not
> being configured. =C2=A0We have never seen this before and are at a l=
oss as
> to where the problem might be - would someone please point us in the
> right direction to look? =C2=A0Could it be a problem with the switch
> itself? Output from ibchecknet below.
>
>
> # ibchecknet
> Error check on lid 3 (Infiniscale-IV Mellanox Technologies) port all:=
 =C2=A0FAILED
> ibwarn: [26732] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
> #warn: Lid is not configured lid 3 port 7
> #warn: SM Lid is not configured

Is there an SM running on your subnet ? If so, I think that the lack
of an SM could account for all of the issues mentioned here.

-- Hal

> Port check lid 3 port 7: =C2=A0FAILED
> # Checked Switch: nodeguid 0x0002c90200405368 with failure
> ibwarn: [26751] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
> #warn: Lid is not configured lid 3 port 10
> #warn: SM Lid is not configured
> Port check lid 3 port 10: =C2=A0FAILED
> ibwarn: [26770] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
> #warn: Lid is not configured lid 3 port 11
> #warn: SM Lid is not configured
> Port check lid 3 port 11: =C2=A0FAILED
> ibwarn: [26789] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
> #warn: Lid is not configured lid 3 port 34
> #warn: SM Lid is not configured
> Port check lid 3 port 34: =C2=A0FAILED
> ibwarn: [26808] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
> #warn: Lid is not configured lid 3 port 35
> #warn: SM Lid is not configured
> Port check lid 3 port 35: =C2=A0FAILED
>
> # Checking Ca: nodeguid 0x0030487f30760000
> ibwarn: [26832] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
>
> # Checking Ca: nodeguid 0x0030487f32b20000
> ibwarn: [26856] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
>
> # Checking Ca: nodeguid 0x0002c9030003360c
>
> # Checking Ca: nodeguid 0x0002c90300084162
> ibwarn: [26904] dump_perfcounters: PortXmitWait not indicated so
> ignore this counter
>
> # Checking Ca: nodeguid 0x0002c90300032de0
>
> ## Summary: 6 nodes checked, 0 bad nodes found
> ## =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010 ports checked, 5 bad ports fo=
und
> ## =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 ports have errors beyond thres=
hold
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
