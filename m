From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Tue, 30 Aug 2016 10:46:07 +0300
Message-ID: <20160830074607.GN594@leon.nu>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhS1Tg3qr2Nncd_eq_eUXrf-wMickoeoF978Q7L+gN7J1g@mail.gmail.com>
 <VI1PR0501MB24297FF784A085DC0AAE2C1EC4E10@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <CAHC9VhTEOvZ76dNJp35WEhr+r84eZZ6_ZmuaznGLakzZGcXhUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GSmKOs+wxh1Tqap7"
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhTEOvZ76dNJp35WEhr+r84eZZ6_ZmuaznGLakzZGcXhUw@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Daniel Jurgens <danielj@mellanox.com>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--GSmKOs+wxh1Tqap7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 29, 2016 at 08:00:32PM -0400, Paul Moore wrote:
> On Mon, Aug 29, 2016 at 5:48 PM, Daniel Jurgens <danielj@mellanox.com> wrote:
> > On 8/29/2016 4:40 PM, Paul Moore wrote:
> >> On Fri, Jul 29, 2016 at 9:53 AM, Dan Jurgens <danielj@mellanox.com> wrote:
> >>> From: Daniel Jurgens <danielj@mellanox.com>
> >> ...
> >>
> >>> Daniel Jurgens (9):
> >>>   IB/core: IB cache enhancements to support Infiniband security
> >>>   IB/core: Enforce PKey security on QPs
> >>>   selinux lsm IB/core: Implement LSM notification system
> >>>   IB/core: Enforce security on management datagrams
> >>>   selinux: Create policydb version for Infiniband support
> >>>   selinux: Allocate and free infiniband security hooks
> >>>   selinux: Implement Infiniband PKey "Access" access vector
> >>>   selinux: Add IB Port SMP access vector
> >>>   selinux: Add a cache for quicker retreival of PKey SIDs
> >> Hi Daniel,
> >>
> >> My apologies for such a long delay in responding to this latest
> >> patchset; conferences, travel, and vacation have made for a very busy
> >> August.  After you posted the v2 patchset we had an off-list
> >> discussion regarding testing the SELinux/IB integration; unfortunately
> >> we realized that IB hardware would be needed to test this (no IB
> >> loopback device), but we agreed that having tests would be beneficial.
> >>
> >> Have you done any work yet towards adding SELinux/IB tests to the
> >> selinux-testsuite project?
> >>
> >> * https://github.com/SELinuxProject/selinux-testsuite
> >
> > Hi Paul, I've not started doing that yet.  I've been waiting for feedback of any kind from the RDMA list.  I thought the test updates would be more appropriate around the time I'm submitting the changes to the user space utilities to allow labeling the new types.
>
> Okay, no problem.  I just want the tests in place and functional when
> we merge the kernel code.

Hi Paul,

IMHO, you can use Soft RoCE (RXE) [1] for it.

----
Soft RoCE (RXE) - The software RoCE driver

ib_rxe implements the RDMA transport and registers to the RDMA core
device as a kernel verbs provider. It also implements the packet IO
layer. On the other hand ib_rxe registers to the Linux netdev stack
as a udp encapsulating protocol, in that case RDMA, for sending and
receiving packets over any Ethernet device.  This yields a RDMA
transport over the UDP/Ethernet network layer forming a RoCEv2
compatible device.

The configuration procedure of the Soft RoCE drivers requires
binding to any existing Ethernet network device. This is done with
/sys interface.
----

[1]
https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/tree/drivers/infiniband/sw/rxe

>
> --
> paul moore
> www.paul-moore.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--GSmKOs+wxh1Tqap7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxTm/AAoJEORje4g2clinxGkQALawBZtqOWl7ZHdJ00Xfft0s
JRi5VCnJmURMO2fTHfe0/26Zd/7PidES2qH3CiZoFkcD4WxtaptmQ+ngmtd2mfpu
KUrahN7XrX/Ok27ukVXcBmr5WWhIv67yR3x08elutdHm3GbN7LA4u0G1jQAcpuf4
4F79Sa60RGxOksOKdi1y18mabNPlkpxGh8ZJUz4idoptE2cefY7x+0Xsjxtwuih+
fnhNia3dKbzXuJBtDu3UpNVKoz+iCVqChyPfM/Y1uqPiEHS3Nko3K4Ww6iHR7yJu
PebIjexlotss/e2ZktrTTyf+c/sT1iMXNiKSDlpQKkecGZLdusXrNg5Gn0NKCYO5
A3oWwuE8T2POKykhnzLfzmosJoHyx88zqImewAnadCGTSx8TT7PNM0MNnVKex/YN
1pqMxItQ7I8JvVruqr/aiW3L1iFooiJnO5WIOP1AcWF1c0h4bfyB6/On730BW3J5
bHJ6k7YeUASXG/win3Ftq8ahOAXY30WLoh9ZDJ2JOUGRloIelY+3k76B7qlTjVqk
9abPfNS3umco3evsRTqh2CrRNzRD5lOzPsSytKPAhL4jgnlzxIyiEm3NRL6WGymT
YF0+7ynhwSiC/fB38T+gi3mk+MqO1yFvQk0Nv+raFb+GojDHcZyDfqddthH/dF0k
AEbc3HwsS8d+Oeh2kR+y
=1TYP
-----END PGP SIGNATURE-----

--GSmKOs+wxh1Tqap7--
