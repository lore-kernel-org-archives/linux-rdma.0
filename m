From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 14:56:37 -0400
Message-ID: <a6c8091e-fe83-8413-77d7-4aac053b8e62@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tichrVOUv2Uw4JsSw0eFKwqwfIr0765BF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017182037.GK14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tichrVOUv2Uw4JsSw0eFKwqwfIr0765BF
Content-Type: multipart/mixed; boundary="N72bOuiUFVWD4H3xrGIHANbfVBaAxOpts";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <a6c8091e-fe83-8413-77d7-4aac053b8e62-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
References: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161014192136.11731-3-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161014231934.GC16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20161017162221.GI14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161017174611.GB6430-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20161017182037.GK14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20161017182037.GK14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--N72bOuiUFVWD4H3xrGIHANbfVBaAxOpts
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/17/2016 2:20 PM, Jarod Wilson wrote:
> On Mon, Oct 17, 2016 at 11:46:11AM -0600, Jason Gunthorpe wrote:
>> On Mon, Oct 17, 2016 at 12:22:21PM -0400, Jarod Wilson wrote:

>>>>> diff --git a/glue/redhat/ibacm.service b/glue/redhat/ibacm.service
>>>>> new file mode 100644
>>>>> index 0000000..1cd031a
>>>>> +++ b/glue/redhat/ibacm.service
>>>>
>>>> Can we just put this in ibacm/ ?
>>>
>>> Probably.
>>
>> Okay, the only thing I really don't like being upstream is the
>> opensm.service..
>>
>> Do you know why acm needs that?
>=20
> I think Doug already attempted to address this elsewhere in the thread,=

> and he'd know better than me.

Since it got snipped, I'm pretty sure it just lists opensm in the Wants=3D=

tag.  With systemd, that's a soft dependency.  Only if opensm is
installed and configured to start anyway does systemd then order this
item after opensm.  Since you need opensm for links to come up anyway,
it makes sense for the order of startup for RDMA related items to be:

rdma-core
\-opensm
  \-Everything else

Because of that, I think I had opensm listed as a want in pretty much
everything, but as already stated, it's a soft dependency and systemd
ignores it if you don't have opensm configured to run on that machine.


>>>>> +SUBSYSTEM=3D=3D"module", KERNEL=3D=3D"cxgb*", ACTION=3D=3D"add", T=
AG+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"rdma.service"
>>>>> +SUBSYSTEM=3D=3D"module", KERNEL=3D=3D"ib_*", ACTION=3D=3D"add", TA=
G+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"rdma.service"
>>>>> +SUBSYSTEM=3D=3D"module", KERNEL=3D=3D"mlx*", ACTION=3D=3D"add", TA=
G+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"rdma.service"
>>>>> +SUBSYSTEM=3D=3D"module", KERNEL=3D=3D"iw_*", ACTION=3D=3D"add", TA=
G+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"rdma.service"
>>>>> +SUBSYSTEM=3D=3D"module", KERNEL=3D=3D"be2net", ACTION=3D=3D"add", =
TAG+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"rdma.service"
>>>>> +SUBSYSTEM=3D=3D"module", KERNEL=3D=3D"enic", ACTION=3D=3D"add", TA=
G+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"rdma.service"
>>>>
>>>> Also cross distro
>>>
>>> Yeah, these are definitely prime candidates for being cross-distro. A=
nd
>>> really, I was thinking maybe these should be part of the core upstrea=
m
>>> udev/systemd rules set, rather than something we ship here.
>>
>> Okay. The trick will be to standardize the systemd_wants name ..
>=20
> Perhaps rdma-core should go with rdma-core.service? We were shipping a
> package called 'rdma' that carried that.

Whatever the service file is, that's what the name is.  I'm partial to
just leaving it as rdma.service.  The -core suffix doesn't add anything
of value IMO, and we really are initializing the entire rdma stack minus
just those upper layer protocols that have their own setup.

>>>>> +# When we detect a new verbs device is added to the system, set th=
e node
>>>>> +# description on that device
>>>>> +# If rdma-ndd is installed, defer the setting of the node descript=
ion to it.
>>>>> +SUBSYSTEM=3D=3D"infiniband", KERNEL=3D=3D"*", ACTION=3D=3D"add", T=
EST!=3D"/usr/sbin/rdma-ndd", RUN+=3D"/bin/bash -c 'sleep 1; echo -n `host=
name -s` %k > /sys/class/infiniband/%k/node_desc'"
>>>>
>>>> Shouldn't this udev drop-in by in the rdma-ndd package?
>>>
>>> Honestly don't even have a clue what rdma-ndd is. :) Don't remember w=
hat
>>> Doug said about this one...
>>
>> Guess I didn't read closely enough, this is used if rdma-ndd is not
>> installed..

A bit of a chicken and egg issue here isn't there?  Wasn't rdma-ndd part
of ibutils?  And since ibutils isn't in rdma-core, how do we know if
it's installed?

>> So something like that should be upstream, but the 'sleep 1' is ugly -=

>> this should probably be a systemd service that runs after
>> network-online.target not as a script run from udev?
>>
>> rdma-ndd dynamically sets the NodeDescription to the hostname in the
>> adaptor for the subnet manager/tools to ready. I guess this hunk is
>> setting the NodeDescription one-shot at boot..
>=20
> Rather than having this janky udev rule, what if we simply made rdma-nd=
d
> part of what's installed with rdma-core, rather than something found in=

> yet another infiniband package? (Looks like it's in infiniband-diags,
> wasn't even aware rdma-ndd existed until looking at this here).

It's probably a good candidate to be pulled back to rdma-core.  Ira?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--N72bOuiUFVWD4H3xrGIHANbfVBaAxOpts--

--tichrVOUv2Uw4JsSw0eFKwqwfIr0765BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYBR7sAAoJELgmozMOVy/dRtIP/jfcJ0eYeMvFlCrRwYApOsVO
QfgcunWn0zDNdxq9cuWYzuUAzLexvRL06B0ZD5LvT78N3C4xm+4J/IKfzQ/ICb79
AgViS6tyBhyEH5hVCVylsxvZyhjP3kUjxtGjRcp5iMNMlNpHZL8VITYC0fJj/nno
gSXAPy3HQ4jafi3HVKrKBzJjWE2fQ81rtBGAyTLKx7E5PrvVSGv3K9ZGEUBObp90
ZrcTdItka8SOXFEDDq5frXOYkSWAsizdqiuLtWxduDU3PLxtH9H/Ie6zZxg0Dg4k
kX3ixrA4XyNRgQL7iPBPivt9bCNcD7mvpzSWBqFouiDz1MQB5QZJFi56EP1p49QG
WeanKpImCIqRy1GOsuvo08XBRYQnagj8AXFi5IR82NNqcsgg0bdQvK72bumbQPC3
qUMIJszXARoKBltU7YVoKTPYdAJa0AqCobmTW/Lf/FSy1xsPhA2w+nBIbq6QJx3N
VOktqsNYOMMtxNEToELMgEA+LX+4tlUGGYhOBKDgatAF3LQpifhbkQFGwmrycmKz
Twawt9wlzet92N3WjOghPa6iUjcbtrMTNxuMu61tneavJ7x8MMIWc8nB18THJk8O
RCUJ/QFJz2Sg8OT/7K6nD3iHNm55FRrf/mFMt1o07mHA/UTTkf6K2RuI9jT2d8rw
v7H4sT5bYVhXN/JIbh3R
=Mz8d
-----END PGP SIGNATURE-----

--tichrVOUv2Uw4JsSw0eFKwqwfIr0765BF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
