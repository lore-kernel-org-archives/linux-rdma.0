From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re:
	=?windows-1252?q?=5BRFC=5D_=96_Proposal_for_new_process_for?=
	=?windows-1252?q?_OFED_releases?=
Date: Fri, 23 Dec 2011 10:40:46 +0000
Message-ID: <CAO+b5-q1hEr+b2j3e7_oGpZZDP_6_vptKF_B5Ec+tNza=MBiWQ@mail.gmail.com>
References: <AcywYuukNsUYemDYTNKYAFgsoWs2mw==>
	<CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1539815206=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--===============1539815206==
Content-Type: multipart/alternative; boundary=00504502cec0b75cb904b4c00c8d

--00504502cec0b75cb904b4c00c8d
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 1, 2011 at 7:53 PM, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>wrote:

>
> We propose a new process for the OFED releases starting from next OFED
> release:
> - OFED content will be the relevant kernel.org modules and user space
> released packages
> - OFED will offer only backports to the distros  (no fixes)
> - OFED package will be used for easy installation of all packages in a
> friendly manner
>
> The main goals of this change:
> 1. Ensure OFED and the upstream kernel are the same
> 2. Provide customers a way to use the new features in latest kernels on
> existing distros
> 3. OFED qualification will contribute to the stability of the upstream code
>
> We think that at this point of the RDMA technology maturity this is the
> right way to go.
> In this way OFED is not conflicting with the kernel or the distros, and
> still provide a valuable value for early adopters of new features.
>
> Versions:
> We suggest that the OFED version will be the same as kernel.org
> For example, for kernel 3.2 the OFED release would be OFED-3.2.
> This would make it easy for people to associate the OFED code with the
> corresponding kernel.org code.
>
> Some open questions that we should consider:
> - How to handle experimental features?
> - Need to follow up kernel stable releases if bug fixes are relevant to
> OFA modules
> - Should we have a release for every kernel release (I think yes)
> - What should we do with modules like SDP that are not in kernel?
>
> Comments and responses are welcome
>

Personally I would appreciate it a lot if everything that is not a kernel
module would be moved out of the kernel-ib RPM. That would make it a lot
easier to use the OFED user space components in combination with upstream
or distro-provided kernel IB modules. The relevant files are:

# rpm -ql kernel-ib | grep -v lib/modules
/etc/infiniband
/etc/infiniband/connectx.conf
/etc/infiniband/info
/etc/infiniband/openib.conf
/etc/init.d/openibd
/etc/modprobe.d/ib_ipoib.conf
/etc/modprobe.d/mlx4_en.conf
/etc/udev/rules.d/90-ib.rules
/sbin/connectx_port_config
/sbin/sysctl_perf_tuning
/usr/bin/ibdev2netdev

Bart.

--00504502cec0b75cb904b4c00c8d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Thu, Dec 1, 2011 at 7:53 PM, Tziporet Koren <=
span dir=3D"ltr">&lt;<a href=3D"mailto:tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org">tziporet@mell=
anox.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
We propose a new process for the OFED releases starting from next OFED rele=
ase:<br>
- OFED content will be the relevant <a href=3D"http://kernel.org" target=3D=
"_blank">kernel.org</a> modules and user space released packages<br>
- OFED will offer only backports to the distros =A0(no fixes)<br>
- OFED package will be used for easy installation of all packages in a frie=
ndly manner<br>
<br>
The main goals of this change:<br>
1. Ensure OFED and the upstream kernel are the same<br>
2. Provide customers a way to use the new features in latest kernels on exi=
sting distros<br>
3. OFED qualification will contribute to the stability of the upstream code=
<br>
<br>
We think that at this point of the RDMA technology maturity this is the rig=
ht way to go.<br>
In this way OFED is not conflicting with the kernel or the distros, and sti=
ll provide a valuable value for early adopters of new features.<br>
<br>
Versions:<br>
We suggest that the OFED version will be the same as <a href=3D"http://kern=
el.org" target=3D"_blank">kernel.org</a><br>
For example, for kernel 3.2 the OFED release would be OFED-3.2.<br>
This would make it easy for people to associate the OFED code with the corr=
esponding <a href=3D"http://kernel.org" target=3D"_blank">kernel.org</a> co=
de.<br>
<br>
Some open questions that we should consider:<br>
- How to handle experimental features?<br>
- Need to follow up kernel stable releases if bug fixes are relevant to OFA=
 modules<br>
- Should we have a release for every kernel release (I think yes)<br>
- What should we do with modules like SDP that are not in kernel?<br>
<br>
Comments and responses are welcome<br></blockquote></div><br>Personally I w=
ould appreciate it a lot if everything that is not a kernel module would be=
 moved out of the kernel-ib RPM. That would make it a lot easier to use the=
 OFED user space components in combination with upstream or distro-provided=
 kernel IB modules. The relevant files are:<br>
<br># rpm -ql kernel-ib | grep -v lib/modules<br>/etc/infiniband<br>/etc/in=
finiband/connectx.conf<br>/etc/infiniband/info<br>/etc/infiniband/openib.co=
nf<br>/etc/init.d/openibd<br>/etc/modprobe.d/ib_ipoib.conf<br>/etc/modprobe=
.d/mlx4_en.conf<br>
/etc/udev/rules.d/90-ib.rules<br>/sbin/connectx_port_config<br>/sbin/sysctl=
_perf_tuning<br>/usr/bin/ibdev2netdev<br><br>Bart.<br>

--00504502cec0b75cb904b4c00c8d--

--===============1539815206==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============1539815206==--
