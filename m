From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Email problems
Date: Wed, 25 May 2016 16:42:37 -0400
Message-ID: <8f47e860-7278-aea5-73a4-ca21d46b3778@redhat.com>
References: <bbc79ac4-6f84-2013-b493-18ec2e9bce9b@redhat.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBC720@ORSMSX115.amr.corp.intel.com>
 <b07e29e0-4349-3927-7f61-ba66a463cf74@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QwUHGENJkL4s5PlinSFL9KblodI0xoTKx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b07e29e0-4349-3927-7f61-ba66a463cf74-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Woodruff Robert J <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QwUHGENJkL4s5PlinSFL9KblodI0xoTKx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/24/2016 03:11 PM, Doug Ledford wrote:
> On 05/24/2016 03:05 PM, Woodruff, Robert J wrote:
>>> Just so people know, my messages to the mailing list are, at best, un=
reliable at the moment.  On the last email I sent, which was the second >=
time to send the same email, I verified linux-rdma@ was on the
>>> To: list, and yet once I hit send and then checked my email in my Sen=
t folder, linux-rdma@ was removed.  So, if you get an email from me, and =
>you think it would normally include the list, and the list isn't on ther=
e, go ahead and add the list on any replies.  Thanks.  Now I'll go try to=
 get >this emailer issue figured out :-/
>>
>> Do you have a spam filter. I has some issues lately where some, not al=
l, of the emails from linux-rdma ended up in my Junk E-mail folder,
>> but then I have to use Microsoft outlook on my company provided laptop=
=2E..... so I am not too surprised.=20
>>
>=20
> No, but I can't imagine a spam filter doing what I'm seeing.  I type my=

> reply, I can see the mailing list in the list of recipients, I click
> "Send" and I then go check what gets copied into my Sent folder and the=

> mailing list (and sometimes other individual recipients) are no longer
> on the list of recipients as recorded in my Sent folder mail and they
> don't get the message.
>=20

I've narrowed this down to a Thunderbird issue.  Whenever it does the
whole "drop some of the recipients" thing, the Error Console has this
logged at the same time as the sent email:

Timestamp: 05/25/2016 04:07:57 PM
Error: DEPRECATION WARNING: Encoding to non-UTF-8 values is obsolete
You may find more details about this deprecation at:
http://bugzilla.mozilla.org/show_bug.cgi?id=3D790855
resource://gre/components/mimeJSComponents.js 438
MimeConverter.prototype.encodeMimePartIIStr_UTF8
chrome://messenger/content/messengercompose/MsgComposeCommands.js 2849
GenericSendMessage
chrome://messenger/content/messengercompose/MsgComposeCommands.js 2930
SendMessage
chrome://messenger/content/messengercompose/MsgComposeCommands.js 590
defaultController.commands.cmd_sendButton.doCommand
chrome://messenger/content/messengercompose/MsgComposeCommands.js 762
defaultController.doCommand
chrome://global/content/globalOverlay.js 100 goDoCommand
chrome://messenger/content/messengercompose/messengercompose.xul 1 oncomm=
and

Source File: resource://gre/modules/Deprecated.jsm
Line: 79

I've filed a bug at Red Hat, but in case I'm not the only one using
Thunderbird, I just wanted to point this out.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QwUHGENJkL4s5PlinSFL9KblodI0xoTKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRg49AAoJELgmozMOVy/dKm4P/0s5XkAohdk8v25UJ54vU98D
HnJT/TZP20xBkw7AYrByPIfI3Yozga4ulCKl1n4Q3Z8rTNeNU5FHj8SbEbhDO0uR
dqxqwoU84ni+A6yfISkjd2BXa3P9Utc92ZDu2CsrwpIPMh0lN34/5KZ2H7vZS+CL
rbNQdkgzYq0z3E41ejcJHo04kR6eQM65yUpa8r6F/E+OFe/MbQZHEk4X/Y5mzHJy
VTzsrPq69kEIQbGDUWjFb3Yz9CN60l/W9YJLWM0tF/NVWdtCmAtFu7JnLNpAyaWO
rC6Yes93BJTgqwfR36rEG7KMleaItT1xi046tarE0+D1E+Yk8pe37iMeS8/ekMZu
LI7RHGLZuj5C+H9oNmxUYaFd0lpsTQXn+K9M1eecbKRevAsgXsUy6br1tYNH+FlP
02QqDUJmv4p1nynID7xFvWuda8G8PQb3xvN6/fG9T56CDUp9J1o3MT7xYJjYZrCp
9wP7werrcCK3NWwX/eyFAPDtfJtEbUJJLNj2capEYOLvYYLVtSEXPrahbihiiDbv
oj4+wZqoFTcFxMpfVs9GjYU3UZmJtbN6fv90YYlmU3/PEyAwN8+FUyQ50Wcwf8QX
nxo470rXQ2/a0h6JNVOxF+90XaAYvsbipM9eHbxyc0pNPoeaG5fqSk/f4rb5Q/1y
SQhFMHL0eZ6myChvymV1
=kxoK
-----END PGP SIGNATURE-----

--QwUHGENJkL4s5PlinSFL9KblodI0xoTKx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
