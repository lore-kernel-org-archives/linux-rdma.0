From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH librdmacm 3/8] autogen.sh: Use autoreconf in autogen.sh
Date: Wed, 17 Jul 2013 08:21:09 +0200
Message-ID: <a0fbc005839e5d4fd1ad13be59be3fae@meuh.org>
References: <cover.1374011243.git.ydroneaud@opteya.com>
 <317ae98daf0eec49ffb297a5fc59b3738366af6d.1374011243.git.ydroneaud@opteya.com>
 <1828884A29C6694DAF28B7E6B8A82373805AECD6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805AECD6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 17.07.2013 06:22, Hefty, Sean a =C3=A9crit=C2=A0:
> Thanks - I pulled in these patches, but see below:
>=20

Thanks.

>> diff --git a/autogen.sh b/autogen.sh
>> index f433312..6c9233e 100755
>> --- a/autogen.sh
>> +++ b/autogen.sh
>> @@ -1,9 +1,4 @@
>>  #! /bin/sh
>>=20
>>  set -x
>> -test -d ./config || mkdir ./config
>=20
> Without the above line, the build fails.  I added it back in.  If
> there's some other way of ensuring that this directory exists, please
> let me know.
>=20

Sorry for the inconvenience.

I've checked libibverbs: it has a .gitignore in ./config so that git=20
kept the empty directory.

It's a different solution for the same problem, I'm not able to say if=20
it's a better one.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
