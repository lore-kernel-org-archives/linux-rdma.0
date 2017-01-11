From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 11 Jan 2017 19:59:51 +0200
Message-ID: <20170111175951.GD20392@mtr-leonro.local>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111071252.GV7218@mtr-leonro.local>
 <dda30e58-41fd-b778-3b6c-6e59d08c41c7@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dda30e58-41fd-b778-3b6c-6e59d08c41c7@intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 11, 2017 at 09:20:54AM -0800, Tadeusz Struk wrote:
> Hi Leon,
> On 01/10/2017 11:12 PM, Leon Romanovsky wrote:
> > Can't you recognize such device at the initialization phase?
>
> Yes, this is exactly what it does. It checks the device GUID
> and reorders the ports during insmod.

Why don't your firmware report the need to revert the ports?

>
> > This is definitely specific HW implementation bug/issue/limitation.
>
> Correct. As the commit message says this is to fix a HW issue.
>
> >
> > I always had an impression that module parameters are rarely beneficial
> > in upstream kernel for driver modules and adding them for new driver
> > code should be explicitly prohibited in CodingStyle guide.
> >
> > You are adding new module parameter which will be with us forever to fix
> > special HW bug/implementation in some legacy installations. It will be
> > insane to add such thing to upstream kernel, errata and out-of-tree
> > implementations are best places for such things.
>
> Agree, but the reality is that there are 5505 $(git grep module_param drivers/ | wc -l)
> module parameters in the kernel already, and even mlx4 and mlx5 drivers use them.

Regarding mlx4/mlx5, I'm not proud of that code and if it was dependent
on me, I would remove it without thinking twice.

Previous copy-paste can not be an excuse to add another module parameter.

> I really considered every other possible solution, but module parameter is the
> only possible way to do such things during insmod.

This is another problem with the module parameters - assumption that
everyone is running modules, but this is simply incorrect, most of my
smoke tests are performed with monolithic kernel.

> Thanks,
> --
> Tadeusz

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh2cpcACgkQ5GN7iDZy
WKd0Bg/9HdHNWx21SQZ9nC1jXT5rD8U498TqPcpAKEE8xyTMNm5w3Ffh2aShlbAO
oW2LQQjmtL677DH7E8n86SH96kHBoNF+WWng0KKf/OsEPTv+YsI/9mzbAfORv4RS
FhOxKuz8NUeMKZq6EV4KNIXjEjITgLJ8lYgMSxWfDd0a8KIt6Wnx02sOaeAFYJuA
cvyxmG69Dr1oMLhK54jeCvoeHos9hLD/DZsgl6eNO/YqR1vSUNjEFtBVWufyMnWG
F6mJZJtTyiRDp5kQxrlumIDbUZsx7bQZPKXELKYOeukjYbbwAsxPu/dTcW4Vf3Un
bnaZK6/c8Mk7+M72zCjIDWYO/bpHmZrsqpA5llG2FqXRI9mRtg2UajPyX4SpBM9E
zlvLeJhy8Qkc+msPmYBm7pW9iB/ps61c2vXcjLA10sUaCT/7JapLIuTDy2ozdkMS
wizo4sSJ/OxCrquij/W3Q51BQ367WhheJQctCmNVU57XN2wxV9kkTcu2+AqoNeSE
KEDmEZGdtK19PK24jc9vDf9k9Bl4ThyMrAP9d+e2q2ru6IOkNzF+xD0zY+r6AQcX
EfmsceQZuwyFQZ1lGfRLtQl4/2aE7MSNtBUq3KOFz6EGQ6gkIKRQJ6qf4nQgZ7yc
4GbyApsLUaKSdrPZTgmJuRL6UzcpWAFZ6P0V8dCbO+2EOBFR614=
=pof/
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
