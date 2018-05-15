From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Tue, 15 May 2018 11:54:11 +0300
Message-ID: <20180515085411.GT10381@mtr-leonro.mtl.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
 <20180514204125.GM21531@ziepe.ca>
 <a8493ed9-f16c-eb71-55db-f27bd1331521@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fKov5AqTsvseSZ0Z"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a8493ed9-f16c-eb71-55db-f27bd1331521@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--fKov5AqTsvseSZ0Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 14, 2018 at 05:04:26PM -0500, Steve Wise wrote:
>
>
> On 5/14/2018 3:41 PM, Jason Gunthorpe wrote:
> > On Mon, May 07, 2018 at 08:53:16AM -0700, Steve Wise wrote:
> >> This enhancement allows printing rdma device-specific state, if provid=
ed
> >> by the kernel.  This is done in a generic manner, so rdma tool doesn't
> >> need to know about the details of every type of rdma device.
> >>
> >> Driver attributes for a rdma resource are in the form of <key,
> >> [print_type], value> tuples, where the key is a string and the value c=
an
> >> be any supported driver attribute.  The print_type attribute, if prese=
nt,
> >> provides a print format to use vs the standard print format for the ty=
pe.
> >> For example, the default print type for a PROVIDER_S32 value is "%d ",
> >> but "0x%x " if the print_type of PRINT_TYPE_HEX is included inthe tupl=
e.
> >>
> >> Driver resources are only printed when the -dd flag is present.
> >> If -p is present, then the output is formatted to not exceed 80 column=
s,
> >> otherwise it is printed as a single row to be grep/awk friendly.
> >>
> >> Example output:
> >>
> >> # rdma resource show qp lqpn 1028 -dd -p
> >> link cxgb4_0/- lqpn 1028 rqpn 0 type RC state RTS rq-psn 0 sq-psn 0 pa=
th-mig-state MIGRATED pid 0 comm [nvme_rdma]
> >>     sqid 1028 flushed 0 memsize 123968 cidx 85 pidx 85 wq_pidx 106 flu=
sh_cidx 85 in_use 0
> >>     size 386 flags 0x0 rqid 1029 memsize 16768 cidx 43 pidx 41 wq_pidx=
 171 msn 44 rqt_hwaddr 0x2a8a5d00
> >>     rqt_size 256 in_use 128 size 130 idx 43 wr_id 0xffff881057c03408 i=
dx 40 wr_id 0xffff881057c033f0
> > Hey some of these look like kernel pointers.. That is a no-no.. What
> > is up there?
>
> Nothing is defined as a kernel pointer.=A0 But wr_id is often a pointer to
> the kernel rdma application's context...
>
> > The wr_id often contains a pointer, right? So we cannot just pass it
> > to user space..
>
> Hmm.=A0 It is useful for debugging kernel rdma applications.=A0 Perhaps
> these attrs can be only be sent up by the kernel if the capabilities
> allow.=A0 But previous review comments of the kernel series, which is now
> merged, forced me to remove passing the capabilities information to the
> driver resource fill functions.=A0
>
> So what's the right way to do this?

The reviewer asked do not pass to drivers whole CAP_.. bits, because
they anyway don't need such granularity.

>
> Steve.
>
>

--fKov5AqTsvseSZ0Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJa+qAzAAoJEORje4g2clinmZkQALzyzmqjn9T3tHR490eIGNks
Rrw628Mxotx7kDLRdF4QBQbDs0UfJXA9w4BMgViY0Ag8BgJa+xUXcqHVnhRn4hJE
dxo2W5VbCTG6z+yXiRWkF7nZuScKrKKFVvomtWLZr6tNshS6RA2a8cdFZxmBLaxl
mztGDwxEItsjZ4AZ79dAA1/yEKKD3KeajqwzB7QqsDBM/mFnroDyJn4wBebbJLHR
rVUdz8bzUGsu5lxWkr8eWrvov8+ufcdewfmPumqkz3ypkeL5lleILtqGvxsO9TtM
DIHBVrhp29Kh6tm2c1P2qBS7XiYJJ1V89KgPSXscX8hvsKD5T0VGeFm8MGHi+k4Z
mTBYvEBrzoGaBXiCoVKeqgjJ+VjQPjWb7ksXR3wVbtvxHwjcXiG1l8idRLRj/dhL
9R3228lKYr1/kdWHdODGZCGEeG/VwJO5acstQeqJfxLbWsp0McV8q3fywdl2TsGB
VOtMI9yaMILIfDiLu5YGDTXyNHSZov7sBXoV9kP64JlD3Gwk5B/ysYsBpmV+wb4N
GPi6DJXxhrhgABDbBTqGU3Sz3xyB+ul30oaPF930R3j2aic4MNXpVpeiv7Jj5thi
3Gcdww2NO3sZGMTWvEynhEqQWVey30b9NagXiZ+b2npmeEhTF+ZpFoIavNGFkMVb
YQo3kFvec8ykcXC2TRk1
=m6np
-----END PGP SIGNATURE-----

--fKov5AqTsvseSZ0Z--
