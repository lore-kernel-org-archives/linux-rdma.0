From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Email problems
Date: Thu, 23 Jun 2016 11:56:12 -0400
Message-ID: <6b1265fe-7f09-5073-12f6-ab9855df894f@redhat.com>
References: <bbc79ac4-6f84-2013-b493-18ec2e9bce9b@redhat.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBC720@ORSMSX115.amr.corp.intel.com>
 <b07e29e0-4349-3927-7f61-ba66a463cf74@redhat.com>
 <8f47e860-7278-aea5-73a4-ca21d46b3778@redhat.com>
 <47e7fa77-df99-dfc0-d91e-2d6c8e8e8dfe@sandisk.com>
 <2306b436-0fc2-6c11-fea6-8ed1f3df67a9@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nUH8PIQ3id0iXjsljUtGfuooWPrextRsx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2306b436-0fc2-6c11-fea6-8ed1f3df67a9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Woodruff Robert J <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nUH8PIQ3id0iXjsljUtGfuooWPrextRsx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/25/2016 05:45 PM, Doug Ledford wrote:
> On 05/25/2016 05:05 PM, Bart Van Assche wrote:
>> On 05/25/2016 01:42 PM, Doug Ledford wrote:
>>> I've narrowed this down to a Thunderbird issue.  Whenever it does the=

>>> whole "drop some of the recipients" thing, the Error Console has this=

>>> logged at the same time as the sent email:
>>>
>>> Timestamp: 05/25/2016 04:07:57 PM
>>> Error: DEPRECATION WARNING: Encoding to non-UTF-8 values is obsolete
>>> You may find more details about this deprecation at:
>>> http://bugzilla.mozilla.org/show_bug.cgi?id=3D790855
>>> resource://gre/components/mimeJSComponents.js 438
>>> MimeConverter.prototype.encodeMimePartIIStr_UTF8
>>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 284=
9
>>> GenericSendMessage
>>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 293=
0
>>> SendMessage
>>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 590=

>>> defaultController.commands.cmd_sendButton.doCommand
>>> chrome://messenger/content/messengercompose/MsgComposeCommands.js 762=

>>> defaultController.doCommand
>>> chrome://global/content/globalOverlay.js 100 goDoCommand
>>> chrome://messenger/content/messengercompose/messengercompose.xul 1
>>> oncommand
>>>
>>> Source File: resource://gre/modules/Deprecated.jsm
>>> Line: 79
>>>
>>> I've filed a bug at Red Hat, but in case I'm not the only one using
>>> Thunderbird, I just wanted to point this out.
>>
>> Thanks Doug for having tracked this down. I'm using Thunderbird 45.1.0=

>> but I have not yet seen this issue.
>>
>> Bart.
>>
>=20
> I have 45.0.  It's possible the bug is already fixed in your version.
>=20

The final culprit here was determined to be the CardBook add-on that
allowed Thunderbird to use CardDAV servers as a network contact database
source.  I don't know if the incompatibility, which was recently
introduced, has been fixed, I simply disabled CardBook and migrated my
CardDAV contacts to one of my google account's contact lists and use
gContactSync now.  Just FYI.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nUH8PIQ3id0iXjsljUtGfuooWPrextRsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbAacAAoJELgmozMOVy/dZDEP/1miIfmKd2Yw2Ip4RPkF0HkC
MeaZB4sYDYSjJgQZuPbcOUbPdLWfQ+jnmC/jT43WCPJp+12KsQn52exMMF/+dvvk
YeAChYJboXQc+dRW48tXQJiNTff/1V7nMlrFK802n13RprLv63zRYDRl6YeW58Dw
feOl8wLdnpe79K20ill59n1//5FJSrjRH7gYs2BPoeRMrYIr1FbfjSlZBjOUPJLI
f/WX+3O/VvqTt2TRq1VVKIlCP2u2Qo2XBevFGhC6HtIygCkxD962Qb2ih12SX0aY
u8NAFWPslVas0cC3SxaXkxA5y4ni1hWedcMj7UqR6BW+x34UgYQcGLtK3qBOcHEj
FDZU6jpB9AoEhP5pmtjTpnrQgx4sFhByImRV//10RC0ipEJitj2BLQBuz7691ban
lwqgeevpIpJAmFSAjZk9ImfUXZl8M4cJvONe8TMnEYMXb70nFU901ITvqE/+PEks
2V+CYSDKXK2zCOnEoZnUOaNchMO0I12PYJDejmhJ8c8BvAAxcU4zepNGbaWL5P6A
eikM7zyLrKnpPCF4Ghc+iQAVRh694eSLuarE+nsYa8PofrCqqHej8rLoFnd0Ulzy
Rpbj9DqkqJL3xHyWMJ16Hit0HIvzvyMzzfW9qWlG+v0T9r7gMXzUjw2Xxu0/k9vb
JGfR2JVkZDh7Lw0t+6iq
=3jFO
-----END PGP SIGNATURE-----

--nUH8PIQ3id0iXjsljUtGfuooWPrextRsx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
