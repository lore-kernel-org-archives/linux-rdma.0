From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible process deadlock in RMPP flow
Date: Wed, 23 Sep 2009 12:20:48 -0400
Message-ID: <f0e08f230909230920l410e3cedm58667d1f6958537b@mail.gmail.com>
References: <20090923150454.GA26150@mtls03>
	<7A32EEE20DF5432CADB60B8F8B1E0093@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0187835604=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <7A32EEE20DF5432CADB60B8F8B1E0093-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, general-list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--===============0187835604==
Content-Type: multipart/alternative; boundary=0016363b9a8a08305b04744119b3

--0016363b9a8a08305b04744119b3
Content-Type: text/plain; charset=UTF-8

On Wed, Sep 23, 2009 at 12:08 PM, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> >ibnetdiscover D ffffffff80149b8d     0 26968  26544
> >(L-TLB)
> > ffff8102c900bd88 0000000000000046 ffff81037e8e0000 ffff81037e8e02e8
> > ffff8102c900bd78 000000000000000a ffff8102c5b50820 ffff81038a929820
> > 0000011837bf6105 0000000000000ede ffff8102c5b50a08 0000000100000000
> >Call Trace:
> > [<ffffffff80064207>] wait_for_completion+0x79/0xa2
> > [<ffffffff8008b4cc>] default_wake_function+0x0/0xe
> > [<ffffffff882271d9>] :ib_mad:ib_cancel_rmpp_recvs+0x87/0xde
> > [<ffffffff88224485>] :ib_mad:ib_unregister_mad_agent+0x30d/0x424
> > [<ffffffff883983e9>] :ib_umad:ib_umad_close+0x9d/0xd6
> > [<ffffffff80012e22>] __fput+0xae/0x198
> > [<ffffffff80023de6>] filp_close+0x5c/0x64
> > [<ffffffff800393df>] put_files_struct+0x63/0xae
> > [<ffffffff80015b26>] do_exit+0x31c/0x911
> > [<ffffffff8004971a>] cpuset_exit+0x0/0x6c
> > [<ffffffff8005e116>] system_call+0x7e/0x83
> >
> >From the dump it seems that the process is waits on the call to
> >flush_workqueue() in ib_cancel_rmpp_recvs(). The package they use is
> >OFED 1.4.2.
>
> Roland just submitted a patch in this area yesterday.  I don't know if the
> patch
> would fix their issue, but it may be worth trying.  What kernel does 1.4.2
> map
> to?
>
> What RMPP messages does ibnetdiscover use?


None AFAIK.

-- Hal


>   If the program is completing
> successfully, there may be a different race with the rmpp cleanup.  I'll
> see if
> anything else stands out in that area.
>
> - Sean
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--0016363b9a8a08305b04744119b3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Wed, Sep 23, 2009 at 12:08 PM, Sean Hefty <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org">sean.hefty@intel=
.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">&gt;ibnetdiscover D ffffffff80149b8d =C2=A0 =C2=A0 0 2696=
8 =C2=A026544<br>&gt;(L-TLB)<br>&gt; ffff8102c900bd88 0000000000000046 ffff=
81037e8e0000 ffff81037e8e02e8<br>&gt; ffff8102c900bd78 000000000000000a fff=
f8102c5b50820 ffff81038a929820<br>
&gt; 0000011837bf6105 0000000000000ede ffff8102c5b50a08 0000000100000000<br=
>&gt;Call Trace:<br>&gt; [&lt;ffffffff80064207&gt;] wait_for_completion+0x7=
9/0xa2<br>&gt; [&lt;ffffffff8008b4cc&gt;] default_wake_function+0x0/0xe<br>
&gt; [&lt;ffffffff882271d9&gt;] :ib_mad:ib_cancel_rmpp_recvs+0x87/0xde<br>&=
gt; [&lt;ffffffff88224485&gt;] :ib_mad:ib_unregister_mad_agent+0x30d/0x424<=
br>&gt; [&lt;ffffffff883983e9&gt;] :ib_umad:ib_umad_close+0x9d/0xd6<br>
&gt; [&lt;ffffffff80012e22&gt;] __fput+0xae/0x198<br>&gt; [&lt;ffffffff8002=
3de6&gt;] filp_close+0x5c/0x64<br>&gt; [&lt;ffffffff800393df&gt;] put_files=
_struct+0x63/0xae<br>&gt; [&lt;ffffffff80015b26&gt;] do_exit+0x31c/0x911<br=
>
&gt; [&lt;ffffffff8004971a&gt;] cpuset_exit+0x0/0x6c<br>&gt; [&lt;ffffffff8=
005e116&gt;] system_call+0x7e/0x83<br>&gt;<br>&gt;From the dump it seems th=
at the process is waits on the call to<br>&gt;flush_workqueue() in ib_cance=
l_rmpp_recvs(). The package they use is<br>
&gt;OFED 1.4.2.<br><br></div>Roland just submitted a patch in this area yes=
terday. =C2=A0I don&#39;t know if the patch<br>would fix their issue, but i=
t may be worth trying. =C2=A0What kernel does 1.4.2 map<br>to?<br><br>What =
RMPP messages does ibnetdiscover use?</blockquote>

<div>=C2=A0</div>
<div>None AFAIK.</div>
<div>=C2=A0</div>
<div>-- Hal</div>
<div>=C2=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">=C2=A0=C2=A0If the program is co=
mpleting<br>successfully, there may be a different race with the rmpp clean=
up. =C2=A0I&#39;ll see if<br>
anything else stands out in that area.<br><br>- Sean<br><font color=3D"#888=
888"><br>--<br>To unsubscribe from this list: send the line &quot;unsubscri=
be linux-rdma&quot; in<br>the body of a message to <a href=3D"mailto:majord=
omo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a><br>
More majordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r></font></blockquote></div><br>

--0016363b9a8a08305b04744119b3--

--===============0187835604==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============0187835604==--
