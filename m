From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Email problems
Date: Wed, 25 May 2016 17:45:57 -0400
Message-ID: <2306b436-0fc2-6c11-fea6-8ed1f3df67a9@redhat.com>
References: <bbc79ac4-6f84-2013-b493-18ec2e9bce9b@redhat.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBC720@ORSMSX115.amr.corp.intel.com>
 <b07e29e0-4349-3927-7f61-ba66a463cf74@redhat.com>
 <8f47e860-7278-aea5-73a4-ca21d46b3778@redhat.com>
 <47e7fa77-df99-dfc0-d91e-2d6c8e8e8dfe@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1LCDXtDk6WRnj2vVQWsDCO0cUU6VEFJvo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47e7fa77-df99-dfc0-d91e-2d6c8e8e8dfe-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Woodruff Robert J <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1LCDXtDk6WRnj2vVQWsDCO0cUU6VEFJvo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/25/2016 05:05 PM, Bart Van Assche wrote:
> On 05/25/2016 01:42 PM, Doug Ledford wrote:
>> I've narrowed this down to a Thunderbird issue.  Whenever it does the
>> whole "drop some of the recipients" thing, the Error Console has this
>> logged at the same time as the sent email:
>>
>> Timestamp: 05/25/2016 04:07:57 PM
>> Error: DEPRECATION WARNING: Encoding to non-UTF-8 values is obsolete
>> You may find more details about this deprecation at:
>> http://bugzilla.mozilla.org/show_bug.cgi?id=3D790855
>> resource://gre/components/mimeJSComponents.js 438
>> MimeConverter.prototype.encodeMimePartIIStr_UTF8
>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 2849=

>> GenericSendMessage
>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 2930=

>> SendMessage
>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 590
>> defaultController.commands.cmd_sendButton.doCommand
>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 762
>> defaultController.doCommand
>> chrome://global/content/globalOverlay.js 100 goDoCommand
>> chrome://messenger/content/messengercompose/messengercompose.xul 1
>> oncommand
>>
>> Source File: resource://gre/modules/Deprecated.jsm
>> Line: 79
>>
>> I've filed a bug at Red Hat, but in case I'm not the only one using
>> Thunderbird, I just wanted to point this out.
>=20
> Thanks Doug for having tracked this down. I'm using Thunderbird 45.1.0
> but I have not yet seen this issue.
>=20
> Bart.
>=20

I have 45.0.  It's possible the bug is already fixed in your version.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--1LCDXtDk6WRnj2vVQWsDCO0cUU6VEFJvo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRh0VAAoJELgmozMOVy/d18AQAL7uJoav6RZWNG8PlaA2481h
VTR3Iukh/KVbDFzitAFX6AINbMgCK21cpeBKLHTweRegHINK+kgpO+tPRjG+D+II
KV+x7ycQ8500jHSIQY8kkwR405phAnR6jfcXWMd3KI8VMuum0XwkqDpvD9d4u+wb
pc04GZqcF1UoWQwTeb6JMQpxeU2eHeik5703uq76vnnQ+FaEGdIJXslfDjOZFqQ2
gFzAzKvKVamayc0uA9KDuANHPi8bKWhBNQy6OdALzT5DLhJKaB7cqGbpb1aD3q3j
qQVGgQX6znDtax2j0rqJ/vslB6lD45jnoydYGRjVazqrUTkDJZJm6RtAT6sFiC3p
h0NaH7TrzC3NoNtdVcRAd25alBI05QhCKxyVX5ydYhWA5tv+2pvu8p0WLxr21Jio
ma/3iniH952CIJ8LC8+qcNCtWTOeUEDTvLuU7HTTYUwvQUnR3nvqDiPJU1bxH8Fw
WGZgkuayjEoy766E9xnFb76/tscmACcycQNu2yhjonGkNj5e3a18mQThfH2TgTa7
Kx7TPyUown9ZhTA21fneQHhsbmf1BOXiLfFTI3q/SSiNhOAKZPi/Zq+Yv75GWJPi
UxaXe9mE92sFIYy4SAzlpoDNXLvX3pz/4hfP3iMv3EIm8xeVjac5cO4nafEZcJ2I
V89oGP3sEx+VA7CHeK8B
=cRKf
-----END PGP SIGNATURE-----

--1LCDXtDk6WRnj2vVQWsDCO0cUU6VEFJvo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
