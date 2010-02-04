From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Thu, 4 Feb 2010 09:19:39 -0500
Message-ID: <f0e08f231002040619y34784bauec6a25d31e7d229b@mail.gmail.com>
References: <20100202164514.bf2b152a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100202164514.bf2b152a.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 2, 2010 at 7:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> Sasha,
>
> Following up on our thread regarding having multiple outstanding SMP'=
s in libibnetdisc.
>
> These 2 patches implement that as well as add a function to set the m=
ax outstanding the lib will use.
>
> I left the default here to be 4. =C2=A0On a large cluster there seems=
 to be some variance with using 8 or 12. =C2=A0Sometimes I get a speed =
up over 4 and other times I don't see any. =C2=A0I think it has to do w=
ith the traffic on the fabric at any particular time.
>
> For example here are some runs I just did on Hyperion.
>
> 14:31:55 > /usr/sbin/ibqueryerrors =C2=A0-s RcvErrors,SymbolErrors,Rc=
vSwRelayErrors,XmtWait -r --data
> Suppressing: RcvErrors SymbolErrors RcvSwRelayErrors XmtWait
> Errors for 0x66a00d90006fb "SW19"
> =C2=A0 GUID 0x66a00d90006fb port 9: [VL15Dropped =3D=3D 3] [XmtData =3D=
=3D 14562048] [RcvData =3D=3D 14563872] [XmtPkts =3D=3D 202255] [RcvPkt=
s =3D=3D 202276]
> =C2=A0 =C2=A0 =C2=A0 Link info: =C2=A0 =C2=A0139 =C2=A0 9[ =C2=A0] =3D=
=3D( 4X 5.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A00x0002c9030001d736 =
=C2=A0 =C2=A0864 =C2=A0 =C2=A01[ =C2=A0] "hyperion1" ( )
>
> 14:32:02 > time ./ibnetdiscover -o 8 --node-name-map /etc/opensm/ib-n=
ode-name-map -g > new
>
> real =C2=A0 =C2=A00m2.210s
> user =C2=A0 =C2=A00m1.251s
> sys =C2=A0 =C2=A0 0m0.869s
>
> 14:40:36 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm/ib-n=
ode-name-map -g > new
>
> real =C2=A0 =C2=A00m3.385s
> user =C2=A0 =C2=A00m1.888s
> sys =C2=A0 =C2=A0 0m1.448s
>
> 14:40:46 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm/ib-n=
ode-name-map -g > new
>
> real =C2=A0 =C2=A00m2.211s
> user =C2=A0 =C2=A00m1.165s
> sys =C2=A0 =C2=A0 0m0.951s
>
> 14:40:51 > time ./ibnetdiscover -o 8 --node-name-map /etc/opensm/ib-n=
ode-name-map -g > new
>
> real =C2=A0 =C2=A00m2.249s
> user =C2=A0 =C2=A00m1.244s
> sys =C2=A0 =C2=A0 0m0.936s
>
> 14:40:59 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm/ib-n=
ode-name-map -g > new
>
> real =C2=A0 =C2=A00m2.170s
> user =C2=A0 =C2=A00m1.160s
> sys =C2=A0 =C2=A0 0m0.933s
>
> 14:41:10 > /usr/sbin/ibqueryerrors =C2=A0-s RcvErrors,SymbolErrors,Rc=
vSwRelayErrors,XmtWait -r --data
> Suppressing: RcvErrors SymbolErrors RcvSwRelayErrors XmtWait
> Errors for 0x66a00d90006fb "SW19"
> =C2=A0 GUID 0x66a00d90006fb port 9: [VL15Dropped =3D=3D 3] [XmtData =3D=
=3D 25187379] [RcvData =3D=3D 25196688] [XmtPkts =3D=3D 349861] [RcvPkt=
s =3D=3D 349954]
> =C2=A0 =C2=A0 =C2=A0 Link info: =C2=A0 =C2=A0139 =C2=A0 9[ =C2=A0] =3D=
=3D( 4X 5.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A00x0002c9030001d736 =
=C2=A0 =C2=A0864 =C2=A0 =C2=A01[ =C2=A0] "hyperion1" ( )
>
> Note that there were no additional VL15Dropped packets on the fabric.=
 =C2=A0I think 4 seems to be a good compromise. =C2=A0I have not tested=
 when there are errors on the fabric. =C2=A0(Right now things seem to b=
e good!)

Is this just with the SM doing light sweeping ?

Is there a speedup with 4 rather than 2 ?

-- Hal

>
> The first patch converts the algorithm and the second adds the ibnd_s=
et_max_smps_on_wire call.
>
> Let me know what you think. =C2=A0Because the algorithm changed so mu=
ch testing this is a bit difficult because the order of the node discov=
ery is different. =C2=A0However, I have done some extensive diffing of =
the output of ibnetdiscover and things look good.
>
> Ira
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
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
