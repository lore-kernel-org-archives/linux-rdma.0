From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for HCA's
Date: Thu, 05 Apr 2012 13:46:19 -0400
Message-ID: <4F7DDA6B.7090304@redhat.com>
References: <20120330173908.0abdd264.weiny2@llnl.gov> <F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com> <20120402184545.GA1311@obsidianresearch.com> <20120403191442.ce88dc0a.weiny2@llnl.gov> <20120404171200.GC20889@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig960FFB8E19FC20B60757135C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120404171200.GC20889-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>, James Silva <jsilva-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig960FFB8E19FC20B60757135C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/04/2012 01:12 PM, Jason Gunthorpe wrote:
> On Tue, Apr 03, 2012 at 07:14:42PM -0700, Ira Weiny wrote:
>> On Mon, 2 Apr 2012 12:45:45 -0600
>> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>
>>> On Mon, Apr 02, 2012 at 03:27:35PM +0000, Heinz, Michael William wrot=
e:
>>>
>>>> Any ideas on how we could solve the hostname problem while we're
>>>> changing the description?
>>>
>>> The node description needs to be set from the DCHP notifier script
>>> chain (eg /etc/network/if-up.d/ on Debian) and also from a udev rule
>>> triggered on device insertion.
>>
>> Jason, I'm confused.  Do you mean DHCP?
>=20
> Yes..
>=20
>> It seems are you indicating you would like to see if[up/down] bring
>> ports up/down like they do for IP?
>=20
> No..
>=20
>> On my ubuntu box (the closest thing I have to Debian) it looks like
>> ifupdown owns /etc/network/if-up.d and that is not specific to DHCP.
>> I don't think DHCP should be required for IB.
>=20
> if-up.d/ is a '.d' directory, the idea is individual packages drop
> their script files in the directory and the system runs them at
> defined times. No package owns the directory.
>=20
> The purpose of placing a hook here is this call path is used when the
> hostname changes via DHCP so you can have a chance to reset the node
> description.
>=20
>> Using udev to set this __seems__ like a better idea although I have
>> not prototyped it.
>=20
> The purpose of the udev hook path is to set the node description on
> initial device insertion, which may be before, or after the DHCP
> process completes, in such cases.

Well, a udev rule is guaranteed to be before dhcp completes *on that
device*.  It might be that dhcp has completed on another device and that
the other device is actually where the hostname is pulled, but the udev
rule will always be before this given device in the rule has completed dh=
cp.

> It may also be before or after the openibd script..

Non hot-plug events are going to end up always being before the openibd
script.  This is merely a side effect of the fact that udev start is
called before the normal init script processing is started (this all
changes somewhat in the systemd world though).

> Having init.d
> scripts depend on the ordering of hardware discovery and module
> loading is considered sketchy these days with all the parallel boot
> fancyness and what not.

I would agree with that.  However...

> IMHO we should have a udev rule that also loads the higher level IB
> modules when any RDMA capable device is discovered, including the mlx4
> IB layer, uverbs, umad, etc. This way systems that have RDMA will load
> the right modules and systems that don't, won't. Fully supporting hot
> plug, of course.

One of the niceties of the rdma/openibd init script is the ability to
completely reload the stack.  That goes away if we switch to a udev load
of the stack (well, unless you now create a script in /sbin and have the
udev rule call that script, but the script should no longer be in the
initrddir if it's not an init script).

> This would broadly eliminate the openibd script, integrate more
> correctly with the modern distro world, be better prepared for systemd
> and just be an overall better example for distros to follow :)

This is mostly true, but you do have to sacrifice the one item I listed
above.

>>> It should probably not be set from the openibd script..
>>
>> I agree there might be better ways but I am not sure I follow your
>> proposal.  Furthermore, I don't know that a start up script of some
>> sort is all that evil.
>>
>> Finally, I think Michael brings up a good point about which package
>> should own any such scripts.
>=20
> udev is like if-up.d/, there is a rules directory packages can drop
> hook scripts into that run at the appropriate time.

Correct.  On Red Hat Enterprise Linux I could have the rdma package drop
in an /sbin/rdma script that would bring the stack up (and possibly
reload it, but I'm a bit sketchy on that idea given that this would no
longer be an init script but something else), have it drop a small
script in /etc/dhcp/dhclient.d/ to set the node description after dhcp
completes (the script in /sbin would also have to set the node
description from whatever information is available on load just in case
the machine doesn't even use dhcp though), have it drop a rules file in
/etc/udev.d/rules.d for bringing up the stack on device discovery (this
one is a bit tricky though, you basically have to match against all
possible RDMA devices and bring up the stack on the presence of any one
of them, and your script that you call to bring the stack up needs to be
safe against parallel invocations), and then also own the /etc/rdma
directory and the whatever config files it places in there itself.

So, I'd say it's doable to change this over, but I'm not sure I would
recommend it in a minor point release.  I'd probably save this sort of
change for a major release update.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig960FFB8E19FC20B60757135C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPfdprAAoJELgmozMOVy/dKqIP/3+3bPaImX3DGf9ZcLtzaKIh
spL90RBpAlN2GFecOTjnNErjV9n8hqJAHQXghKmm0P0hnHkp+cQnntZ7XbmdPb0Y
ZQpeOUEZ9N99JULYY5MTwKFKravmXlFc37roZVVT4zQ55xsS/GhdwRmPyoI8SIGD
p/zqcti5HXVw3dqgBvMGiXVmJ9fQPUoWI9M0jXDNs8s0XcuRUUx7VwX1V7a9CI8g
v344Y91/h3Bj2+k+a5BL65c/lHqVM3A02TndmXvaqH6j3RCkzsvniTtWWjccRCQL
jtSjuuwOYaIIpwTwRsTSoWoMJzWZz+fVx5asDB0IRL2SExHgAuZmw+wHWruzy4mS
SggKrCkYeRELGO5K14pmyzSRVTZ7epsen9SAzjES3nbaWR10oX5Fef70raWxmEMQ
5AuHIaj5qJT11W41FkNA4i3qNnXUZWonOFnrdlct0sbzb8yKNbexHhg5YxjIOYkZ
v4Rik6qhPUN9R9mQd6CSqG2fPFV/Hjvlq1nXhQEAARfDb74aKMe9MHBgrw/uI77W
1ZY2nGbaEal4a0Ky7aX4SpONyy9g+7d3BDhys4tdCCpMjJhi/FZ36nCwyRQVXB94
/fnuPYJvWo8iBHZr9QgK88FHfGV3yOmTGK18BN5wBY06tinwk8AmgYoQaLq1b4Ox
1Hfn7kQQKyhzrpi8UQy5
=0nms
-----END PGP SIGNATURE-----

--------------enig960FFB8E19FC20B60757135C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
